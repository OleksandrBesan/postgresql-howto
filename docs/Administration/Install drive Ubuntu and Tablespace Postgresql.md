# Installing ned drive Ubuntu and automount on load
## 1. Create the dir for mount 
```bash 
sudo mkdir data 
sudo groupadd data 
sudo usermod -aG data postgres
sudo chown -R  :data /data/path 
```
or just right to specific user 
```bash 
sudo chown postgres:postgres /data/path
```
## 2. prepare disk to ext4 
for new disks 
```bash 
sudo mkfs.ext4 /dev/sdb
```
to check disks
```bash 
lsblk -p
```

## 3. Then you will see the UUID
```bash 
sudo blkid
```

uuid for disks for example 
```
/dev/sdb: UUID="65ce9f99-452d-4c54-ac10-94e49536351e" TYPE="ext4"
```
## 4. Then change the mount 
In the file /etc/fstab
```bash 
sudo vi /etc/fstab
```
You will need to add a new line 
```
UUID=65ce9f99-452d-4c54-ac10-94e49536351e /data/path ext4 defaults 0 0   
```

Check and mount 
```bash
sudo mount -a 
```

The other way to just mount without automounting 
```bash
sudo mount /dev/sdb /data/path
```

The last step is restart and test if everything is correct.

# Managing new tablespace in postgres on new drive 
6. Database work 
```sql
CREATE TABLESPACE drive LOCATION '/data/path';

```
Manage and see tablespaces of current schema & tables in DB
```sql 
select  * from pg_tables; 
```

Move table to another tablespace 
```sql 
alter table schema.tablename set tablespace drive;
```

Create table in specific tablespace 
```sql 
CREATE table schema.tablename (x int) TABLESPACE drive;
```