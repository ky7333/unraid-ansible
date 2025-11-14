#!/bin/bash

# Set default values for SSH_USERNAME if not provided
: ${SSH_USERNAME:=ubuntu}
  ${AUTHORIZED_KEYS:?"Error: AUTHORIZED_KEYS environment variable is not set."}
: ${SSHD_CONFIG_ADDITIONAL:=""}

# Create the user with the provided username
if id "$SSH_USERNAME" &>/dev/null; then
    echo "User $SSH_USERNAME already exists"
else
    useradd -ms /bin/bash "$SSH_USERNAME"
    echo "User $SSH_USERNAME created with no password"
fi

echo "$AUTHORIZED_KEYS" > /root/.ssh/authorized_keys
chown -R root:root /root/.ssh
chmod 700 /root.ssh
chmod 600 /root/.ssh/authorized_keys
echo "Authorized keys set for user $SSH_USERNAME"

# Apply additional SSHD configuration if provided
if [ -n "$SSHD_CONFIG_ADDITIONAL" ]; then
    echo "$SSHD_CONFIG_ADDITIONAL" >> /etc/ssh/sshd_config
    echo "Additional SSHD configuration applied"
fi

# Apply additional SSHD configuration from a file if provided
if [ -n "$SSHD_CONFIG_FILE" ] && [ -f "$SSHD_CONFIG_FILE" ]; then
    cat "$SSHD_CONFIG_FILE" >> /etc/ssh/sshd_config
    echo "Additional SSHD configuration from file applied"
fi

# Start the SSH server
echo "Starting SSH server..."
exec /usr/sbin/sshd -D