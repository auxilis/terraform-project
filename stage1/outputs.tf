output "sg_bastion" {
  value = module.security.sg_bastion
}

output "sg_lb" {
  value = module.security.sg_lb
}

output "sg_priv" {
  value = module.security.sg_priv
}

output "key_id" {
  value = module.security.key_id
}
