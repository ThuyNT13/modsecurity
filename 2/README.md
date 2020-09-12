## Docker 

Build image named `modsec` tagged with optional version tag `config` from Dockerfile located in current directory `.`:
```bash
$ docker image build -t modsec:config .
```

Run interactive (`-it`) container based off of modsec image. Container will autoremove upon exit (`--rm`).
```bash
$ docker container run --rm -it -p 8080:80 modsec:config sh
```

Inside container, make sure webserver is running:
```bash
# curl http://localhost/index.html
<html><body><h1>It works!</h1></body></html>
```

Or for more detail:
```bash
# curl --verbose http://localhost/index.html
```

Run a simple benchmarking test to get performance results:
```bash
ab -c 1 -n 1000 http://localhost/index.html
```

Script to determine if all modules loaded in confugration files is actually being used:
```bash
grep LoadModule /apache/conf/httpd.conf | awk '{print $2}' | sed -e "s/_module//" | while read M; do \
echo "Module $M"; R=$(httpd -L | grep $M | cut -d\  -f1 | tr -d "<" | xargs | tr " " "|"); \
egrep -q "$R" /apache/conf/httpd.conf; \
if [ $? -eq 0 ]; then echo "OK"; else echo "Not used"; fi; echo; \
done
```
