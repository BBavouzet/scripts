#!/bin/bash

#A éditer selon les versions installées : cf github pour les différents noms et extensions existants
atom='atom-amd64.deb'

#récupération du package 64bits avec wget en mode non-silencieux
recup() {
    echo -e "\e[1;92mRécupération avec wget...\e[0m"
    cd ~/Téléchargements/
    wget $1
    echo -e "\e[1;96mFin du téléchargement.\e[0m"
}

#mise à jour d'Atom.
updt() {
    echo -e "\e[1;92mSuppression\e[0m de l'ancien package Deb d'Atom"
    sudo dpkg -r atom
    if [ -e $atom ]
    then
        sudo dpkg -i $atom
        echo -e "\e[1;92mSuppression\e[0m du package sur le disque."
        rm $atom
        cd ~
        #vérification de la version du package
        echo -e "\e[1;92mVérification\e[0m : Atom version : $(atom -v)"
    else
        echo -e "\e[1;91mLe nom du fichier n'est pas le bon\e[Om : éditez le fichier"
    fi
}

rls=$(curl -s https://github.com/atom/atom/releases/latest)
#debug :
#rls="<html><body>You are being <a href=https://github.com/atom/atom/releases/tag/v1.0.7>redirected</a>.</body></html>"
online=$(echo $rls | sed "s/^.*\(....[0-9]\).*$/\1/")
toinstall="https://github.com/atom/atom/releases/download/v$online/atom-amd64.deb"
install=$(atom -v)

#Point d'entrée du script : vérification des versions en ligne et en local
if [ "$online" != "$install" ]
then
    echo "Dernière version en ligne disponible : $online"
    echo "Souhaitez-vous la mettre à jour ? [o|n]"
    read rep
    if [ $rep == "o" ] || [ $rep == "oui" ]
    then
        recup $toinstall
        updt
    else
        echo -e "\e[1;31mAnnulation\e[0m de toute mise à jour."
    fi
else
    echo -e "\e[1;92mPas de mise à jour disponible\e[0m : la version installée localement (\e[1;92mv$install\e[0m) est la plus récente."
fi
