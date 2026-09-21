#!/bin/bash
# Runs after the new WAR is copied (ApplicationStart).
set -e

systemctl enable tomcat
systemctl restart tomcat
