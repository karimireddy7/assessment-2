provider "google" {
  project = var.project_id
  region  = var.region
}

module "network" {
  source       = "./modules/network"
  region       = var.region
  vpc_name     = "private-vpc"
  subnet_cidr  = "10.10.0.0/24"
}

module "vm" {
  source    = "./modules/vm"
  region    = var.region
  subnet_id = module.network.subnet_id
}

module "lb" {
  source         = "./modules/lb"
  instance_group = module.vm.instance_group
}
