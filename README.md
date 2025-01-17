# Home Assistant Supervised in Docker

> 通过Docker安装[Home Assistant Supervised](https://github.com/home-assistant/supervised-installer) (HassIO)，并对国内网络环境进行优化


### Compose 安装

```yaml
services:
  hass-super:
    container_name: hass-super
    image: ghcr.nju.edu.cn/hasscc/hass-super
    restart: unless-stopped
    volumes:
      - ./hassio:/usr/share/hassio
      - /run/dbus:/run/dbus:ro
      - docker_lib:/var/lib/docker
    environment:
      - DEFAULT_TZ=Asia/Shanghai
    devices:
      - /dev/net/tun
    privileged: true
    network_mode: host

volumes:
  docker_lib:
```

> `./hassio`用于存储HassIO数据，包括HA配置及Add-ons配置等
> 
> `docker_lib`用于存储HassIO容器及镜像等数据，会占用较大的空间
> 
> 仅当`DEFAULT_TZ=Asia/Shanghai`时才会对国内网络环境进行优化


### 命令安装

```bash
docker run -d \
  --name hass-super \
  -v /usr/share/hassio:/usr/share/hassio \
  -v /run/dbus:/run/dbus:ro \
  -e DEFAULT_TZ=Asia/Shanghai \
  --device /dev/net/tun \
  --network=host \
  --restart=unless-stopped \
  --privileged \
  ghcr.nju.edu.cn/hasscc/hass-super
```

> 首次安装时，需要较长时间安装环境及拉取镜像，请耐心等待
> 
> 通过`http://192.168.xx.xx:4357`可以查看系统状态
> 
> 通过`http://192.168.xx.xx:8123`进入Home Assistant


### 鸣谢
- [NJU Mirror](https://doc.nju.edu.cn/books/e1654/page/ghcr)
