provider "aiven" {
  api_token = var.aiven_api_token
}

# Account
resource "aiven_account" "env" {
  name = lower(var.env_code)
}

# Project
resource "aiven_project" "kafka" {
  project    = lower(var.project_code)
  account_id = aiven_account.env.account_id
}

# Account team
resource "aiven_account_team" "admin" {
  account_id = aiven_account.env.account_id
  name       = "Account Admins"
}

# Account team project
resource "aiven_account_team_project" "admin" {
  account_id   = aiven_account.env.account_id
  team_id      = aiven_account_team.admin.team_id
  project_name = aiven_project.kafka.project
  team_type    = "admin"
}

# Account team member
resource "aiven_account_team_member" "admin" {
  account_id = aiven_account.env.account_id
  team_id    = aiven_account_team.admin.team_id
  user_email = "entechlog@gmail.com"
}
