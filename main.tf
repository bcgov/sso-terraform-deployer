resource "kubernetes_role" "this" {
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
    namespace = var.namespace
  }
  rule {
    api_groups = [""]
    resources = [
      "replicationcontrollers",
      "persistentvolumeclaims",
      "services",
      "secrets",
      "configmaps",
      "endpoints",
      "pods",
      "pods/exec"
    ]
    verbs = [
      "watch",
      "list",
      "get",
      "create",
      "update",
      "patch",
      "delete",
      "deletecollection"
    ]
  }
  rule {
    api_groups = [""]
    resources = [
      "pods/status",
      "pods/log"
    ]
    verbs = [
      "watch",
      "list",
      "get",
    ]
  }
  rule {
    api_groups = [""]
    resources  = ["serviceaccounts"]
    verbs = [
      "get",
      "list",
      "create",
      "update",
      "patch",
      "delete",
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
      "watch",
      "update"
    ]
  }
  rule {
    api_groups = ["apps"]
    resources  = ["statefulsets"]
    verbs = [
      "get",
      "create",
      "delete",
      "update",
      "patch",
    ]
  }
  rule {
    api_groups = ["batch"]
    resources = [
      "jobs",
      "cronjobs",
    ]
    verbs = [
      "get",
      "create",
      "update",
      "patch",
      "delete",
      "watch",
      "list",
    ]
  }
  rule {
    api_groups = ["policy"]
    resources  = ["poddisruptionbudgets"]
    verbs = [
      "get",
      "create",
      "update",
      "patch",
      "delete",
    ]
  }
  rule {
    api_groups = [
      "rbac.authorization.k8s.io",
      "authorization.openshift.io"
    ]
    resources = [
      "roles",
      "rolebindings",
    ]
    verbs = [
      "get",
      "list",
      "create",
      "update",
      "patch",
      "delete",
    ]
  }
  rule {
    api_groups = [
      "extensions",
      "apps"
    ]
    resources = [
      "deployments",
      "replicasets",
    ]
    verbs = [
      "get",
      "list",
      "create",
      "update",
      "patch",
      "delete",
    ]
  }
  rule {
    api_groups = ["networking.k8s.io"]
    resources  = ["networkpolicies"]
    verbs = [
      "get",
      "list",
      "create",
      "update",
      "patch",
      "delete",
    ]
  }
  rule {
    api_groups = ["autoscaling"]
    resources  = ["horizontalpodautoscalers"]
    verbs = [
      "get",
      "list",
      "create",
      "update",
      "patch",
      "delete",
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
      "get",
      "create",
      "update",
      "patch",
    ]
  }
  rule {
    api_groups = ["route.openshift.io"]
    resources  = ["routes"]
    verbs = [
      "get",
      "create",
      "update",
      "patch",
      "delete",
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
        "get",
        "list",
        "create",
        "update",
        "patch",
        "delete",
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
  metadata {
    name      = var.name
    namespace = var.namespace
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role.this.metadata.0.name
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.this.metadata.0.name
    namespace = var.namespace
  }
}
