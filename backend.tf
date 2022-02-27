terraform {
  backend "remote" {
    organization = "Bebetter"
    workspaces {
      name = "msdnbaseinfra"
    }
  }
}
