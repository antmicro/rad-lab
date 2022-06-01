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
  parent_type              = var.parent == null ? null : split("/", var.parent)[0]
  parent_id                = var.parent == null ? null : split("/", var.parent)[1]
  cloud_function_iam_roles = []
}

resource "google_service_account" "function_identity" {
  project     = module.orchestrator_project.project_id
  account_id  = var.function_identity_name
  description = "Cloud Function identity that will be used to disconnect the Billing Account from the project, in case the billing budget has been reached."
}

resource "google_folder_iam_member" "function_identity_permissions" {
  for_each = local.parent_type == "folders" ? local.cloud_function_iam_roles : toset([])
  folder   = local.parent_id
  member   = "serviceAccount:${google_service_account.function_identity.email}"
  role     = each.value
}

resource "google_organization_iam_member" "function_identity_permissions" {
  for_each = local.parent_type == "organizations" ? local.cloud_function_iam_roles : toset([])
  org_id   = local.parent_id
  member   = "serviceAccount:${google_service_account.function_identity.email}"
  role     = each.value
}

resource "google_billing_account_iam_member" "function_identity_billing_permissions" {
  billing_account_id = var.billing_account_id
  member             = "serviceAccount:${google_service_account.function_identity.email}"
  role               = "roles/billing.admin"
}

resource "google_vpc_access_connector" "function_vpc_access" {
  provider      = google-beta
  project       = module.orchestrator_project.project_id
  name          = var.vpc_access_connector_name
  network       = module.network.name
  region        = var.region
  ip_cidr_range = var.vpc_access_connector_cidr_range
  machine_type  = var.vpc_access_connector_machine_type
}