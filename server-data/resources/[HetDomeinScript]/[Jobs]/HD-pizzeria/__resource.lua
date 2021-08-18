resource_manifest_version '05cfa83c-a124-4cfa-a768-c24a5811d8f9'

description "pizza Job"

client_scripts {
  'client/*.lua',
  'config.lua',
  'client/gui.lua',
}

server_scripts {
  'server/*.lua',
  'config.lua',
}