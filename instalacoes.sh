#!/bin/bash

# Arquivo para instalação dos itens básicos no sistema operacional após sua atualização

# Fedora 27 (ultima mudança)

function instala_proxy ()
{
	sudo dnf -y install cntlm
   erro "Falha no download de pacotes."
	# Antes, exporte as variaveis http_proxy e https_proxy
	# export http_proxy=user:senha@proxy.br
	sudo mv /etc/cntlm.conf{,.bkp}
    # Gerado com cntlm -H
	cat << EOF > /tmp/cntlm.conf
Username        c054979
Domain		rede
Workstation	eti-i36997
#Proxy		10.0.3.135:3128
Proxy		proxyserver.rede.tst:3128
#PassLM          B2B0A12E1E29B556552C4BCA4AEBFB11
#PassNT          CCD9C08F6DC3BC3F7CAB80CD170BB5B4
#PassNTLMv2      4BA3935D62453CE12672EF472E4ABB6D    # Only for user 'c054979', domain ''
Auth            NTLM
PassNT          CCD9C08F6DC3BC3F7CAB80CD170BB5B4
PassLM          B2B0A12E1E29B556552C4BCA4AEBFB11
NoProxy intranet,*.pje.csjt.jus.br,*.pje2.csjt.jus.br,*.jt.gov.br,*.tst.gov.br,*.jt.jus.br,*.enamat.gov.br,www1.tesouro.fazenda.gov.br,localhost,*.redetst,aplicacao*.tst.gov.br,aplicacao*.tst.jus.br,aplicacao*.jt.jus.br,aplicacao*.jt.gov.br,bacenjud.stj.cnj,*.cnj,www.cnj.jus.br,www.tst.jus.br,www3.tst.jus.br,portaldeprojetos.tst.jus.br,intranet.tst.gov.br,aplicacao.tst.jus.br,aplicacao6.tst.jus.br,10.*.*.*,aplicacao5.tst.jus.br,aplicacao3.tst.jus.br,*contas.tcu.gov.br,*.rede.tst,vm274,vm285,vm421,*.redejt,127.0.0.1
Listen 10.0.240.40:3128
Listen 127.0.0.1:3128
EOF
    sudo mv /tmp/cntlm.conf /etc/cntlm.conf
    sudo systemctl restart cntlm.service
    
    sudo chkconfig cntlm on
    #systemctl enable cntlm
	
}

function instala_pacotes () {
    echo "### Iniciando instalacoes..."
    [ -z $TST ] && prepara_ntst || prepara_tst
    echo "## Instalando pacotes"
    LATEX="texlive texlive-latex texlive-collection-langportuguese texlive-tocbibind texlive-titlesec texlive-relsize texlive-subfigure texlive-lastpage texlive-algorithm2e texlive-cleveref texmaker texlive-hypernat texlive-boites texlive-needspace texlive-examplep texlive-example texlive-cprotect texlive-algorithmicx texlive-stmaryrd"
    sudo rpm -ivh http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-stable.noarch.rpm
    sudo dnf -y install http://linuxdownload.adobe.com/adobe-release/adobe-release-x86_64-1.0-1.noarch.rpm
    sudo dnf config-manager --add-repo=https://negativo17.org/repos/fedora-uld.repo
    erro "Falha na instalação de pacotes."
    sudo dnf -y install $PACOTES $LATEX
    erro "Falha na instalação de pacotes."
    echo "## Atualizando pacotes"
    sudo dnf -y update
    
    # Codecs de audio e video
    instala_codecs
    
    instala_loffice
}

function instala_codecs() {
	echo "## Instalando codecs..."
	sudo dnf -y localinstall --nogpgcheck http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-stable.noarch.rpm http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-stable.noarch.rpm
	sudo dnf -y install gstreamer gstreamer-ffmpeg gstreamer-plugins-bad gstreamer-plugins-bad-free gstreamer-plugins-bad-free-extras gstreamer-plugins-bad-nonfree gstreamer-plugins-base gstreamer-plugins-good gstreamer-plugins-ugly faad2 faac libdca compat-libstdc++-33 compat-libstdc++-296 xine-lib-extras-freeworld flac lame
   erro "Falha na instalação de pacotes."
}

function instala_loffice() {
   dnf -y install libreoffice
   dnf -y install libreoffice-langpack-pt-BR
}

