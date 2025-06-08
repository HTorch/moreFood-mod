local cols = templatemod.Pills

local Pills = {}
local function AddPill(id, entry)
	if (id) then
		Pills[id] = entry;
	end
end

AddPill(cols.PolioVaccines.ID, {
	Name = "脊髓灰质炎减毒活疫苗糖丸（人二倍体细胞）",
    Description = "解除当前层的诅咒"
})

local lang = "zh_cn";
local descriptions = EID.descriptions[lang];
for id, col in pairs(Pills) do
	EID:addPill(id, col.Description, col.Name, lang);
end