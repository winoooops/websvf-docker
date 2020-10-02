#I also need to automate the .vsix installation
FROM ubuntu:20.04

#RUN rm /bin/sh && ln -s /bin/bash /bin/sh
SHELL [ "/bin/bash","-c"]


#avoid geographic dialog with tzdata
ENV DEBIAN_FRONTEND=noninteractive

#enter the ubuntu bash 
#CMD /bin/bash/

#update ubuntu 
RUN apt-get update 

#install environment 
RUN apt-get install -y curl git nodejs npm lsb-core net-tools
#install code-server
RUN curl -fsSL https://code-server.dev/install.sh | sh



#install yarn properly
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt update && apt install yarn

#clone WebSVF project into the image
RUN git clone https://github.com/SVF-tools/WebSVF.git --depth 1
# RUN cd ./WebSVF/src/SVFTOOLS

#change working directory
WORKDIR /WebSVF/src/SVFTOOLS

RUN yarn



#generate extension
RUN npm install -y -g vsce
RUN vsce package 
RUN mkdir -p ~/.local/share/code-server/extensions
ENV XDG_DATA_HOME="~/.local/share/code-server/extensions"
RUN cp svftools-0.0.3.vsix ~/.local/share/code-server/extensions

CMD code-server --install-extension svftools-0.0.3.vsix --force && code-server --auth="none" --host 0.0.0.0 --port 8080
#go back to the root repo
# WORKDIR /root

#install extension from the genereated vsix



