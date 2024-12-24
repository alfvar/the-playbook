FROM ubuntu:latest

RUN apt-get update && \
    apt-get install -y sudo vim less curl wget net-tools openssh-server && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir /var/run/sshd && \
    useradd -m -s /bin/bash alfvar && \
    echo 'alfvar:test' | chpasswd && \
    usermod -aG sudo alfvar && \
    mkdir -p /home/alfvar/.ssh && \
    chmod 700 /home/alfvar/.ssh && \
    echo 'export PATH=$PATH:/usr/sbin' >> /etc/profile

COPY id_rsa.pub /home/alfvar/.ssh/authorized_keys
RUN chown -R alfvar:alfvar /home/alfvar/.ssh && \
    chmod 600 /home/alfvar/.ssh/authorized_keys && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/Port 22/Port 22/' /etc/ssh/sshd_config

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]