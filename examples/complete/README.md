# Complete Example

This example creates a VPC (Launch vpc primitive), a subnet, a transit gateway (Launch transit_gateway primitive), and a transit gateway VPC attachment.

## Usage

```hcl
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
  source = "git::https://github.com/launchbynttdata/tf-aws-module_primitive-transit_gateway.git?ref=1.0.0"

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
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.100 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_resource_names"></a> [resource\_names](#module\_resource\_names) | terraform.registry.launch.nttdata.com/module_library/resource_name/launch | ~> 2.0 |
| <a name="module_transit_gateway"></a> [transit\_gateway](#module\_transit\_gateway) | git::https://github.com/launchbynttdata/tf-aws-module_primitive-transit_gateway.git | 0.1.0 |
| <a name="module_transit_gateway_attachment"></a> [transit\_gateway\_attachment](#module\_transit\_gateway\_attachment) | ../.. | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform.registry.launch.nttdata.com/module_primitive/vpc/aws | ~> 1.0 |

## Resources

| Name | Type |
|------|------|
| [aws_default_security_group.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_security_group) | resource |
| [aws_subnet.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_appliance_mode_support"></a> [appliance\_mode\_support](#input\_appliance\_mode\_support) | Whether appliance mode support is enabled. Valid values are enable and disable. | `string` | `"disable"` | no |
| <a name="input_class_env"></a> [class\_env](#input\_class\_env) | Class environment for resource naming (for example, dev). | `string` | n/a | yes |
| <a name="input_dns_support"></a> [dns\_support](#input\_dns\_support) | Whether DNS support is enabled. Valid values are enable and disable. | `string` | `"enable"` | no |
| <a name="input_instance_env"></a> [instance\_env](#input\_instance\_env) | Instance environment for resource naming. | `number` | n/a | yes |
| <a name="input_instance_resource"></a> [instance\_resource](#input\_instance\_resource) | Instance resource for resource naming. | `number` | n/a | yes |
| <a name="input_ipv6_support"></a> [ipv6\_support](#input\_ipv6\_support) | Whether IPv6 support is enabled. Valid values are enable and disable. | `string` | `"disable"` | no |
| <a name="input_logical_product_family"></a> [logical\_product\_family](#input\_logical\_product\_family) | Logical product family for resource naming. | `string` | n/a | yes |
| <a name="input_logical_product_service"></a> [logical\_product\_service](#input\_logical\_product\_service) | Logical product service for resource naming. | `string` | n/a | yes |
| <a name="input_resource_names_map"></a> [resource\_names\_map](#input\_resource\_names\_map) | Map of resource types to naming configuration. | <pre>map(object({<br/>    name       = string<br/>    max_length = number<br/>  }))</pre> | n/a | yes |
| <a name="input_security_group_referencing_support"></a> [security\_group\_referencing\_support](#input\_security\_group\_referencing\_support) | Whether security group referencing support is enabled. Valid values are enable and disable. | `string` | `"disable"` | no |
| <a name="input_subnet_cidr_block"></a> [subnet\_cidr\_block](#input\_subnet\_cidr\_block) | IPv4 CIDR block for the example subnet. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of tags to assign to example resources. | `map(string)` | `{}` | no |
| <a name="input_transit_gateway_default_route_table_association"></a> [transit\_gateway\_default\_route\_table\_association](#input\_transit\_gateway\_default\_route\_table\_association) | Whether the VPC attachment should be associated with the EC2 Transit Gateway association default route table. | `bool` | `true` | no |
| <a name="input_transit_gateway_default_route_table_propagation"></a> [transit\_gateway\_default\_route\_table\_propagation](#input\_transit\_gateway\_default\_route\_table\_propagation) | Whether the VPC attachment should propagate routes to the EC2 Transit Gateway propagation default route table. | `bool` | `true` | no |
| <a name="input_vpc_cidr_block"></a> [vpc\_cidr\_block](#input\_vpc\_cidr\_block) | IPv4 CIDR block for the example VPC. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | ID of the transit gateway VPC attachment. |
| <a name="output_subnet_ids"></a> [subnet\_ids](#output\_subnet\_ids) | IDs of the subnets used by the attachment. |
| <a name="output_transit_gateway_id"></a> [transit\_gateway\_id](#output\_transit\_gateway\_id) | ID of the EC2 Transit Gateway. |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | ID of the attached VPC. |
| <a name="output_vpc_owner_id"></a> [vpc\_owner\_id](#output\_vpc\_owner\_id) | ID of the AWS account that owns the VPC. |
<!-- END_TF_DOCS -->
