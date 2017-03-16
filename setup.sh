#!/bin/bash


ssh-keyscan $(printenv REMOTE_SERVER) >> /root/.ssh/known_hosts

/usr/sbin/apache2ctl -D FOREGROUND