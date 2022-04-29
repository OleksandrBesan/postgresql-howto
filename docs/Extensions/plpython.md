# plpython manual 

## Install plpython extension
On the server 
```bash
sudo apt install python3 --fix-missing
sudo apt install postgresql-plpython3-13 --fix-missing
sudo apt install python3-pip --fix-missing
```

## Install on the postgresql db 


```sql
CREATE EXTENSION plpython3u;
```

To test, you can create simple function 
```sql
CREATE FUNCTION pymax (a integer, b integer)
  RETURNS integer
AS $$
  if a > b:
    return a
  return b
$$ LANGUAGE plpython3u;

select pymax(3,4)
DO $$
    # PL/Python code
$$ LANGUAGE plpython3u;

DO $$
	import sys
	plpy.info(sys.version)   
	plpy.info("hello")
$$ LANGUAGE plpython3u;
```

## Install  packages for python for use in postgresql
```bash
sudo su
pip3 install
```

# urls 
1. https://zoomadmin.com/HowToInstall/UbuntuPackage/postgresql-plpython-10
2. https://www.postgresql.org/docs/9.1/plpython.html
3. https://packages.debian.org/sid/main/postgresql-plpython3-13
4. https://www.postgresql.org/docs/9.1/plpython.html