FROM centos:6

COPY CentOS-Base.repo /etc/yum.repos.d/

RUN yum -y update
RUN yum -y install gcc wget openssl-devel bzip2-devel libffi-devel libjpeg-devel
RUN yum -y groupinstall 'development tools'

RUN yum -y install centos-release-scl && cd /tmp/ && \
    curl https://www.getpagespeed.com/files/centos6-scl-eol.repo --output /etc/yum.repos.d/CentOS-SCLo-scl.repo && \
    curl https://www.getpagespeed.com/files/centos6-scl-rh-eol.repo --output /etc/yum.repos.d/CentOS-SCLo-scl-rh.repo

RUN yum install -y devtoolset-9
RUN scl enable devtoolset-9 bash
RUN echo "source /opt/rh/devtoolset-9/enable" >> /etc/bashrc

RUN cd /tmp/ && curl https://ftp.openssl.org/source/old/1.1.1/openssl-1.1.1j.tar.gz -o openssl.tar.gz && \
    tar xvf openssl.tar.gz && cd openssl-* && export CFLAGS="-I/usr/include/openssl11" && \
    export LDFLAGS="-L/usr/lib64/openssl11" && export PYTHONPATH=/usr/local/bin/python3.11 && \
    ./config --prefix=/usr --openssldir=/etc/ssl --libdir=lib no-shared zlib-dynamic && make -j$(nproc) && make install && \
    cd .. && rm -rf openssl.tar.gz && rm -rf openssl-*

RUN cd /tmp/ && curl https://www.python.org/ftp/python/3.11.5/Python-3.11.5.tgz -o Python-3.11.5.tgz && \
    tar xzf Python-3.11.5.tgz && cd Python-3.11.5 && sed -i 's/PKG_CONFIG openssl /PKG_CONFIG openssl11 /g' configure && \
    ./configure --enable-optimizations --enable-unicode=ucs4 \
    --enable-shared LDFLAGS="-Wl,-rpath /usr/local/lib" && source /opt/rh/devtoolset-9/enable && make -j$(nproc) && make altinstall && \
    cd .. && rm -rf Python-3.11.5.tgz && rm -rf Python-3.11.5
RUN ln -sfn /usr/local/bin/python3.11 /usr/bin/python3.11

RUN cd /tmp/ && \
    wget https://github.com/OpenMathLib/OpenBLAS/releases/download/v0.3.25/OpenBLAS-0.3.25.tar.gz && \
    tar xvf OpenBLAS-0.3.25.tar.gz && cd OpenBLAS-0.3.25 && source /opt/rh/devtoolset-9/enable && \
    make -j$(nproc) && make PREFIX=/usr/local/OpenBLAS install && \
    cd .. && rm -rf OpenBLAS-0.3.25.tar.gz && rm -rf OpenBLAS-0.3.25

RUN python3.11 -m pip install --upgrade pip

RUN python3.11 -m pip install cmake
RUN cd /tmp/ && wget https://github.com/llvm/llvm-project/archive/refs/tags/llvmorg-14.0.6.tar.gz && \
    tar xfv llvmorg-14.0.6.tar.gz && cd llvm-project-llvmorg-14.0.6 && mkdir build && cd build && \
    source /opt/rh/devtoolset-9/enable && \
    cmake -DLLVM_ENABLE_PROJECTS=clang -DCMAKE_BUILD_TYPE=Release -G "Unix Makefiles" ../llvm && \
    make -j$(nproc) && make install && \
    cd ../.. && rm -rf llvmorg-14.0.6.tar.gz && rm -rf llvm-project-llvmorg-14.0.6
