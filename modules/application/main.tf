data "aws_ami" "server_ami" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-hvm*-x86_64-gp2"]
  }
}


resource "aws_lb" "project_lb" {
  name     = "project-lb"
  internal = false

  subnets            = "${var.public_subnets}"
  security_groups    = "${var.lb_sg}"
  load_balancer_type = "application"


  enable_cross_zone_load_balancing = true
  idle_timeout              = 400

  tags = {
    Name = "${var.name_of_deploy}-lb"
  }
}

resource "aws_lb_target_group" "project_lb_tg" {
  name     = "projecttg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"
}

resource "aws_lb_listener" "project_lb_listener" {
  load_balancer_arn = "${aws_lb.project_lb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.project_lb_tg.arn}"
  }
}

resource "aws_instance" "project_bastion_instance" {

  count         = "${var.instance_count}"
  instance_type = "${var.instance_type}"
  ami           = "${data.aws_ami.server_ami.id}"

  tags = {
    Name = "bastion_server-${count.index + 1}"
  }

  key_name               = "${var.key_id}"
  vpc_security_group_ids = "${var.sg_bastion}"
  subnet_id              = "${var.public_subnets[count.index]}"
  user_data              = <<EOF
#!/bin/bash
echo "Bastion" > bastion
EOF

}

resource "aws_network_interface" "project_ani_bastion" {
  count     = "${var.instance_count}"
  subnet_id = "${var.private_subnets[count.index]}"

  security_groups = "${var.sg_prv}"

  attachment {
    instance     = "${aws_instance.project_bastion_instance.*.id[count.index]}"
    device_index = 1
  }
}

resource "aws_launch_configuration" "project_lc" {
  name_prefix     = "project_lc-"
  image_id        = "${data.aws_ami.server_ami.id}"
  instance_type   = "${var.instance_type}"
  security_groups = "${var.sg_prv}"
  key_name        = "${var.key_id}"
  user_data       = <<EOF
#!/bin/bash
yum -y install httpd
service httpd start
chkconfig httpd on
EOF
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "project_asg" {
  name                      = "asg-${aws_launch_configuration.project_lc.id}"
  max_size                  = "${var.asg_max}"
  min_size                  = "${var.asg_min}"
  health_check_grace_period = "${var.asg_grace}"
  health_check_type         = "${var.asg_hct}"
  desired_capacity          = "${var.asg_cap}"
  force_delete              = true
  target_group_arns         = ["${aws_lb_target_group.project_lb_tg.arn}"]

  vpc_zone_identifier = "${var.private_subnets}"

  launch_configuration = "${aws_launch_configuration.project_lc.name}"

  tag {
    key                 = "Name"
    value               = "${var.name_of_deploy}-instance"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}
