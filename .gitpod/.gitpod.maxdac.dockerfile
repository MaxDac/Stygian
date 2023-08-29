FROM maxdac/gitpod-elixir:1.15.4-otp-25

ENV SHELL=/usr/bin/zsh

USER gitpod

# Trying this to check whether this starts postgres
SHELL ["/bin/bash", "-lc"]
