FROM docker.cmg.int/cmg/node-base

EXPOSE 3000

# Configure manifests and modules
ADD puppet/site.pp /etc/puppet/manifests/

# Add Puppetfile
ADD puppet/Puppetfile /etc/puppet/

# Configure hiera
ADD puppet/hiera/hiera.yaml /etc/puppet/

ADD puppet/hiera/common.json /etc/puppet/hieradata/

# Run r10k
RUN PUPPETFILE=/etc/puppet/Puppetfile PUPPETFILE_DIR=/etc/puppet/modules/ r10k puppetfile install --verbose debug2 --color

# Run Puppet apply
RUN puppet apply --modulepath=/etc/puppet/modules/ --hiera_config /etc/puppet/hiera.yaml

WORKDIR /var/node/helloworld

RUN npm install
RUN chown -R nodejs:nodejs /var/node/helloworld

ENV NODE_ENV production

CMD ["/var/node/helloworld/bin/www"]
