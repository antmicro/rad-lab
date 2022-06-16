/**
 * Copyright 2022 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

variable "billing_account_id" {
  description = "Billing Account ID that will be attached to the project."
  type        = string
}

variable "cloud_function_subnet" {
  description = "Subnet where the Cloud Function should be deployed."
  type = list(object({
    name               = string
    ip_cidr_range      = string
    region             = string
    secondary_ip_range = map(string)
  }))
  default = [{
    name               = "cf-disconnect-ba"
    ip_cidr_range      = "10.0.0.0/28"
    region             = "us-east1"
    secondary_ip_range = null
  }]
}

variable "create_folder" {
  description = "Whether or not to create the parent folder as well."
  type        = bool
  default     = false
}

variable "folder_name" {
  description = "Name of the folder that should be created.  Only set this value when 'create_folder' is set to true."
  type        = string
  default     = null
}

variable "function_identity_name" {
  description = "Name of the service account that will be used by the Cloud Function."
  type        = string
  default     = "cf-ba-disconnect"
}

variable "function_name" {
  description = "Name of the function that will disconnect the billing account from a project."
  type        = string
  default     = "cf-radlab-billing-check"
}

variable "labels" {
  description = "Labels to attach to the project."
  type        = map(string)
  default     = {}
}

variable "network_name" {
  description = "Name of the network.  The network will be used to ensure private connectivity from and to the Cloud Function."
  type        = string
  default     = "rl-billing-nw"
}

variable "parent" {
  description = "Parent of the project.  Should be formatted as 'folders/folder_id' or 'organization/org_id'."
  type        = string
  default     = ""
}

variable "project_name" {
  description = "The name of the project.  The project ID will be constructed from this project."
  type        = string
  default     = "rl-orchestrator"
}

variable "region" {
  description = "Region where all resources should be created."
  type        = string
  default     = "us-east1"
}

variable "function_repository_name" {
  description = "Name of the repository where the Cloud Function will be hosted."
  type        = string
  default     = "cf-ba-disconnect-repo"
}
variable "storage_bucket_location" {
  description = "Location where the Terraform state files will be stored."
  type        = string
  default     = "us-east1"
}

variable "suffix" {
  description = "Suffix that is used for all resources.  When left empty, the project module will generate one and that one will be used for all other resources."
  type        = string
  default     = null
}

variable "storage_bucket_name" {
  description = "Name of the storage bucket that will host the RAD Lab state files."
  type        = string
  default     = "rad-lab-state-files"
}

variable "terraform_state_prefix" {
  description = "Prefix to be used for the Terraform state files for the orchestrator."
  type        = string
  default     = "rad-lab/orchestrator/state"
}

variable "tf_state_revisions_to_keep" {
  description = "Number of revisions of the state files to keep."
  type        = number
  default     = 10
}

variable "topic_name" {
  description = "Name of the PubSub Topic that will receive the billing threshold reached notifications."
  type        = string
  default     = "billing-threshold"
}

variable "vpc_access_connector_cidr_range" {
  description = "CIDR range for the VPC access connector"
  type        = string
  default     = "10.100.0.0/28"
}

variable "vpc_access_connector_machine_type" {
  description = "Machine type to use for the VPC Access Connector."
  type        = string
  default     = "e2-micro"
}

variable "vpc_access_connector_name" {
  description = "Name of the VPC access connector."
  type        = string
  default     = "cf-ba-vpc-access"
}

variable "zone" {
  description = "Default zone for all resources, if one has to be specified."
  type        = string
  default     = "us-east1-b"
}