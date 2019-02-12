# ssclient

centos 下自动部署ssclient脚本，仅支持yum安装

* 需要在root用户下执行，如果无法切换，通过`sudo su`
* 可以在sh脚本目录下放置`config.json`配置文件也可以通过提示配置。
* 支持新的算法例如：`chacha20-ietf-poly1305`。
* 命令执行完成以后首先刷新环境变量`. /etc/profile`，然后通过`onproxy`和`offproxy`。
* 不支持多次执行，有多个配置文件影响
```
ss配置文件：/etc/shadowsocks/config.json
privoxy配置文件，增加最后一行：/etc/privoxy/config
快捷命令：/etc/profile
```
