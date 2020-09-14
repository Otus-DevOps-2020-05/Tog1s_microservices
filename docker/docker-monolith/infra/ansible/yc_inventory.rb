#!/usr/bin/ruby
#
# create secrets.yml with
# folder_id: <folder id>
# iam_token: < iam_key  $ yc iam create-token >
#
require 'rest-client'
require 'json'
require 'yaml'

secrets = YAML.load_file('../../../secrets.yml')

url = "https://compute.api.cloud.yandex.net/compute/v1/instances?folderId=#{secrets['folder_id']}"
response = RestClient.get(url, {
  Authorization: "Bearer #{secrets['iam_token']}"
})

instances = JSON.parse(response.body)

inventory = {}
inventory.store("_meta", hostvars:{})

instances['instances'].each do |i|
  inventory.store(i['name'], {
  hosts: [i['networkInterfaces'][0]['primaryV4Address']['oneToOneNat']['address']],
  vars: { private_ip: i['networkInterfaces'][0]['primaryV4Address']['address'] }
  })

end

puts inventory.to_json if ARGV[0] == "--list"
