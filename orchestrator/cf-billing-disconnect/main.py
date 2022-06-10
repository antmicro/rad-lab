# Copyright 2022 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import base64
import json
import os
from googleapiclient import discovery


def stop_billing(data, context):
    pubsub_data = base64.b64decode(data['data']).decode('utf-8')
    pubsub_json = json.loads(pubsub_data)
    cost_amount = pubsub_json['costAmount']
    budget_amount = pubsub_json['budgetAmount']
    if cost_amount <= budget_amount:
        print(f'No action necessary, (Current cost: {cost_amount}.')
        return

    billing = discovery.build(
        'cloudbilling',
        'v1',
        cache_discovery=False
    )

    projects = billing.projects()
    billing_enabled = __is_billing_enabled('', projects)


def __is_billing_enabled(project_name, projects):
    """
    Determine whether or not billing is enabled for the project
    :param project_name: Name of the project to check if billing is enabled
    :param projects: List of projects to validate
    :return:  Whether project has billing enabled or not
    """
    try:
        response = projects.getBillingInfo(name=project_name).execute()
        return response['billingEnabled']
    except KeyError:
        return False
    except Exception:
        print('Unable to determine if billing is enabled on specified project, assuming billing is enabled.')
        return True

def __disable_billing_for_project(project_name, projects):
    """
    Disable billing for the specified project
    :param project_name:
    :param projects:
    :return:
    """
    body = {'billingAccountName': ''} # Disable billing
    try:
        response = projects.updateBillingInfo(name=project_name, body=body).execute()
        print(f'Billing disabled: {json.dumps(response)}')
    except Exception:
        print(f'Failed to disable billing for project {project_name}')
