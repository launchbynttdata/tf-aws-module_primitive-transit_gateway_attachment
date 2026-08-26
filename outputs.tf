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

output "id" {
  description = "ID of the transit gateway VPC attachment."
  value       = aws_ec2_transit_gateway_vpc_attachment.attachment.id
}

output "vpc_owner_id" {
  description = "ID of the AWS account that owns the VPC."
  value       = aws_ec2_transit_gateway_vpc_attachment.attachment.vpc_owner_id
}

output "vpc_id" {
  description = "ID of the attached VPC."
  value       = aws_ec2_transit_gateway_vpc_attachment.attachment.vpc_id
}

output "transit_gateway_id" {
  description = "ID of the EC2 Transit Gateway."
  value       = aws_ec2_transit_gateway_vpc_attachment.attachment.transit_gateway_id
}

output "subnet_ids" {
  description = "IDs of the subnets used by the attachment."
  value       = aws_ec2_transit_gateway_vpc_attachment.attachment.subnet_ids
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider."
  value       = aws_ec2_transit_gateway_vpc_attachment.attachment.tags_all
}
