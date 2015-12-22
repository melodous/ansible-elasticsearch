#FROM mrlesmithjr/ansible:ubuntu-12.04
FROM mrlesmithjr/ansible

MAINTAINER mrlesmithjr@gmail.com

#Installs git
RUN apt-get update && apt-get install -y \
  git \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#Create Ansible Folder
RUN mkdir -p /opt/ansible-playbooks/roles

#Clone GitHub Repo
RUN git clone https://github.com/mrlesmithjr/ansible-elasticsearch.git /opt/ansible-playbooks/roles/ansible-elasticsearch && \
  cd /opt/ansible-playbooks/roles/ansible-elasticsearch && \
  git checkout 2.1

#Copy Ansible playbooks
COPY playbook.yml /opt/ansible-playbooks/

#Run Ansible playbook to install elasticsearch
RUN ansible-playbook -i "localhost," -c local /opt/ansible-playbooks/playbook.yml

#Clean up APT
RUN apt-get clean

# Mountable data directories.
VOLUME ["/var/lib/elasticsearch", "/var/log/elasticsearch"]

#Expose ports
EXPOSE 9200
EXPOSE 9300
EXPOSE 54328/udp

CMD ["gosu", "elasticsearch:elasticsearch", "/usr/share/elasticsearch/bin/elasticsearch", "--default.config" ,"/etc/elasticsearch/elasticsearch.yml"]
