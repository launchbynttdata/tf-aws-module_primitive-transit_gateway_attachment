// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

data "aws_region" "current" {}

module "resource_names" {
  source  = "terraform.registry.launch.nttdata.com/module_library/resource_name/launch"
  version = "~> 2.0"

  for_each = var.resource_names_map

  logical_product_family  = var.logical_product_family
  logical_product_service = var.logical_product_service
  class_env               = var.class_env
  instance_env            = var.instance_env
  instance_resource       = var.instance_resource
  cloud_resource_type     = each.value.name
  maximum_length          = each.value.max_length

  region                = join("", split("-", data.aws_region.current.name))
  use_azure_region_abbr = false
}


data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/vpc/aws"
  version = "~> 1.0"

  cidr_block = var.vpc_cidr_block

  tags = merge(var.tags, { Name = module.resource_names["vpc"].standard })
}

resource "aws_default_security_group" "default" {
  vpc_id = module.vpc.vpc_id
  tags   = merge(var.tags, { Name = "${module.resource_names["vpc"].standard}-default-sg" })
}

resource "aws_subnet" "this" {
  vpc_id            = module.vpc.vpc_id
  cidr_block        = var.subnet_cidr_block
  availability_zone = data.aws_availability_zones.available.names[0]
  tags              = merge(var.tags, { Name = module.resource_names["subnet"].standard })
}

module "transit_gateway" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/transit_gateway/aws"
  version = "~> 2.0"

  description = "Complete example transit gateway for VPC attachment."
  tags        = var.tags
}

module "transit_gateway_attachment" {
  source = "../.."

  subnet_ids         = [aws_subnet.this.id]
  transit_gateway_id = module.transit_gateway.ec2_transit_gateway_id
  vpc_id             = module.vpc.vpc_id

  appliance_mode_support             = var.appliance_mode_support
  dns_support                        = var.dns_support
  ipv6_support                       = var.ipv6_support
  security_group_referencing_support = var.security_group_referencing_support

  transit_gateway_default_route_table_association = var.transit_gateway_default_route_table_association
  transit_gateway_default_route_table_propagation = var.transit_gateway_default_route_table_propagation

  tags = var.tags
}
