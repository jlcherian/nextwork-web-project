#!/bin/bash
# Runs on the EC2 instance before the new WAR is copied (BeforeInstall).
# Makes sure Tomcat is installed, so a fresh instance can serve the app.
set -e

# Safe to run every deployment: yum skips packages that are already installed.
yum install -y tomcat tomcat-webapps tomcat-admin-webapps

# Remove the previously unpacked app so Tomcat unpacks the new WAR cleanly.
rm -rf /usr/share/tomcat/webapps/nextwork-web-project
