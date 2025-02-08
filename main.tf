terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

# Read applications.json
locals {
  apps = jsondecode(file("${path.module}/applications.json"))["applications"]
}

# Loop over applications to create deployments and services
resource "kubernetes_deployment" "app" {
  for_each = { for app in local.apps : app.name => app }

  metadata {
    name = each.value.name
    labels = {
      app = each.value.name
    }
  }

  spec {
    replicas = each.value.replicas

    selector {
      match_labels = {
        app = each.value.name
      }
    }

    template {
      metadata {
        labels = {
          app = each.value.name
        }
      }

      spec {
        container {
          name  = each.value.name
          image = each.value.image
          args = flatten([each.value.args])  # Ensures args are correctly formatted as a list

          port {
            container_port = each.value.port
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "app" {
  for_each = { for app in local.apps : app.name => app }

  metadata {
    name = each.value.name
  }

  spec {
    selector = {
      app = each.value.name
    }

    port {
      port        = each.value.port
      target_port = each.value.port
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_ingress_v1" "app_ingress" {
  metadata {
    name = "app-ingress"
    annotations = {
      "nginx.ingress.kubernetes.io/rewrite-target" = "/"
    }
  }

  spec {
    rule {
      host = "my-app.local"
      http {
        path {
          path      = "/blue"
          path_type = "Prefix"
          backend {
            service {
              name = "blue-service"
              port {
                number = 8080
              }
            }
          }
        }
        path {
          path      = "/green"
          path_type = "Prefix"
          backend {
            service {
              name = "green-service"
              port {
                number = 8081
              }
            }
          }
        }
      }
    }
  }
}
