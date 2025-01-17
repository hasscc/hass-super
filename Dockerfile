FROM debian:bookworm

ENV container=docker \
    DEBIAN_FRONTEND=noninteractive

COPY build /tmp/build
RUN run-parts --report --exit-on-error /tmp/build/scripts && rm -rfv /tmp/build

EXPOSE 22
VOLUME ["/usr/share/hassio", "/var/lib/docker"]
WORKDIR /root

ENTRYPOINT ["/opt/init-wrapper/sbin/entrypoint.sh"]
CMD ["/sbin/init"]
