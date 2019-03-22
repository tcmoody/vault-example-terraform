resource "aws_kms_key" "vault-key" {
  description             = "Vault KMS key"
  deletion_window_in_days = 7
}