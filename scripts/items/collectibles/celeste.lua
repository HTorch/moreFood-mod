local mod = moreFood
local Celeste = {}
Celeste.name = "Celeste"
Celeste.ID = Isaac.GetItemIdByName("Celeste")
local game = Game()

local DASH_DURATION = 3
local DASH_SPEED = 10
local DASH_COOLDOWN = 30

-- ...existing code...
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, function(_, player)
    local data = player:GetData()
    data._CelesteLastCount = player:GetCollectibleNum(Celeste.ID)
end)

function Celeste:OnPlayerEffectUpdate(player)
    if not player:HasCollectible(Celeste.ID) then return end
    local data = player:GetData()
    local count = player:GetCollectibleNum(Celeste.ID)
    data._CelesteLastCount = data._CelesteLastCount or 0
    if count > data._CelesteLastCount then
        -- 增加一格红心上限并补满一格红心
        player:AddMaxHearts(2, false)
        player:AddHearts(2)
    end
    data._CelesteLastCount = count
end

function Celeste:PlayerDashUpdate(player)
    if not player:HasCollectible(Celeste.ID) then return end
    local data = player:GetData()
    data.CelesteDashTimer = data.CelesteDashTimer or 0
    data.CelesteDashCooldown = data.CelesteDashCooldown or 0
    local input = Input

    -- 冲刺冷却
    if data.CelesteDashCooldown > 0 then
        data.CelesteDashCooldown = data.CelesteDashCooldown - 1
    end

    -- 冲刺中
    if data.CelesteDashTimer > 0 then
        data.CelesteDashTimer = data.CelesteDashTimer - 1
        player:SetMinDamageCooldown(30)
        -- 让角色变白
        player:SetColor(Color(2,2,2,1,0,0,0), 2, 1, false, false)
        if data.CelesteDashDir then
            player.Velocity = data.CelesteDashDir * DASH_SPEED
        end

        if data.CelesteDashTimer == 0 then
            data.CelesteDashCooldown = DASH_COOLDOWN
            data.CelesteDashDir = nil
            -- 冲刺结束恢复颜色
            player:SetColor(Color(1,1,1,1,0,0,0), 0, 1, false, false)
        end
        return
    end


    -- 检测shfit+方向键冲刺（4向）
    local shiftDown = Input.IsButtonPressed(Keyboard.KEY_LEFT_SHIFT, 0) or Input.IsButtonPressed(Keyboard.KEY_RIGHT_SHIFT, 0)
    if shiftDown and data.CelesteDashCooldown == 0 then
        local directions = {
            {key = ButtonAction.ACTION_UP,    vec = Vector(0,-1)},
            {key = ButtonAction.ACTION_DOWN,  vec = Vector(0,1)},
            {key = ButtonAction.ACTION_LEFT,  vec = Vector(-1,0)},
            {key = ButtonAction.ACTION_RIGHT, vec = Vector(1,0)},
        }
        for _, dir in ipairs(directions) do
            if input.IsActionTriggered(dir.key, player.ControllerIndex) then
                data.CelesteDashDir = dir.vec
                data.CelesteDashTimer = DASH_DURATION
                player:SetMinDamageCooldown(30)
                game:ShakeScreen(8)
                break
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, player)
    Celeste:OnPlayerEffectUpdate(player)
    Celeste:PlayerDashUpdate(player)
end)

return Celeste