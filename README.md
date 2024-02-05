# centos-python-docker

This is a Docker image of a Python 3.6 installation in a CentOS 6 environment. 

This should be useful for anyone developing Python applications in legacy enterprise servers.

## Installation

To just use the image:

```shell
docker run --plaftorm linux/amd64 -it fabiofortkamp/centos-python:3.6
```

This start an IPython shell inside the container.

## Building

To build the image locally:

```shell
docker build . --platform linux/amd64 -t fabiofortkamp/centos-python:3.6
```

## Acknowledgments

The initial idea and Dockerfile was provided by João Paulo Nogueira de Araújo from UFAL in Brazil.
