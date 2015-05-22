#!/bin/bash

# Arquivo para instalação dos itens básicos no sistema operacional após sua atualização

# Fedora 21 (ultima mudança)

function instala_proxy ()
{
	yum -y install cntlm
	
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
    yum -y install wget rpm-build vim bind-utils iptraf make gcc git cups-pdf ntpdate
    yum -y install vlc mozilla-vlc pidgin gnome-subtitles gimp
    # Pacotes para o TST
    yum -y install pgadmin3
}

function clonar_repos_git() {
    mkdir -p ~/git
    cd ~/git
    git clone git@git.pje.csjt.jus.br:infra/equipe.git
    git clone git@git.pje.csjt.jus.br:infra/regional.git
}


### MAIN ###

#instala_proxy

#instala_pacotes

#clonar_repos_git
