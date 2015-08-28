#!/bin/bash

#A éditer selon les versions installées : cf github pour les différents noms et extensions existants
atom='atom-amd64.deb'
dl=$(echo ~/Téléchargements)

# couleurs
vert="\e[1;92m"
rouge="\e[1;91m"
bleu="\e[1;96m"
fin="\e[0m"

#récupération du package 64bits avec wget en mode non-silencieux
recup() {
    echo -e $bleu"Récupération avec wget...$fin"
    cd $dl
    wget $1
    echo -e $bleu"Fin du téléchargement.$fin"
}

#mise à jour d'Atom.
updt() {
    echo -e $vert"Suppression$fin de l'ancien package Deb d'Atom"
    sudo dpkg -r atom
    if [ -e $atom ]
    then
        sudo dpkg -i $atom
        echo -e $vert"Suppression$fin du package sur le disque."
        rm $atom
        cd ~
        #vérification de la version du package
        echo -e $vert"Vérification$fin : Atom version : $(atom -v)"
    else
        echo -e $rouge"Le nom du fichier n'est pas le bon$fin : éditez le fichier"
    fi
}

# fonction principale du programme
main() {
  rls=$(curl -s https://github.com/atom/atom/releases/latest)
  #debug :
  #rls="<html><body>You are being <a href=https://github.com/atom/atom/releases/tag/v1.0.7>redirected</a>.</body></html>"
  online=$(echo $rls | sed "s/^.*\(....[0-9]\).*$/\1/")
  toinstall="https://github.com/atom/atom/releases/download/v$online/atom-amd64.deb"
  install=$(atom -v)

  if [ "$online" != "$install" ]
    then
      echo -e "Dernière version en ligne disponible : $online"
      echo "Souhaitez-vous la mettre à jour ? [o|n]"
      read rep
      if [ $rep == "o" ] || [ $rep == "oui" ]
        then
          recup $toinstall
          updt
      else
          echo -e $rouge"Annulation$fin de toute mise à jour."
      fi
      else
        echo -e $vert"Pas de mise à jour disponible$fin : la version installée localement ($vert$install$fin) est la plus récente."
  fi
}

# Point d'entrée du script
# Attention à bien vérifier les variables de débuts de script
checkCurl=$(apt list --installed "curl")
# 8 est la longueur du mot retournées par apt (nouvelle version)
# si la longueur est supérieure à 8 alors curl est bien installé
if [[ $(echo ${#checkCurl}) -gt 8 ]]
  then
  main
else
  echo -e "Le logiciel curl est requis\n\tInstallation: sudo apt install curl"
fi
