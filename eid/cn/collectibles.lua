local cols = moreFood.Collectibles

local Collectibles = {}	
local function AddItem(id, entry)
	if (id) then
		Collectibles[id] = entry;
	end
end

AddItem(cols.ChickenBreast.ID, {
	Name = "鸡胸肉",
    Description = "柴的有点嵌牙"..
	"#{{ArrowUp}} +1心之容器"..
	"#{{ArrowDown}} 属性下降"..
	"#{{ArrowUp}} 随后属性缓慢提升"
})

AddItem(cols.Celeste.ID, {
	Name = "蔚蓝草莓",
    Description = "多汁"..
	"#{{ArrowUp}} +1心之容器"..
	"#{{Heart}} 治疗1红心"..
	"#允许冲刺 (Shift + 移动方向键)"..
	"#冲刺给予1s无敌时间"
})

AddItem(cols.HotPot.ID, {
	Name = "火锅",
    Description = "好辣好辣好辣好辣"..
	"ST:@Trspent"..
	"#{{ArrowUp}} +2心之容器"..
	"#{{Heart}} 治疗2红心"..
	"#允许用屁股喷火"
})

AddItem(cols.Ginger.ID, {
	Name = "姜",
    Description = "最佳Coser"..
	"#ST:@Shining"..
	"#{{ArrowUp}} +1心之容器"..
	"#{{ArrowUp}} +3攻速上升"..
	"#{{Luck}} +6幸运上升"..
	"#如果你没有姜，在你获得道具时"..
	"#概率将你最后获得的道具转换为姜"..
	"#品质越高越不容易被转换成姜"
})

local lang = "zh_cn";
local descriptions = EID.descriptions[lang];
for id, col in pairs(Collectibles) do
	EID:addCollectible(id, col.Description, col.Name, lang);
end