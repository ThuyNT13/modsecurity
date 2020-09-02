ModSecurity testing lab 

Based off of [Apache/ModSecurity Tutorials](https://www.netnea.com/cms/apache-tutorials/) from [**netnea**](https://www.netnea.com)

- [x] [Tutorial 1 - Compiling an Apache web server](https://www.netnea.com/cms/apache-tutorial-1_compiling-apache/)
- [x] [Tutorial 2 - Configuring a minimal Apache server](https://www.netnea.com/cms/apache-tutorial-2_minimal-apache-configuration/)
- [ ] [Tutorial 4 - Configuring an SSL server](https://www.netnea.com/cms/apache-tutorial-4_configuring-ssl-tls/)
- [ ] [Tutorial 5 - Extending and analyzing the access log](https://www.netnea.com/cms/apache-tutorial-5/apache-tutorial-5_extending-access-log/)
- [ ] [Tutorial 6 - Embedding ModSecurity](https://www.netnea.com/cms/apache-tutorial-6/apache-tutorial-6_embedding-modsecurity/)
- [ ] [Tutorial 7 - Including the Core Rule Set](https://www.netnea.com/cms/apache-tutorial-7_including-modsecurity-core-rules/)
- [ ] [Tutorial 8 - Handling False Positives with the OWASP ModSecurity Core Rule Set ](https://www.netnea.com/cms/apache-tutorial-8_handling-false-positives-modsecurity-core-rule-set/)

## Docker 

Build image named `modsec` tagged with optional version tag `v1` from Dockerfile located in current directory `.`:
```bash
$ docker image build -t modsec:v1 .
```

Run interactive (`-it`) container based off of modsec image. Container will autoremove upon exit (`--rm`).
```bash
$ docker container run --rm -it -p 8080:80 modsec:v1 sh
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
