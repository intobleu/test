#!/bin/bash 
# vim: filetype=sh
#set -x
source ./function
# run
# run in center contoller 
u_check_run c_check_expect  # 检查并安装 expect
u_check_run s_set_ssh_without_pwd # 配置免密码登录

## 包解压
u_check_run "u_unpack $SRC_NAME $BK_INSTALL_PATH"
u_check_run "u_unpack $INSTALL_NAME $BK_INSTALL_PATH"
u_check_run "u_unpack $SERVICE_PKG_NAME $BK_INSTALL_PATH"
u_check_run "u_unpack bkeeallpip.tar.gz $RUN_PATH"

# run in all servers
u_check_run "s_set_localyum" # 配置本地yum源
u_check_run "c_install_dependences" # 安装依赖条件
u_check_run "c_config_umask" #设置 umask 为0022
u_check_run "c_config_selinux" # 关闭 selinux
u_check_run "c_config_firewalld" # 关闭防火墙
u_check_run "c_config_networkmanager" # 关闭 NetworkManager 服务
u_check_run "c_config_open_file" # 设置 open file 值为102400

# open_paas  补全 open_paas的离线 pip 包
u_check_run "c_config_pip_pkgs open_paas appengine"
u_check_run "c_config_pip_pkgs open_paas console"
u_check_run "c_config_pip_pkgs open_paas esb"
u_check_run "c_config_pip_pkgs open_paas login"
u_check_run "c_config_pip_pkgs open_paas paas"

# bkdata  补全 bkdata 的离线 pip 包
u_check_run "c_config_pip_pkgs bkdata dataapi"
u_check_run "c_config_pip_pkgs bkdata monitor"

# fta  补全 fta 的离线 pip 包
u_check_run "c_config_pip_pkgs fta fta"

# paas_agent  补全 paas_agent 的离线包
u_check_run "c_config_pip_pkgs paas_agent paas_agent"


# ------ 社区版请注释 ------
#
# paas_plugins  补全 paas_plugins 的离线 pip 包
u_check_run "c_config_pip_pkgs paas_plugins log_alert"
#
# 补全开源组件
u_check_run "c_config_bkdata_src"
u_check_run "c_config_zbx_src"
u_check_run "c_config_job_src"
#
# ------    END     ------

# 检查机器Mac地址是否匹配证书
u_check_run "c_check_mac"

rm -rf ./bkeepip
