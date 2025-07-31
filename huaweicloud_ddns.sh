#!/bin/bash
# Copyright 2021 LVCS
# 在运行此脚本之前，请先在华为云DNS管理控制台内添加对应域名的A记录
# 并获取对应的 ZONE_ID 和 RECORDSET_ID

# 一般来说用户名和账户名相同
ACCOUNTNAME=""  #登录时填的用户名
USERNAME=""        #租户名
PASSWORD=""  #租户名对应的租户密码

# 对应解析记录的 ZONE_ID 和 RECORDSET_ID
ZONE_ID=""
RECORDSET_ID=""


# 更新IPv4
TARGET_IP="$(curl -s ip.sb|grep -oE '([0-9]{1,3}.?){4}' | sed -n 1p)"
#更新IPv6
#TARGET_IP="$(curl ipv6.ip.sb)"


# 获取IPv4接口
# 国内API
#TARGET_IP="$(curl -s ip.3322.net | grep -oE '([0-9]{1,3}.?){4}' | sed -n 1p)"
#TARGET_IP="$(curl -s members.3322.org/dyndns/getip | grep -oE '([0-9]{1,3}.?){4}' | sed -n 1p)"
#TARGET_IP="$(curl -s myip.ipip.net/ | grep -oE '([0-9]{1,3}.?){4}' | sed -n 1p)"
#国外API
#TARGET_IP="$(curl -s whatismyip.akamai.com | grep -oE '([0-9]{1,3}.?){4}' | sed -n 1p)"
#TARGET_IP="$(curl -s api.myip.la/ | grep -oE '([0-9]{1,3}.?){4}' | sed -n 1p)"
#TARGET_IP="$(curl -s v4.ip.zxinc.org/getip | grep -oE '([0-9]{1,3}.?){4}' | sed -n 1p)"

#若有多个IP，可以用 curl --interface 172.16.0.1 …… 来指定本地IP

#获取IPv6接口
#TARGET_IP="$(curl api6.ipify.org)"
#TARGET_IP="$(curl 6.ipw.cn)"



# End Point 终端地址 请根据地域选择，默认为香港
#IAM="iam.myhuaweicloud.com"
#IAM="iam.cn-north-4.myhuaweicloud.com"
#IAM="iam.cn-east-2.myhuaweicloud.com"
#IAM="iam.cn-east-3.myhuaweicloud.com"
#IAM="iam.cn-south-1.myhuaweicloud.com"
#IAM="iam.cn-southwest-2.myhuaweicloud.com"
IAM="iam.ap-southeast-1.myhuaweicloud.com"
#IAM="iam.ap-southeast-2.myhuaweicloud.com"
#IAM="iam.ap-southeast-3.myhuaweicloud.com"
#IAM="iam.af-south-1.myhuaweicloud.com"

#DNS="dns.myhuaweicloud.com"
#DNS="dns.cn-north-4.myhuaweicloud.com"
#DNS="dns.cn-east-2.myhuaweicloud.com"
#DNS="dns.cn-east-3.myhuaweicloud.com"
#DNS="dns.cn-south-1.myhuaweicloud.com"
#DNS="dns.cn-southwest-2.myhuaweicloud.com"
DNS="dns.ap-southeast-1.myhuaweicloud.com"
#DNS="dns.ap-southeast-2.myhuaweicloud.com"
#DNS="dns.ap-southeast-3.myhuaweicloud.com"
#DNS="dns.af-south-1.myhuaweicloud.com"

TOKEN_X="$(
    curl -L -k -s -D - -X POST \
    "https://$IAM/v3/auth/tokens" \
    -H 'content-type: application/json' \
    -d '{
    "auth": {
        "identity": {
            "methods": ["password"],
            "password": {
                "user": {
                    "name": "'$USERNAME'",
                    "password": "'$PASSWORD'",
                    "domain": {
                        "name": "'$ACCOUNTNAME'"
                    }
                }
            }
        },
        "scope": {
            "domain": {
                "name": "'$ACCOUNTNAME'"
            }
        }
    }
  }' | grep X-Subject-Token
)"

TOKEN="$(echo $TOKEN_X | awk -F ' ' '{print $2}')"


curl -X PUT -L -k -s \
"https://$DNS/v2/zones/$ZONE_ID/recordsets/$RECORDSET_ID" \
-H "Content-Type: application/json" \
-H "X-Auth-Token: $TOKEN" \
-d "{\"records\": [\"$TARGET_IP\"],\"ttl\": 1}"
