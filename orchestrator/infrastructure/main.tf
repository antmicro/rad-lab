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

locals {
  suffix = var.suffix == null ? module.orchestrator_project.deployment_id : var.suffix
  project_apis = [
    "cloudbilling.googleapis.com",
    "cloudfunctions.googleapis.com",
    "vpcaccess.googleapis.com",
    "cloudbuild.googleapis.com",
    "sourcerepo.googleapis.com"
  ]

  parent_folder = var.create_folder ? "folders/${google_folder.radlab_folder.0.folder_id}" : var.parent
}

resource "google_folder" "radlab_folder" {
  count        = var.create_folder ? 1 : 0
  display_name = var.folder_name
  parent       = var.parent
}

module "orchestrator_project" {
  source = "../../helpers/tf-modules/project"

  project_name       = var.project_name
  billing_account_id = var.billing_account_id
  parent             = local.parent_folder
  labels             = var.labels
  project_apis       = local.project_apis
}

module "network" {
  source = "../../helpers/tf-modules/net-vpc"

  project_id   = module.orchestrator_project.project_id
  network_name = var.network_name
  subnets      = var.cloud_function_subnet
}

resource "google_storage_bucket" "radlab_state_bucket" {
  project                     = module.orchestrator_project.project_id
  location                    = var.storage_bucket_location
  name                        = format("%s-%s", var.storage_bucket_name, local.suffix)
  force_destroy               = true
  uniform_bucket_level_access = true
  labels                      = var.labels

  versioning {
    enabled = true
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }

    condition {
      num_newer_versions = var.tf_state_revisions_to_keep
    }
  }
}

resource "local_file" "terraform_backend" {
  filename = "./backend.tf"
  content = templatefile("${path.module}/templates/backend.tf.tpl", {
    BUCKET_NAME     = google_storage_bucket.radlab_state_bucket.name
    TF_STATE_PREFIX = var.terraform_state_prefix
  })
}
