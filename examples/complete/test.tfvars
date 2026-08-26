logical_product_family  = "lp"
logical_product_service = "lps"
class_env               = "dev"
instance_env            = 0
instance_resource       = 0

resource_names_map = {
  vpc = {
    name       = "vpc"
    max_length = 32
  }
  subnet = {
    name       = "subnet"
    max_length = 32
  }
}

vpc_cidr_block    = "10.80.0.0/16"
subnet_cidr_block = "10.80.1.0/24"

tags = {
  Environment = "test"
  Terraform   = "true"
}
