# Gunakan Debian terbaru sebagai base image
FROM debian:latest

# Set lingkungan
ENV TZ=Asia/Jakarta
ENV DEBIAN_FRONTEND=noninteractive

# Instal dependensi penting
RUN apt-get update && \
    apt-get install -y curl wget gnupg2 ca-certificates lsb-release && \
    rm -rf /var/lib/apt/lists/*

# Unduh dan jalankan installer resmi aaPanel
RUN wget -O install.sh https://www.aapanel.com/script/install_7.0_en.sh && \
    bash install.sh aapanel && \
    rm install.sh

# Expose port yang dibutuhkan:
# - 7800 untuk akses panel
# - 80/443 untuk HTTP/HTTPS
# - 21,22 untuk FTP/SSH (opsional)
EXPOSE 7800 80 443 21 22

# Volume untuk persistensi data dan konfigurasi
VOLUME ["/www/wwwroot", "/www/server/data", "/www/server/panel/vhost"]

# Jalankan aaPanel sebagai proses utama
CMD ["/usr/bin/python3", "/www/server/panel/class/panel.py", "--daemon", "off"]



