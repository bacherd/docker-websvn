# docker-websvn

A simple webdav subversion server with websvn.

## how to use

The container store their data in */opt/repositories* and
use the files *dav_svn.authz* and *dav_svn.passwd* for
authority.

#### docker run
```
docker run --name websvn -d \
    -v ./repositories:/opt/repositories \
    -v ./config:/opt/config \
    -p 80:80 \
    bacherd/websvn
```    

### docker-compose
```
websvn:
   image: websvn
   ports:
     - 80:80
   environment:
     - BACKUP=true
   volumes:
     - ./repositories:/opt/repositories
     - ./backups:/opt/backups
     - ./imports:/opt/imports
     - ./config:/opt/config
   restart: always
```   

## configure
The files *dav_svn.authz* and *dav_svn.passwd* automatic created
*/opt/config/* if they do not exist.

## backups

The environment variable *BACKUP* can be set for daily backup.
The backup is stored in */opt/backups*.

## import or create a new repository
All svn dump files stored in */opt/imports* will automatically imported on
container start.
