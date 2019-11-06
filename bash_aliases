###
alias la='ls -la'
alias pje='/home/rlins/git/equipe/pjessh/pje.sh'
alias mvn='/home/rlins/Documentos/Cursos/Alura-Maven/apache-maven-3.5.4/bin/mvn'

######## Alias para cpu/mem #########
## pass options to free ##
alias free='free -m'

## get top process eating memory
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'

## get top process eating cpu ##
alias pscpu='ps auxf | sort -nr -k 3'
alias pscpu10='ps auxf | sort -nr -k 3 | head -10'

## Get server cpu info ##
#alias cpuinfo='lscpu'

## older system use /proc/cpuinfo ##
#alias cpuinfo='less /proc/cpuinfo' ##

## get GPU ram on desktop / laptop##
#alias gpumeminfo='grep -i --color memory /var/log/Xorg.0.log'
#alias pegaperfil="$HOME/Copy/Scripts/Facebook/pegaperfil.sh"
alias flacconvert="$HOME/github/linux-utils/flacconvert.sh"
alias expandsrt="$HOME/github/linux-utils/expandsrt.sh"
