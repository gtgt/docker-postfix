<?php
$CONF['configured'] = true;
$CONF['setup_password'] = '$2y$10$UecbnlsW6EBira2YtajzROc/euqw8jRx7bsc6eoqlPn3oVWXiYa7.';
$CONF['database_type'] = 'sqlite';
$CONF['database_name'] = '/srv/postfixadmin/database/postfixadmin.db';
unset($CONF['default_aliases']);
$CONF['fetchmail'] = 'NO';

$CONF['emailcheck_resolve_domain'] = 'NO';

// Default Domain Values
// Specify your default values below. Quota in MB.
$CONF['aliases'] = '100';
$CONF['mailboxes'] = '-1';
$CONF['maxquota'] = '10';
$CONF['domain_quota_default'] = '2048';

$CONF['theme_logo'] = 'images/logo-default.png';
$CONF['theme_css'] = 'css/bootstrap.css';
// If you want to customize some styles without editing the $CONF['theme_css'] file,
// you can add a custom CSS file. It will be included after $CONF['theme_css'].
$CONF['theme_custom_css'] = 'css/custom.css';
$CONF['password_expiration'] = 'NO';

$CONF['show_footer_text'] = 'NO';
$CONF['footer_text'] = 'Return to change-this-to-your.domain.tld';
$CONF['footer_link'] = 'http://change-this-to-your.domain.tld';
