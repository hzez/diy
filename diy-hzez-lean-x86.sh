#/bin/bash
#=================================================
#   Description: DIY script
#   Lisence: MIT
#   Author: P3TERX
#   Blog: https://p3terx.com
#=================================================

echo '修改网关地址'
sed -i 's/192.168.1.1/192.168.68.4/g' package/base-files/files/bin/config_generate

echo '修改时区'
sed -i "s/'UTC'/'CST-8'\n        set system.@system[-1].zonename='Asia\/Shanghai'/g" package/base-files/files/bin/config_generate



echo '添加软件包'

git clone https://github.com/liuran001/openwrt-packages package/openwrt-packages

rm -rf package/lean/luci-theme-argon
rm -rf package/openwrt-packages/luci-theme-argon
git clone https://github.com/jerrykuku/luci-theme-argon -b 18.06 package/lean/luci-theme-argon

echo '定义默认值'
cat > package/lean/default-settings/files/zzz-default-settings <<-EOF
#!/bin/sh

uci set luci.main.lang=zh_cn
uci set luci.themes.Argon=/luci-static/argon
uci set luci.main.mediaurlbase=/luci-static/argon
uci commit luci

uci set system.@system[0].timezone=CST-8
uci set system.@system[0].zonename=Asia/Shanghai
uci commit system

uci set fstab.@global[0].anon_mount=1
uci commit fstab



ln -sf /sbin/ip /usr/bin/ip

sed -i 's/downloads.openwrt.org/openwrt.proxy.ustclug.org/g' /etc/opkg/distfeeds.conf
sed -i 's/http:/https:/g' /etc/opkg/distfeeds.conf


sed -i "s/# //g" /etc/opkg/distfeeds.conf

sed -i '/REDIRECT --to-ports 53/d' /etc/firewall.user
echo "iptables -t nat -A PREROUTING -p udp --dport 53 -j REDIRECT --to-ports 53" >> /etc/firewall.user
echo "iptables -t nat -A PREROUTING -p tcp --dport 53 -j REDIRECT --to-ports 53" >> /etc/firewall.user


exit 0
EOF

echo '当前路径'
pwd
