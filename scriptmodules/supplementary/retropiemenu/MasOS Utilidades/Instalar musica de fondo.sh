#!/usr/bin/env bash

infobox= ""
infobox="${infobox}___________________________________________________________________________\n\n"
infobox="${infobox}Install Backgroud Music\n\n"
infobox="${infobox}This script will install and setup backgroud music for you.\n"
infobox="${infobox}    NOTE: Your system will reboot after removal or Install of Background Music\n"
infobox="${infobox}You can change out the default background music by accessing the 'music' directory in your roms directory.\n"
infobox="${infobox}Once installed you can adjust the volume to your liking with this script as well.\n"
infobox="${infobox}I will also add a 'Background Music Toggle' script to your default 'MasOS' menu so you can shut it off or start it any time.\n\n"
infobox="${infobox}This script was written with MUCH retro love for my fellow Retro-Gamers\n"
infobox="${infobox}I really hope it helps you make your retro rig exactly how you want it.\n"
infobox="${infobox}-Forrest aka Eazy Hax on Youtube\n"
infobox="${infobox}-Editado por mabedeep para MasOS\n"
infobox="${infobox}___________________________________________________________________________\n\n"

dialog --backtitle "Eazy Hax MasOS Toolkit" \
--title "Eazy Hax MasOS Toolkit" \
--msgbox "${infobox}" 23 80

function main_menu() {
    local choice

    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " MAIN MENU " \
            --ok-label OK --cancel-label Exit \
            --menu "What action would you like to perform?" 25 75 20 \
            1 "Instalar MasOS Background Music" \
            2 "Establecer volumen en musica de fondo - Solo despues de ser instalado" \
            3 "Eliminar musica de fondo" \
            2>&1 > /dev/tty)

        case "$choice" in
            1) install_bgm  ;;
            2) vol_menu  ;;
            3) remove_bgm  ;;
            *)  break ;;
        esac
    done
}

function vol_menu() {
    local choice

    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " MAIN MENU " \
            --ok-label OK --cancel-label Exit \
            --menu "Puede elegir el nivel de volumen uno tras otro hasta que este satisfecho con su configuracion." 25 75 20 \
            1 "Establecer el volumen de la musica de fondo en 100%" \
            2 "Establecer el volumen de la musica de fondo en 90%" \
            3 "Establecer el volumen de la musica de fondo en 80%" \
            4 "Establecer el volumen de la musica de fondo en 70%" \
            5 "Establecer el volumen de la musica de fondo en 60%" \
            6 "Establecer el volumen de la musica de fondo en 50%" \
            7 "Establecer el volumen de la musica de fondo en 40%" \
            8 "Establecer el volumen de la musica de fondo en 30%" \
            9 "Establecer el volumen de la musica de fondo en 20%" \
            10 "Establecer el volumen de la musica de fondo en 10%" \
            2>&1 > /dev/tty)

        case "$choice" in
            1) 100_v  ;;
            2) 90_v  ;;
            3) 80_v  ;;
            4) 70_v  ;;
            5) 60_v  ;;
            6) 50_v  ;;
            7) 40_v  ;;
            8) 30_v  ;;
            9) 20_v  ;;
            10) 10_v  ;;
            *)  break ;;
        esac
    done
}

function install_bgm() {
        sudo grep livewire /etc/rc.local > /dev/null 2>&1
        if [ $? -eq 0 ] ; then
        echo -e "\n\n\n         Parece que la musica de fondo ya esta instalada. Saliendo......\n\n\n"
        sleep 5
        exit
        fi
        PKG=python-pygame
        PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $PKG|grep "install ok installed")
        if [ "" == "$PKG_OK" ]; then
                echo -e "\n\n\n     No $PKG installed. Setting up $PKG.\n\n\n"
                sleep 3
                sudo apt-get update; sudo apt-get install -y $PKG
        else
        echo -e "\n\n\n    $PKG seems to be installed...moving on with the Livewire background music install"
        sleep 3
        fi
        wget https://raw.githubusercontent.com/Shakz76/Eazy-Hax-RetroPie-Toolkit/master/cfg/Toggle%20Background%20Music.sh -O $HOME/RetroPie/retropiemenu/Toggle\ Background\ Music.sh
        cd $HOME && cp MasOS-Setup/scriptmodules/extras/.livewire.py -O $HOME/.livewire.py
        sudo perl -i.bak -pe '$_ = qq[(sudo python $HOME/.livewire.py) &\n$_] if $_ eq qq[exit 0\n]'  /etc/rc.local
        if [ ! -d "$HOME/MasOS/roms/music" ]; then
                echo -e "\n\n\n    Music directory is missing. Downloading some starter music for you.\n\n\n"
                sleep 3
                cd $HOME/MasOS/roms/
                wget http://eazyhax.com/downloads/music.zip -O $HOME/MasOS/roms/music.zip
                unzip -o music.zip  && rm music.zip
        fi
        vol_menu
}

