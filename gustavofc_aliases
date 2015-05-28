alias mkdir='mkdir -pv'
alias grep='grep --colour=auto'
alias c='clear'
alias echo='echo -e'

# Instalação de produtos
alias yum='sudo -i yum'
alias gem='sudo -i gem'

alias df='df -H'
alias du='du -sh ./*'
alias mount='mount |column -t'
alias ports='netstat -tulanp'
alias wget='wget -c'

######## Alias para ls ########
alias ls='ls --color=auto'
# Exibir arquivos ocultos
alias l.='ls -d .* --color=auto'

######## Alias para cd #########
alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../../../'
alias ....='cd ../../../../'
alias .....='cd ../../../../'
alias .4='cd ../../../../'
alias .5='cd ../../../../..'

######## Alias para iptables #########
# Atalho para invocar o comando iptables com sudo
alias ipt='sudo /sbin/iptables'
  
# Exibir todas as regras
alias iptlist='sudo /sbin/iptables -L -n -v --line-numbers'
alias iptlistin='sudo /sbin/iptables -L INPUT -n -v --line-numbers'
alias iptlistout='sudo /sbin/iptables -L OUTPUT -n -v --line-numbers'
alias iptlistfw='sudo /sbin/iptables -L FORWARD -n -v --line-numbers'
alias firewall=iptlist

######## Alias para cpu/mem #########
## pass options to free ## 
alias meminfo='free -m -l -t'
 
## get top process eating memory
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'
 
## get top process eating cpu ##
alias pscpu='ps auxf | sort -nr -k 3'
alias pscpu10='ps auxf | sort -nr -k 3 | head -10'
 
## Get server cpu info ##
alias cpuinfo='lscpu'
 
## older system use /proc/cpuinfo ##
##alias cpuinfo='less /proc/cpuinfo' ##
 
## get GPU ram on desktop / laptop## 
alias gpumeminfo='grep -i --color memory /var/log/Xorg.0.log'
