FROM heroku/heroku:22

ARG version=25.03.0

RUN apt-get -y update && apt-get -y install build-essential cmake checkinstall libfreetype6-dev libfontconfig1-dev libjpeg-dev libtiff-dev libopenjp2-7-dev libnss3-dev libcairo2-dev libboost-dev liblcms2-dev libcurl4-openssl-dev
RUN mkdir -p /tmp/install && \
    git clone https://gitlab.freedesktop.org/poppler/poppler.git && \
    cd poppler && \
    git checkout poppler-${version} && \
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
