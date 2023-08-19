FROM gitpod/workspace-postgres

ARG ASDF_VERSION=v0.12.0
ARG NEOVIM_VERSION=0.9.1
ARG ERLANG_VERSION=25.3.2.5
ARG ELIXIR_VERSION=1.15.4-otp-25
ARG NODEJS_VERSION=18.17.0

ENV ZSH_THEME=powerlevel10k/powerlevel10k
ENV KERL_BUILD_DOCS=yes

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

# Installing asdf and dependencies
RUN git config --global advice.detachedHead false; \
    git clone https://github.com/asdf-vm/asdf.git $HOME/.asdf --branch ${ASDF_VERSION}; \
    /bin/bash -c 'echo -e "\n\n## Configure ASDF \n. $HOME/.asdf/asdf.sh" >> ~/.bashrc'; \
    /bin/bash -c 'echo -e "\n\n## ASDF Bash Completion: \n. $HOME/.asdf/completions/asdf.bash" >> ~/.bashrc'; \
    exec bash; \
    # Neovim
    /bin/bash -c asdf plugin add neovim; \
    /bin/bash -c asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git; \
    /bin/bash -c asdf plugin add erlang https://github.com/asdf-vm/asdf-erlang.git; \
    /bin/bash -c asdf plugin add elixir https://github.com/asdf-vm/asdf-elixir.git; \
    /bin/bash -c asdf install neovim ${NEOVIM_VERSION}; \
    /bin/bash -c asdf install erlang ${ERLANG_VERSION}; \
    /bin/bash -c asdf install elixir ${ELIXIR_VERSION}; \
    /bin/bash -c asdf install nodejs ${NODEJS_VERSION}; \
    /bin/bash -c asdf global neovim ${NEOVIM_VERSION}; \
    /bin/bash -c asdf global erlang ${ERLANG_VERSION}; \
    /bin/bash -c asdf global elixir ${ELIXIR_VERSION}; \
    /bin/bash -c asdf global nodejs ${NODEJS_VERSION}; \
    git clone https://github.com/MaxDac/neovim-configuration $HOME/.config/nvim;

# ZSH
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended; \
    git clone https://github.com/romkatv/powerlevel10k.git $HOME/.oh-my-zsh/custom/themes/powerlevel10k; \
    wget https://gist.githubusercontent.com/MaxDac/46ca202e8456fe91cad5d3f77147ce6f/raw/f184201b0a8b4288de691c7af903239e9112f568/.zshrc -o $HOME/.zshrc;

CMD ["zsh"]
