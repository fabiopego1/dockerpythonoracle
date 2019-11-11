#Before mounting the image be sure that you have all the needed files and folders in the same directory as this one.
#Required Oracle Instant Client Files:
#Download required files from http://www.oracle.com/technetwork/topics/linuxx86-64soft-092277.html
#oracle-instantclient12.1-basic-12.1.0.2.0-1.x86_64.rpm
#oracle-instantclient12.1-sqlplus-12.1.0.2.0-1.x86_64.rpm
#oracle-instantclient12.1-devel-12.1.0.2.0-1.x86_64.rpm

#Installing Python 3.7 and copying all folders in the same directory.
FROM python:3.7
ENV PYTHONHONUNBUFFERED 1
RUN mkdir /code
WORKDIR /code
COPY . /code/

#Installing Miniconda
RUN curl -LO http://repo.continuum.io/miniconda/Miniconda-latest-Linux-x86_64.sh
RUN bash Miniconda-latest-Linux-x86_64.sh -p /miniconda -b
RUN rm Miniconda-latest-Linux-x86_64.sh
ENV PATH=/miniconda/bin:${PATH}
RUN conda update -y conda

#Installing Oracle Instant Client
ENV ORACLE_HOME=/usr/lib/oracle/12.1/client64
ENV PATH=$PATH:$ORACLE_HOME/bin
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$ORACLE_HOME/lib
ADD oracle-instantclient12.1-basic-12.1.0.2.0-1.x86_64.rpm /tmp/
ADD oracle-instantclient12.1-sqlplus-12.1.0.2.0-1.x86_64.rpm /tmp/
ADD oracle-instantclient12.1-devel-12.1.0.2.0-1.x86_64.rpm /tmp/
# Setup locale, Oracle instant client and Python
RUN apt-get update \
    && apt-get -y install alien libaio1 \
    && alien -i /tmp/oracle-instantclient12.1-basic-12.1.0.2.0-1.x86_64.rpm \
    && alien -i /tmp/oracle-instantclient12.1-sqlplus-12.1.0.2.0-1.x86_64.rpm \
    && alien -i /tmp/oracle-instantclient12.1-devel-12.1.0.2.0-1.x86_64.rpm \
    && ln -snf /usr/lib/oracle/12.1/client64 /opt/oracle \
    && mkdir -p /opt/oracle/network \
    && ln -snf /etc/oracle /opt/oracle/network/admin \
    && pip install cx_oracle \
    && apt-get clean && rm -rf /var/cache/apt/* /var/lib/apt/lists/* /tmp/* /var/tmp/*