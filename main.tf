locals {
  enabled = module.this.enabled
}

resource "helm_release" "this" {
  count = local.enabled ? 1 : 0

  name        = module.this.name
  description = var.description
  chart       = var.chart
  devel       = var.devel
  version     = var.chart_version

  repository           = var.repository
  repository_key_file  = var.repository_key_file
  repository_cert_file = var.repository_cert_file
  repository_ca_file   = var.repository_ca_file
  repository_username  = var.repository_username
  repository_password  = var.repository_password

  # Note: creating a namespace here will not allow creation of labels/annotations
  # For that, a `kubernetes_namespace` resource would have to be created.
  # See https://github.com/hashicorp/terraform-provider-helm/issues/584#issuecomment-689555268
  create_namespace = var.create_namespace
  namespace        = var.kubernetes_namespace

  values = var.values

  atomic                     = var.atomic
  cleanup_on_fail            = var.cleanup_on_fail
  dependency_update          = var.dependency_update
  disable_openapi_validation = var.disable_openapi_validation
  disable_webhooks           = var.disable_webhooks
  force_update               = var.force_update
  keyring                    = var.keyring
  lint                       = var.lint
  max_history                = var.max_history
  recreate_pods              = var.recreate_pods
  render_subchart_notes      = var.render_subchart_notes
  replace                    = var.replace
  reset_values               = var.reset_values
  reuse_values               = var.reuse_values
  skip_crds                  = var.skip_crds
  timeout                    = var.timeout
  verify                     = var.verify
  wait                       = var.wait
  wait_for_jobs              = var.wait_for_jobs

  dynamic "set" {
    for_each = var.set
    content {
      name  = set.value["name"]
      value = set.value["value"]
      type  = set.value["type"]
    }
  }

  dynamic "set_sensitive" {
    for_each = var.set_sensitive
    content {
      name  = set_sensitive.value["name"]
      value = set_sensitive.value["value"]
      type  = set_sensitive.value["type"]
    }
  }

  dynamic "postrender" {
    for_each = var.postrender_binary_path != null ? [1] : []

    content {
      binary_path = var.postrender_binary_path
    }
  }
}
