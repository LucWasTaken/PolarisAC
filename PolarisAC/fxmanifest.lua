fx_version 'bodacious'
game 'gta5'

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    "config/Config.lua",
    "server.lua",
}

client_scripts {
    "client.lua",
}