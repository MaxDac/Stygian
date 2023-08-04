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
    && git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v${asdf_ver} \
    && echo ". $HOME/.asdf/asdf.sh" >> ~/.bashrc \
    && echo ". $HOME/.asdf/completions/asdf.bash" >> ~/.bashrc \
    && apt-get install inotify-tools -y \
    && apt-get clean && rm -rf /var/cache/apt/* && rm -rf /var/lib/apt/lists/* && rm -rf /tmp/*

COPY install_asdf_plugins.sh /home/gitpod/

RUN bash -c ". $HOME/.asdf/asdf.sh && ~/install_asdf_plugins.sh" && \
  rm -rf /home/gitpod/install_asdf_plugins.sh

USER gitpod

RUN mix local.hex --force \
    && mix local.rebar --force \
    && mix archive.install hex phx_new
