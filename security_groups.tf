locals {
  allowed_sgs_str   = "${join(",", var.allowed_security_groups)}"
  allowed_sgs       = "${split(",", local.allowed_sgs_str)}"
  allowed_sgs_count = "${length(local.allowed_sgs)}"
}


resource "aws_security_group" "redis_security_group" {
  count       = "${length(var.custom_redis_sg) > 0 ? 0 : 1}"
  name        = "${format("%.255s", "tf-sg-ec-${var.name}-${var.env}-${data.aws_vpc.vpc.tags["Name"]}")}"
  description = "Terraform-managed ElastiCache security group for ${var.name}-${var.env}-${data.aws_vpc.vpc.tags["Name"]}"
  vpc_id      = "${data.aws_vpc.vpc.id}"

  tags {
    Name = "tf-sg-ec-${var.name}-${var.env}-${data.aws_vpc.vpc.tags["Name"]}"
  }
}

resource "aws_security_group_rule" "redis_ingress" {
  count                    = "${local.allowed_sgs_count}"
  # count                    = 2
  type                     = "ingress"
  from_port                = "${var.redis_port}"
  to_port                  = "${var.redis_port}"
  protocol                 = "tcp"
  source_security_group_id = "${local.allowed_sgs[count.index]}"
  # security_group_id        = "${aws_security_group.redis_security_group.*.id[0]}"
  # security_group_id        = "${coalesce((join(aws_security_group.redis_security_group.*.id)),"")}"
  security_group_id        = "${join("",(coalescelist(local.which_sg_to_use[local.sg_var], list(""))))}"
  depends_on               = ["aws_security_group.redis_security_group"]
}

resource "aws_security_group_rule" "redis_networks_ingress" {
  type              = "ingress"
  from_port         = "${var.redis_port}"
  to_port           = "${var.redis_port}"
  protocol          = "tcp"
  cidr_blocks       = ["${var.allowed_cidr}"]
  # security_group_id = "${aws_security_group.redis_security_group.*.id[0]}"
  security_group_id = "${join("",(coalescelist(local.which_sg_to_use[local.sg_var], list(""))))}"
  depends_on        = ["aws_security_group.redis_security_group"]
}
