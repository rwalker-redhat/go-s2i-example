FROM registry.access.redhat.com/ubi8

LABEL maintainer="Richard Walker <rwalker@redhat.com>"

ENV BUILDER_VERSION 1.0
ENV PATH=$PATH:/usr/local/go/bin
ENV GOCACHE=/opt/app-root
ENV GOMODCACHE=/opt/app-root

LABEL io.k8s.description="Platform for building go 1.18" \
      io.k8s.display-name="builder 1.0.0" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,1.0.0,go-1.18"

# Install Go 1.18.1
RUN dnf install wget git -y
RUN wget https://go.dev/dl/go1.18.1.linux-amd64.tar.gz
RUN tar -C /usr/local -xzf go1.18.1.linux-amd64.tar.gz
RUN export PATH=$PATH:/usr/local/go/bin
RUN rm -f ./go1.18.1.linux-amd64.tar.gz

# Copy s2i scripts
COPY ./s2i/bin/ /usr/libexec/s2i
RUN mkdir /opt/app-root

RUN chown -R 1001:1001 /opt/app-root

# This default user is created in the openshift/base-centos7 image
USER 1001

# Set the default port for applications built using this image
EXPOSE 8080

# Set the default CMD for the image
CMD ["/usr/libexec/s2i/usage"]

