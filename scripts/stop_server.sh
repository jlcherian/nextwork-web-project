#!/bin/bash
# Runs before a new deployment (ApplicationStop).
# Stops Tomcat if it is running; does nothing if it isn't installed yet.
if systemctl is-active --quiet tomcat; then
  systemctl stop tomcat
fi
exit 0
