#!/bin/bash

# Cores
C_D="\033[0m"     # Default
C_T="\033[0;34m"  # Título
C_I="\033[0;36m"  # Input
C_W="\033[0;33m"  # Wraning
C_S="\033[0;32m"  # Sucess
C_E="\033[0;31m"  # Error

# Variaveis
SAVES=SAVES.txt
KEY=KEY.key

# Funções
continuar(){
  echo -ne "${C_I}Pressione enter para continuar${C_D}"
  read -s
}

ip_usr(){
  c=0
  while IFS=- read -r nome usr_save ip_save; do
    nomes[$c]="$nome"
    usrs[$c]="$usr_save"
    ips[$c]="$ip_save"
    c=$(( $c + 1 ))
  done < $SAVES

  if [ -f $SAVES ]; then
    clear
    echo -e "${C_T}----- Usuários e IPs -----${C_D}"
    for s in $( seq 0 $(( $c - 1 )) ); do
      echo -e "[$s] Nome: ${C_T}${nomes[$s]}${C_D}"
      echo -e "[$s] Usuário: ${C_T}${usrs[$s]}${C_D}"
      echo -e "[$s] IP: ${C_T}${ips[$s]}${C_D}"
      echo "---------------"
    done
  fi

  echo -ne "${C_I}Digite uma das opições acima ou qualquer outro valor para usar ip personalizado ➜ ${C_D}"
  read ip_menu

  for x in $( seq 0 $(( $c - 1 )) ); do
    if [ "$ip_menu" = "$x" ]; then
      ip=${ips[ip_menu]}
      usr=${usrs[ip_menu]}
      ip_menu_re=1
    elif [ "$ip_menu_re" = "1" ]; then
      sleep 0
    else
      ip_menu_re=0
    fi
  done

  if [ $ip_menu_re -eq 0 ]; then
    echo -ne "${C_I}Digite o ip a ser usado ➜ ${C_D}"
    read ip

    echo -ne "${C_I}Digite o usuário a ser usado ➜ ${C_D}"
    read usr
  fi
}

while :; do
  clear
  echo -e "${C_I}----- Menu -----${C_D}"
  echo -ne "[0] Sair \
  \n[1] SSH \
  \n[2] SCP \
  \n[3] Poweroff \
  \n[4] Reboot \
  \n[5] CMD \
  \n[6] Config \
  \n[7] Sobre \
  \n${C_I}Digite a opição desejada ➜ ${C_D}"
  read menu

  # Sair
  if [ "$menu" = "0" ]; then
    exit
  # SSH
elif [ "$menu" = "1" ]; then
    clear
    echo -e "${C_T}----- SSH -----${C_D}"
    ip_usr
    echo -e "---------------"
    echo -ne "${C_I}Deseja usar um arquivo KEY ? [${C_S}S${C_I}/${C_E}N${C_I}] ➜ ${C_D}"
    read key
    echo -e "---------------"

    case $key in
      s)
        ssh -i $KEY $usr@$ip
        continuar;;
      n)
        ssh $usr@$ip
        continuar
    esac
  # SCP
elif [ "$menu" = "2" ]; then
    clear
    echo -e ${C_I}"----- SCP -----${C_D}"
    ip_usr
    echo -e "---------------"
    echo -e "${C_W}Não utilize ~ para o HOME mas sim $HOME${C_D}"
    echo -ne "${C_I}Digite o arquivo a ser enviado ➜ ${C_D}"
    read arq
    echo -e "---------------"
    echo -ne "${C_I}Digite onde o arquivo deve ficar ➜ ${C_D}"
    read dir
    echo -e "---------------"
    echo -ne "${C_I}Deseja usar um arquivo KEY ? [${C_S}S${C_I}/${C_E}N${C_I}] ➜ ${C_D}"
    read key
    echo -e "---------------"

    case $key in
      s)
        scp -i $KEY $arq $usr@$ip:$dir
        continuar;;
      n)
        scp $usr@$ip:$dir
        continuar
    esac
  # Poweroff
