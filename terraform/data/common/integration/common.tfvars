aws_region = "eu-west-1"

aws_environment = "integration"

remote_state_bucket = "govuk-terraform-steppingstone-integration"

ssh_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCqNd3w1dljlYl1SK8ey5cU80hACnfjZE13vJV49t1Zx+me/5dDnkoEASNB2HZgHlZeQb9sJmDl+MQdugcZy5/SfxohkxPUT+H+YXyERSsxv0iskkh9+HPTCQDWudom/4klRc4+OYY/vBgS6kUnBnTYdniWpL8XCWJOBrHQRzMcryeEI1705f45aEBpVxpgMD7LtHp/Tp+Pf4Qkvj9IFX9CnixltUpT5JgZI6qc1H4eE7QYlL0zko3N85IvaoMY8utM3Xmk5zkSJ/5VgnRFovgySCLzWqpoYA3CBYOZ6uEsj+6+2FCOxhO7y6NbIOmXMtQCGqclVusQQvwHoqbXRdUFPNU6M0xfOK9EN1CdnMJWcXXwrtkDhdmhtif7uanbJ4LlP6sE/Kxl3Aqb9ftff1Wk9DqYebznlfct2jE61jSZSfLrZc+7hbEV+EcexS2RPG5QTOoKvZsowAcXicpUY9ujq48XtQGjQwvoflrhe1ObPdLfI+/fVdKlBGDN2pcaxAKgRumWnhDHIBEXVS3tNpIatnx4IRbHJSs0hElRzsN6Btq80YaLZGcnio4Kq+A0pFzQrxCCvg/Zgz196WRC7XzMMiudI6FPfTRUfQxsU7+lqznb5AfpdVRqmgmW4ogOLbo1xvF3XmTsvkyaw8TvKbWmnIBJ53104V9rBZls0RAVNw== govuk"

office_ips = [
  "80.194.77.90/32",
  "80.194.77.100/32",
  "85.133.67.244/32",
  "213.86.153.212/32",
  "213.86.153.213/32",
  "213.86.153.214/32",
  "213.86.153.235/32",
  "213.86.153.236/32",
  "213.86.153.237/32",
]

user_data_snippets = [
  "00-base",
  "20-puppet-client",
]

api-mongo_1_subnet = "govuk_private_a"
api-mongo_2_subnet = "govuk_private_b"
api-mongo_3_subnet = "govuk_private_c"

mongo_1_subnet = "govuk_private_a"
mongo_2_subnet = "govuk_private_b"
mongo_3_subnet = "govuk_private_c"

performance-mongo_1_subnet = "govuk_private_a"
performance-mongo_2_subnet = "govuk_private_b"
performance-mongo_3_subnet = "govuk_private_c"

router-backend_1_subnet = "govuk_private_a"
router-backend_2_subnet = "govuk_private_b"
router-backend_3_subnet = "govuk_private_c"
