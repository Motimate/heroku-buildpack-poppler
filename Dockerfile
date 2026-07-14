FROM heroku/heroku:22

# 26.07.0 requires Freetype >= 2.13; heroku-22 ships 2.11.1. 26.04.0 is the
# newest poppler that still builds against heroku-22's system libraries.
ARG version=26.04.0
ARG cmake_version=3.31.6

RUN apt-get -y update && apt-get -y install build-essential checkinstall curl ca-certificates libfreetype6-dev libfontconfig1-dev libjpeg-dev libtiff-dev libopenjp2-7-dev libnss3-dev libcairo2-dev libboost-dev liblcms2-dev libcurl4-openssl-dev

# Ubuntu 22.04 (heroku-22) ships CMake 3.22.1, but poppler requires >= 3.28.
# Install an official CMake binary into /usr/local just for the build.
RUN curl -fsSL "https://github.com/Kitware/CMake/releases/download/v${cmake_version}/cmake-${cmake_version}-linux-x86_64.tar.gz" \
  | tar -xz --strip-components=1 -C /usr/local
# Security patches applied on top of the checked-out release (see patches/).
COPY patches/ /tmp/patches/

RUN mkdir -p /tmp/install && \
  git clone https://gitlab.freedesktop.org/poppler/poppler.git && \
  cd poppler && \
  git checkout poppler-${version} && \
  git apply --recount --verbose /tmp/patches/*.patch && \
  mkdir build && \
  cd build && \
  cmake .. \
  -DCMAKE_INSTALL_PREFIX=/usr \
  -DCMAKE_BUILD_TYPE=release \
  -DBUILD_GTK_TESTS=OFF \
  -DBUILD_QT5_TESTS=OFF \
  -DBUILD_QT6_TESTS=OFF \
  -DBUILD_CPP_TESTS=OFF \
  -DENABLE_QT5=OFF \
  -DENABLE_QT6=OFF \
  -DENABLE_GPGME=OFF && \
  make -j$(nproc --all) && \
  checkinstall -y --install=no --backup=no --fstrans=no \
  --pkgname=poppler --pkgversion=${version} \
  -- make install DESTDIR=/tmp/install
