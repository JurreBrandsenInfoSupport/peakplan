FROM ruby:3.4.3-slim-bookworm

ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Install system dependencies including Node.js
RUN apt update && apt install -y build-essential libyaml-dev libpq-dev git sudo curl

# Install Node.js 22.x
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y nodejs

# Create the user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# Set the default shell to /bin/bash for the vscode user
RUN chsh -s /bin/bash $USERNAME

USER $USERNAME

# Install Rails
RUN gem install rails

WORKDIR /workspace
