// VMs
resource "digitalocean_droplet" "default" {
  count  = var.instances
  name   = "${var.name_prefix}${count.index + 1}"
  region = var.region

  image         = var.image
  size          = var.sku
  droplet_agent = true
  vpc_uuid      = var.vpc_id
  ssh_keys      = var.ssh_keys
  user_data     = data.cloudinit_config.boot-script.rendered
}

# Bruk cloud-init for å bootstrappe maskinen (https://cloudinit.readthedocs.io/)
#
# Her ber vi maskinen installere sikkerhetsoppdateringer på egen hånd, installere Docker og spinne
# opp et dummy image med port 8080 eksponert.
data "cloudinit_config" "boot-script" {
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/x-shellscript"
    content      = <<EOF
#!/bin/sh
apt-get update

echo unattended-upgrades unattended-upgrades/enable_auto_updates boolean true | debconf-set-selections
apt-get -y install unattended-upgrades update-notifier-common
echo 'Unattended-Upgrade::Automatic-Reboot "true";' >> /etc/apt/apt.conf.d/50unattended-upgrades

# Install docker
apt-get -y install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update
apt-get -y install docker-ce docker-ce-cli containerd.io

docker run -p8080:80 --hostname=$(hostname) -d nginxdemos/hello
EOF
  }
}
