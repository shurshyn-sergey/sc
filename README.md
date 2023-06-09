## INSTALL

```
git clone https://github.com/shurshyn-sergey/sc.git
```
```
chmod u+x ./sc/sc/install.sh && ./sc/sc/install.sh
```


<!---
## AFTER INSTALL
```
mysql
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'password';
exit
mysql_secure_installation
```
> #set password  
> #Remove anonymous users  
> #Disallow root login remotely  
> #Remove test database and access to it  

```
mysql -u root -p
ALTER USER 'root'@'localhost' IDENTIFIED WITH auth_socket;
```
-->


## COMMANDS
| Command                                                   | Description                                                           |
|-----------------------------------------------------------|-----------------------------------------------------------------------|
| `sc-add-user user`                                        | add system user                                                       |
| `sc-add-sudo-user user`                                   | add sudo user                                                         |
| `sc-add-user-public-key user`                             | add user public key                                                   |
| `sc-add-mysql-user user [db]`                             | add mysql user with same db name as username ( if db is not provided) |
| `sc-add-user-domain user domain [php_version]`            | add domain                                                            |
| `sc-add-user-sftp-jail [user]`                            | chroot user to home dir and access via sftp only                      |
| `sc-change-user-domain-php [user] [domain] [php_version]` | change domain php version                                             |
