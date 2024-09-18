#!/bin/bash

clear

fun_bar() {
    CMD[0]="$1"
    CMD[1]="$2"
    (
        [[ -e $HOME/fim ]] && rm $HOME/fim
        ${CMD[0]} -y >/dev/null 2>&1
        ${CMD[1]} -y >/dev/null 2>&1
        touch $HOME/fim
    ) >/dev/null 2>&1 &
    tput civis
    echo -ne "\033[0;33mTunggu sek Loading \033[1;37m- \033[0;33m["
    while true; do
        for ((i = 0; i < 18; i++)); do
            echo -ne "\033[0;32m#"
            sleep 0.1s
        done
        [[ -e $HOME/fim ]] && rm $HOME/fim && break
        echo -e "\033[0;33m]"
        sleep 1s
        tput cuu1
        tput dl1
        echo -ne "\033[0;33mTunggu Sebentar loading \033[1;37m- \033[0;33m["
    done
    echo -e "\033[0;33m]\033[1;37m -\033[1;32m OK !\033[1;37m"
    tput cnorm
}

res1() {
    wget https://raw.githubusercontent.com/RyyStore/x2621/main/menu/menu.zip
    unzip menu.zip
    chmod +x menu/*
    mv menu/* /usr/local/sbin
    rm -rf menu.zip
    rm -rf update.sh
    wget -qO- fv-tunnel "https://raw.githubusercontent.com/RyyStore/x2621/main/config/fv-tunnel" 
    chmod +x fv-tunnel 
    bash fv-tunnel
    rm -rf fv-tunnel
}

ins_backup() {
    clear
    print_install "Memasang Backup Server"
    apt install rclone -y
    printf "q\n" | rclone config
    wget -O /root/.config/rclone/rclone.conf "${REPO}config/rclone.conf"
    
    cd /bin
    git clone https://github.com/magnific0/wondershaper.git
    cd wondershaper
    sudo make install
    cd
    rm -rf wondershaper
    
    echo > /home/limit
    apt install msmtp-mta ca-certificates bsd-mailx -y
    
    cat<<EOF>>/etc/msmtprc
defaults
tls on
tls_starttls on
tls_trust_file /etc/ssl/certs/ca-certificates.crt

account default
host smtp.gmail.com
port 587
auth on
user oceantestdigital@gmail.com
from oceantestdigital@gmail.com
password jokerman77 
logfile ~/.msmtp.log
EOF
    
    chown -R www-data:www-data /etc/msmtprc
    wget -q -O /etc/ipserver "${REPO}files/ipserver" && bash /etc/ipserver
    print_success "Backup Server"
}

netfilter-persistent
clear

echo -e ""
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | lolcat
echo -e "\e[1;97;101m        » UPDATE Sedang Proses RyyStore🧩«             \033[0m"
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | lolcat
echo -e ""
echo -e "\033[1;91mPerbarui Script Layanan\033[1;37m"
fun_bar 'res1'
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | lolcat
echo -e ""

# Call ins_backup function after updating services
ins_backup

read -n 1 -s -r -p "Tab [ Spasi ] Untuk kembali ke Menu"
menu
