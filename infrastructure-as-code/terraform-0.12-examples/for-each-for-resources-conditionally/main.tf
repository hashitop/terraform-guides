#https://www.terraform.io/docs/language/expressions/for.html
#https://www.terraform.io/docs/language/meta-arguments/for_each.html#referring-to-instances
#https://www.terraform.io/docs/language/meta-arguments/for_each.html#chaining-for_each-between-resources
#https://www.terraform.io/docs/language/expressions/splat.html#splat-expressions-with-maps

terraform {
  required_version = ">= 0.12.6"
}

provider "random" {
}

variable "sizes" {
  description = "pre-defined sizes"
  type = map
  default = {
    a = 2
    b = 4
    c = 6
    d = 8
    e = 10
    f = 12
  }
}

variable "selected_sizes" {
  description = "selected sizes"
  type = list
  default = ["a","c","e"]
}

variable "min_size" {
  description = "minimum size"
  type = number
  default = 4
}

resource "random_string" "random_by_min_size" {
  for_each = { for size in keys(var.sizes) : size => var.sizes[size] if var.sizes[size] > var.min_size }
  length = each.value 
}

resource "random_string" "random_by_selected_sizes" {
  for_each = { for size in keys(var.sizes) : size => var.sizes[size] if contains(var.selected_sizes, size) }
  length = each.value 
}

output "random_strings_by_min_size" {
  value = tomap({
    for k, v in random_string.random_by_min_size : k => v.result
  })
}

output "random_strings_by_min_size_value_only" {
  value = toset([
    for v in random_string.random_by_min_size : v.result
  ])
}

output "random_strings_by_selected_sizes" {
  value = tomap({
    for k, v in random_string.random_by_selected_sizes : k => v.result
  })
}

output "random_strings_by_selected_sizes_value_only" {
  value = toset([
    for v in random_string.random_by_selected_sizes : v.result
  ])
}
