
data "http" "time" {
  url = "https://timeapi.io/api/Time/current/zone?timeZone=${var.timezone}"
}

resource "helm_release" "app1" {
  chart = var.chart_path
  name  = var.chart_name

  set {
    name  = "time"
    value = jsondecode(data.http.time.response_body)["time"]
  }

  set {
    name  = "timezone"
    value = var.timezone
  }
}
