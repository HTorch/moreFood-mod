local Collectibles = {}
Collectibles.ChickenBreast =  require("scripts.items.collectibles.chicken_breast")
Collectibles.Celeste =  require("scripts.items.collectibles.celeste")
Collectibles.HotPot =  require("scripts.items.collectibles.hot_pot")
Collectibles.Ginger =  require("scripts.items.collectibles.ginger")

local Pills = {}
Pills.PolioVaccines = require("scripts.pockets.polio_vaccines")

moreFood.Pills = Pills
moreFood.Collectibles = Collectibles
local Trinkets = {}
moreFood.Trinkets = Trinkets