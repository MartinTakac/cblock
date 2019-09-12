FROM gitlab.soulmachines.com:5005/cogarch/sml-base:latest

# Normally this is all bad security practice, but these containers are only ever run locally
# or on Jenkins, i.e. within the company, so it's not a problem.

RUN mkdir /var/run/sshd

RUN apt-get update && apt-get install --yes rsync zip openssh-server gdb

# Need to change settings in ssh config to let us login without a password so VScode can communicate with it
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config && \
    sed -i 's/PermitEmptyPasswords no/PermitEmptyPasswords yes/g' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/g' /etc/ssh/sshd_config && \
    sed -i 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config && \
    ssh-keygen -A

# This is so we can SSH into the local container without a password
RUN passwd -d root

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
