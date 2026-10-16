+++
date = '2026-10-15T18:00:00+08:00'
lastmod = '2026-10-15T18:00:00+08:00'
draft = false
title = 'Writing WiFi to an NFC Tag: the So-Called Non-Standard Layout Was the WFA Standard'
description = 'Writing a tap-to-connect WiFi NFC tag: the so-called non-standard bytes are the WFA WSC Configuration Token. OTA messages and NFC tokens use different attribute ID sets.'
tags = ['NFC', 'Flutter', 'WiFi', 'WSC', 'Android']
categories = ['Engineering']
author = 'Diogo Ferro'
+++

I built a Flutter plugin to write NFC tags. The goal was simple: tap a tag and join WiFi.

I assembled a record of type `application/vnd.wfa.wsc` following the WSC spec. On HyperOS, the phone only showed the "open with" picker. It never connected. On the same phone, a tag written by NFC Tools connected instantly.

So which was wrong: the spec, or my bytes?

## 1. Evidence first: read both tags and diff them

Guessing gets you nowhere. I read both tags back and dumped their payloads as hex, byte by byte.

Mine (the failure) was an OTA-shaped WSC message. The working one was written by NFC Tools.

Here are the two decoded attribute trees. Left fails, right works:

```
10 4a 00 04  VendorExtension (0x104A) -> 00 50 f2 04 (WFA OUI)
10 12 00 02  Version2        (0x1012) -> 20 01
10 26 00 26  Credential      (0x1026)  len=38:
  └ 10 0e 00 0a  SSID        (0x100E) = "ZTE-dtTtGY"
  └ 10 0f 00 08  NetworkKey  (0x100F) = "f3hsp7jd"
  └ 10 03 00 02  AuthType    (0x1003) = 0x0020
  └ 10 04 00 02  EncType     (0x1004) = 0x0008

10 0e 00 35  (top container 0x100E)          len=53:
  └ 10 26 00 01  Credential (0x1026)  len=1, value 0x01
  └ 10 45 00 0a  SSID        (0x1045) = "ZTE-dtTtGY"
  └ 10 03 00 02  AuthType    (0x1003) = 0x0022
  └ 10 0f 00 02  EncryptionType (0x100F) = 0x000c
  └ 10 27 00 08  NetworkKey  (0x1027) = "f3hsp7jd"
  └ 10 20 00 06  MAC         (0x1020) = ff:ff:ff:ff:ff:ff
```

The difference is obvious. The working tag starts with a `0x100E` container that wraps a Credential marker and scoped IDs. Mine started with a VendorExtension and a Version2.

## 2. The "non-standard" layout was a WFA standard

I first assumed NFC Tools used some vendor-private format. It does not.

The MIME type `application/vnd.wfa.wsc` is a media type registered by the Wi-Fi Alliance (WFA). It belongs to the WFA "Wi-Fi Simple Configuration" spec, better known as WPS. NFC is just an out-of-band way to hand over credentials: write them to a tag, tap to connect.

The third-party library ndeflib/nfcpy builds this record through `WifiSimpleConfigRecord`. When it prints a Credential, the attribute IDs it emits are:

`0x1003 0x100F 0x1020 0x1026 0x1027 0x1045`

Those numbers match NFC Tools, and they match the tag that actually connects. So this is not a Xiaomi-private protocol. It is the standard WFA usage.

## 3. WSC has two carrier forms with different ID sets

The catch: WSC has two usages, and their attribute IDs are not the same set.

One is the OTA WSC message. It is what WPS push-button and device registration use. Its SSID uses the root-level ID `0x100E`, the key uses `0x100F`, and the encryption type uses `0x1004`.

The other is the NFC Configuration Token. It wraps the credential in a Credential and switches to "scoped" IDs: SSID becomes `0x1045`, the key becomes `0x1027`, and the encryption type becomes `0x100F`.

