FROM ubuntu:24.04

# Set environment variables to avoid interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive
ENV SSHD_CONFIG_ADDITIONAL=""

# Install OpenSSH server, clean up, create directories, set permissions, and configure SSH
RUN apt-get update \
    && apt-get install -y iproute2 iputils-ping libguestfs-tools linux-image-generic openssh-server python3-guestfs python3-libvirt python3-lxml telnet \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && mkdir -p /run/sshd \
    && chmod 755 /run/sshd \
    && echo "PasswordAuthentication no" >> /etc/ssh/sshd_config

# Copy the script to configure the user's password and authorized keys
COPY configure-ssh-user.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/configure-ssh-user.sh

# Expose SSH port
EXPOSE 22

# Start SSH server
CMD ["/usr/local/bin/configure-ssh-user.sh"]