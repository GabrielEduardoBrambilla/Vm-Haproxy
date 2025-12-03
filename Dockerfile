FROM haproxy:lts

USER root

# Create directory for certs
RUN mkdir -p /etc/haproxy/certs

# Copy configuration
COPY haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg

# Copy SSL certs from build context (expecting them to be in ./ssl_certs/)
# We need to combine them into a single PEM file for HAProxy
COPY fullchain.pem /etc/haproxy/certs/fullchain.pem
COPY wildcard.key /etc/haproxy/certs/wildcard.key

# Combine cert and key into haproxy.pem
RUN cat /etc/haproxy/certs/fullchain.pem /etc/haproxy/certs/wildcard.key > /etc/haproxy/certs/haproxy.pem && \
    chmod 600 /etc/haproxy/certs/haproxy.pem && \
    chown -R haproxy:haproxy /etc/haproxy/certs

USER haproxy
