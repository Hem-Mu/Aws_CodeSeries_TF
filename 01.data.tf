data "terraform_remote_state" "network" {
    backend = "local"
    config = {
        path = ".././terraform.tfstate"
    }   
}