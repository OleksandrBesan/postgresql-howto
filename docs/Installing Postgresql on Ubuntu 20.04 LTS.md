Installing Postgresql on Ubuntu 20.04 LTS 
=========================================

# Prepare OS for install 
```bash
sudo apt update 
sudo apt -y upgrade
# Once the system has been updated, I recommend you perform a reboot to get the new kernel running incase it was updated.
sudo reboot
```
Install other packages and latest Postgres
Ubuntu 20.04 comes with Postgres 12 from it’s universe repository. Since we want version 13, we can directly use the PostgreSQL project’s official APT repository. This repository contains binaries for Ubuntu 20.04, and also includes packages for various extensions that you might want to install later.

```bash 
sudo apt -y install vim bash-completion wget
# add the repository
sudo tee /etc/apt/sources.list.d/pgdg.list <<END
deb http://apt.postgresql.org/pub/repos/apt/ focal-pgdg main
END

# get the signing key and import it
wget https://www.postgresql.org/media/keys/ACCC4CF8.asc
sudo apt-key add ACCC4CF8.asc

# fetch the metadata from the new repo
sudo apt-get update
```

# Install PostgreSQL Client DBMS on Ubuntu
```bash
sudo apt install postgresql-client-13 -y --fix-missing
```

# Install PostgreSQL Server on Ubuntu
```bash
sudo apt install postgresql-13 postgresql-contrib-13 -y --fix-missing
sudo apt install postgresql-server-dev-13 --fix-missing
```

### Check Port Used by PostgreSQL
```bash
ss -nlt
```
### Change Startup Settings
Enable startup postgresql
```bash
sudo systemctl enable postgresql
```
### Access PostgreSQL Server
```bash
sudo vi /etc/postgresql/13/main/postgresql.conf
```
Change the following line under the “CONNECTIONS AND AUTHENTICATIONS” section.
```
listen_addresses = ‘*’
```
### Allow Incoming Client to Connect
```bash
sudo vi /etc/postgresql/13/main/pg_hba.conf
```
```
Line = host all all 0.0.0.0/0 md5
```

###  Adjust Firewall Settings
You should make sure that the firewall does not stop incoming connections through the PostgreSQL port 5432. To do this, input the following command in the terminal window.
If there is any firewall..
```bash
sudo ufw allow from any to any port 5432 proto tcp
```
### Restart PostgreSQL
```bash
sudo systemctl restart postgresql
```
# Create a PostgreSQL Database and User
First, connect to the PostgreSQL shell with the following command:
```bash
sudo -i -u postgres
psql
```
Create user interactive
```bash
sudo -u postgres createuser --interactive 
```
OR 
Once connected, create a user and database with the following command:
```bash
postgres=# CREATE USER admin WITH PASSWORD 'password';
postgres=# CREATE DATABASE admin;


postgres=# CREATE USER admin WITH PASSWORD 'password';
postgres=# ALTER USER postgres PASSWORD 'password'; 
postgres=# ALTER USER admin WITH SUPERUSER;
```
Next, grant all the privileges to PostgreSQL database with the following command:
```bash
postgres=# GRANT ALL PRIVILEGES ON DATABASE admin to admin;
postgres=# ALTER USER admin WITH SUPERUSER;
```
Next, exit from the PostgreSQL shell with the following command:
```bash
postgres=# \q
exit
```

If you want to enter from command line by user admin you should add user linux 
```bash
sudo adduser admin
```

```bash
sudo -u admin psql
```
#  Install pgAdmin4

First, install all the required dependencies using the following command:
```bash
sudo apt-get install curl gnupg2 -y
```

Once installed, download and add the GPG key with the following command:
```bash
curl https://www.pgadmin.org/static/packages_pgadmin_org.pub | apt-key add
```
Next, add the pgAdmin4 repository using the following command:
```bash
sudo sh -c 'echo "deb https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$(lsb_release -cs) pgadmin4 main" > /etc/apt/sources.list.d/pgadmin4.list'
```
Next, update the repository cache and install the latest version of pgAdmin4 with the following command:
```bash
sudo apt-get update
sudo apt-get install pgadmin4
```
After installing pgAdmin4, you will need to run a web setup script to configure the system to run in web mode. You can run it using the following command;
```bash
/usr/pgadmin4/bin/setup-web.sh
```
You will be asked to provide your Email and password to finish the configuration as shown below.
```bash 
sudo apt-get install -y pgagent --fix-missing
```

