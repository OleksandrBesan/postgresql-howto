 # Install Oracle Client on Ubuntu (debian)
 
## Prepare & install packages 
First you will need to create the distination folder 
 ```bash
sudo mkdir /opt/oracle
 ```

Secondly you will need to create the folder to download all source to hold all needed files - rpm , zip and other. 
 ```bash
mkdir ~/oracle_bin 
mkdir ~/oracle_bin/rpm
mkdir ~/oracle_bin/zip
mkdir ~/oracle_bin/deb
 ```

Requierements to work unzip and make deb files from rpm
 ```bash
sudo apt-get install unzip --fix-missing
sudo apt-get install alien --fix-missing
sudo apt install alien libaio1 unixodbc --fix-missing
 ```
 

## Download zip and rpm packages 

[Source of oracle install files](https://www.oracle.com/ru/database/technologies/instant-client/linux-x86-64-downloads.html)
Then you should choose what you need to install  on page https://www.oracle.com/database/technologies/instant-client/downloads.html

```bash 
wget https://download.oracle.com/otn_software/linux/instantclient/213000/instantclient-basic-linux.x64-21.3.0.0.0.zip -P  ~/oracle_bin/zip
wget https://download.oracle.com/otn_software/linux/instantclient/213000/instantclient-sqlplus-linux.x64-21.3.0.0.0.zip -P  ~/oracle_bin/zip
 ```

```bash 
wget https://download.oracle.com/otn_software/linux/instantclient/213000/oracle-instantclient-sqlplus-21.3.0.0.0-1.el8.x86_64.rpm -P  ~/oracle_bin/rpm
wget https://download.oracle.com/otn_software/linux/instantclient/213000/oracle-instantclient-basic-21.3.0.0.0-1.el8.x86_64.rpm -P  ~/oracle_bin/rpm
wget https://download.oracle.com/otn_software/linux/instantclient/213000/oracle-instantclient-tools-21.3.0.0.0-1.el8.x86_64.rpm -P  ~/oracle_bin/rpm
wget https://download.oracle.com/otn_software/linux/instantclient/213000/oracle-instantclient-devel-21.3.0.0.0-1.el8.x86_64.rpm -P  ~/oracle_bin/rpm
wget https://download.oracle.com/otn_software/linux/instantclient/213000/oracle-instantclient-jdbc-21.3.0.0.0-1.el8.x86_64.rpm -P  ~/oracle_bin/rpm
wget https://download.oracle.com/otn_software/linux/instantclient/213000/oracle-instantclient-odbc-21.3.0.0.0-1.el8.x86_64.rpm -P  ~/oracle_bin/rpm
```

## Unzip the main files

```bash 
sudo unzip ~/oracle_bin/zip/instantclient-basic-linux.x64-21.3.0.0.0.zip -d /opt/oracle
sudo unzip ~/oracle_bin/zip/instantclient-sqlplus-linux.x64-21.3.0.0.0.zip -d /opt/oracle
```
## Make deb package 
```bash 
cd ~/oracle_bin/
sudo alien --script ~/oracle_bin/rpm/oracle-instantclient-tools-21.3.0.0.0-1.el8.x86_64.rpm
sudo alien --script ~/oracle_bin/rpm/oracle-instantclient-basic-21.3.0.0.0-1.el8.x86_64.rpm 
sudo alien --script ~/oracle_bin/rpm/oracle-instantclient-sqlplus-21.3.0.0.0-1.el8.x86_64.rpm
sudo alien --script ~/oracle_bin/rpm/oracle-instantclient-devel-21.3.0.0.0-1.el8.x86_64.rpm
sudo alien --script ~/oracle_bin/rpm/oracle-instantclient-jdbc-21.3.0.0.0-1.el8.x86_64.rpm
sudo alien --script ~/oracle_bin/rpm/oracle-instantclient-odbc-21.3.0.0.0-1.el8.x86_64.rpm
```
## Install deb
```bash 
sudo dpkg -i oracle-instantclient-basic_21.3.0.0.0-2_amd64.deb
sudo dpkg -i oracle-instantclient-sqlplus_21.3.0.0.0-2_amd64.deb
sudo dpkg -i oracle-instantclient-tools_21.3.0.0.0-2_amd64.deb
sudo dpkg -i oracle-instantclient-devel_21.3.0.0.0-2_amd64.deb
sudo dpkg -i oracle-instantclient-jdbc_21.3.0.0.0-2_amd64.deb
sudo dpkg -i oracle-instantclient-odbc_21.3.0.0.0-2_amd64.deb
```

## set ORACLE_HOME and tnsnames.ora
```bash  
export LD_LIBRARY_PATH=/usr/lib/oracle/21/client64/lib/
export ORACLE_HOME=/usr/lib/oracle/21/client64/lib/

```

The last is to put on the path  /usr/lib/oracle/21/client64/lib/network/admin - tnsnames.ora file. 

The example of the file tnsnames.ora

```
SID =
  (DESCRIPTION =
    (ADDRESS_LIST =
      (ADDRESS = (PROTOCOL = TCP)(HOST = ip)(PORT = 1521)) 
    )
    (CONNECT_DATA =
      (SERVICE_NAME=SID)
    )
  ) 
```

# CheatSheet 
```bash  

# To check 
sqlplus USER/PASSWORD@//IP:1521/SID 
# or 
sqlplus USER/PASSWORD@TNSNAME 

# check for open ports  
telnet ip 1521 

ping ip
```

# References

1. https://stackoverflow.com/questions/66830312/trying-to-install-oracle-xe-18c-in-linux-mint-but-getting-error-any-suggestions
2. https://housecomputer.ru/programs/alien/alien.html
3. https://internet-lab.ru/ubuntu_oracle_instant_client
4. https://help.ubuntu.com/community/Oracle%20Instant%20Client
5. https://www.oracle.com/ru/database/technologies/instant-client/linux-x86-64-downloads.html