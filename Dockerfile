# Use Debian as base
FROM debian:latest

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV URL=https://www.aapanel.com/script/install_7.0_en.sh

# Install dependencies
RUN apt-get update && \
    apt-get install -y curl wget sudo locales tzdata cron && \
    ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    dpkg-reconfigure --frontend noninteractive tzdata

# Create persistent directories
VOLUME ["/www", "/www/server"]

# Download and install aaPanel
RUN if [ -f /usr/bin/curl ]; then \
        curl -ksSO "$URL"; \
    else \
        wget --no-check-certificate -O install_7.0_en.sh "$URL"; \
    fi && \
    bash install_7.0_en.sh

# Create startup script
RUN echo '#!/bin/bash\n\
/etc/init.d/bt start\n\
tail -f /www/server/panel/logs/error.log' > /start.sh && chmod +x /start.sh

# Expose aaPanel's default port
EXPOSE 8888

# Run aaPanel on container start
CMD ["/bin/bash", "/start.sh"]
