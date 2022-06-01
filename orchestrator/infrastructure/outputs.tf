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

output "deployment_id" {
  value = module.orchestrator_project.deployment_id
}

output "project_id" {
  value = module.orchestrator_project.project_id
}

output "project_name" {
  value = module.orchestrator_project.name
}

output "project_number" {
  value = module.orchestrator_project.number
}

output "storage_bucket_name" {
  value = google_storage_bucket.radlab_state_bucket.name
}