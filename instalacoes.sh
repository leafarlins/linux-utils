#!/bin/bash

# Arquivo para instalação dos itens básicos no sistema operacional após sua atualização

# Fedora 21 (ultima mudança)

function instala_proxy ()
{
	yum -y install cntlm
	# Antes, exporte as variaveis http_proxy e https_proxy
	# export http_proxy=user:senha@proxy.br
	mv /etc/cntlm.conf{,.bkp}
    # Gerado com cntlm -H
	cat << EOF >> /etc/cntlm.conf
Username        c054979
PassLM          B2B0A12E1E29B556552C4BCA4AEBFB11
PassNT          CCD9C08F6DC3BC3F7CAB80CD170BB5B4
PassNTLMv2      4BA3935D62453CE12672EF472E4ABB6D    # Only for user 'c054979', domain ''
Proxy proxy3.tst.jus.br:3128
NoProxy localhost, 127.0.0.*, 0.0.0.0, 10.0.0.0/8, *.csjt.jus.br, *.tst.jus.br, *.jt.jus.br
Listen 3128
EOF
    systemctl restart cntlm.service
	
}

function instala_pacotes () {
    
    rpm -ivh http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-stable.noarch.rpm
    yum -y install wget rpm-build vim bind-utils iptraf make gcc git cups-pdf ntpdate icedtea-web
    yum -y install vlc mozilla-vlc pidgin gnome-subtitles gimp lifeograph audacity
    yum -y update
    # Pacotes para o TST
    yum -y install pgadmin3 libvtemm expect system-config-printer
    # Pacotes para casa
    yum -y install tuxguitar azureus kdenlive
    
    # LibreOffice 4.4
   cd /tmp
   wget http://download.documentfoundation.org/libreoffice/stable/4.4.3/rpm/x86_64/LibreOffice_4.4.3_Linux_x86-64_rpm.tar.gz
   yum remove -y openoffice* libreoffice*
   tar -xvf LibreOffice_4.4.3_Linux_x86-64_rpm.tar.gz
   cd /tmp/LibreOffice_4.4.3.2_Linux_x86-64_rpm/RPMS/
   yum localinstall -y *.rpm
   cd /tmp
   wget http://download.documentfoundation.org/libreoffice/stable/4.4.3/rpm/x86_64/LibreOffice_4.4.3_Linux_x86-64_rpm_langpack_pt-BR.tar.gz
   tar -xvf LibreOffice_4.4.3_Linux_x86-64_rpm_langpack_pt-BR.tar.gz
   cd LibreOffice_4.4.3.2_Linux_x86-64_rpm_langpack_pt-BR/RPMS/
   yum localinstall -y *.rpm
}

function clonar_repos_git() {
    mkdir -p ~/git
    cd ~/git
    git clone git@git.pje.csjt.jus.br:infra/equipe.git
    git clone git@git.pje.csjt.jus.br:infra/regional.git
}

function customizar() {
   yum install -y gnome-tweak-tool
}


### MAIN ###
   
   
   
   
#instala_proxy

#instala_pacotes

#clonar_repos_git
