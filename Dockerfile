FROM factual/docker-cdh5-base

# for ruby 2.3
RUN apt-add-repository ppa:brightbox/ruby-ng

ENV MAVEN_VERSION=3.3.9
RUN apt-get update
RUN apt-get install -y git-core build-essential unzip zlib1g-dev libcurl4-gnutls-dev libncurses5-dev 
RUN apt-get install -y ruby2.3 ruby2.3-dev nodejs npm
RUN gem install bundler --no-rdoc --no-ri

RUN apt-get install -y ldap-utils libpam-ldap libnss-ldap nslcd
RUN apt-get install -y spark-core spark-python hive

RUN apt-get install -y openjdk-8-jdk-headless

#maven
ADD http://apache.cs.utah.edu/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz .
RUN cd /opt/ && tar xzf ../apache-maven-$MAVEN_VERSION-bin.tar.gz
RUN echo "PATH=$PATH:/opt/apache-maven-$MAVEN_VERSION/bin" >> /etc/profile

RUN update-ca-certificates -f

#lein
ADD https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein /bin/lein
ENV LEIN_ROOT=true
RUN chmod +x /bin/lein
RUN lein --version

#Drake
ADD https://raw.githubusercontent.com/Factual/drake/master/bin/drake /bin/drake
RUN chmod 755 /bin/drake


#cleanup
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


ADD bootstrap.sh /etc/my_init.d/099_bootstrap


