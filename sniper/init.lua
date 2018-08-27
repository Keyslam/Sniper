local PATH = (...):gsub('%.init$', '')

local Sniper = {
   entity    = require(PATH..".entity"),
   component = require(PATH..".component"),
   system    = require(PATH..".system"),
}

return Sniper
