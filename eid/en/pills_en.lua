<<<<<<< HEAD
local cols = templatemod.Pills

local Pills = {}
local function AddPill(id, entry)
	if (id) then
		Pills[id] = entry;
	end
end

AddPill(cols.PolioVaccines.ID, {
	Name = "Poliomyelitis Vaccine in Dragee Candy(Human Diploid Cell), Live",
    Description = "Remoevs all curses on the current floor"
})

local lang = "en_us";
local descriptions = EID.descriptions[lang];
for id, col in pairs(Pills) do
	EID:addPill(id, col.Description, col.Name, lang);
=======
local cols = templatemod.Pills

local Pills = {}
local function AddPill(id, entry)
	if (id) then
		Pills[id] = entry;
	end
end

AddPill(cols.PolioVaccines.ID, {
	Name = "Poliomyelitis Vaccine in Dragee Candy(Human Diploid Cell), Live",
    Description = "Remoevs all curses on the current floor"
})

local lang = "en_us";
local descriptions = EID.descriptions[lang];
for id, col in pairs(Pills) do
	EID:addPill(id, col.Description, col.Name, lang);
>>>>>>> d35c1c50f9ec8083dc8f476c254e12ae4506c252
end