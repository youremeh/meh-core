fx_version 'cerulean'
game 'gta5'
lua54 'yes'
dependencies {'/onesync', 'ox_lib', 'screenshot-basic'}

files {'metas/weapons/*.meta', 'theme/*'}
shared_scripts {'shared/*.lua', '@ox_lib/init.lua'}
server_scripts {'@oxmysql/lib/MySQL.lua', 'server/*.lua'}
client_scripts {'@qbx_core/modules/playerdata.lua', 'client/*.lua'}

data_file 'WEAPONINFO_FILE_PATCH' 'metas/weapons/*.meta'