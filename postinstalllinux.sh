#!/bin/bash
#
#	CODIGO ADAPTADO POR MAURO ADRIANO CAVALHEIRO SIQUEIRA  PRESENTE NA APOSTILA DE SHELLSCRIPT DO AURELIO
#
# dependencia do dialog para funcionar
sudo apt-get install dialog
#Versão do Script
versao=01.00
#Armazena a data da ultima modificação do script
datamod=`date -r script.sh`
#FUNÇÃO PARA CONTAR O TEMPO, FUNÇÃO AUXILIAR PARA USO INTERNO NO SCRIPT ( NESTE EXEMPLO, i=2 temos uma contagem de 2 segundos )
tempo() {
	echo
    for (( i=2; i>0; i--)); do
	sleep 1 &  printf "POR FAVOR AGUARDE ... $i \r"
	wait
    done
	cd ~
}
#AQUI APENAS UM EXEMPLO DE FUNÇÃO QUE SERA CHAMADA NO MENU DE OPÇÕES
update_script() {
	sudo apt-get clean && sudo apt-get update && sudo apt-get upgrade -y  -f 
}

# Armazena a opção selecionada pelo usuario no menu
INPUT=/tmp/menu.sh.$$

# Storage file for displaying cal and date command output
OUTPUT=/tmp/output.sh.$$

DATA=`date +%d/%m/%Y`
HORA=`date +%H:%M:%S`

TECNICO=$( dialog --inputbox "Nome do Tecnico que ira atualizar o Sistema: " 10 30 --stdout )

sudo echo "O sistema foi acessado por $TECNICO em `date +%d/%m/%Y` às `date +%H:%M:%S` " >> /opt/saude/logUpdate 
# trap and delete temp files
trap "rm $OUTPUT; rm $INPUT; exit" SIGHUP SIGINT SIGTERM

#
# Purpose - display output using msgbox 
#  $1 -> set msgbox height
#  $2 -> set msgbox width
#  $3 -> set msgbox title
#
logupdate() {
    sudo echo "Sistema Atualizdo em `date +%d/%m/%Y` por $TECNICO às `date +%H:%M:%S`" >> /opt/saude/logUpdate
    }

showlogupdate() {
    dialog  --tailbox /opt/saude/logUpdate 20 100
    }

function display_output(){
	local h=${1-10}	# box height default 10
	local w=${2-41} # box width default 41
	local t=${3-Output} # box title 
	dialog --backtitle "LINUX SAÚDE - CONFIGURADOR DE AMBIENTE DO USUÁRIO" --title "${t}" --clear --msgbox "$(<$OUTPUT)" ${h} ${w}
}

#DEFALUT COLOR
Color_Off='\033[0m'       # Text Reset
IBlue='\033[0;94m'        # Blue
BIYellow='\033[1;93m'     # Yellow

#IDENTIFICA PLATAFORMA GLOBALMENTE

while true
do

### display main menu ###
dialog --clear  --help-button --backtitle "CONFIGURADOR DE AMBIENTE DO USUÁRIO" \
--title "[ CONFIGURADOR DE AMBIENTE DO USUÁRIO ]" \
--menu "
\n  Ultima Atualização: `date +%d/%m/%Y`mod
\n  Última selecionada: $menuitem
\n     Versao do Linux: `uname -o` - $plataform bits
\n    Versao do Script: $versao  
\n      Técnico Online: $TECNICO
\n\n                  Escolha uma tarefa" 25 80 11 \
Exit "Exit to the shell" 2>"${INPUT}" \
0 "AUTO ATUALIZAR SCRIPT" \
Exit "Exit to the shell" 2>"${INPUT}" \

menuitem=$(<"${INPUT}")

# make decsion 
case $menuitem in
  0) update_script;;
  Exit)echo ""; break;;
esac


done
