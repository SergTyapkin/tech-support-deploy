# TechSupport deployment
- Frontend: https://github.com/SergTyapkin/tech-support-frontend
- Backend: https://github.com/SergTyapkin/tech-support-backend

---
### CentOS 7 deployment:
> On Ubuntu `yum` just changes to `apt-get`

```shell
yum install -y epel-release
yum -y update
yum install -y --update


# ----- SETUP THE ENVIRONMENT ------
nano /etc/environment
# --> Set "environment" into it
```
> [environment](environment)
```shell
PATH=$PATH:/usr/pgsql-12/bin
reboot


# ------ INSTALL DATABASE -------
yum -y install postgresql-12  
reboot
yum install postgresql-devel
systemctl enable postgresql-12 --now
su - postgres
createuser "tech-support-backend"
createuser "backups"
psql
# --> CREATE DATABASE "tech-support";
# --> \password "tech-support-backend"
# -----> Enter your <TECH_SUPPORT_BACKEND_PASSWORD>
# --> \password "backups"
# -----> Enter your <BACKUPS_PASSWORD>
# --> ALTER DEFAULT PRIVILEGES FOR USER backups IN SCHEMA public GRANT SELECT ON SEQUENCES TO backups;
# --> ALTER DEFAULT PRIVILEGES FOR USER backups IN SCHEMA public GRANT SELECT ON TABLES TO backups;
# --> \q
psql -t -P format=unaligned -c 'show hba_file';
nano /var/lib/pgsql/12/data/pg_hba.conf
# --> Change all "md5" methods to "password". See pd_hba.conf
```
> [pg_hba.conf](pg_hba.conf)
```shell
systemctl restart postgresql-12
exit


# ------ INSTALL NGINX -------
yum -y install nginx
nano /etc/nginx/nginx.conf
# --> Set nginx.conf into it
```
> [nginx.conf](nginx.conf)
```shell
nginx -t
systemctl enable nignx --now
firewall-cmd --zone=public --permanent --add-service=http
firewall-cmd --zone=public --permanent --add-service=https
firewall-cmd --reload

# ------ INSTALL CERTBOT FOR HTTPS ON NGINX -----
sudo yum install certbot certbot-python-nginx
yum install python3-certbot-nginx
certbot certonly --nginx -d creativetechteam.bmstu.ru -d www.creativetechteam.bmstu.ru
systemctl restart nginx

# ----- SETUP DATABASE BACKUPS -----
nano ~/.pgpass
# --> Set .pgpass into it
```
> [.pgpass](.pgpass)
```shell
chmod 0600 ~/.pgpass

# ----- INSTALL CRONTAB TO RENEWING CERTS, SET AUTO-ACHIEVEMENTS AND DATABASE BACKUPS -----
mkdir /pg_backups  # directory for backups
yum install crontabs
crontab -e
# --> Set "crontab -e" into it 
```
> [crontab -e](crontab%20-e)
```shell
systemctl enable crond.service --now

# ------ INSTALL BACKEND -------
cd /home
yum -y install python3.10
git clone https://github.com/SergTyapkin/tech-support-backend
cd tech-support-backend
pip3.10 install psycopg2-binary
pip3.10 install pillow
pip3.10 install flask
pip3.10 install -r requirements.txt


# ------ INSTALL GUNICORN -------
pip install gunicorn
nano /etc/systemd/system/gunicorn_site.service
# --> Set gunicorn_site.service into it
```
> [gunicorn_site.service](gunicorn_site.service)
```shell
chmod +x /etc/systemd/system/gunicorn_site.service
systemctl enable gunicorn_site --now


# ------ INSTALL FRONTEND -------
cd /home
curl -sL https://rpm.nodesource.com/setup_12.x | sudo bash -
yum install -y nodejs
git clone https://github.com/SergTyapkin/tech-support-frontend
cd tech-support-frontend
npm install -y
cd node_modules
nano \@jitbit/htmlsanitizer/HtmlSanitizer.js
# --> Add "export default" before the first variable


# ----- CREATE DIR TO FRONT DIST FILES ------
mkdir /data/techSupport
mkdir /data/techSupportImages
mkdir /data/techSupportImages/image
chown nginx /data/techSupportImages/image/
chmod ogu+rwx /data/techSupportImages/image/*
chmod ogu+rwx /data/techSupportImages/image


# ----- CREATE UPDATING SCRIPTS -------
cd /home
nano override_config.json
# --> Set override_config.json into it
```
> [override_config.json](override_config.json)
```shell
nano override_autoAchievementsConfig.json
# --> Set override_autoAchievementsConfig.json into it
```
> [override_autoAchievementsConfig.json](override_autoAchievementsConfig.json)
```shell

cd ~
nano front-update.sh
# --> Set front-update.sh into it
```
> [front-update.sh](front-update.sh)
```shell
nano back-update.sh
# --> Set back-update.sh into it
```
> [back-update.sh](back-update.sh)
```shell
nano all-update.sh
# --> Set all-update.sh into it
```
> [all-update.sh](all-update.sh)
```shell
chmod +x front-update.sh back-update.sh all-update.sh
./all-update.sh


# ----- SET MINIMAL ACCESS RIGHTS IN DB TO BACKEND -----
psql -U  postgres
# --> \connect "tech-support"
# --> Execute all commands from "minimalAccessRights.sql"
```
> [minimalAccessRights.sql](minimalAccessRights.sql)
```shell


# ----- CHECK SERVICES ------
systemctl daemon-reload

systemctl status postgresql-12
systemctl status nginx
systemctl status gunicorn_site
systemctl status cron
```


