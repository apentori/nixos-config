{ pkgs, ... }:

{
  users.users.irotnep.packages = with pkgs; [
    # DevOps
    ansible_2_14
    # Security
    bitwarden unstable.bitwarden-cli yubikey-manager
    # Network
    netcat websocat tcpdump whois
    # Cloud
    awscli s3cmd unstable.doctl google-cloud-sdk
    scaleway-cli aliyun-cli hcloud

    # Utils
    jsonnet appimage-run
  ]; 
} 
