# DL-Ticket: Download Ticket Service
## This is the Dockerised web tool dl-ticket.

DL is a tool for sending/receiving files through a web interface (ticket service).

Please, check official website: https://www.thregr.org/~wavexx/software/dl/
or its Github code: https://github.com/wavexx/dl
&hellip;

### Considerations
#### Database: SQLite3
This image only works with SQLite3 user management. Files are NOT stored in a database but in a private directory.
#### Empty initial database
This image will create an empty database with an admin / admin login if no db is found.
#### User management tools
This image includes an easier way to change admin password called "change_admin_pass.sh". Check containers output.

### Data Persistence
If you want to use this as a production service, you'll need a volume for */var/spool/dl* directory. Container will try to fix folder permissions.

Example: -v /storage/dl-ticket/persistent-data:/var/spool/dl

### Configuration folder
DL's default configuration is included inside the public html. For easier configuration I created a folder /app/config iside the container where configurations can be made.
#### .htaccess
There's a template htaccess which you might not need to modify. It's placed at /var/www/html/.htacces which is a symlink from /app/config/.htaccess
It includes 3 PHP value modifications: post_max_size, upload_max_filesize and memory_limit.
These can be set as environmental variables as you'll read below.
#### config.php
include/config.php has been replaced to include /app/config/config.php file.
#### Volume for configuration
As both config and htaccess are now taken from /app/config, one can use a volume for them

example:  -v /storage/dl/config_folder:/app/config

### Current supported customisations through envionment variables

#### SERVER_URL
If not defined, it'll use the one that client tells the server. Notice no protocol is set.
Current image only working over SSL proxy or HTTP.

Example: -e SERVER_URL=dl.example.com
Or: -e SERVER_URL=dl.example.com:8080

#### FROM_ADDR
Defaults to: "ticket service Dockerised <nobody@example.com>".

This variable will be the email address the tool will use to send emails to receptors/users when needed.
Not mandatory but really recommended. Mind it has no SMTP support. It'll use PHP mail function.

Example: -e FROM_ADDR="My Company's Ticket Service <nobody@mycompany.com>"

#### LANG
Defaults to: en_EN.
Mind that this variable will get to apache server too, so it'll reach apache's plugins and modules.
dl-ticket supports a few languages choose the one you prefer, and help adding new ones!!!

Example: -e LANG=es_ES

#### TIMEZONE
Defaults to: UTC

Set your server's timezone as needed.

Example: -e TIMEZONE=Europe/Madrid

#### POST_MAX_SIZE
Defaults to: 20M

PHP's post_max_size.
Example: -e POST_MAX_SIZE=25M

#### UPLOAD_MAX_FILESIZE
Defaults to: 20M

PHP's upload_max_filesize.
Example: -e UPLOAD_MAX_FILESIZE=25M

#### MEMORY_LIMIT
Defaults to: 25M

PHP's memory_limit.
Example: -e MEMORY_LIMIT=25M

