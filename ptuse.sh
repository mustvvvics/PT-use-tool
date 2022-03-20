#!/bin/bash
# set ARGS
ARGS=`getopt -a -o bp:s:qnz:df:m:P:S:A:Z:t:vh \\
-l basic-install,qbittorrent-port:,qbittorrent-save:,qbittorrent-install,\\
,nginx-install,qbittorrent-public-zones-ssl,\\
docker-install,flexget-install-config:,baidu,FolderMagic:,transmission-install:,trans:,\\
FolderMagic-port:,FolderMagic-save:,FolderMagic-account:,FolderMagic-public-zones-ssl:,\\
remove-qbit,remove-nginx,remove-docker,remove-flexget,remove-baidu,remove-m,remove-trans,\\
version,help -- "$@"`

# define function
function usage() {
echo "Usage:"
echo "PT-use-tool COMMAND"
echo ""
echo "-b, --basic-install                      basic config,port:9999，save directory:/root/Download/qbittorrent"
echo ""
echo "-p, --qbittorrent-port                   set qbittorrent-nox port, eg: ptuse -p 9999"
echo ""
echo "-s, --qbittorrent-save                   set qbittorrent-nox save directory, eg: ptuse -s /root/Download/qbittorrent"
echo ""
echo "-q, --qbittorrent-install                install qbittorrent-nox"
echo ""
echo "-n, --nginx-install                      install nginx"
echo ""
echo "-z, --qbittorrent-public-zones-ssl       set public zones and ssl certificate for your qbittorrent-nox serve, eg: ptuse -z google.com"
echo ""
echo "-d, --docker-install                     install docker"
echo ""
echo "-f, --flexget-install-config             Configure flexget"
echo ""
echo "-P, --FolderMagic-port                   set FolderMagic port, eg: ptuse -P 9999"
echo ""
echo "-S, --FolderMagic-save                   set FolderMagic save directory, eg: ptuse -S /root/Download/"
echo ""
echo "-A, --FolderMagic-account                set FolderMagic account , eg: ptuse -A FolderMagic_account"
echo ""
echo "-Z, --FolderMagic-public-zones-ssl       set public zones and ssl certificate for your FolderMagic serve, eg: ptuse -Z github.com"
echo ""
echo "-m, --FolderMagic                        set FolderMagic passward and configure FolderMagic, eg: ptuse -m FolderMagic_passward"
echo ""
echo "-t,--transmission-install                install transmission and set your pt tracker"
echo ""
echo "--trans                                  use transmission-create to make torrent.  eg: ptuse --trans your_file_name"
echo ""
echo "--baidu                                  install BaiduPCS-Go"
echo ""
echo "--remove-trans                           remove transmission"
echo ""
echo "--remove-qbit                            remove qbittorrent-nox"
echo ""
echo "--remove-nginx                           remove nginx"
echo ""
echo "--remove-docker                          remove docker"
echo ""
echo "--remove-flexget                         remove flexget "
echo ""
echo "--remove-baidu                           remove BaiduPCS-Go"
echo ""
echo "--remove-m                               remove FolderMagic"
echo ""
echo "-h, --help                               show help"
echo ""
echo "-v, --version                            show version"
}

[ $? -ne 0 ] && usage
#set -- "${ARGS}"
eval set -- "${ARGS}"

