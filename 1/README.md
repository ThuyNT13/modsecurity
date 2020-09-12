## Docker 

Build image named `modsec` tagged with optional version tag `minimal` from Dockerfile located in current directory `.`:
```bash
$ docker image build -t modsec:minimal .
```

Run interactive (`-it`) container based off of modsec image. Container will autoremove upon exit (`--rm`).
```bash
$ docker container run --rm -it -p 8080:80 modsec:minimal sh
```

Inside container, make sure webserver is running:
```bash
# curl http://172.17.0.2/
<html><body><h1>It works!</h1></body></html>
```