local f = CreateFrame("Frame", "ManaTickTurtle", PlayerFrameManaBar)
f:SetFrameStrata("HIGH")
local spark = f:CreateTexture(nil, "OVERLAY")
spark: SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
spark:SetBlendMode("ADD")
spark:SetWidth(16); spark:SetHeight(32)

local lastMana, lastHealth = UnitMana("player"), UnitHealth("player")
local lastTick = GetTime() -- tick immediately; lock onto the real server heartbeat on first regen

f:RegisterEvent("PLAYER_LOGIN")
f:RegisterEvent("UNIT_MANA")
f:RegisterEvent("UNIT_HEALTH")
f:RegisterEvent("UNIT_RAGE")
f:RegisterEvent("UNIT_ENERGY")
f:SetScript("OnEvent", function()
	if event == "PLAYER_LOGIN" then
		lastMana = UnitMana("player")
		lastHealth = UnitHealth("player")
		return
	end
	if arg1 ~= "player" then return end

	local mana, hp = UnitMana("player"), UnitHealth("player")
	if mana > lastMana or hp > lastHealth then
		lastTick = GetTime()
	end
	lastMana, lastHealth = mana, hp
end)

f:SetScript("OnUpdate", function()
	local now = GetTime()
	local p = math.mod(now - lastTick, 2) / 2
	spark:SetPoint("CENTER", PlayerFrameManaBar, "LEFT",
		PlayerFrameManaBar:GetWidth() * p, 0)
	spark:Show()
end)