```bash 
sudo passwd postgres
```

```sql 
CREATE EXTENSION pgagent;

CREATE USER "pgagent" WITH
  LOGIN
  NOSUPERUSER
  INHERIT
  NOCREATEDB
  NOCREATEROLE
  NOREPLICATION
  encrypted password 'password';

GRANT USAGE ON SCHEMA public TO pgagent;
GRANT USAGE ON SCHEMA pgagent TO pgagent;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA pgagent TO pgagent;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA pgagent TO pgagent;
```

Create .pgpass file.
```bash 
sudo su - postgres
echo localhost:5432:*:pgagent:securepassword >> ~/.pgpass
chmod 600 ~/.pgpass
chown postgres:postgres /var/lib/postgresql/.pgpass

```
Setup Logging directory
```bash
mkdir /var/log/pgagent
chown -R postgres:postgres /var/log/pgagent
chmod g+w /var/log/pgagent 
```
Create a config file and save to /etc/pgagent.conf
```bash 
#/etc/pgagent.conf
DBNAME=postgres
DBUSER=pgagent
DBHOST=localhost
DBPORT=5432
# ERROR=0, WARNING=1, DEBUG=2
LOGLEVEL=1
LOGFILE="/var/log/pgagent/pgagent.log"
```
/usr/lib/systemd/system/pgagent.service
```configfile
[Unit]
Description=PgAgent for PostgreSQL
After=syslog.target
After=network.target

[Service]
Type=forking

User=postgres
Group=postgres

# Location of the configuration file
EnvironmentFile=/etc/pgagent.conf

# Where to send early-startup messages from the server (before the logging
# options of pgagent.conf take effect)
# This is normally controlled by the global default set by systemd
# StandardOutput=syslog

# Disable OOM kill on the postmaster
OOMScoreAdjust=-1000

ExecStart=/usr/bin/pgagent -s ${LOGFILE}  -l ${LOGLEVEL} host=${DBHOST} dbname=${DBNAME} user=${DBUSER} port=${DBPORT}
KillMode=mixed
KillSignal=SIGINT

Restart=on-failure

# Give a reasonable amount of time for the server to start up/shut down
TimeoutSec=300

[Install]
WantedBy=multi-user.target
```
Start Service
```bash 
sudo -i
systemctl daemon-reload
systemctl disable pgagent
systemctl enable pgagent
systemctl start pgagent
systemctl restart pgagent
systemctl status pgagent
```
# Cheatsheet commands 

```bash
psql -h localhost -d postgres -U pgagent  
# manage service postgresql
sudo systemctl start postgresql
sudo systemctl status postgresql
sudo systemctl stop postgresql
sudo systemctl restart postgresql
#Check Port Used by PostgreSQL
ss -nlt
ss -antpl | grep 5432

#Check version of postgres
psql -V psql
journalctl -u pgagent.service
journalctl -u postgresql.service
journalctl -u pgadmin.service

# see database log 
sudo tail -f /var/log/postgresql/postgresql-13-main.log
sudo tail -f /var/log/postgresql/postgresql-14-main.log
# see pgagent log 
sudo vi /var/log/pgagent/pgagent.log

# configuration file 
sudo vi /etc/postgresql/13/main/postgresql.conf
sudo vi /etc/postgresql/13/main/pg_hba.conf 
sudo vi /etc/pgagent.conf


sudo vi /etc/postgresql/14/main/postgresql.conf
sudo vi /etc/postgresql/14/main/pg_hba.conf 
``` 

### Remove PgAdmin , Postgresql
to check 
dpkg -l | grep postgres

sudo apt-get --purge remove pgagent
sudo apt-get --purge remove postgresql postgresql-*
sudo apt autoremove pgadmin4
sudo rm -rf /etc/postgresql/
sudo rm -rf /var/log/postgresql/
sudo rm -rf /var/lib/postgresql/
sudo rm -rf /var/lib/pgadmin/
sudo rm -rf /var/log/pgadmin/
sudo rm -rf /var/log/pgagent/
sudo rm -rf /etc/pgagent.conf

After reboot 
sudo deluser postgres