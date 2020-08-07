# Tests
infra_path = 'docker-monolith/infra'

task test: ['test:packer', 'test:terraform', 'test:ansible']

desc 'Test infrastructure config'
namespace :test do
  task :packer do
    system "packer validate -var-file=#{infra_path}/packer/variables.json #{infra_path}/packer/docker-host.json"
  end

  task :terraform do
    system "cd #{infra_path}/terraform && terraform validate"
  end

  task :ansible do
    system "cd #{infra_path}/ansible/playbooks && ansible-lint"
  end
end

# Provision
desc 'packer build'
task :pb do
  system "packer build -var-file=docker-monolith/infra/packer/variables.json docker-monolith/infra/packer/docker-host.json"
end

desc 'terrafrom apply'
task :tfa do
  system "cd docker-monolith/infra/terraform && terraform apply"
end

desc 'terraform destroy'
task :tfd do
  system "cd docker-monolith/infra/terraform && terraform destroy"
end

desc 'ansible check'
task :apc do
  system "cd docker-monolith/infra/ansible && ansible-playbook playbooks/deploy_reddit.yml --check"
end

desc 'ansible deploy'
task :apd do
  system "cd docker-monolith/infra/ansible && ansible-playbook playbooks/deploy_reddit.yml"
end
