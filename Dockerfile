FROM debian:jessie
MAINTAINER Werner Beroux <werner@beroux.com>

# 1. Install compile and runtime dependencies
# 2. Compile PhantomJS from the source code
# 3. Remove compile depdencies
# We do all in a single commit to reduce the image size (a lot!)
RUN apt-get update \
    && apt-get install -y \
        build-essential \
        ca-certificates \
        curl \
        g++ \
        flex \
        bison \
        gperf \
        perl \
        python \
        ruby \
        libsqlite3-dev \
        libfontconfig1-dev \
        libicu-dev \
        libfreetype6 \
        libssl-dev \
        libpng-dev \
        libjpeg-dev \
    && mkdir /tmp/phantomjs \
    && curl -L https://github.com/ariya/phantomjs/archive/master.tar.gz | tar -xzC /tmp/phantomjs --strip-components=1 \
    && cd /tmp/phantomjs \
    && ./build.sh --confirm --silent --jobs 2 \
    && mv bin/phantomjs /usr/local/bin \
    && cd \
    && apt-get purge --auto-remove -y \
        build-essential \
        curl \
        g++ \
        flex \
        bison \
        gperf \
        ruby \
        perl \
        python \
    && apt-get clean \
    && rm -rf /tmp/* /var/lib/apt/lists/*

# Run as non-root user
RUN useradd --system --uid 72379 -m --shell /usr/sbin/nologin phantomjs
USER phantomjs

EXPOSE 8910

CMD ["/usr/local/bin/phantomjs"]
