# Configuramos el proveedor de AWS
provider "aws" {
  region = "us-east-1"
}

# Creamos un grupo de seguridad para el frontend
resource "aws_security_group" "sg_frontend" {
  name        = "sg_frontend"
  description = "Grupo de seguridad para la instancia de frontend2"

  # Reglas de entrada para permitir el tráfico SSH, HTTP y HTTPS
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Reglas de salida para permitir todas las conexiones salientes
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Creamos un grupo de seguridad para el servidor nfs.
resource "aws_security_group" "sg_nfs" {
  name        = "sg_nfs"
  description = "Grupo de seguridad para la instancia de nfs_server"

  # Reglas de entrada para permitir el tráfico SSH, HTTP y HTTPS
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Reglas de salida para permitir todas las conexiones salientes
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Creamos un grupo de seguridad para el balanceador de carga.
resource "aws_security_group" "sg_load_balancer" {
  name        = "sg_load_balancer"
  description = "Grupo de seguridad para la instancia de load_balancer"

  # Reglas de entrada para permitir el tráfico SSH, HTTP y HTTPS
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  } 

  # Reglas de salida para permitir todas las conexiones salientes
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Creamos una instancia EC2 para el frontend 2.
resource "aws_instance" "frontend_2" {
  ami           = "ami-0c7217cdde317cfec"
  instance_type = "t2.small"
  key_name      = "labsuser"
  security_groups = [aws_security_group.sg_frontend]
  tags = {
    Name = "frontend_2"
  }
}

# Creamos una instancia EC2 para el servidor nfs.
resource "aws_instance" "nfs_server" {
  ami           = "ami-0c7217cdde317cfec"
  instance_type = "t2.small"
  key_name      = "labsuser"
  tags = {
    Name = "nfs_server"
  }
}

# Creamos una instancia EC2 para el balanceador de carga.
resource "aws_instance" "load_balancer" {
  ami           = "ami-0c7217cdde317cfec"
  instance_type = "t2.small"
  key_name      = "labsuser"
  tags = {
    Name = "load_balancer"
  }
}