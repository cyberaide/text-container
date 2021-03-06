FROM ubuntu:20.04
LABEL maintainer="Gregor von Laszewski <laszewski@gmail.com>" maintainer="George K. Thiruvathukal <gkt@cs.luc.edu>"

ENV DEBIAN_FRONTEND noninteractive


#Ultimate text management dockerfile

#OS 20.04

#    reasoning: ubuntu is easy and one could convert dockerfile to native. good for testing native installs


#Initial dockerfiel for inspiration:

#    * https://github.com/cyberaide/bookmanager/blob/main/docker/20.04/Dockerfile


#Here is why I am excited about your Dockerfile idea. I have a course proposal that is aimed at bringing these tools/techniques to audiences that would otherwise ignore them (read: people who think Word is the best thing since...)

#It's an interdisciplinary course proposal, Introduction to Notetaking Tools and Techniques [really a course about using many tools in the Dockerfile].

#* add topic notetaking at scale, i did this with more then 70 students. word breaks easily. ....

#https://www.overleaf.com/read/xmfxynswngmf
#check out: 
#   * https://github.com/cloudmesh/cloudmesh-mpi/blob/main/docs/report-group.pdf
#
#    * https://laszewski.medium.com/simple-collaboration-tools-for-open-source-teams-aead3a0c46ae



####################################################################################
# SYSTEM TOOLS
#
RUN apt-get update
RUN apt-get install -y \
    git \
    git-core \
    wget \
    curl \
    rsync 

####################################################################################
# INSTALL EMACS
#
RUN apt-get install -y emacs-nox

####################################################################################
# DEVELOPMENT TOOLS
#
RUN apt-get install -y build-essential checkinstall --fix-missing
RUN apt-get install -y \
    lsb-core \
    dnsutils \
    libssl-dev \
    libffi-dev \
    libreadline-gplv2-dev \
    libncursesw5-dev \
    libsqlite3-dev \
    libgdbm-dev \
    libc6-dev \
    libbz2-dev \
    zlib1g-dev \
    libncurses-dev \
    libgdbm-dev \
    libz-dev \ 
    tk-dev \
    libsqlite3-dev \
    liblzma-dev

#    libreadline-dev \
    
# we may not need tk

####################################################################################
## INSTALL SOURCE PYTHON 3.10.1

## PYTHON_VERSION=3.10.1

## RUN wget https://www.python.org/ftp/python/$(PYTHON_VESRION)/Python-$(PYTHON_VERSION).tgz
## RUN tar xvf Python-$(PYTHON_VERSION).tgz
### TODO: cd Python-$(PYTHON_VERSION)
## RUN ./configure --enable-optimizations --prefix=$HOME/python3.10
## RUN make altinstall
## to overwrite existing python
## make install

####################################################################################
# INSTALL APT PYTHON 3.10
RUN apt install -y software-properties-common
RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt install -y python3.10
RUN apt install -y python3-pip
    
####################################################################################
# INSTALL LATEX, BIBTEX, this should aso have biblatex (check needed)

RUN apt-get -y install texlive
RUN ln -snf /usr/share/zoneinfo/Etc/UTC /etc/localtime \
    && echo "Etc/UTC" > /etc/timezone
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get -y install texlive-latex-extra
RUN apt-get -y install texlive-fonts-recommended texlive-fonts-extra
RUN apt-get -y install texlive-xetex
RUN unset DEBIAN_FRONTEND

####################################################################################
#
# BibTool
RUN apt install -y bibtool

####################################################################################
# INSTALL BIBER
RUN apt-get install -y biber

####################################################################################
# INSTALL GRAPHVIZ
RUN apt-get install -y graphviz

####################################################################################
# INSTALL PANDOC (updated from 2.14.2 to 2.16.2, Jan 2022)
# https://github.com/jgm/pandoc/releases/download/2.16.2/pandoc-2.16.2-1-amd64.deb
ENV PANDOC_VERSION=2.16.2
RUN wget -q https://github.com/jgm/pandoc/releases/download/${PANDOC_VERSION}/pandoc-${PANDOC_VERSION}-1-amd64.deb
RUN dpkg -i pandoc-${PANDOC_VERSION}-1-amd64.deb
RUN pandoc --version

# INSTALL CROSSREF (updated from version 3.12.0c  to v0.3.12.1a, Jan  2022
# https://github.com/lierdakil/pandoc-crossref/releases/download/v0.3.12.1a/pandoc-crossref-Linux.tar.xz
ENV CROSSREF_VERSION=v0.3.12.1a
RUN wget https://github.com/lierdakil/pandoc-crossref/releases/download/${CROSSREF_VERSION}/pandoc-crossref-Linux.tar.xz
RUN tar xvf pandoc-crossref-Linux.tar.xz
RUN mv pandoc-crossref /usr/local/bin

#
# INSTALL PANDOC EXTENSIONS
#
RUN pip install pandoc-include
RUN pip install pandoc-xnos

####################################################################################
#
# INSTALL jq and yq query processing
#

RUN apt install -y jq
RUN pip install yq


####################################################################################
# INSTALL GO
#
# RUN apt install -y golang

####################################################################################
# INSTALL HUGO

#I do not like the homebrew install, but it works on 20.04 we need extended version of hugo
#Right, I recommend not using Homebrew on Linux. It tends to have conflicts with many base packages.
#do you have hugo install instructions?

####################################################################################
# INSTALL SPHINX
RUN apt-get install -y python3-sphinx

## RUN pip install -U sphinx

####################################################################################
#
# INSTALL Pygments (newest)
#
RUN pip install pygments


####################################################################################
# INSTALL BOOKMANAGER
# Hey, how come you didn't set up PyPI for Bookmanager yet? Let me know if I can help with that... :-)

# RUN git clone https://github.com/cyberaide/bookmanager.git
# WORKDIR /usr/local/code/bookmanager
# RUN pip install -e .

####################################################################################
# INSTALL PDF and eBook Tools - poppler, Calibre latest

# RUN pip install python-poppler
# RUN wget -nv -O- https://download.calibre-ebook.com/linux-installer.sh | sudo sh /dev/stdin


####################################################################################
# INSTALL zettelgeist

RUN pip install zettelgeist


# WOULD BE COOL

#maybe we can have a menu as python script 

#1 - hugo
#2 - sphinx
#3 - ACM LaTeX
#4 - IEEE LaTeX

#here an example ow to call it:

#    ./doc-setup.py --hugo --theme=docsy sitename
#    ./doc-setup.py --latex --theme=acm document.tex
#    ./doc-setup.py --sphinx sitename
# The way this works we ut this on pypi than internally it set
# up the docker image and calls the appropriate thing, so no one has to remember the docker commands ...



# Install NodeJS and tooling
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - \
 && apt install -y nodejs \
 && npm install -g autoprefixer@10.2.4 postcss@8.2.6 postcss-cli@8.3.1 yarn@1.22.10 @babel/cli @babel/core

RUN wget https://go.dev/dl/go1.17.5.linux-amd64.tar.gz
RUN rm -rf /usr/local/go && tar -C /usr/local -xzf go1.17.5.linux-amd64.tar.gz

ENV PATH="/usr/local/go/bin:${PATH}"

WORKDIR /usr/local/code
RUN git clone https://github.com/gohugoio/hugo.git
WORKDIR /usr/local/code/hugo
RUN go install --tags extended

ENV PATH="/root/go/bin:${PATH}"

WORKDIR /root

