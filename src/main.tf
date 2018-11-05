provider "aws" {
  region  = "${var.aws_region}"
  version = "~> 1.33"
}

locals {
  public_az  = "${var.aws_region}a"
  private_az = "${var.aws_region}b"
}
