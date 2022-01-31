FROM ruby:2.7.2

WORKDIR /tmp
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN curl -sL https://deb.nodesource.com/setup_16.x -o nodesource_setup.sh
RUN chmod +x ./nodesource_setup.sh
RUN ./nodesource_setup.sh

RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    locales \
    nodejs \
    yarn \
    gh \
    && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && dpkg-reconfigure --frontend=noninteractive locales \
    && update-locale LANG=en_US.UTF-8

WORKDIR /app
ENV LANG en_US.UTF-8 
ENV LC_ALL en_US.UTF-8
ENV RUBYOPT='-W:no-deprecated -W:no-experimental' 
# RUN gem install minitest

