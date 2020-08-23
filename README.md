ModSecurity testing lab 

Based off of [Apache/ModSecurity Tutorials](https://www.netnea.com/cms/apache-tutorials/) from [**netnea**](https://www.netnea.com)

## Docker 

Build image named `modsec` tagged with optional version tag `v1` from Dockerfile located in current directory `.`:
```bash
$ docker image build -t modsec:v1 .
```

Run interactive (`-it`) container based off of modsec image. Container will autoremove upon exit (`--rm`).
```bash
$ docker container run --rm -it -p 8080:80 modsec:v1 sh
```

Inside container, make sure webserver is running with curl:
```bash
# curl http://localhost:80/index.html
<html><body><h1>It works!</h1></body></html>
```

Also try `http://127.0.0.1:80/index.html`

Script to determine if all modules loaded in confugration files is actually being used:
```bash
grep LoadModule /apache/conf/httpd.conf | awk '{print $2}' | sed -e "s/_module//" | while read M; do \
echo "Module $M"; R=$(httpd -L | grep $M | cut -d\  -f1 | tr -d "<" | xargs | tr " " "|"); \
egrep -q "$R" /apache/httpd.conf; \
if [ $? -eq 0 ]; then echo "OK"; else echo "Not used"; fi; echo; \
done
```