elif [ "$menu" = "3" ]; then
    clear
    echo -e "${C_T}----- Poweroff -----${C_D}"
    ip_usr
    echo -e "---------------"
    echo -ne "${C_I}Deseja usar um arquivo KEY ? [${C_S}S${C_I}/${C_E}N${C_I}] ➜ ${C_D}"
    read key
    echo -e "---------------"

    case $key in
      s)
        ssh -i $KEY $usr@$ip 'poweroff'
        continuar;;
      n)
        ssh $usr@$ip 'poweroff'
        continuar
    esac
  # Reboot
elif [ "$menu" = "4" ]; then
    clear
    echo -e "${C_T}----- Reboot -----${C_D}"
    ip_usr
    echo -e "---------------"
    echo -ne "${C_I}Deseja usar um arquivo KEY ? [${C_S}S${C_I}/${C_E}N${C_I}] ➜ ${C_D}"
    read key
    echo -e "---------------"

    case $key in
      s)
        ssh -i $KEY $usr@$ip 'reboot'
        continuar;;
      n)
        ssh $usr@$ip 'reboot'
        continuar
    esac
  # CMD
  elif [ "$menu" = "5" ]  ; then
    clear echo -e "${C_T}----- CMD -----${C_D}"
    ip_usr
    echo -e "---------------"
    echo -ne "${C_I}Digite o comando a ser executado ➜ ${C_D}"
    read cmd
    echo -e "---------------"
    echo -ne "${C_I}Deseja usar um arquivo KEY ? [${C_S}S${C_I}/${C_E}N${C_I}] ➜ ${C_D}"
    read key
    echo -e "---------------"

    case $key in
      s)
        ssh -i $KEY $usr@$ip '$cmd'
        continuar;;
      n)
        ssh $usr@$ip '$cmd'
        continuar
    esac
  # Config
  elif [ "$menu" = "6" ]; then
    clear
    echo -e "${C_T}----- Config -----${C_D}"
    echo -ne "[1] Key \
    \n[2] Saves \
    \n${C_I}Digite a opição desejada ➜ ${C_D}"
    read cfg

    if [ "$cfg" = "1" ]; then
      echo -e "${C_W}O diretório padrão para o arquivo .key é ➜ $KEY${C_D}"
      echo -e "---------------"
      echo -ne "${C_I}Deseja alterar o diretório ? [${C_S}S${C_I}/${C_E}N${C_I}] ➜ ${C_D}"
      read key_cfg

      case $key_cfg in
        s | S)
          echo -e "---------------"
          echo -ne "${C_I}Digite o novo diretório [0 para default] ➜ ${C_D}"
          read key_dir

          if [ "$key_dir" = "0" ]; then
            sed -i 13s/KEY=.*/KEY=KEY.key/ main.sh
          else
            sed -i 13s/KEY=.*/KEY=$key_dir/ main.sh
          fi
          continuar;;
        n | N)
          sleep 0
      esac
    elif [ "$cfg" = "2" ]; then
      echo -e "${C_W}O diretório padrão para o arquivo SAVES é ➜ $SAVES${C_D}"
      echo -e "---------------"
      echo -ne "${C_I}Deseja alterar o diretório ? [${C_S}S${C_I}/${C_E}N${C_I}] ➜ ${C_D}"
      read saves_cfg

      case $saves_cfg in
        s | S)
          echo -e "---------------"
          echo -ne "${C_I}Digite o novo diretório [0 para default] ➜ ${C_D}"
          read saves_dir

          if [ "$saves_dir" = "0" ]; then
            sed -i 12s/SAVES=.*/SAVES=SAVES.txt/ main.sh
          else
            sed -i 12s/SAVES=.*/SAVES=$saves_dir/ main.sh
          fi
          continuar;;
        n | N)
          sleep 0
      esac
    fi
  # Sobre
  elif [ "$menu" = "7" ]; then
    clear
    echo -e "${C_T}----- Sobre -----${C_D}"
    echo -e "Criado por: ${C_T}Douglas Maia${C_D} \
    \nVersão: ${C_T}0.0.1B${C_D}"
    continuar
  else
    echo -e "${C_E}Opição não disponivel, tente novamente${C_D}"
    continuar
  fi
done
