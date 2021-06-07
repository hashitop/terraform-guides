# https://github.com/hashicorp/terraform/pull/28446

locals {
  sensitive_parts = tomap({
    boop = "hello"
    beep = sensitive("goodbye")
  })
}

resource "null_resource" "example" {
  for_each = local.sensitive_parts
}