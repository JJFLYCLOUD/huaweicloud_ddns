# huaweicloud_ddns  华为云ddns脚本
# 重要提示！
## 本项目现已有关于```ZONE_ID```和```RECORDSET_ID```获取方法的教程，不再回答任何关于此类问题的issue
## 本脚本适用于ipv4和ipv6地址的更新，请根据需求调整注释
## 和原脚本不同之处：只保留了在线获取IP地址，同时将v4和v6合二为一
# 安装
```
Ubuntu/Debian执行
#apt-get update
apt-get install wget curl dnsutils net-tools cron -y
#CentOS执行
yum install wget curl bind-utils net-tools cron -y

#下载脚本
wget -N --no-check-certificate https://raw.githubusercontent.com/lllvcs/huaweicloud_ddns/master/huaweicloud_ddns.sh
#赋予执行权限
chmod +x ./huaweicloud_ddns.sh
之后自行修改脚本内参数
```


# 首次操作
## 第一步，先在DNS管理控制台```https://console.huaweicloud.com/dns/```内添加对应域名解析记录
## 第二步,获取对应记录的```ZONE_ID```和```RECORDSET_ID```信息
### 方法一 F12抓包
```
在修改记录集时，点击提交，即可在网络中找到如下图的数据包
在响应结果中即可找到id与zone_id，其中id为RECORDSET_ID、zone_id为ZONE_ID
```
![方法一](https://cdn.jsdelivr.net/gh/lllvcs/huaweicloud_ddns@master/img/1.jpg)
### 方法二 调用API Explorer
```
点击控制台上方的开发工具-API Explorer
可见如下图的页面，选择云解析服务-Record Set管理-ListRecordSets，填写name(即域名 subdomain.domain.com)，点击调试
在响应结果中即可找到id与zone_id，其中id为RECORDSET_ID、zone_id为ZONE_ID
```
![方法二](https://cdn.jsdelivr.net/gh/lllvcs/huaweicloud_ddns@master/img/2.jpg)
## 第三步，在```huaweicloud_ddns.sh```内填写 ```账号信息```、```各ID信息```和```ip地址获取的相关参数```
## 第四步(可选)，运行```huaweicloud_ddns.sh```，设置定时任务

# 设置定时任务(可选)
```
crontab -e
* * * * * bash ~/huaweicloud_ddns.sh
# 此为每分钟更新一次
```

# 一点说明
华为云目前虽然支持AK/SK调用API进行域名更新，但是在获取```Zone_ID```和```Record_ID```时需要有一个```X-Auth-Token```头的请求，而目前只能通过用户名、账户名和密码三者来获取```X-Auth-Token```，通过AK/SK获取```X-Auth-Token```目前只在华为内部实现，暂不对外开放。

附上获取```Token```的PDF说明文档
