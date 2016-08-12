FROM alpine
MAINTAINER Jun Tsai <jcai@ganshane.com>

RUN apk add --no-cache zsh openssh-client git ruby vim curl
#config sshd
RUN echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config
RUN echo "UserKnownHostsFile /dev/null" >> /etc/ssh/ssh_config
RUN mkdir /root/.ssh
ADD keys/id_rsa /root/.ssh/id_rsa
ADD keys/id_rsa.pub /root/.ssh/id_rsa.pub
RUN chmod 0600 /root/.ssh/id_rsa
RUN cat /root/.ssh/id_rsa.pub > /root/.ssh/authorized_keys

#setup capistrano
RUN {\
  gem sources --remove http://rubygems.org/ \
  && gem sources -a https://ruby.taobao.org/ \
  && gem install sshkit-sudo  --no-rdoc --no-ri \
  && gem install capistrano -v 3.5.0  --no-rdoc --no-ri;\
}

#setup zsh
ENV HOME /root
WORKDIR /root
ENV SHELL zsh
ADD install.sh /root/install.sh
RUN  zsh   install.sh
RUN {\
  sed -i 's/plugins=(git)/plugins=(git vi-mode history-substring-search capistrano)/g' /root/.zshrc \
  && echo "bindkey -v" >> /root/.zshrc \
  && echo "export KEYTIMEOUT=1" >> /root/.zshrc \
  && echo "bindkey -M vicmd \"k\" history-substring-search-up" >> /root/.zshrc \
  && echo "bindkey -M vicmd \"j\" history-substring-search-down" >> /root/.zshrc ;\
}
ENV LANG zh_CN.UTF-8
ENV LANGUAGE zh_CN

WORKDIR /roar-deploy

ENTRYPOINT ["zsh"]

