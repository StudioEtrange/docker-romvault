FROM jlesage/baseimage-gui:debian-10-v3.5.7



RUN set -x && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        curl \
        wget \
        gnupg \
        ca-certificates \
        unzip \
        libgtk2.0-0 \
        apt-transport-https \
        dirmngr \
        && \
    # https://www.mono-project.com/download/stable/#download-lin
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF && \
    echo "deb https://download.mono-project.com/repo/ubuntu stable-buster main" | tee /etc/apt/sources.list.d/mono-official-stable.list && \
    apt update && \
    apt-get install -y --no-install-recommends \
        # problem with netstandard 2.0 https://github.com/mono/mono/issues/17148
        #mono-runtime \
        #libmono-system-servicemodel4.0a-cil \
        mono-complete

# Get latest version of ROMVault windows binary & RVCmd linux binary
RUN ROMVAULT_DOWNLOAD=$(curl -kLs 'https://www.romvault.com' | \
        sed -n 's/.*href="\([^"]*\).*/\1/p' | \
        grep -i download | \
        grep -i romvault | \
        sort -r -f -u | \
        head -1) \
        && \
    RVCMD_DOWNLOAD=$(curl -kLs 'https://www.romvault.com' | \
        sed -n 's/.*href="\([^"]*\).*/\1/p' | \
        grep -i download | \
        grep -i rvcmd | \
        grep -i linux | \
        sort -r -f -u | \
        head -1) \
        && \
    # Document Versions
    echo "romvault" $(basename --suffix=.zip $ROMVAULT_DOWNLOAD | cut -d "_" -f 2) >> /VERSIONS && \
    echo "rvcmd" $(basename --suffix=.zip $RVCMD_DOWNLOAD | cut -d "_" -f 2) >> /VERSIONS && \
    # Download RomVault
    mkdir -p /opt/romvault_downloads/ && \
    curl --output /opt/romvault_downloads/romvault.zip "https://www.romvault.com/${ROMVAULT_DOWNLOAD}" && \
    curl --output /opt/romvault_downloads/rvcmd.zip "https://www.romvault.com/${RVCMD_DOWNLOAD}" && \
    unzip /opt/romvault_downloads/romvault.zip -d /opt/romvault/ && \
    unzip /opt/romvault_downloads/rvcmd.zip -d /opt/romvault/ && \
    chmod -R +x /opt/romvault

# Clean up
RUN rm -rf /opt/romvault_downloads && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

COPY startapp.sh /startapp.sh
COPY etc/ /etc/

ENV APP_NAME="ROMVault"




  