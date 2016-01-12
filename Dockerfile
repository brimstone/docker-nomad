FROM scratch

CMD []
ENTRYPOINT ["/bin/nomad"]

ADD nomad /bin/
