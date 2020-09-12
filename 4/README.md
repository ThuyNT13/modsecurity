## Docker 

Build image named `modsec` tagged with optional version tag `ssl` from Dockerfile located in current directory `.`:
```bash
$ docker image build -t modsec:ssl .
```

Run interactive (`-it`) container based off of modsec image. Container will autoremove upon exit (`--rm`).
```bash
$ docker container run --rm -it -p 8080:80 modsec:ssl sh
```

<!-- FIXME neither works for now -->
Inside container, make sure webserver is running:
```bash
# curl http://localhost/index.html
# curl http://localhost:80/index.html
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

## certs

generate CSR and key: 
```bash
openssl req -new -newkey rsa:4096 -nodes -keyout snakeoil.key -out snakeoil.csr
```
generate PEM and self-sign with key:
```bash
openssl x509 -req -sha256 -days 365 -in snakeoil.csr -signkey snakeoil.key -out snakeoil.pem
```

## References
- [A 6 Part Introductory OpenSSL Tutorial](https://www.keycdn.com/blog/openssl-tutorial)
- [Let's Encrypt - How It Works](https://letsencrypt.org/how-it-works/)