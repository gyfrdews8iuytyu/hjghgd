  #!/usr/bin/env bash

  # 下载并运行 Argo
  [ ! -e cloudflared ] && wget -O cloudflared https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 && chmod +x cloudflared
  if [[ -e cloudflared && ! $(ps -ef) =~ cloudflared ]]; then
    ./cloudflared tunnel --url http://localhost:8080 --no-autoupdate > argo.log 2>&1 &
    sleep 15
    ARGO=$(cat argo.log | grep -oE "https://.*[a-z]+cloudflare.com" | sed "s#https://##")
    VMESS="{ \"v\": \"2\", \"ps\": \"Argo-Vmess\", \"add\": \"www.digitalocean.com\", \"port\": \"443\", \"id\": \"de04add9-5c68-8bab-950c-08cd5320df18\", \"aid\": \"0\", \"scy\": \"none\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"${ARGO}\", \"path\": \"/argo-vmess\", \"tls\": \"tls\", \"sni\": \"${ARGO}\", \"alpn\": \"\" }"

  cat > list << EOF
*******************************************
V2-rayN:
----------------------------
vless://de04add9-5c68-8bab-950c-08cd5320df18@www.digitalocean.com:443?encryption=none&security=tls&sni=${ARGO}&type=ws&host=${ARGO}&path=%2Fargo-vless#Argo-Vless
----------------------------
vmess://$(echo $VMESS | base64 -w0)
----------------------------
trojan://de04add9-5c68-8bab-950c-08cd5320df18@www.digitalocean.com:443?security=tls&sni=${ARGO}&type=ws&host=${ARGO}&path=%2Fargo-trojan#Argo-Trojan
----------------------------
ss://Y2hhY2hhMjAtaWV0Zi1wb2x5MTMwNTpkZTA0YWRkOS01YzY4LThiYWItOTUwYy0wOGNkNTMyMGRmMThAd3d3LmRpZ2l0YWxvY2Vhbi5jb206NDQzCg==@www.digitalocean.com:443#Argo-Shadowsocks
由于该软件导出的链接不全，请自行处理如下: 传输协议: WS ， 伪装域名: ${ARGO} ，路径: /argo-shadowsocks ， 传输层安全: tls ， sni: ${ARGO}
*******************************************
小火箭:
----------------------------
vless://de04add9-5c68-8bab-950c-08cd5320df18@www.digitalocean.com:443?encryption=none&security=tls&type=ws&host=${ARGO}&path=/argo-vless&sni=${ARGO}#Argo-Vless
----------------------------
vmess://bm9uZTpkZTA0YWRkOS01YzY4LThiYWItOTUwYy0wOGNkNTMyMGRmMThAd3d3LmRpZ2l0YWxvY2Vhbi5jb206NDQzCg==?remarks=Argo-Vmess&obfsParam=${ARGO}&path=/argo-vmess&obfs=websocket&tls=1&peer=${ARGO}&alterId=0
----------------------------
trojan://de04add9-5c68-8bab-950c-08cd5320df18@www.digitalocean.com:443?peer=${ARGO}&plugin=obfs-local;obfs=websocket;obfs-host=${ARGO};obfs-uri=/argo-trojan#Argo-Trojan
----------------------------
ss://Y2hhY2hhMjAtaWV0Zi1wb2x5MTMwNTpkZTA0YWRkOS01YzY4LThiYWItOTUwYy0wOGNkNTMyMGRmMThAd3d3LmRpZ2l0YWxvY2Vhbi5jb206NDQzCg==?obfs=wss&obfsParam=${ARGO}&path=/argo-shadowsocks#Argo-Shadowsocks
*******************************************
Clash:
----------------------------
- {name: Argo-Vless, type: vless, server: www.digitalocean.com, port: 443, uuid: de04add9-5c68-8bab-950c-08cd5320df18, tls: true, servername: ${ARGO}, skip-cert-verify: false, network: ws, ws-opts: {path: /argo-vless, headers: { Host: ${ARGO}}}, udp: true}
----------------------------
- {name: Argo-Vmess, type: vmess, server: www.digitalocean.com, port: 443, uuid: de04add9-5c68-8bab-950c-08cd5320df18, alterId: 0, cipher: none, tls: true, skip-cert-verify: true, network: ws, ws-opts: {path: /argo-vmess, headers: {Host: ${ARGO}}}, udp: true}
----------------------------
- {name: Argo-Trojan, type: trojan, server: www.digitalocean.com, port: 443, password: de04add9-5c68-8bab-950c-08cd5320df18, udp: true, tls: true, sni: ${ARGO}, skip-cert-verify: false, network: ws, ws-opts: { path: /argo-trojan, headers: { Host: ${ARGO} } } }
----------------------------
- {name: Argo-Shadowsocks, type: ss, server: www.digitalocean.com, port: 443, cipher: chacha20-ietf-poly1305, password: de04add9-5c68-8bab-950c-08cd5320df18, plugin: v2ray-plugin, plugin-opts: { mode: websocket, host: ${ARGO}, path: /argo-shadowsocks, tls: true, skip-cert-verify: false, mux: false } }
*******************************************
EOF
  cat list
  fi
