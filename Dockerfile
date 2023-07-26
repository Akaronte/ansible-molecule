FROM ubuntu:22.04

RUN apt-get update && apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN echo 'root:toor' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

RUN apt-get update && apt-get install -y software-properties-common gcc && \
    add-apt-repository -y ppa:deadsnakes/ppa

RUN apt-get update && apt-get install -y python3 python3-distutils python3-pip python3-apt

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
  && apt-get install -y python3-pip python3-dev \
  && cd /usr/local/bin \
  && ln -s /usr/bin/python3 python \
  && pip3 --no-cache-dir install --upgrade pip \
  && rm -rf /var/lib/apt/lists/*

RUN apt-get -y install python3-pip 
RUN pip3 install ansible molecule pywinrm ansible-lint molecule[lint] molecule[docker]

#RUN ssh-keygen -q -t rsa -N '' -f ~/.ssh/id_rsa <<<y >/dev/null 2>&1

RUN  ssh-keygen -b 4096 -t rsa -f /tmp/sshkey -q -N ""

RUN apt install apt-transport-https 

RUN apt install  ca-certificates

RUN apt install software-properties-common

RUN apt update

RUN apt install curl rsync -y

RUN apt-cache policy docker-ce 

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

RUN apt update

RUN apt install docker-ce -y

WORKDIR /
RUN apt -y install git && \
    apt-get clean && \
    apt-get autoremove && \
    mkdir /home/ansible/ && \
    groupadd -g 1000060001 ansible && \
    useradd -u 1001 -g ansible -d /home/ansible -s /bin/bash ansible && \
    chown -R ansible:ansible /home/ansible

RUN pip install yamllint ansible-lint molecule molecule-docker

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]