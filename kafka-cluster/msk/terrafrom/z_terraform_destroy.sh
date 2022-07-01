# https://stackoverflow.com/questions/55265203/terraform-delete-all-resources-except-one
# list all resources
terraform state list

# remove that resource you don't want to destroy
# you can add more to be excluded if required
# aws_mskconnect_worker_configuration does not support delete, AWS issue
# aws_secretsmanager_secret deletes has a cooling period of 7 days, so delete and deployment won't work
terraform state rm aws_mskconnect_worker_configuration.default_config
terraform state rm aws_secretsmanager_secret.msk

# destroy the whole stack except above excluded resource(s)
terraform destroy
