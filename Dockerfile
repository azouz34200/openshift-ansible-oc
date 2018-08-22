FROM centos:7

# Labels consumed by Red Hat build service
LABEL com.redhat.component="ansible-oc-container" \
      name="openshift3/ansible-oc-rhel7" \
      version="1.0" \
      architecture="x86_64" \
      io.k8s.display-name="Ansible with OC container" \
      io.k8s.description="ansible container with oc command" \
      io.openshift.tags="openshift,ansible,oc"

USER root
RUN yum-config-manager --disable epel >/dev/null
RUN yum install -y epel-release 
RUN INSTALL_PKGS="PyYAML python-jinja2 python-httplib2 python-keyczar python-paramiko python-setuptools git python2-pip ansible" && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
    yum clean all


#RUN mkdir /etc/ansible/
RUN echo -e '[local]\nlocalhost' > /etc/ansible/hosts
#RUN pip install ansible==2.6.3
# Copy the entrypoint
ADD contrib/bin/* /usr/local/bin/

ENV USER_UID=1001
USER ${USER_UID}

# Run the Jenkins JNLP client
ENTRYPOINT ["/usr/local/bin/entrypoint"]