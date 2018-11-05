resource "aws_db_subnet_group" "db" {
  name       = "db-subnet-group-${var.env}"
  subnet_ids = ["${aws_subnet.public.id}", "${aws_subnet.private.id}"]

  tags {
    Name = "db-subnet-group-${var.env}"
    env  = "${var.env}"
  }
}

resource "aws_db_instance" "db" {
  identifier = "db-${var.env}"

  engine                     = "mysql"
  engine_version             = "5.7"
  auto_minor_version_upgrade = true

  instance_class    = "db.t2.small"
  storage_type      = "standard"
  allocated_storage = 20

  name     = "db-${var.env}"
  username = "admin"
  password = "xxx-dummy-password-xxx"

  multi_az               = false
  availability_zone      = "${local.public_az}"
  db_subnet_group_name   = "${aws_db_subnet_group.db.id}"
  vpc_security_group_ids = ["${aws_security_group.db.id}"]

  backup_retention_period   = 7
  final_snapshot_identifier = "db-final-snapshot-${var.env}-${uuid()}"

  # Immediately after provisioning the database, replace the dummy password
  # above with a real master password, to avoid storing the password in the
  # resulting tfstate.
  #
  # Inpsired by https://tosbourn.com/hiding-secrets-terraform/
  provisioner "local-exec" {
    command = "aws rds modify-db-instance --db-instance-identifier ${self.id} --master-user-password ${var.db_master_password} --apply-immediately"
  }
}
