# Ansible and GCP

An example for creating GCP resource using ansible by using Terraform modules and managing the configuration using ansible.

## Prerequisites

- Ansible
- Terraform

## Configuration of Access with GCP

You need to generate SSH keys from your system and need to configure the same in GCP project.

- Generate SSH keys in your servers
```
ssh-keygen -t ed25519 -f ~/.ssh/ansible_key -C ansible
```

- In the Google Cloud Platform Console, go to the Metadata page for your project.  
  
![Drag Racing](https://miro.medium.com/max/454/1*BspYx-2625Bjjq4d3zQ-gg.png)

- Under SSH Keys, click Edit.
- Modify the project-wide public SSH keys:
- When you are done, click Save at the bottom of the page.

## Create Ansible Playbook

- Create ```roles/nginx/main.yaml``` task
- Create ```nginx.yaml``` playbook
- Create Ansible Config ```ansible.cfg``` to skip host key verification
  
## Create Terraform Ansible Integration

- Create terraform file ```1-example.tf```
- Open default firewall rules
- Verify that you have Terraform and Ansible installed

```
command -v terraform
command -v ansible-playbook
```
- Run ```terraform init``` to download provider and plugins
- Run ```terraform plan``` to validate plan
- Run ```terraform apply``` to create the resource and run the playbook

## Clean-up

- Run ```terraform destroy```

## Contributing

Pull requests are welcome. For major changes, please open an issue first
to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License

[MIT](https://choosealicense.com/licenses/mit/)