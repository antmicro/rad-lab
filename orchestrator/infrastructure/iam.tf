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
  radlab_id_permissions = [
    "roles/resourcemanager.projectCreator"
  ]

  radlab_id_billing_permissions = [
    "roles/billing.admin"
  ]

  cloud_build_identity = "${module.orchestrator_project.number}@cloudbuild.gserviceaccount.com"
}

resource "google_service_account" "radlab_identity" {
  project      = module.orchestrator_project.project_id
  account_id   = "rad-lab-orchestrator"
  display_name = "Rad Lab Orchestrator"
  description  = "Identity that manages RAD Lab resources in folder ${local.parent_folder}."
}

resource "google_billing_account_iam_member" "radlab_identity_billing_permissions" {
  for_each           = toset(local.radlab_id_billing_permissions)
  billing_account_id = var.billing_account_id
  member             = "serviceAccount:${google_service_account.radlab_identity.email}"
  role               = each.value
}

resource "google_folder_iam_member" "radlab_identity_folder_permissions" {
  for_each = toset(local.radlab_id_permissions)
  folder   = local.parent_folder
  member   = "serviceAccount:${google_service_account.radlab_identity.email}"
  role     = each.value
}

resource "google_service_account_iam_member" "cloud_build_impersonator" {
  member             = "serviceAccount:${local.cloud_build_identity}"
  role               = "roles/iam.serviceAccountTokenCreator"
  service_account_id = google_service_account.radlab_identity.id
}