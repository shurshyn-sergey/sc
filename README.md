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
| Command                                                          | Description                                                                                                         |
|------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------|
| `sc-add-user user [generate_password]`                           | add system user ( generate_password yes/no - no by default)                                                         |
| `sc-delete-user user`                                            | delete system user                                                                                                  |
| `sc-add-sudo-user user`                                          | add sudo user                                                                                                       |
| `sc-add-user-public-key user`                                    | add user public key                                                                                                 |
| `sc-add-mysql-database user database dbuser [generate_password]` | add mysql database and user ( system user prefix adding automatically,  generate_password yes/no - no by default )  |
| `sc-delete-mysql-database user database`                         | delete mysql database and user                                                                                      |
| `sc-add-user-domain user domain [php_version]`                   | add user domain                                                                                                     |
| `sc-delete-user-domain user domain`                              | delete user domain                                                                                                  |
| `sc-add-user-sftp-jail [user]`                                   | chroot user to home dir and access via sftp only                                                                    |
| `sc-delete-user-sftp-jail [user]`                                | delete user sftp jail                                                                                               |
| `sc-change-user-domain-php user domain php_version`              | change domain php version                                                                                           |