function instala_loffice_old () {
   # LibreOffice 5.0.2
   VER='5.0.2'
   LOVERSAO="LibreOffice_$VER""_Linux_x86-64_rpm"
   LOLANG="LibreOffice_$VER""_Linux_x86-64_rpm_langpack_pt-BR"
   ERROMSG="## >> ERRO na instalação do libreoffice, confira link de versao. << ##"
   echo "## Instalando LibreOffice $VER"
   cd /tmp
   wget http://download.documentfoundation.org/libreoffice/stable/$VER/rpm/x86_64/$LOVERSAO.tar.gz -O $LOVERSAO.tar.gz
   erro "$ERROMSG. Problema no download."
   
      sudo yum remove -y openoffice* libreoffice*
      tar -xvf $LOVERSAO.tar.gz
      cd /tmp/LibreOffice_*Linux_x86-64_rpm/RPMS/
      sudo yum localinstall -y *.rpm
      erro "$ERROMSG"
      cd /tmp
      wget http://download.documentfoundation.org/libreoffice/stable/$VER/rpm/x86_64/$LOLANG.tar.gz -O $LOLANG.tar.gz
      erro "$ERROMSG"
      tar -xvf $LOLANG.tar.gz
      cd /tmp/*langpack_pt-BR/RPMS/
      sudo yum localinstall -y *.rpm
      erro "$ERROMSG"
}

function prepara_ntst() {
   NTSTPKG=' tuxguitar amarok kdenlive sound-juicer xchat'
   PACOTES+="$NTSTPKG"
	echo "## Adicionando pacotes para ambiente fora do trabalho"
	echo "$NTSTPKG"
}

function prepara_tst() {
   TSTPKG=' pgadmin3 libvtemm expect system-config-printer meld rdesktop'
   PACOTES+="$TSTPKG"
	echo "## Adicionando pacotes para ambiente de trabalho"
	echo "$TSTPKG"
	instala_proxy
}

function clonar_repos_git() {
    if [ ! -z $TST ]; then
       mkdir -p ~/git
       cd ~/git
       git clone git@git.pje.csjt.jus.br:infra/equipe.git
       erro "Falha ao clonar repositorio."
       git clone git@git.pje.csjt.jus.br:infra/regional.git
       erro "Falha ao clonar repositorio."
       git clone git@git.pje.csjt.jus.br:infra/puppet.git
       erro "Falha ao clonar repositorio."
    fi
    echo "## Clonando repositorios do github"
    mkdir -p ~/github
    cd ~/github
    git clone https://github.com/leafarlins/linux-utils.git
    erro "Falha ao clonar repositorio."
    
    cd ~
    ln -sf github/linux-utils/bashrc ~/.bashrc
    ln -s github/linux-utils/bash_aliases ~/.bash_aliases
    ln -s github/linux-utils/vimrc ~/.vimrc
    #ln -s github/linux-utils/vim ~/.vim
    #ln -s github/linux-utils/toprc ~/.toprc
    source github/linux-utils/bashrc
}

function customizar() {
   echo "### Customizando ambiente..."
   sudo yum install -y gnome-tweak-tool dconf-editor
   erro "Falha no download de gnome-tweak-tool dconf-editor"
   # gedit
   gsettings set org.gnome.gedit.preferences.editor auto-indent true
   gsettings set org.gnome.gedit.preferences.editor bracket-matching true
   gsettings set org.gnome.gedit.preferences.editor display-line-numbers true
   gsettings set org.gnome.gedit.preferences.editor tabs-size 3
   # Desktop
   gsettings set org.gnome.desktop.interface clock-show-date true
   gsettings set org.gnome.nautilus.preferences sort-directories-first true
   gsettings set org.gnome.nautilus.preferences executable-text-activation ask
   #gsettings set org.gnome.shell.window-switcher current-workspace-only false
   #gsettings set org.gnome.shell.overrides dynamic-workspaces false
   #gsettings set org.gnome.shell.overrides workspaces-only-on-primary false
}

function cria_visitas() {
   echo "## Customizando usuários"
   # Usuário visitante
   sudo useradd visitas
   sudo passwd -d visitas
   sudo mkdir -p /home/visitas/.config/autostart
   sudo cat << EOF > /home/visitas/.config/autostart/cleanup.sh
#!/bin/bash
gvfs-trash Área\ de\ trabalho/* Downloads/*
EOF
   erro "Falha na criação de arquivo /home/visitas/.config/autostart/cleanup.sh"
   sudo chmod +x /home/visitas/.config/autostart/cleanup.sh
   
}

function erro() {
   if [ $? -ne 0 ]; then
      echo "Ocorreu um erro: $1"
      echo -ne "Deseja prosseguir? [s/n] "
      read RESP
      case $RESP in
         s | S | y | Y | sim )
            ;;
         * )
           echo "Abortando."
           exit 1
      esac
   fi
}

function usage() {
   echo "Usage: $0 [-cdlty]
   Argumentos:
      -t    Instalação para estação no TST
      -d	   Instalação para desktop
      -l	   Instalação apenas do libreoffice
      -c	   Instalação apenas de codecs nao-free
      -y    Instala sem pedir confirmação
      -h    Imprimir a ajuda (esta mensagem) e sair"
}

# Variaveis #

PACOTES='wget gparted rpm-build vim bind-utils iptraf make gcc git flash-plugin ntpdate icedtea-web vlc mozilla-vlc pidgin gnome-subtitles gimp lifeograph audacity uld foremost'

while [ "$1" != '' ]; do
   case $1 in
      -t | --tst )   
         TST='1'
      ;;
      -d )   
         DESKTOP='1'
      ;;
      -l )  
         instala_loffice
         exit 0 ;;
      -c )  
         instala_codecs
         exit 0 ;;
      -y )  
         Y=true
         exit 0 ;;
      -h | --help )  
         usage
         exit 0 ;;
      * ) 
         usage
         exit 1
   esac
   shift
done

Y=${Y:-false}

### MAIN ###

$Y || echo -ne "Realizando instalação. Confirma execução? [s/n] "
$Y && EXEC='y' || read EXEC
case "$EXEC" in
   yes | y | Y | s | S | sim )
      instala_pacotes  
      clonar_repos_git
      customizar
   *)
      echo "Abortando"
      exit 0
esac

