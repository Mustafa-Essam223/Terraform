provider "aws" {
    region = "eu-north-1"
    shared_config_files = ["$HOME/.aws/config"]
    shared_credentials_files = ["$HOME/.aws/credentials"]
}
