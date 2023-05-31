variable "timezone" {
  description = "Timezone for the application"
  type        = string
  default     = "America/New_York"
}

variable "chart_path" {
  description = "Path to the Helm chart for the application"
  type        = string
  default     = "../app1"
}
variable "chart_name" {
  description = "Name for the Helm chart for the application"
  type        = string
  default     = "app1"
}
