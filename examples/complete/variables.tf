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

variable "logical_product_family" {
  description = "Logical product family for resource naming."
  type        = string
}

variable "logical_product_service" {
  description = "Logical product service for resource naming."
  type        = string
}

variable "class_env" {
  description = "Class environment for resource naming (for example, dev)."
  type        = string
}

variable "instance_env" {
  description = "Instance environment for resource naming."
  type        = number
}

variable "instance_resource" {
  description = "Instance resource for resource naming."
  type        = number
}

variable "resource_names_map" {
  description = "Map of resource types to naming configuration."
  type = map(object({
    name       = string
    max_length = number
  }))
}

variable "vpc_cidr_block" {
  description = "IPv4 CIDR block for the example VPC."
  type        = string
}

variable "subnet_cidr_block" {
  description = "IPv4 CIDR block for the example subnet."
  type        = string
}

variable "appliance_mode_support" {
  description = "Whether appliance mode support is enabled. Valid values are enable and disable."
  type        = string
  default     = "disable"
}

variable "dns_support" {
  description = "Whether DNS support is enabled. Valid values are enable and disable."
  type        = string
  default     = "enable"
}

variable "ipv6_support" {
  description = "Whether IPv6 support is enabled. Valid values are enable and disable."
  type        = string
  default     = "disable"
}

variable "security_group_referencing_support" {
  description = "Whether security group referencing support is enabled. Valid values are enable and disable."
  type        = string
  default     = "disable"
}

variable "transit_gateway_default_route_table_association" {
  description = "Whether the VPC attachment should be associated with the EC2 Transit Gateway association default route table."
  type        = bool
  default     = true
}

variable "transit_gateway_default_route_table_propagation" {
  description = "Whether the VPC attachment should propagate routes to the EC2 Transit Gateway propagation default route table."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Map of tags to assign to example resources."
  type        = map(string)
  default     = {}
}
