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

Inside container, make sure webserver is running:
```bash
# curl http://172.17.0.2/
<html><body><h1>It works!</h1></body></html>
```