# Home Assistant Supervised in Docker

> 通过Docker安装[Home Assistant Supervised](https://github.com/home-assistant/supervised-installer) (HassIO)，并对国内网络环境进行优化

| 　　　 | HAOS | Supervised | Container | Core |
|:-----:|:----:|:----------:|:---------:|:----:|
| 自动化 |  ✅  |     ✅     |     ✅    |  ✅  |
| 仪表盘 |  ✅  |     ✅     |     ✅    |  ✅  |
| 集　成 |  ✅  |     ✅     |     ✅    |  ✅  |
| 加载项 |  ✅  |     ✅     |     ❌    |  ❌  |
| 升　级 |  ✅  |     ✅     |     ❌    |  ❌  |
| 备　份 |  ✅  |     ✅     |     ✅    |  ✅  |


### Compose 安装

```bash
HASSIO=/usr/share/hassio
mkdir -p $HASSIO
cd $HASSIO
wget https://ghrp2.hacs.vip/raw/hasscc/hass-super/main/compose.yml
docker compose up -d
```

> `/usr/share/hassio`用于存储HassIO数据，包括HA配置及Add-ons配置等，可更改为其他路径
> 
> `docker_lib`用于存储HassIO容器及镜像等数据，会占用较大的空间
> 
> 仅当`DEFAULT_TZ=Asia/Shanghai`时才会对国内网络环境进行优化


### 命令安装

```bash
# 新建用于存储容器及镜像等数据的卷
docker volume create hass_super_docker

# 运行容器
docker run -d \
  --name hass-super \
  -v /usr/share/hassio:/usr/share/hassio \
  -v /run/dbus:/run/dbus:ro \
  -v hass_super_docker:/var/lib/docker \
  -e DEFAULT_TZ=Asia/Shanghai \
  --device /dev/net/tun \
  --restart unless-stopped \
  --network host \
  --hostname hassio \
  --privileged \
  ghcr.nju.edu.cn/hasscc/hass-super
```

> 首次安装时，需要较长时间安装环境及拉取镜像，请耐心等待
> 
> 通过`http://192.168.xx.xx:4357`可以查看系统状态
> 
> 通过`http://192.168.xx.xx:8123`进入Home Assistant


### 问题排查

> 如果提示无网络连接`no host internet connection`，请尝试在[网络配置](https://my.home-assistant.io/redirect/network/)中禁用IPv6
> 
> 如果安装后超过10分钟仍然无法进入Home Assistant，请尝试执行以下命令查看日志

```bash
docker exec -it hass-super tail -f /tmp/hassio.log -n 500
docker exec -it hass-super journalctl -f -u docker -n 100
docker exec -it hass-super journalctl -f -u hassio-supervisor -n 200
docker exec -it hass-super docker logs -f hassio_supervisor
docker exec -it hass-super ha core info
docker exec -it hass-super ha core start
```


### 鸣谢
- [NJU Mirror](https://doc.nju.edu.cn/books/e1654/page/ghcr)