Watch the key ID: `0x100F` in OTA, `0x1027` in the token. Same field, two numbers.

| Field | OTA / WPS message | NFC Configuration Token |
|---|---|---|
| SSID | 0x100E (root) | 0x1045 (scoped) |
| Key | 0x100F (root) | 0x1027 (scoped) |
| Encryption type | 0x1004 (root) | 0x100F (scoped) |
| Top level | VendorExtension + Version2 | single 0x100E container |
| VendorExtension | present | absent |

## 4. The real trap: attribute IDs are scoped

WSC attribute numbers are not globally unique. The same number means different things in different containers.

`0x100E` is SSID at the root, but the top-level container in the token.
`0x100F` is the key at the root, but the encryption type inside a Credential.

So the parser must know whether it is at the message root or inside a Credential before it can read `0x100F` correctly.

My first attempt failed exactly here. I built the OTA shape with root IDs `0x100E`/`0x100F`/`0x1004` plus a VendorExtension. But Android's `WpsNfcConfigTokenParser` is hard-coded for the token shape: it wants a `0x100E` container on top, a `0x1026` marker inside, then `0x1045`/`0x1027`/`0x100F`. Mismatch, and it falls back to the "open with" picker.

## 5. The fix: replicate the working tag

Since the device only accepts the token shape, the direct path is to replicate the bytes NFC Tools writes.

A top-level `0x100E` container wraps this:

- Credential marker: `0x1026`, length 1, value `0x01`
- SSID: `0x1045`, your SSID
- AuthType: `0x1003`, value `0x0022`
- Encryption type: `0x100F`, value `0x000c`
- Key: `0x1027`, your password
- MAC: `0x1020`, value `ff:ff:ff:ff:ff:ff`

Note that `0x100F` here is the encryption type, not the key. I first misread it as a "mystery fixed field" precisely because I missed the scoping.

I verified with Python: for the same SSID and password, my generated bytes match the captured tag byte for byte. On a real phone, a tap launches the WiFi connection.

(The SSID and password above are from a captured test tag, not my own network.)

## 6. Corrections on what I left open

A technical post should say what is still open. I listed three points here, then read ndeflib's source and found two were my own gaps, not missing spec text. Corrections below.

The spec PDF itself: WFA's Wi-Fi Simple Configuration spec PDF is not free to download. It sits behind the Wi-Fi Alliance member portal (wi-fi.org/discover-wi-fi/specifications), so non-members cannot get the original. I could not check line by line against that PDF. But "the spec is closed, so I only reverse-engineered bytes" is wrong. ndeflib maps every attribute ID to the spec, AOSP's parser agrees independently, and the NFC Tools bytes are a fourth source. This is four-way corroboration, with ndeflib as the public mirror of the spec.

AuthType and encryption type: I wrote "I did not decode each bit." That was wrong. ndeflib's bitmap gives each bit's meaning. AuthType `0x0022` is WPA-Personal (`0x0002`) OR-ed with WPA2-Personal (`0x0020`), i.e. mixed WPA/WPA2 personal. Encryption type `0x000c` is TKIP (`0x0004`) OR-ed with AES (`0x0008`), i.e. mixed TKIP/AES, the typical WPA2 set. Both are ordinary bitmaps, not mystery captured values.

The outer `0x100E`: the body's claim is right, that `0x100E` is SSID in the WSC root message but the Credential container in the token, same number, different scope. My draft said "I could not find the spec wording for this reuse." That was wrong; I can now. In ndeflib, the Credential class key is `0x100E`, and its docs say the Credential is a compound attribute holding other WSC TLVs. It is not a misappropriation. It is one number, scoped differently by the spec. I removed that wrong sentence.

## Closing

When you write a WiFi NFC tag, decide which WSC form you need first. The OTA message and the NFC token do not share one attribute numbering. Get the form wrong and, however correct your spec reading, the phone hands you an "open with" dialog.
