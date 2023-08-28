FROM centos:centos7.9.2009

RUN yum update -y

RUN yum -y erase vim-minimal iputils libss && \
    yum -y install openssh openssh-server openssh-clients && \
    yum -y clean all

RUN mkdir /var/run/sshd
RUN echo 'root:toor' | chpasswd
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

# ENV NOTVISIBLE "in users profile"
# RUN echo "export VISIBLE=now" >> /etc/profile

RUN test -f /etc/ssh/ssh_host_ecdsa_key || /usr/bin/ssh-keygen -q -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -C '' -N ''
RUN test -f /etc/ssh/ssh_host_rsa_key || /usr/bin/ssh-keygen -q -t rsa -f /etc/ssh/ssh_host_rsa_key -C '' -N ''
RUN test -f /etc/ssh/ssh_host_ed25519_key || /usr/bin/ssh-keygen -q -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -C '' -N ''
RUN test -f /root/.ssh/id_rsa || /usr/bin/ssh-keygen -t rsa -f /root/.ssh/id_rsa -N ''
RUN test -f /root/.ssh/id_rsa.pub || ssh-keygen -y -t rsa -f ~/.ssh/id_rsa > ~/.ssh/id_rsa.pub
RUN test -f /root/.ssh/authorized_keys || /usr/bin/cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys

RUN yum install -y yum-utils 
RUN yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo 
RUN yum install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
