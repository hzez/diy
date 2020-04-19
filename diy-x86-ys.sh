#/bin/bash
#=================================================
#   Description: DIY script
#   Lisence: MIT
#   Author: P3TERX
#   Blog: https://p3terx.com
#=================================================

#echo '修改feeds'
#sed -i '1,2s/coolsnowwolf/sypopo/g' ./feeds.conf.default

echo '修改网关地址'
sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate

echo '修改时区'
sed -i "s/'UTC'/'CST-8'\n        set system.@system[-1].zonename='Asia\/Shanghai'/g" package/base-files/files/bin/config_generate

#echo '修改机器名称'
#sed -i 's/OpenWrt/OpenWrt-x64/g' package/base-files/files/bin/config_generate

echo '修改banner'
cp -f diy/sypopo/banner package/base-files/files/etc/
date=`date +%m.%d.%Y`
sed -i "s/SyPopo$/SyPopo $date/g" package/base-files/files/etc/banner

echo '添加软件包'
git clone https://github.com/vernesong/OpenClash.git && mv OpenClash/luci-app-openclash package/luci-app-openclash
git clone https://github.com/tty228/luci-app-serverchan package/luci-app-serverchan

echo '配置aria2'
rm -Rf files/usr/share/aria2 && git clone https://github.com/P3TERX/aria2.conf files/usr/share/aria2
sed -i 's/#rpc-secure/rpc-secure/g' files/usr/share/aria2/aria2.conf
sed -i 's/rpc-secret/#rpc-secret/g' files/usr/share/aria2/aria2.conf
sed -i 's/root\/Download/data\/download\/aria2/g' files/usr/share/aria2/*
sed -i 's/extra_setting\"/extra_settings\"/g' feeds/luci/applications/luci-app-aria2/luasrc/model/cbi/aria2/config.lua
sed -i "s/sed '\/^$\/d' \"\$config_file_tmp\" >\"\$config_file\"/cd \/usr\/share\/aria2 \&\& sh .\/tracker.sh\n    cat \/usr\/share\/aria2\/aria2.conf > \"\$config_file\"\n\    echo '' >> \"\$config_file\"\n    sed '\/^$\/d' \"\$config_file_tmp\" >> \"\$config_file\"/g" feeds/packages/net/aria2/files/aria2.init

echo '当前路径'
pwd


