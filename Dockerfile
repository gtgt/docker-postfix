FROM alpine:3.15 as base
COPY init.d/* /etc/init.d/
COPY conf/postfix/main.sql.cf /tmp/
## Install system dependencies
RUN apk update && \
    apk add --no-cache --update shadow git sudo nano curl openrc postfix postfix-sqlite postfix-openrc postfixadmin logrotate logrotate-openrc cronie cronie-openrc \
        php8 php8-sqlite3 php8-tokenizer php8-mysqli php8-simplexml php8-dom php8-xml php8-xmlwriter php8-session php8-pdo_sqlite composer && \
    ln -s /usr/bin/php8 /usr/bin/php && \
    groupmod -g 1000 nobody && usermod -u 1000 -g 1000 nobody && \
    usermod -d /home nobody && \
    # Disable getty's
    sed -i 's/^\(tty\d\:\:\)/#\1/g' /etc/inittab && \
    sed -i \
        # Change subsystem type to "docker"
        -e 's/#rc_sys=".*"/rc_sys="docker"/g' \
        # Allow all variables through
        -e 's/#rc_env_allow=".*"/rc_env_allow="\*"/g' \
        # Start crashed services
        -e 's/#rc_crashed_stop=.*/rc_crashed_stop=NO/g' \
        -e 's/#rc_crashed_start=.*/rc_crashed_start=YES/g' \
        # Define extra dependencies for services
        -e 's/#rc_provide=".*"/rc_provide="loopback net dev"/g' \
        /etc/rc.conf && \
    # Remove unnecessary services
    rm -f /etc/init.d/hwdrivers \
            /etc/init.d/hwclock \
            /etc/init.d/hwdrivers \
            /etc/init.d/modules \
            /etc/init.d/modules-load \
            /etc/init.d/modloop && \
    # Can't do cgroups
    sed -i 's/cgroup_add_service /# cgroup_add_service /g' /lib/rc/sh/openrc-run.sh && \
    sed -i 's/VSERVER/DOCKER/Ig' /lib/rc/sh/init.sh && \
    mkdir /run/openrc && \
    touch /run/openrc/softlevel && \
    mkdir -p /srv/postfixadmin/database /srv/vmail && \
    touch /srv/postfixadmin/database/postfixadmin.db && \
    sudo chown -R nobody:nobody /srv/postfixadmin/database && \
    sudo chmod a+rwx /var/cache/postfixadmin/templates_c && \
    chmod a+x /etc/init.d/postfixadmin && \
    cat /tmp/main.sql.cf >> /etc/postfix/main.cf && \
    rc-update add postfixadmin default; \
    rc-update add postfix default; \
    rc-update add cronie default

COPY conf/postfixadmin/config.local.php /etc/postfixadmin/config.local.php
COPY postfixadmin/css/bootstrap.min.css /usr/share/webapps/postfixadmin/public/css/bootstrap-3.4.1-dist/css/
COPY postfixadmin/css/custom.css /usr/share/webapps/postfixadmin/public/css/
COPY conf/postfix/sql /etc/postfix/sql/
COPY conf/logrotate.d/* /etc/logrotate.d/
COPY conf/cron/cron.daily/* /etc/cron.daily/

RUN chmod a+x /etc/cron.daily/*

EXPOSE 8025 25

WORKDIR /srv
VOLUME /srv
CMD ["/sbin/init"]
