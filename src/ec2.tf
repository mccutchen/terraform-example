# =============================================================================
# ec2
# =============================================================================
resource "aws_key_pair" "default" {
  key_name   = "default"
  public_key = "${file("${var.key_path}")}"
}

resource "aws_ebs_volume" "web-volume" {
  depends_on = ["aws_instance.web"]

  availability_zone = "${local.public_az}"
  type              = "gp2"
  size              = 250
}

resource "aws_volume_attachment" "web-volume-attachment" {
  device_name = "/dev/xvdb"
  instance_id = "${aws_instance.web.id}"
  volume_id   = "${aws_ebs_volume.web-volume.id}"
}

resource "aws_instance" "web" {
  count = "${var.web_instance_count}"

  ami           = "${var.web_ami}"
  instance_type = "${var.web_instance_type}"

  subnet_id                   = "${aws_subnet.public.id}"
  availability_zone           = "${local.public_az}"
  vpc_security_group_ids      = ["${aws_security_group.web.id}"]
  associate_public_ip_address = true

  user_data = "${file("scripts/bootstrap-host.sh")}"

  key_name = "${aws_key_pair.default.id}"

  lifecycle = {
    create_before_destroy = true
    ignore_changes        = ["key_name", "user_data"]
  }

  provisioner "remote-exec" {
    when = "destroy"

    connection {
      type    = "ssh"
      user    = "ec2-user"
      timeout = "1m"
    }

    inline = "sudo umount /data"
  }

  tags {
    role = "web"
    env  = "${var.env}"
  }
}
