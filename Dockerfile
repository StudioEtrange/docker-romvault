FROM ghcr.io/linuxserver/baseimage-guacgui
# ubuntu bionic

# set version label
LABEL maintainer="StudioEtrange <sboucault@gmail.com>"

# environment settings
ARG DEBIAN_FRONTEND="noninteractive"
ENV PYTHONIOENCODING=utf-8
ENV APPNAME="ROMVault" UMASK_SET="022"

# default versions
# pick versions at build time like "3.4.4" from https://www.romvault.com/
ARG ROMVAULT_VERSION="latest"
ARG RVCMD_VERSION="latest"


ENV ROMVAULT_VERSION="${ROMVAULT_VERSION}"
ENV RVCMD_VERSION="${RVCMD_VERSION}"


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
    echo "deb https://download.mono-project.com/repo/ubuntu stable-bionic main" | tee /etc/apt/sources.list.d/mono-official-stable.list && \
    apt update && \
    apt-get install -y --no-install-recommends \
        # problem with netstandard 2.0 https://github.com/mono/mono/issues/17148
        #mono-runtime \
        #libmono-system-servicemodel4.0a-cil \
        mono-complete

# Get latest version of ROMVault windows binary & RVCmd linux binary
RUN if [ "$ROMVAULT_VERSION" = "latest" ]; then FILTER='head -1'; else FILTER="grep $ROMVAULT_VERSION"; fi && \
    ROMVAULT_DOWNLOAD=$(curl -kLs 'https://www.romvault.com' | \
        sed -n 's/.*href="\([^"]*\).*/\1/p' | \
        grep -i download | \
        grep -i romvault | \
        sort -r -f -u | \
        $FILTER) \
        && \
    if [ "$RVCMD_VERSION" = "latest" ]; then FILTER='head -1'; else FILTER="grep $RVCMD_VERSION"; fi && \
    RVCMD_DOWNLOAD=$(curl -kLs 'https://www.romvault.com' | \
        sed -n 's/.*href="\([^"]*\).*/\1/p' | \
        grep -i download | \
        grep -i rvcmd | \
        grep -i linux | \
        sort -r -f -u | \
        $FILTER) \
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


# add local files
COPY root/ /




  