function remove_bgm() {
	pgrep -f "python $HOME/.livewire.py"|xargs sudo kill -9
	rm -f $HOME/RetroPie/retropiemenu/Toggle\ Background\ Music.sh
	rm $HOME/.livewire.py
	if [ -e $HOME/.DisableMusic ]; then
		rm $HOME/.DisableMusic
	fi
	rm -r  $HOME/MasOS/roms/music/
	sudo sed -i '/livewire/d' /etc/rc.local
	echo -e "\n\n\n         Background Music has been removed from your system.\n\n\n"
	sleep 5
}



function 100_v() {
        CUR_VAL=`grep "maxvolume =" $HOME/.livewire.py|awk '{print $3}'`
        export CUR_VAL
        perl -p -i -e 's/maxvolume = $ENV{CUR_VAL}/maxvolume = 1.0/g' $HOME/.livewire.py
        pgrep -f "python $HOME/.livewire.py"|xargs sudo kill -9
        sudo python $HOME/.livewire.py  --silent &
}
function 90_v() {
        CUR_VAL=`grep "maxvolume =" $HOME/.livewire.py|awk '{print $3}'`
        export CUR_VAL
        perl -p -i -e 's/maxvolume = $ENV{CUR_VAL}/maxvolume = 0.90/g' $HOME/.livewire.py
        pgrep -f "python $HOME/.livewire.py"|xargs sudo kill -9
        sudo python $HOME/.livewire.py  --silent &
}
function 80_v() {
        CUR_VAL=`grep "maxvolume =" $HOME/.livewire.py|awk '{print $3}'`
        export CUR_VAL
        perl -p -i -e 's/maxvolume = $ENV{CUR_VAL}/maxvolume = 0.80/g' $HOME/.livewire.py
        pgrep -f "python $HOME/.livewire.py"|xargs sudo kill -9
        sudo python $HOME/.livewire.py  --silent &
}
function 70_v() {
        CUR_VAL=`grep "maxvolume =" $HOME/.livewire.py|awk '{print $3}'`
        export CUR_VAL
        perl -p -i -e 's/maxvolume = $ENV{CUR_VAL}/maxvolume = 70.0/g' $HOME/.livewire.py
        pgrep -f "python $HOME/.livewire.py"|xargs sudo kill -9
        sudo python $HOME/.livewire.py  --silent &
}
function 60_v() {
        CUR_VAL=`grep "maxvolume =" $HOME/.livewire.py|awk '{print $3}'`
        export CUR_VAL
        perl -p -i -e 's/maxvolume = $ENV{CUR_VAL}/maxvolume = 60.0/g' $HOME/.livewire.py
        pgrep -f "python $HOME/.livewire.py"|xargs sudo kill -9
        sudo python $HOME/.livewire.py  --silent &
}
function 50_v() {
        CUR_VAL=`grep "maxvolume =" $HOME/.livewire.py|awk '{print $3}'`
        export CUR_VAL
        perl -p -i -e 's/maxvolume = $ENV{CUR_VAL}/maxvolume = 0.50/g' $HOME/.livewire.py
        pgrep -f "python $HOME/.livewire.py"|xargs sudo kill -9
        sudo python $HOME/.livewire.py  --silent &
}
function 40_v() {
        CUR_VAL=`grep "maxvolume =" $HOME/.livewire.py|awk '{print $3}'`
        export CUR_VAL
        perl -p -i -e 's/maxvolume = $ENV{CUR_VAL}/maxvolume = 0.40/g' $HOME/.livewire.py
        pgrep -f "python $HOME/.livewire.py"|xargs sudo kill -9
        sudo python $HOME/.livewire.py  --silent &
}
function 30_v() {
        CUR_VAL=`grep "maxvolume =" $HOME/.livewire.py|awk '{print $3}'`
        export CUR_VAL
        perl -p -i -e 's/maxvolume = $ENV{CUR_VAL}/maxvolume = 0.30/g' $HOME/.livewire.py
        pgrep -f "python $HOME/.livewire.py"|xargs sudo kill -9
        sudo python $HOME/.livewire.py  --silent &
}
function 20_v() {
        CUR_VAL=`grep "maxvolume =" $HOME/.livewire.py|awk '{print $3}'`
        export CUR_VAL
        perl -p -i -e 's/maxvolume = $ENV{CUR_VAL}/maxvolume = 0.20/g' $HOME/.livewire.py
        pgrep -f "python $HOME/.livewire.py"|xargs sudo kill -9
        sudo python $HOME/.livewire.py  --silent &
}
function 10_v() {
        CUR_VAL=`grep "maxvolume =" $HOME/.livewire.py|awk '{print $3}'`
        export CUR_VAL
        perl -p -i -e 's/maxvolume = $ENV{CUR_VAL}/maxvolume = 0.10/g' $HOME/.livewire.py
        pgrep -f "python $HOME/.livewire.py"|xargs sudo kill -9
        sudo python $HOME/.livewire.py  --silent &
}


main_menu

