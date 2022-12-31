resource "cloudflare_zone" "zone" {
  account_id = var.account_id
  paused     = var.zone.paused
  plan       = var.zone.plan
  type       = var.zone.type
  zone       = var.zone.zone
}
