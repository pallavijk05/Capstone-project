terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

resource "aws_key_pair" "example" {
  key_name   = "key02"
  public_key = file("~/.ssh/id_ed25519.pub")
}

resource "aws_instance" "application_server" {
  ami           = "ami-0522ab6e1ddcc7055"
  instance_type = var.instance_type
  key_name      = "key02"

  tags = {
    Name = "application_server"
  }

  provisioner "remote-exec" {
    inline = [
      "cat /etc/os-release",
      "mkdir -p /home/ubuntu/.ssh",
      "echo '${var.ssh_public_key}' >> /home/ubuntu/.ssh/authorized_keys",
      "chmod 600 /home/ubuntu/.ssh/authorized_keys",
      "chown -R ubuntu:ubuntu /home/ubuntu/.ssh"
    ]
  }

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file(var.ssh_private_key)
  }

  provisioner "local-exec" {
    command = "echo '${self.public_ip} ansible_user=ubuntu ansible_private_key_file=~/.ssh/id_ed25519' > inventory.ini"
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i inventory.ini -e 'ansible_python_interpreter=/usr/bin/python3' ansible-playbook.yml"
    environment = {
      ANSIBLE_CONFIG = "ansible.cfg"
    }
  }
}

resource "aws_instance" "testing_server" {
  ami           = "ami-0522ab6e1ddcc7055"
  instance_type = var.instance_type
  key_name      = "key02"

  tags = {
    Name = "testing_server"
  }

  provisioner "remote-exec" {
    inline = [
      "cat /etc/os-release",
      "mkdir -p /home/ubuntu/.ssh",
      "echo '${var.ssh_public_key}' >> /home/ubuntu/.ssh/authorized_keys",
      "chmod 600 /home/ubuntu/.ssh/authorized_keys",
      "chown -R ubuntu:ubuntu /home/ubuntu/.ssh"
    ]
  }

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file(var.ssh_private_key)
  }

  provisioner "local-exec" {
    command = "echo '${self.public_ip} ansible_user=ubuntu ansible_private_key_file=~/.ssh/id_ed25519' > inventory.ini"
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i inventory.ini -e 'ansible_python_interpreter=/usr/bin/python3' ansible-playbook.yml"
    environment = {
      ANSIBLE_CONFIG = "ansible.cfg"
    }
  }
}

resource "aws_instance" "prometheus_server" {
  ami           = "ami-0522ab6e1ddcc7055"
  instance_type = var.instance_type
  key_name      = "key02"

  tags = {
    Name = "prometheus_server"
  }

  provisioner "remote-exec" {
    inline = [
      "cat /etc/os-release",
      "mkdir -p /home/ubuntu/.ssh",
      "echo '${var.ssh_public_key}' >> /home/ubuntu/.ssh/authorized_keys",
      "chmod 600 /home/ubuntu/.ssh/authorized_keys",
      "chown -R ubuntu:ubuntu /home/ubuntu/.ssh"
    ]
  }

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file(var.ssh_private_key)
  }

  provisioner "local-exec" {
    command = "echo '${self.public_ip} ansible_user=ubuntu ansible_private_key_file=~/.ssh/id_ed25519' > inventory.ini"
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i inventory.ini -e 'ansible_python_interpreter=/usr/bin/python3' ansible-playbook.yml"
    environment = {
      ANSIBLE_CONFIG = "ansible.cfg"
    }
  }
}

output "application_server_ip" {
  value = aws_instance.application_server.public_ip
}

output "testing_server_ip" {
  value = aws_instance.testing_server.public_ip
}

output "prometheus_server_ip" {
  value = aws_instance.prometheus_server.public_ip
}
