FROM busybox

CMD []
ENTRYPOINT ["/bin/nomad"]

ADD nomad /bin/
