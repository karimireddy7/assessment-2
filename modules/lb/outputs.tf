output "lb_ip" {
  value = google_compute_global_forwarding_rule.rule.ip_address
}