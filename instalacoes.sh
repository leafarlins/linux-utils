#!/bin/bash

# Arquivo para instalação dos itens básicos no sistema operacional após sua atualização

# Fedora 21 (ultima mudança)


function instala_proxy ()
{
	sudo yum -y install cntlm
	# Antes, exporte as variaveis http_proxy e https_proxy
	# export http_proxy=user:senha@proxy.br
	sudo mv /etc/cntlm.conf{,.bkp}
    # Gerado com cntlm -H
	sudo cat << EOF >> /etc/cntlm.conf
Username        c054979
PassLM          B2B0A12E1E29B556552C4BCA4AEBFB11
PassNT          CCD9C08F6DC3BC3F7CAB80CD170BB5B4
PassNTLMv2      4BA3935D62453CE12672EF472E4ABB6D    # Only for user 'c054979', domain ''
Proxy proxy3.tst.jus.br:3128
NoProxy localhost, 127.0.0.*, 0.0.0.0, 10.0.0.0/8, *.csjt.jus.br, *.tst.jus.br, *.jt.jus.br
Listen 3128
EOF
    sudo systemctl restart cntlm.service
    
    sudo chkconfig cntlm on
    #systemctl enable cntlm
	
}

function instala_pacotes () {
    echo "### Iniciando instalacoes..."
    echo "## Instalando pacotes gerais"
    sudo rpm -ivh http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-stable.noarch.rpm
    sudo yum -y install wget rpm-build vim bind-utils iptraf make gcc git cups-pdf ntpdate icedtea-web vlc mozilla-vlc pidgin gnome-subtitles gimp lifeograph audacity
    sudo yum -y update
    
    [ -z $TST ] && instala_ntst || instala_tst
    
    # Para desktop
    [ -z $DESKTOP ] || instala_desktop
    
   # LibreOffice 4.4
   echo "## Instalando LibreOffice 4.4"
   cd /tmp
   wget http://download.documentfoundation.org/libreoffice/stable/4.4.3/rpm/x86_64/LibreOffice_4.4.3_Linux_x86-64_rpm.tar.gz
   sudo yum remove -y openoffice* libreoffice*
   tar -xvf LibreOffice_4.4.3_Linux_x86-64_rpm.tar.gz
   cd /tmp/LibreOffice_4.4.3.2_Linux_x86-64_rpm/RPMS/
   sudo yum localinstall -y *.rpm
   cd /tmp
   wget http://download.documentfoundation.org/libreoffice/stable/4.4.3/rpm/x86_64/LibreOffice_4.4.3_Linux_x86-64_rpm_langpack_pt-BR.tar.gz
   tar -xvf LibreOffice_4.4.3_Linux_x86-64_rpm_langpack_pt-BR.tar.gz
   cd LibreOffice_4.4.3.2_Linux_x86-64_rpm_langpack_pt-BR/RPMS/
   sudo yum localinstall -y *.rpm
}

function instala_ntst() {
	echo "## Instalando pacotes para ambiente fora do trabalho"
	sudo yum -y install tuxguitar amarok kdenlive sound-juicer 
}

function instala_tst() {
	echo "## Instalando pacotes para ambiente de trabalho"
	sudo yum -y install pgadmin3 libvtemm expect system-config-printer
	instala_proxy
}

function instala_desktop() {
	 echo "## Instalando pacotes para desktop"
	 cat << EOF > /etc/yum.repos.d/playonlinux.repo
[playonlinux]
name=PlayOnLinux Official repository
baseurl=http://rpm.playonlinux.com/fedora/yum/base
enable=1
gpgcheck=0
gpgkey=http://rpm.playonlinux.com/public.gpg
EOF

    sudo yum install --nogpgcheck http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
    sudo yum -y install steam playonlinux
    
    # Instala driver NVidea Gforce GT 630
    echo "Instalando driver da GeForce"
    sudo yum localinstall --nogpgcheck http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
    lspci | grep -i VGA
    sudo yum install -y akmod-nvidia xorg-x11-drv-nvidia-libs kernel-devel acpid
	 sudo mv /boot/initramfs-$(uname -r).img /boot/initramfs-$(uname -r)-nouveau.img
	 sudo dracut /boot/initramfs-$(uname -r).img $(uname -r)
    
}

function clonar_repos_git() {
    if [ ! -z $TST ]; then
       mkdir -p ~/git
       cd ~/git
       git clone git@git.pje.csjt.jus.br:infra/equipe.git
       git clone git@git.pje.csjt.jus.br:infra/regional.git
       git clone git@git.pje.csjt.jus.br:infra/puppet.git
    fi
    echo "## Clonando repositorios do github"
    mkdir -p ~/github
    cd ~/github
    git clone https://github.com/leafarlins/linux-utils.git
    
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
   
   echo "## Customizando usuários"
   # Usuário visitante
   sudo useradd visitas
   sudo passwd -d visitas
   sudo mkdir -p /home/visitas/.config/autostart
   sudo cat << EOF > /home/visitas/.config/autostart/cleanup.sh
#!/bin/bash
gvfs-trash Área\ de\ trabalho/* Downloads/*
EOF
   sudo chmod +x /home/visitas/.config/autostart/cleanup.sh
   
}

function usage() {
   echo "Usage: $0 [argumentos]
   Argumentos:
      -t                Instalação para estação no TST
      -d						Instalação para desktop
      -h ou --help      Imprimir a ajuda (esta mensagem) e sair"
}

### MAIN ###

while [ "$1" != '' ]; do
   case $1 in
      -a | -aaa )    shift
                     A=$1
      ;;
      -t | --tst )   
         TST='1'
      ;;
      -d )   
         DESKTOP='1'
      ;;
      -h | --help )  
         usage
         exit ;;
      * ) 
         usage
         exit 1
   esac
   shift
done


#instala_pacotes

#clonar_repos_git
