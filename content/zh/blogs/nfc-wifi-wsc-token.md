+++
date = '2026-10-15T18:00:00+08:00'
lastmod = '2026-10-15T18:00:00+08:00'
draft = false
title = '碰一下连 WiFi：所谓非标准布局，其实是 WFA WSC 标准'
description = '写 NFC WiFi 标签时，所谓非标准字节布局其实是 WFA WSC 的 NFC 配置令牌标准；OTA 消息与令牌形态的属性 ID 完全不同，用错形态手机只弹选应用。'
tags = ['NFC', 'Flutter', 'WiFi', 'WSC', 'Android']
categories = ['工程']
author = 'Diogo Ferro'
+++

我用一个 Flutter 插件写 NFC 标签，想实现"碰一下就连 WiFi"。

我按 WSC 规范拼出一条 `application/vnd.wfa.wsc` 记录。结果在 HyperOS 上，手机只弹"选应用"，连不上。同一台手机，用 NFC Tools 写的标签却能一键连。

规范和我写的，到底谁错了？

## 一、先取证：把两张标签读回来逐字节比

光猜没用。我把两张标签都读回来，把 payload 打成十六进制，逐字节对比。

失败的（我写的）是一条 OTA 形态的 WSC 消息。成功的是 NFC Tools 写的那张。

下面是两个标签解码后的属性树。左边失败，右边成功：

```
10 4a 00 04  VendorExtension (0x104A) -> 00 50 f2 04 (WFA OUI)
10 12 00 02  Version2        (0x1012) -> 20 01
10 26 00 26  Credential      (0x1026)  len=38:
  └ 10 0e 00 0a  SSID        (0x100E) = "ZTE-dtTtGY"
  └ 10 0f 00 08  NetworkKey  (0x100F) = "f3hsp7jd"
  └ 10 03 00 02  AuthType    (0x1003) = 0x0020
  └ 10 04 00 02  EncType     (0x1004) = 0x0008

10 0e 00 35  (顶层容器 0x100E)              len=53:
  └ 10 26 00 01  Credential (0x1026)  len=1, 值 0x01
  └ 10 45 00 0a  SSID        (0x1045) = "ZTE-dtTtGY"
  └ 10 03 00 02  AuthType    (0x1003) = 0x0022
  └ 10 0f 00 02  EncryptionType (0x100F) = 0x000c
  └ 10 27 00 08  NetworkKey  (0x1027) = "f3hsp7jd"
  └ 10 20 00 06  MAC         (0x1020) = ff:ff:ff:ff:ff:ff
```

差别一眼可见。成功那条，顶层是一个 `0x100E` 容器，里面包着 `Credential` 标记和作用域 ID。失败那条，顶层是 `VendorExtension` 加 `Version2`。

## 二、那个"非标准布局"，其实是 WFA 标准

我原以为 NFC Tools 写的是某种厂商私有格式。查了之后发现不是。

`application/vnd.wfa.wsc` 这个 MIME 类型，是 Wi-Fi 联盟（WFA）注册的标准媒体类型。它对应 WFA 的「Wi-Fi Simple Configuration」规范，也就是大家熟知的 WPS。

NFC 在这里是一种"带外"分发方式：把 WiFi 凭证写进标签，手机碰一下就连，不用跑完整的注册协议。

第三方库 ndeflib/nfcpy 的 `WifiSimpleConfigRecord` 能直接生成这种记录。它打印出一个 `Credential` 实际写出的属性 ID：

`0x1003 0x100F 0x1020 0x1026 0x1027 0x1045`

这串数字，和 NFC Tools 写出来的、以及我能连的那张标签，逐一对应。所以结论很清楚：这不是小米私有协议，是 WFA 的标准用法。

## 三、WSC 有两种承载形态，属性 ID 完全不同

关键在 WSC 其实有两种用法，它们用的属性 ID 不是一套。

第一种是 OTA WSC 消息。它是 WPS 按键、设备间注册协议用的，里面的 SSID 用根级 ID `0x100E`，密码用 `0x100F`，加密类型用 `0x1004`。

第二种是 NFC 配置令牌。它把凭证包进一个 `Credential` 里，字段改用"作用域 ID"：SSID 是 `0x1045`，密码是 `0x1027`，加密类型是 `0x100F`。

