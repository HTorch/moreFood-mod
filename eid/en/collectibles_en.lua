<<<<<<< HEAD
local cols = moreFood.Collectibles

local Collectibles = {}	
local function AddItem(id, entry)
	if (id) then
		Collectibles[id] = entry;
	end
end

AddItem(cols.ChickenBreast.ID, {
	Name = "Chicken Breast",
    Description = "Woody and tough"..
	"#{{ArrowUp}} +1 Heart Container"..
	"#{{ArrowDown}} - Some statues down"..
	"#{{ArrowUp}} ++ Some statues gradually up"
})
AddItem(cols.Celeste.ID, {
	Name = "Celeste",
    Description = "Juicy"..
	"#{{ArrowUp}} +1 Heart Container"..
	"#{{Heart}} Heals 1 Red Heart"..
	"#Dash Permitted (Shift + MoveKey)"..
	"#Dash will give 1s invincibility"
})
AddItem(cols.HotPot.ID, {
	Name = "Hot Pot",
    Description = "So so so spicy"..
	"#{{ArrowUp}} +2 Heart Container"..
	"#{{Heart}} Heals 2 Red Heart"..
	"#Fire from your ass Permitted (charge)"
})
AddItem(cols.Ginger.ID, {
	Name = "Ginger",
    Description = "BEST Coser"..
	"#{{ArrowUp}} +1 Heart Container"..
	"#{{ArrowUp}} +3 Tears up"..
	"#{{Luck}} +6 Luck up"..
	"#When you collect a passive collectibles"..
	"#it may turn into ginger."..
	"#The higher the quality, "..
	"#the less likely it is to be converted into ginger."
})
local lang = "en_us";
local descriptions = EID.descriptions[lang];
for id, col in pairs(Collectibles) do
	EID:addCollectible(id, col.Description, col.Name, lang);
=======
local cols = moreFood.Collectibles

local Collectibles = {}	
local function AddItem(id, entry)
	if (id) then
		Collectibles[id] = entry;
	end
end

AddItem(cols.ChickenBreast.ID, {
	Name = "Chicken Breast",
    Description = "Woody and tough"..
	"#{{ArrowUp}} +1 Heart Container"..
	"#{{ArrowDown}} - Some statues down"..
	"#{{ArrowUp}} ++ Some statues gradually up"
})
AddItem(cols.Celeste.ID, {
	Name = "Celeste",
    Description = "Juicy"..
	"#{{ArrowUp}} +1 Heart Container"..
	"#{{Heart}} Heals 1 Red Heart"..
	"#Dash Permitted (Shift + MoveKey)"..
	"#Dash will give 1s invincibility"
})
AddItem(cols.HotPot.ID, {
	Name = "Hot Pot",
    Description = "So so so spicy"..
	"#{{ArrowUp}} +2 Heart Container"..
	"#{{Heart}} Heals 2 Red Heart"..
	"#Fire from your ass Permitted (charge)"
})
AddItem(cols.Ginger.ID, {
	Name = "Ginger",
    Description = "BEST Coser"..
	"#{{ArrowUp}} +1 Heart Container"..
	"#{{ArrowUp}} +3 Tears up"..
	"#{{Luck}} +6 Luck up"..
	"#When you collect a passive collectibles"..
	"#it may turn into ginger."..
	"#The higher the quality, "..
	"#the less likely it is to be converted into ginger."
})
local lang = "en_us";
local descriptions = EID.descriptions[lang];
for id, col in pairs(Collectibles) do
	EID:addCollectible(id, col.Description, col.Name, lang);
>>>>>>> d35c1c50f9ec8083dc8f476c254e12ae4506c252
end