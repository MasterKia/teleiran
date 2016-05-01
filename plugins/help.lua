do
function run(msg, matches)
  return " 💠TeleIran Tools Commands: \n\n\n 🚫Anti Words: \n #block [Word] \n #unblock [Word] \n\n 🎁Sticker Maker: \n #sticker \n #png \n\n 📷WebShot: \n #web [Site] \n\n 📚Calculator: \n #calc [Number] \n\n 🎤Text To Voice: \n #vc [Text] \n\n 🌦Weather: \n #weather [City] \n\n ⏰Online Clock: \n #time \n\n☢About TeleIan: \n #TeleIran \n\n\n 🚀 Channel: @TeleIranTeam 💎 "
  end
return {
  description = " TeleIran ", 
  usage = " TeleIran ",
  patterns = {
    --"^[!#/][Hh][Ee][Ll][Pp]$",
    --"^[#/!][Hh][Ee][Ll][Pp][Mm][Ee]$",
    --"^[#/!][Hh][Ee][Ll][Pp] [Mm][Ee]$",
    --"^[#/!][Hh][Ee][Ll][Pp][Aa][Ll][Ll]$",
    --"^[#/!][Hh][Ee][Ll][Pp] [Aa][Ll][Ll]$",
    --"^[#/!][Ss][Hh][Ee][Ll][Pp]$",
  },
  run = run
}
end
