module "main_vpc" {
  source = "git::https://github.com/Mistrikoff/tf_modules.git//yandex_modules/vpc"
  SUBNETS = [
    {
      name    = "sn-1"
      address = "10.1.0.0/16"
      zone    = "ru-central1-a"
    },
    {
      name    = "sn-2"
      address = "10.2.0.0/16"
      zone    = "ru-central1-a"
    },
    {
      name    = "sn-3"
      address = "10.3.0.0/16"
      zone    = "ru-central1-a"
    }
  ]
  VPC_NAME = "main-vpc"
  FOLDER_ID = "1234567890987654321"
  ZONE = "ru-central1-a"
}