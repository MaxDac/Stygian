FROM gitpod/workspace-postgres

# Maybe not needed
# ENV DEBIAN_FRONTEND noninteractive

RUN sudo apt-get update -y \
    && sudo apt-get install -y gnupg software-properties-common curl git apt-transport-https zsh \
    # && curl -fsSL https://packages.erlang-solutions.com/ubuntu/erlang_solutions.asc | gpg --dearmor -o /etc/apt/trusted.gpg.d/erlang.gpg \
    # && echo "deb https://packages.erlang-solutions.com/ubuntu $(lsb_release -cs) contrib" | tee /etc/apt/sources.list.d/erlang.list \
    # && apt-get update -y \
    # && apt-get install erlang -y \
    # && apt-get install elixir -y \
    && sudo apt-get install -y build-essential autoconf m4 libncurses5-dev libncurses-dev \
    && sudo apt-get install inotify-tools -y \
    && sudo rm -rf /var/lib/apt/lists/* \
    && sudo apt-get clean && sudo rm -rf /var/cache/apt/* && sudo rm -rf /var/lib/apt/lists/* && sudo rm -rf /tmp/*

# homebrew
# ENV TRIGGER_BREW_REBUILD=2
# RUN mkdir ~/.cache && /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# ENV PATH=$PATH:/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin/
# ENV MANPATH="$MANPATH:/home/linuxbrew/.linuxbrew/share/man"
# ENV INFOPATH="$INFOPATH:/home/linuxbrew/.linuxbrew/share/info"
# ENV HOMEBREW_NO_AUTO_UPDATE=1
# RUN sudo apt remove -y cmake \
#     && brew install cmake
# RUN echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> $HOME/.bashrc.d/homebrew.sh

# hygen
# RUN bash -ic "brew tap jondot/tap"
# RUN bash -ic "brew install hygen"

USER gitpod

RUN git clone https://github.com/asdf-vm/asdf.git $HOME/.asdf --branch v0.8.1

RUN echo ". $HOME/.asdf/asdf.sh" >> $HOME/.bashrc.d/asdf.sh
RUN echo ". $HOME/.asdf/completions/asdf.bash" >> $HOME/.bashrc.d/asdf.sh

ENV BUMP_TO_FORCE_GITPOD_UPDATE=4
COPY install-asdf-plugins.sh $HOME/install-asdf-plugins.sh
RUN ./install-asdf-plugins.sh

# ZSH
ENV ZSH_THEME cloud
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
COPY zsh-template.sh $HOME/.zshrc

ONBUILD COPY .tool-versions $HOME/
ONBUILD RUN bash -c ". $HOME/.bashrc.d/asdf.sh && asdf install"

CMD [ "zsh" ]
