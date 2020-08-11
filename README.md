ModSecurity testing lab 

Based off of [Apache/ModSecurity Tutorials](https://www.netnea.com/cms/apache-tutorials/) from [**netnea**](https://www.netnea.com)

## Docker 

Download Debian image from DockerHub:
```bash
docker pull debian
```

Build image from Dockerfile:
```bash
docker image build -t <name_for_image>:<optional_tag> .
```