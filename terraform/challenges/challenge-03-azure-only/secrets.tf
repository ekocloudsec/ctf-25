# Key Vault secrets for Challenge-03
# Contains the flag for the privilege escalation challenge

# Sleep to allow RBAC role propagation
# Azure RBAC assignments can take time to propagate
resource "time_sleep" "wait_for_rbac_propagation" {
  depends_on = [azurerm_role_assignment.terraform_keyvault_secrets_officer]
  create_duration = "60s"
}

# Flag secret - the main target for the challenge
resource "azurerm_key_vault_secret" "flag" {
  name         = "flag"
  value        = "CTF{k3y_v4ult_pr1v1l3g3_3sc4l4t10n_fr0m_s3rv1c3_pr1nc1p4l}"
  key_vault_id = azurerm_key_vault.challenge_03_vault.id
  
  content_type = "text/plain"
  
  tags = {
    Purpose     = "CTF Flag"
    Challenge   = "Challenge-03"
    Difficulty  = "Advanced"
  }
  
  depends_on = [
    azurerm_key_vault.challenge_03_vault,
    azurerm_role_assignment.sp_keyvault_secrets_user,
    azurerm_role_assignment.terraform_keyvault_secrets_officer,
    time_sleep.wait_for_rbac_propagation
  ]
}
