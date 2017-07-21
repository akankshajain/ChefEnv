echo "Installing Chef Server"

user="$2"
password="$4"
email="$6"
org="$8"

apt-get update
wget https://packages.chef.io/files/stable/chef-server/12.15.7/ubuntu/14.04/chef-server-core_12.15.7-1_amd64.deb
dpkg -i chef-server-core_12.15.7-1_amd64.deb
/bin/dd if=/dev/zero of=/var/swap.1 bs=1M count=1024
/sbin/mkswap /var/swap.1
chmod 600 /var/swap.1
/sbin/swapon /var/swap.1
chef-server-ctl reconfigure
chef-server-ctl user-create ${user} ${user} User  ${email} '${password}' --filename /tmp/${user}.pem
chef-server-ctl org-create  ${org} '${org} Inc' --association_user ${user} --filename ${org}.pem
chef-server-ctl install chef-manage
chef-server-ctl reconfigure
chef-manage-ctl reconfigure --accept-license
chef-server-ctl install opscode-push-jobs-server
chef-server-ctl reconfigure
opscode-push-jobs-server-ctl reconfigure
chef-server-ctl install opscode-reporting
chef-server-ctl reconfigure
opscode-reporting-ctl reconfigure --accept-license