FROM ruby:2.7.2

WORKDIR /tmp
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN curl -sL https://deb.nodesource.com/setup_16.x -o nodesource_setup.sh
RUN chmod +x ./nodesource_setup.sh
RUN ./nodesource_setup.sh

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    locales \
    nodejs \
    yarn \
    && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && dpkg-reconfigure --frontend=noninteractive locales \
    && update-locale LANG=en_US.UTF-8

WORKDIR /app
ENV LANG en_US.UTF-8 
ENV LC_ALL en_US.UTF-8
ENV RUBYOPT='-W:no-deprecated -W:no-experimental' 
# RUN gem install minitest

