#!/bin/bash

apt update
apt -y upgrade
apt install vim --yes --no-install-recommends   --fix-missing 
apt install bash-completion --yes --no-install-recommends   --fix-missing 
apt install wget --yes --no-install-recommends   --fix-missing 
apt install ca-certificates --yes --no-install-recommends   --fix-missing  
apt install gnupg --yes --no-install-recommends   --fix-missing 
 
echo "deb http://apt.postgresql.org/pub/repos/apt/ focal-pgdg main 13" > /etc/apt/sources.list.d/pgdg.list

wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -

apt-get install -y debconf-utils apt-utils
export DEBIAN_FRONTEND=noninteractive
export LANG=C
echo 'Installing locales...'
echo "locales locales/default_environment_locale select ${LOCALE}" | debconf-set-selections
echo "locales locales/locales_to_be_generated multiselect ${LOCALE} UTF-8" | debconf-set-selections
echo 'Check locales preconfiguration...'
debconf-get-selections | grep '^locales'

apt-get update
apt -y upgrade
apt install postgresql-client-13 -y --fix-missing
apt install postgresql-13 postgresql-contrib-13 -y --fix-missing  
apt install postgresql-server-dev-13 -y --fix-missing

echo "listen_addresses = '*'" >> /etc/postgresql/13/main/postgresql.conf 
echo "host    all             all             0.0.0.0/0                 md5" >> /etc/postgresql/13/main/pg_hba.conf

_contains () {  # Check if space-separated list $1 contains line $2
  echo "$1" | tr ' ' '\n' | grep -F -x -q "$2"
}
answers="Y N yes no"


read -p 'do you want to create admin user in DB ? (Y/N)' isuser
while ! _contains "${answers}" "${isuser}";
do   
    read -p 'do you want to create admin user in DB ? (Y/N)' isuser
done

if _contains "${answers}" "${isuser}"; then
    read -p 'admin user name: ' admin_user
    echo
    read -sp 'password: ' admin_password
    echo
    echo "CREATE USER $admin_user WITH PASSWORD '$admin_password';" | sudo -u postgres psql
    echo
    echo "ALTER USER $admin_user WITH SUPERUSER;" | sudo -u postgres psql
fi
 
read -p 'do you want to create DB ? (Y/N)' iscreatedb
while ! _contains "${answers}" "${iscreatedb}";
do   
    read -p 'do you want to create DB ? (Y/N)' iscreatedb
done 

if _contains "${answers}" "${iscreatedb}"; then
    read -p 'create db name: ' dbname
    echo "CREATE DATABASE $dbname;" | sudo -u postgres psql
fi