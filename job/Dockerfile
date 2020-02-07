FROM google/cloud-sdk:279.0.0

ARG ansible_version=2.9.4
ARG consul_version=1.6.3

RUN set -xe \
    && apt-get update \
    && apt-get install -y unzip \
    && pip3 install "ansible==${ansible_version}" \
    && curl -Lo /tmp/consul.zip "https://releases.hashicorp.com/consul/${consul_version}/consul_${consul_version}_linux_amd64.zip" \
    && unzip -d /usr/local/bin /tmp/consul.zip \
    && rm /tmp/consul.zip \
    && ansible --version \
    && consul version \
    && gsutil --version

WORKDIR /opt/consul_backup
COPY ./ ./

CMD ["ansible-playbook", "-i", "localhost," "--connection", "local", "site.yml"]
