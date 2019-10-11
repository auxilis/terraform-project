output "sg_bastion" {
  value = aws_security_group.aws_security_group_bastion.id
}

output "sg_lb" {
  value = aws_security_group.aws_security_group_lb.id
}

output "sg_priv" {
  value = aws_security_group.aws_security_group_prv.id
}

output "key_id" {
  value = aws_key_pair.key_pair.id
}
