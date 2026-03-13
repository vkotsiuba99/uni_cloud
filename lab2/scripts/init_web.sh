#!/bin/bash
while fuser /var/lib/dpkg/lock-frontend >/dev/null 2>&1; do sleep 5; done
while fuser /var/lib/apt/lists/lock >/dev/null 2>&1; do sleep 5; done

apt-get update
apt-get install -y golang git mysql-router

mkdir -p /app
cd /app

cat << 'GOEOF' > main.go
package main

import (
    "database/sql"
    "fmt"
    "log"
    "net/http"
    "os"
    _ "github.com/go-sql-driver/mysql"
)

func main() {
    http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
        // Connect to local MySQL Router instead of the direct DB IP
        dsn := "clusteradmin:${db_password}@tcp(127.0.0.1:6446)/testdb"
        db, err := sql.Open("mysql", dsn)
        if err != nil {
            http.Error(w, err.Error(), http.StatusInternalServerError)
            return
        }
        defer db.Close()

        rows, err := db.Query("SELECT firstname, lastname, position, salary FROM employee")
        if err != nil {
            http.Error(w, err.Error(), http.StatusInternalServerError)
            return
        }
        defer rows.Close()

        hostname, _ := os.Hostname()
        
        w.Header().Set("Content-Type", "text/html; charset=utf-8")
        fmt.Fprintf(w, "<h2>${student_name}</h2>")
        fmt.Fprintf(w, "<h3>Served by Web Node: %%s</h3>", hostname)
        fmt.Fprintf(w, "<p>Connected via MySQL Router (localhost:6446)</p>")
        fmt.Fprintf(w, "<table border='1'><tr><th>Name</th><th>Position</th><th>Salary</th></tr>")
        
        for rows.Next() {
            var fname, lname, pos string
            var sal int
            rows.Scan(&fname, &lname, &pos, &sal)
            fmt.Fprintf(w, "<tr><td>%%s %%s</td><td>%%s</td><td>%%d</td></tr>", fname, lname, pos, sal)
        }
        fmt.Fprintf(w, "</table>")
    })

    log.Fatal(http.ListenAndServe(":80", nil))
}
GOEOF

go mod init cloudlab
go get github.com/go-sql-driver/mysql
go build -o server main.go

cat << 'SYSEOF' > /etc/systemd/system/goweb.service
[Unit]
Description=Go Web Server
After=network.target

[Service]
ExecStart=/app/server
WorkingDirectory=/app
Restart=always

[Install]
WantedBy=multi-user.target
SYSEOF

systemctl enable goweb
systemctl start goweb
