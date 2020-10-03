#I also need to automate the .vsix installation
FROM ubuntu:20.04

#use bash by default 
ENV SHELL /bin/bash


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


#first create root folder
WORKDIR /root
#clone WebSVF project into the image
RUN git clone https://github.com/SVF-tools/WebSVF.git --depth 1
RUN npm install 
# RUN cd ./WebSVF/src/SVFTOOLS

#change working directory
WORKDIR /root/WebSVF/src/SVFTOOLS

RUN yarn



#generate extension
RUN npm install -y -g vsce
RUN vsce package 
RUN mkdir -p ~/.local/share/code-server/extensions
ENV XDG_DATA_HOME="~/.local/share/code-server/extensions"
RUN cp svftools-0.0.3.vsix ~/.local/share/code-server/extensions

# SHELL ["/bin/bash","-c"]
CMD code-server --install-extension ~/.local/share/code-server/extensions/svftools-0.0.3.vsix --force && code-server --auth="none" --host 0.0.0.0 --port 8080


#install the backend

#install the sudo keyword first
# RUN npm install -g @websvf/create-analysis
# RUN create-analysis


