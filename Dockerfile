FROM centos:6

COPY CentOS-Base.repo /etc/yum.repos.d/

RUN yum -y update
RUN yum -y install gcc openssl-devel bzip2-devel
RUN cd /tmp/ && curl https://www.python.org/ftp/python/3.6.6/Python-3.6.6.tgz -o Python-3.6.6.tgz && tar xzf Python-3.6.6.tgz && cd Python-3.6.6 && ./configure --enable-optimizations --enable-unicode=ucs4 --enable-shared LDFLAGS="-Wl,-rpath /usr/local/lib" && make altinstall
RUN ln -sfn /usr/local/bin/python3.6 /usr/bin/python3.6

RUN yum -y install python34-pip python-devel python3-dev libpython3.6-dev
RUN yum -y groupinstall 'development tools'

RUN python3.6 -m pip install --upgrade pip
RUN python3.6 -m pip install ipython

CMD ["ipython"]