注意密码的 ID：OTA 里是 `0x100F`，令牌里是 `0x1027`。同一个功能，两套编号。

| 字段 | OTA / WPS 消息 | NFC 配置令牌 |
|---|---|---|
| SSID | 0x100E（根级） | 0x1045（作用域） |
| 密码 | 0x100F（根级） | 0x1027（作用域） |
| 加密类型 | 0x1004（根级） | 0x100F（作用域） |
| 顶层 | VendorExtension + Version2 | 单个 0x100E 容器 |
| VendorExtension | 有 | 无 |

## 四、最坑的一点：属性 ID 是带作用域的

WSC 的属性编号不是全局唯一的。同一个数字，在不同容器里意思不同。

`0x100E` 在根级是 SSID，在令牌里却是顶层容器。
`0x100F` 在根级是密码，在 Credential 里却是加密类型。

这意味着解析器必须知道自己"现在在消息根，还是在 Credential 里面"，才能正确读 `0x100F`。

我第一次写挂，就是栽在这：我按 OTA 形态，用了根级的 `0x100E`/`0x100F`/`0x1004`，还带了 `VendorExtension`。但 Android 的 `WpsNfcConfigTokenParser` 是写死按令牌形态解析的。它要的是顶层 `0x100E` 容器，里面 `0x1026` 标记，再找 `0x1045`/`0x1027`/`0x100F`。对不上，就退回"选应用"。

## 五、怎么修：复刻能连的那张标签

既然真机只认令牌形态，最直接的就是复刻 NFC Tools 写出的字节。

顶层 `0x100E` 容器，包住下面这段：

- `Credential` 标记：`0x1026`，长度 1，值 `0x01`
- SSID：`0x1045`，值填你的 SSID
- AuthType：`0x1003`，值 `0x0022`
- 加密类型：`0x100F`，值 `0x000c`
- 密码：`0x1027`，值填你的密码
- MAC：`0x1020`，值 `ff:ff:ff:ff:ff:ff`

注意 `0x100F` 这里不是密码，是加密类型。我一开始把它误当成"含义不明的固定字段"，就是因为没看穿作用域。

我用 Python 验证过：对相同 SSID/密码，生成的字节和抓回来的标签逐字节一致。真机上，碰一下就调起 WiFi 连接了。

（文中 SSID、密码是抓回来的测试标签，不是我的真实网络。）

## 六、关于"没查清"的更正

写技术文章，没查清的要摊开说。这一节我原本列了三点，但写完去翻 ndeflib 源码后，发现其中两点是我自己没查，不是规范查不到。下面更正。

规范 PDF 本身：WFA 的《Wi-Fi Simple Configuration》规范 PDF 不对外公开下载，挂在会员门户后面（wi-fi.org/discover-wi-fi/specifications），非会员拿不到原文。所以我对着规范 PDF 逐条核对这步确实做不到。但"规范不公开等于我只能对着字节逆推"是错的：ndeflib 把每个属性 ID 都按规范映射好，AOSP 的解析器独立印证，NFC Tools 字节是第四方。实际是四源互证，ndeflib 这份就是规范的公开镜像。

AuthType 与加密类型：我之前写"没逐位解码"，这是错的。ndeflib 的 bitmap 直接给了每个 bit 的含义。AuthType `0x0022` 是 WPA-Personal（`0x0002`）加 WPA2-Personal（`0x0020`），即 WPA/WPA2 个人版混合。加密类型 `0x000c` 是 TKIP（`0x0004`）加 AES（`0x0008`），即 TKIP/AES 混合，典型 WPA2。两个值都是常规 bitmap，不是神秘抓取值。

外层 `0x100E`：正文说的"0x100E 在 WSC 根消息里是 SSID、在令牌顶层是 Credential 容器，同一编号作用域不同"是对的。我草稿里写"这个挪用没找到出处"不对，现在能找到了。ndeflib 里 `Credential` 的 key 就是 `0x100E`，文档注明它是包含其他 WSC TLV 的复合属性。它不是挪用，是规范里作用域不同的同一个编号。这句误述我已删掉。

## 收尾

写 NFC WiFi 标签，先想清楚你要的是哪种 WSC 形态。OTA 消息和 NFC 令牌，属性编号不是一套。用错形态，规范写得再对，手机也只给你弹个"选应用"。
