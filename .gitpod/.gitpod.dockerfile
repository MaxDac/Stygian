FROM gitpod/workspace-postgres

ENV DEBIAN_FRONTEND noninteractive

USER root

RUN sudo apt-get update -y \
    && apt-get install curl software-properties-common apt-transport-https lsb-release git -y \
    # && curl -fsSL https://packages.erlang-solutions.com/ubuntu/erlang_solutions.asc | gpg --dearmor -o /etc/apt/trusted.gpg.d/erlang.gpg \
    # && echo "deb https://packages.erlang-solutions.com/ubuntu $(lsb_release -cs) contrib" | tee /etc/apt/sources.list.d/erlang.list \
    # && apt-get update -y \
    # && apt-get install erlang -y \
    # && apt-get install elixir -y \
    && sudo apt-get install -y build-essential autoconf m4 libncurses5-dev libwxgtk3.0-gtk3-dev libwxgtk-webview3.0-gtk3-dev libgl1-mesa-dev libglu1-mesa-dev libpng-dev libssh-dev unixodbc-dev xsltproc fop libxml2-utils libncurses-dev \
    && apt-get install inotify-tools -y \
    && apt-get clean && rm -rf /var/cache/apt/* && rm -rf /var/lib/apt/lists/* && rm -rf /tmp/*

USER gitpod

RUN brew install asdf

RUN asdf plugin add erlang https://github.com/asdf-vm/asdf-erlang.git \
    && asdf install erlang 25.3.2.5 \
    && asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git \
    && asdf install elixir 1.15.4-otp-25 \
    && asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git \
    && asdf install nodejs 18.17.0 

RUN asdf global erlang 25.3.2.5 \
    && asdf global elixir 1.15.4-otp-25 \
    && asdf global nodejs 18.17.0 \
    && export PATH="$PATH:/home/gitpod/.asdf/shims"
      
