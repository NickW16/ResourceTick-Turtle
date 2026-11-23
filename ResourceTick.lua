local f = CreateFrame("Frame", "ManaTickTurtle", PlayerFrameManaBar)
f:SetFrameStrata("HIGH")
local spark = f:CreateTexture(nil, "OVERLAY")
spark: SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
spark:SetBlendMode("ADD")
spark:SetWidth(16); spark:SetHeight(32)
local label = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
label:SetPoint("LEFT", PlayerFrameManaBar, "RIGHT", 5, -2)

local lastMana, lastTick, labelUntil = UnitMana("player"), 0, 0
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function(_, event)
	if event == "PLAYER_LOGIN" then
		lastMana = UnitMana("Player")
		return
	end
	if event ~= "UNIT_MANA" or arg1 ~= "player" then return end
end)

f:RegisterEvent("UNIT_MANA")
f:SetScript("OnEvent", function()
	if arg1 ~= "player" then return end
	local mana = UnitMana("player")
	if mana > lastMana then
		lastTick = GetTime()
		label:SetText("|cff66ccff+" .. (mana - lastMana) .. "|r")
		labelUntil = lastTick + 1.5
	end
	lastMana = mana
end)

f:SetScript("OnUpdate", function()
	local now = GetTime()
	if lastTick > 0 then
		local p = math.mod(now - lastTick, 2) / 2
		spark:SetPoint("CENTER", PlayerFrameManaBar, "LEFT", PlayerFrameManaBar:GetWidth() * p, 0)
		spark:Show()
	end
	if labelUntil > 0 then
		if now > labelUntil then label:Hide(); labelUntil = 0
		else label:SetAlpha(math.min(1, (labelUntil - now) * 2)); label:Show() end
	end
end)