# Passing parameters need 'shift'
while true
do
      case "$1" in
        # basic install
      -b|--basic-install)
                qbittorrent_port="9999"
                savepath="/root/Download/qbittorrent"
                echo default qbittorrent port:$qbittorrent_port,savepath:$savepath . 
                ;;
        # set port for qbittorrent
      -p|--qbittorrent-port)
                qbittorrent_port="$2"
                shift
                ;;
        # set save dir for qbittorrent
      -s|--qbittorrent-save)
                savepath="$2"
                echo set qbittorrent port:$qbittorrent_port,savepath:$savepath finish! 
                shift
                ;;
        # install for qbittorrent
      -q|--qbittorrent-install)
                ufw allow $qbittorrent_port/tcp
                cp /root/PT-use-tool/config/qbittorrent-nox.service /etc/systemd/system/qbittorrent-nox.service
                sed -i "6s/9999/$qbittorrent_port/1;6s?/root/Download/qbittorrent?$savepath?1" /etc/systemd/system/qbittorrent-nox.service        
                # wget qbittorrent-nox for x86_64
                wget -qO /usr/bin/qbittorrent-nox https://github.com/userdocs/qbittorrent-nox-static/releases/latest/download/x86_64-qbittorrent-nox 
                chmod 700 /usr/bin/qbittorrent-nox 
                systemctl daemon-reload && systemctl enable qbittorrent-nox && systemctl start qbittorrent-nox && systemctl status qbittorrent-nox
                ;;
        # install for nginx
      -n|--nginx-install)
                apt update
                apt install nginx -y
                mkdir /etc/nginx/cert
                echo install nginx finish!
                ;;
      -z|--qbittorrent-public-zones-ssl)
                qbittorrent_public_zones="$2"
                echo your public zones is:$qbittorrent_public_zones , your qbittorrent port is $qbittorrent_port.
                unzip -q /root/PT-use-tool/config/nginxconfig/cert/certqbittorrent/*.zip -d /root/PT-use-tool/config/nginxconfig/cert/certqbittorrent
                mv /root/PT-use-tool/config/nginxconfig/cert/certqbittorrent/*.key /etc/nginx/cert/$qbittorrent_public_zones.key
                mv /root/PT-use-tool/config/nginxconfig/cert/certqbittorrent/*.pem /etc/nginx/cert/$qbittorrent_public_zones.cert
                cp -rf /root/PT-use-tool/config/nginxconfig/sites-available/default /etc/nginx/sites-available/default
                cp /root/PT-use-tool/config/nginxconfig/sites-available/qbittorrent-nox.conf /etc/nginx/sites-available/qbittorrent-nox.conf
                # config qbittorrent_public_zones
                sed -i "s/your_public_zones/$qbittorrent_public_zones/g;s?9999?$qbittorrent_port?g" /etc/nginx/sites-available/qbittorrent-nox.conf
                # set ln -s
                ln -s /etc/nginx/sites-available/qbittorrent-nox.conf /etc/nginx/sites-enabled/qbittorrent-nox.conf
                nginx -s reload
                shift
                ;;
      -d|--docker-install)
                apt update
                apt install ca-certificates curl gnupg lsb-release -y
                curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
                echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian   $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null 
                apt update && apt install docker-ce docker-ce-cli containerd.io -y
                systemctl daemon-reload && systemctl enable docker && systemctl start docker 
                echo docker install finish!
                ;;
      -f|--flexget-install-config)
                ufw allow 5050/tcp
                your_flexgetwebui_passward="$2"
                docker run -d --name=flexget -p 5050:5050 -v /root/.config/flexget/data:/data -v /root/.config/flexget/config:/config -e FG_WEBUI_PASSWD=$your_flexgetwebui_passward -e FG_LOG_LEVEL=info -e FG_LOG_FILE=flexget.log -e PUID=0  -e PGID=0 -e TZ=Asia/Shanghai wiserain/flexget
                echo Now you can set your rss rule in \' ip:5050 \' ,
                echo and your user:flexget passward:$your_flexgetwebui_passward
                shift
                ;;
        # remove 
      --baidu)
                wget -P /root/BaiduPCS https://github.com/qjfoidnh/BaiduPCS-Go/releases/download/v3.8.7/BaiduPCS-Go-v3.8.7-linux-amd64.zip
                unzip /root/BaiduPCS/*.zip -d /root/BaiduPCS/ && rm -rf /root/BaiduPCS/*.zip
                mv /root/BaiduPCS/* /root/BaiduPCS/baidu
                echo "alias baidu='/root/BaiduPCS/baidu/BaiduPCS-Go'" >> /root/.bashrc && source /root/.bashrc
                ;;
      # -P port
      -P|--FolderMagic-port)
                FolderMagic_port="$2"
                echo set FolderMagic port:$FolderMagic_port.
                shift
                ;;
      # -S /root/share
      -S|--FolderMagic-save)
                FolderMagic_save="$2"
                echo set FolderMagic port:$FolderMagic_port
                shift
                ;;
      # -A account
      -A|--FolderMagic-account) 
                FolderMagic_account="$2"
                shift
                ;;
      -Z|--FolderMagic-public-zones-ssl) 
                FolderMagic_public_zones="$2"
                unzip -q /root/PT-use-tool/config/nginxconfig/cert/certFolderMagic/*.zip -d /root/PT-use-tool/config/nginxconfig/cert/certFolderMagic
                mv /root/PT-use-tool/config/nginxconfig/cert/certFolderMagic/*.key /etc/nginx/cert/$FolderMagic_public_zones.key
                mv /root/PT-use-tool/config/nginxconfig/cert/certFolderMagic/*.pem /etc/nginx/cert/$FolderMagic_public_zones.cert
                cp /root/PT-use-tool/config/nginxconfig/sites-available/FolderMagic.conf /etc/nginx/sites-available/FolderMagic.conf
                # config FolderMagic_public_zones
                sed -i "s/your_public_zones/$FolderMagic_public_zones/g;s?10000?$FolderMagic_port?g" /etc/nginx/sites-available/FolderMagic.conf
                # set ln -s
                ln -s /etc/nginx/sites-available/FolderMagic.conf /etc/nginx/sites-enabled/FolderMagic.conf
                nginx -s reload
                shift
                ;;
      # -m passward
      -m|--FolderMagic) 
                FolderMagic_passward="$2"
                echo set FolderMagic port:$FolderMagic_port,savepath:$FolderMagic_save finish! 
                echo set FolderMagic\&webdav account:$FolderMagic_account,passward:$FolderMagic_passward finish! 
                echo set your public zones is:$FolderMagic_public_zones finish! 

                ufw allow $FolderMagic_port/tcp
                mkdir /root/FolderMagic
                cp /root/PT-use-tool/config/FolderMagic.service /etc/systemd/system/FolderMagic.service
                sed -i "s/10000/$FolderMagic_port/g;s?/root/Drive?$FolderMagic_save?g;s?account?$FolderMagic_account?g;s?passward?$FolderMagic_passward?g" /etc/systemd/system/FolderMagic.service
                wget -qO /root/FolderMagic/FolderMagic https://github.com/FolderMagic/FolderMagic/blob/master/FolderMagic?raw=true
                chmod +x /root/FolderMagic/FolderMagic
                systemctl daemon-reload && systemctl enable FolderMagic && systemctl start FolderMagic && systemctl status FolderMagic

                echo set FolderMagic successfully!
                shift
                ;;
      # enter your pt_tracker 
      -t|--transmission-install)  
                your_pt_tracker="$2"
                touch /root/.pt_tracker
                echo "$your_pt_tracker" > /root/.pt_tracker
                apt install transmission-daemon transmission-cli -y
                service transmission-daemon start
                echo install transmission finish！
                echo "your pt tracker which in /root/.pt_tracker is:"
                cat /root/.pt_tracker
                shift
                ;;  
      --trans) # 
                torrent_name="$2"
                cat /root/.pt_tracker | while read pt_tracker; 
                do transmission-create -p -t $pt_tracker -o $torrent_name.torrent $torrent_name;done
                shift
                ;;   
      --remove-trans)  
                apt remove transmission-daemon transmission-cli -y
                rm -rf /root/.pt_tracker
                echo transmission finish!
                ;;
      # FolderMagic   
      --remove-m) 
                systemctl stop FolderMagic
                ufw delete allow $FolderMagic_port/tcp
                rm -rf /root/FolderMagic
                rm -rf /etc/nginx/sites-enabled/FolderMagic.conf
                rm -rf /etc/nginx/sites-available/FolderMagic.conf
                nginx -s reload
                echo remove FolderMagic finish!
                ;;   
      --remove-qbit)
                systemctl stop qbittorrent-nox
                ufw delete allow $qbittorrent_port/tcp
                rm -rf /.config/qBittorrent/*
                rm -rf /.config/qBittorrent
                rm -rf /usr/bin/qbittorrent-nox
                rm -rf /.local/share/qBittorrent/*
                rm -rf /.local/share/qBittorrent
                rm -rf /.cache/qBittorrent
                rm -rf /root/.config/qBittorrent
                rm -rf /root/.local/share/qBittorrent/*
                rm -rf /root/.local/share/qBittorrent
                rm -rf /root/.cache/qBittorrent
                rm -rf /etc/systemd/system/multi-user.target.wants/qbittorrent-nox.service
                rm -rf /etc/systemd/system/qbittorrent-nox.service
                echo remove qbittorrent-nox finish!
                ;;
      --remove-nginx)
                apt remove --purge nginx -y
                apt autoremove --purge -y
                rm -rf /usr/sbin/nginx 
                rm -rf /usr/lib/nginx 
                rm -rf /etc/nginx 
                rm -rf /usr/share/nginx 
                rm -rf /usr/share/man/man8/nginx.8.gz
                echo remove nginx finish!
                ;;  
      --remove-docker)
                # stop docker
                systemctl stop docker
                # remove something
                apt remove --purge docker docker-engine docker.io containerd runc -y       
                apt remove --purge docker-scan-plugin docker-ce-rootless-extras -y
                apt remove --purge docker-ce docker-ce-cli containerd.io -y
                apt autoremove --purge -y
                rm -rf /var/lib/docker
                rm -rf /var/lib/containerd
                rm -rf /usr/share/keyrings/docker-archive-keyring.gpg
                # rm -rf /etc/apt/sources.list.d/docker*
                # rm -rf /lib/systemd/system/docker*
                # rm -rf /usr/libexec/docker
                # rm -rf /usr/libexec/docker/*
                # rm -rf /usr/share/doc/docker*
                # rm -rf /etc/docker
                # rm -rf /var/cache/apt/archives/docker*
                echo remove docker finish!
                ;;
      --remove-flexget)
                ufw delete allow 5050/tcp
                docker rm -f flexget && docker rmi -f wiserain/flexget
                echo flexget finish!
                ;;
      --remove-baidu)
                rm -rf /root/BaiduPCS
                sed -i "s?alias baidu='/root/BaiduPCS/baidu/BaiduPCS-Go'?   ?g" /root/.bashrc && source /root/.bashrc
                echo BaiduPCS finish!
                ;;
      -h|--help)
                usage
                ;;
      -v|--version)
                echo PT-use-tool version v1.0.0
                ;;   
      --)
                shift
                break
                ;;
      esac
shift
done 
