# provider configuration
provider "aws" {
  region = "us-east-1"   # change to your preferred region
}

# create a key pair (optional if you already have one)
resource "aws_key_pair" "example" {
  key_name   = "example-key"
  public_key = file("~/.ssh/id_rsa.pub")   # path to your public key
}

# security group to allow SSH
resource "aws_security_group" "example" {
  name        = "example-sg"
  description = "Allow SSH inbound traffic"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 instance
resource "aws_instance" "example" {
  ami           = "ami-0c02fb55956c7d316"   # Amazon Linux 2 AMI (update per region)
  instance_type = "t2.micro"                # free-tier eligible
  key_name      = aws_key_pair.example.key_name
  security_groups = [aws_security_group.example.name]

  tags = {
    Name = "Terraform-EC2-Instance"
  }
}
