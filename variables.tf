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

variable "subnet_ids" {
  description = "IDs of one or more subnets to place the attachment in. Specify one subnet per Availability Zone used by the attachment."
  type        = list(string)

  validation {
    condition     = length(var.subnet_ids) >= 1
    error_message = "At least one subnet ID must be provided."
  }
}

variable "transit_gateway_id" {
  description = "ID of the EC2 Transit Gateway."
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC to attach to the transit gateway."
  type        = string
}

variable "appliance_mode_support" {
  description = "Whether appliance mode support is enabled. Valid values are enable and disable."
  type        = string
  default     = "disable"

  validation {
    condition     = contains(["enable", "disable"], var.appliance_mode_support)
    error_message = "Appliance mode support must be enable or disable."
  }
}

variable "dns_support" {
  description = "Whether DNS support is enabled. Valid values are enable and disable."
  type        = string
  default     = "enable"

  validation {
    condition     = contains(["enable", "disable"], var.dns_support)
    error_message = "DNS support must be enable or disable."
  }
}

variable "ipv6_support" {
  description = "Whether IPv6 support is enabled. Valid values are enable and disable."
  type        = string
  default     = "disable"

  validation {
    condition     = contains(["enable", "disable"], var.ipv6_support)
    error_message = "IPv6 support must be enable or disable."
  }
}

variable "security_group_referencing_support" {
  description = "Whether security group referencing support is enabled. Valid values are enable and disable."
  type        = string
  default     = "disable"

  validation {
    condition     = contains(["enable", "disable"], var.security_group_referencing_support)
    error_message = "Security group referencing support must be enable or disable."
  }
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
  description = "Map of tags to assign to the transit gateway VPC attachment."
  type        = map(string)
  default     = {}
}
