resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

description "Create Mafia"

version "1.1"

ui_page "ui/index.html"

client_scripts {
  "@es_extended/locale.lua",
  "client/*.lua",
  "Config.lua"
}

server_scripts {
  "@es_extended/locale.lua",
  "@async/async.lua",
  "@mysql-async/lib/MySQL.lua",
  "Config.lua",
  "server/main.lua",
  "locales/cs.lua",
  "locales/sv.lua",
  "locales/fr.lua",
}

files {
  "ui/index.html",
  "ui/animate.css",
  "ui/hover.css",
  -- JS LOCALES
  "ui/script.js",
  "ui/style.css",
  -- IMAGES
  'ui/images/*.png',
  'ui/images/*.gif'
}
