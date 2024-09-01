# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.234.0/containers/ubuntu/.devcontainer/base.Dockerfile

# [Choice] Ubuntu version (use ubuntu-22.04 or ubuntu-18.04 on local arm64/Apple Silicon): ubuntu-22.04, ubuntu-20.04, ubuntu-18.04
# ARG VARIANT="focal"
FROM mcr.microsoft.com/vscode/devcontainers/base:ubuntu-20.04

# [Optional] Uncomment this section to install additional OS packages.
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends npm lsb-release software-properties-common vim tmux python3 python3-pip default-jre curl
RUN npm install -g @bazel/bazelisk
RUN npm install -g n
RUN n stable

RUN wget https://apt.llvm.org/llvm.sh
RUN chmod +x ./llvm.sh
RUN ./llvm.sh 14
RUN rm ./llvm.sh
RUN cd /usr/bin && ln -s clangd-14 clangd

RUN apt-get install -y clang-format-14 git
RUN update-alternatives --install /usr/bin/clang-format clang-format /usr/bin/clang-format-14 99999

# Install the zsh-autosuggestions plugin
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
RUN sed -i "s/plugins=(git)/plugins=(git zsh-autosuggestions)/g" ~/.zshrc

RUN cd /usr/local/lib; curl -O https://www.antlr.org/download/antlr-4.11.1-complete.jar

RUN pip install fire matplotlib

RUN echo 'java -Xmx500M -cp "/usr/local/lib/antlr-4.11.1-complete.jar:$CLASSPATH" org.antlr.v4.gui.Interpreter "$@"' | tee /usr/local/bin/antlr4-parse; chmod +x /usr/local/bin/antlr4-parse
RUN echo 'java -Xmx500M -cp "/usr/local/lib/antlr-4.11.1-complete.jar:$CLASSPATH" org.antlr.v4.Tool "$@"' | tee /usr/local/bin/antlr4; chmod +x /usr/local/bin/antlr4