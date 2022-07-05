resource "kubernetes_role" "this" {
  for_each = toset(var.privileged_namespaces)

  metadata {
    name = var.name
    labels = {
      role       = "deployer"
      created-by = "Terraform"
    }
    annotations = {
      "openshift.io/description"       = "deployer"
      "openshift.io/reconcile-protect" = "false"
    }
    namespace = each.key
  }
  rule {
    api_groups = [""]
    resources = [
      "configmaps",
      "endpoints",
      "persistentvolumeclaims",
      "pods",
      "pods/exec",
      "replicationcontrollers",
      "secrets",
      "services",
    ]
    verbs = [
      "create",
      "delete",
      "deletecollection",
      "get",
      "list",
      "patch",
      "update",
      "watch",
    ]
  }
  rule {
    api_groups = [""]
    resources = [
      "pods/log",
      "pods/status",
    ]
    verbs = [
      "get",
      "list",
      "watch",
    ]
  }
  rule {
    api_groups = [""]
    resources  = ["serviceaccounts"]
    verbs = [
      "create",
      "delete",
      "get",
      "list",
      "patch",
      "update",
    ]
  }
  rule {
    api_groups = [""]
    resources  = ["events"]
    verbs      = ["list"]
  }
  rule {
    api_groups = ["image.openshift.io"]
    resources = [
      "imagestreamimages",
      "imagestreammappings",
      "imagestreams",
      "imagestreamtags"
    ]
    verbs = [
      "get",
      "list",
      "update",
      "watch",
    ]
  }
  rule {
    api_groups = ["apps"]
    resources  = ["statefulsets"]
    verbs = [
      "create",
      "delete",
      "get",
      "list",
      "patch",
      "update",
    ]
  }
  rule {
    api_groups = ["batch"]
    resources = [
      "cronjobs",
      "jobs",
    ]
    verbs = [
      "create",
      "delete",
      "get",
      "list",
      "patch",
      "update",
      "watch",
    ]
  }
  rule {
    api_groups = ["policy"]
    resources  = ["poddisruptionbudgets"]
    verbs = [
      "create",
      "delete",
      "get",
      "patch",
      "update",
    ]
  }
  rule {
    api_groups = [
      "authorization.openshift.io",
      "rbac.authorization.k8s.io",
    ]
    resources = [
      "rolebindings",
      "roles",
    ]
    verbs = [
      "create",
      "delete",
      "get",
      "list",
      "patch",
      "update",
    ]
  }
  rule {
    api_groups = [
      "apps",
      "extensions",
    ]
    resources = [
      "deployments",
      "replicasets",
    ]
    verbs = [
      "create",
      "delete",
      "get",
      "list",
      "patch",
      "update",
    ]
  }
  rule {
    api_groups = ["networking.k8s.io"]
    resources  = ["networkpolicies"]
    verbs = [
      "create",
      "delete",
      "get",
      "list",
      "patch",
      "update",
    ]
  }
  rule {
    api_groups = ["autoscaling"]
    resources  = ["horizontalpodautoscalers"]
    verbs = [
      "create",
      "delete",
      "get",
      "list",
      "patch",
      "update",
    ]
  }
  rule {
    api_groups = ["image.openshift.io"]
    resources  = ["imagestreamtags"]
    verbs      = ["delete"]
  }
  rule {
    api_groups = ["project.openshift.io"]
    resources  = ["projects"]
    verbs      = ["get"]
  }
  rule {
    api_groups = ["apps.openshift.io"]
    resources  = ["deploymentconfigs"]
    verbs = [
      "create",
      "get",
      "patch",
      "update",
    ]
  }
  rule {
    api_groups = ["route.openshift.io"]
    resources  = ["routes"]
    verbs = [
      "create",
      "delete",
      "get",
      "patch",
      "update",
    ]
  }
  rule {
    api_groups = ["route.openshift.io"]
    resources  = ["routes/custom-host"]
    verbs      = ["create"]
  }
  rule {
    api_groups = ["template.openshift.io"]
    resources  = ["processedtemplates"]
    verbs      = ["create"]
  }

  dynamic "rule" {
    for_each = toset(var.ops_bcgov ? ["1"] : [])
    content {
      api_groups = ["ops.gov.bc.ca"]
      resources  = ["sysdig-teams"]
      verbs = [
        "create",
        "delete",
        "get",
        "list",
        "patch",
        "update",
      ]
    }
  }

  dynamic "rule" {
    for_each = toset(var.bcgov_tsc ? ["1"] : [])
    content {
      api_groups = ["porter.devops.gov.bc.ca"]
      resources  = ["transportserverclaims"]
      verbs = [
        "create",
        "delete",
        "get",
        "list",
        "patch",
        "update",
      ]
    }
  }
}

resource "kubernetes_service_account" "this" {
  metadata {
    name      = var.name
    namespace = var.namespace
  }

  automount_service_account_token = true

  lifecycle {
    ignore_changes = [
      image_pull_secret,
      secret
    ]
  }
}

resource "kubernetes_role_binding" "this" {
  for_each = toset(var.privileged_namespaces)

  metadata {
    name      = var.name
    namespace = kubernetes_role.this[each.key].metadata.0.namespace
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role.this[each.key].metadata.0.name
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.this.metadata.0.name
    namespace = var.namespace
  }
}
