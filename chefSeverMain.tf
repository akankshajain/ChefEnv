{
  "provider": {
    "ibmcloud": {
    }
  },
  
  "variable": {
    "hostname": {
            "description": "Hostname of the virtual instance (small flavor) to be deployed",
            "default": "ubuntu-small"
        },
	  "datacenter": {
      "description": "Softlayer datacenter where infrastructure resources will be deployed",
			"default": "dal09"
    },
    "public_ssh_key": {
      "description": "Public SSH key used to connect to the virtual guest"
    }
  },
  
  "resource": {
    "tls_private_key": {
      "ssh": {
        "algorithm": "RSA"
      }
    },
    "ibmcloud_infra_ssh_key": {
      "cam_public_key": {
        "label": "CAM Public Key",
        "public_key": "${var.public_ssh_key}"
      },
      "temp_public_key": {
        "label": "Temp Public Key",
        "public_key": "${tls_private_key.ssh.public_key_openssh}"
      }
    }
  },
  
	"module": {
    "install_chefServer_ibmcloud": {
      "source": "git::https://github.com/akankshajain/akajain.git?ref=master//chef/ibmcloud",
      "hostname": "chefServer",
      "datacenter": "${var.datacenter}",
      "user_public_key_id": "${ibmcloud_infra_ssh_key.cam_public_key.id}",
      "temp_public_key_id": "${ibmcloud_infra_ssh_key.temp_public_key.id}",
      "temp_public_key": "${tls_private_key.ssh.public_key_openssh}",  
      "temp_private_key": "${tls_private_key.ssh.private_key_pem}",
      "module_script": "scripts/install.sh",
      "os_reference_code": "UBUNTU_14_64",
      "domain": "cam.ibm.com",
      "cores": 1,
      "memory": 1024,
      "disk1": 100
    }
  },
	"output": {
    "You can access the chef manage console using the following url": {
      "value": "https://${module.install_chefServer_ibmcloud.public_ip}"
    }
  }
}