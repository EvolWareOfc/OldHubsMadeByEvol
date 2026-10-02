local L_1_ = game:GetService("Players")
local L_2_ = game:GetService("UserInputService")
local L_3_ = game:GetService("Lighting")
local L_4_ = game:GetService("RunService")
local L_5_ = game:GetService("HttpService")
local L_6_ = game:GetService("Workspace")
local L_7_ = game:GetService("CollectionService")
local L_8_ = game:GetService("CoreGui")
local L_9_ = L_1_.LocalPlayer
local L_10_ = L_6_.CurrentCamera
local L_11_ = L_9_:GetMouse()

----------------------------------------------------------------
-- CONFIG
----------------------------------------------------------------
local L_12_ = {
	ESP = false,
    -- Players
	Chams = false,
	ChamsVisCheck = false,
	Box = false,
	BoxStyle = "Corner",
	Skeleton = false,
	Tracers = false,
	TracerOrigin = "Bottom",
	HeadDot = false,
	Facing = false,
	ShowName = false,
	ShowDistance = false,
	ShowHealth = false,
	ShowHealthBar = false,
	ShowWeapon = false,
	ShowArmor = false,
	ShowBackpack = false,
	ShowState = false,
	SquadCheck = false,
	OffScreen = false,
	Optimised = false,
	DistFade = false,
	WeaponColors = false,
	MinDist = 0,
	MaxDist = 5000,
    -- World
	ZombieESP = false,
	ZombieChams = false,
	VehicleESP = false,
	VehicleOccupancy = false,
	CorpseESP = false,
	CorpseGear = false,
	FuelESP = false,
    -- Loot
	LootESP = false,
	LootMaxDist = 400,
	LootWeapons = false,
	LootAmmo = false,
	LootMedical = false,
	LootFood = false,
	LootClothing = false,
	LootOther = false,
	LootIgnoreJunk = true,
    -- Env
	Fullbright = false,
	NoFog = false,
}
local L_13_ = {
	"Medkit",
	"M4",
	"AK",
	"Energy Drink",
	"Military",
	"Tactical"
}
local L_14_ = "bscripts_ar2_v42.json"
local function L_15_func()
	if writefile then
		pcall(function()
			writefile(L_14_, L_5_:JSONEncode(L_12_))
		end)
	end
end
local function L_16_func()
	if not (readfile and isfile and isfile(L_14_)) then
		return
	end
	local L_130_, L_131_ = pcall(function()
		return L_5_:JSONDecode(readfile(L_14_))
	end)
	if L_130_ and type(L_131_) == "table" then
		for L_132_forvar0, L_133_forvar1 in pairs(L_131_) do
			if L_12_[L_132_forvar0] ~= nil and type(L_12_[L_132_forvar0]) == type(L_133_forvar1) then
				L_12_[L_132_forvar0] = L_133_forvar1
			end
		end
	end
end
L_16_func()

----------------------------------------------------------------
-- FOLDERS / HELPERS
----------------------------------------------------------------
for L_134_forvar0, L_135_forvar1 in ipairs({
	L_8_,
	L_9_:FindFirstChild("PlayerGui")
}) do
	if L_135_forvar1 then
		local L_136_ = L_135_forvar1:FindFirstChild("bScriptsAR2_HL")
		if L_136_ then
			pcall(function()
				L_136_:Destroy()
			end)
		end
	end
end
local L_17_ = Instance.new("Folder")
L_17_.Name = "bScriptsAR2_HL"
pcall(function()
	L_17_.Parent = L_8_
end)
if not L_17_.Parent then
	L_17_.Parent = L_9_:WaitForChild("PlayerGui")
end
local function L_18_func()
	return L_6_:FindFirstChild("Characters")
end
local function L_19_func()
	return L_6_:FindFirstChild("Zombies")
end
local function L_20_func()
	return L_6_:FindFirstChild("Vehicles")
end
local function L_21_func()
	return L_6_:FindFirstChild("Corpses")
end
local function L_22_func(L_137_arg0)
	if not L_137_arg0 then
		return nil
	end
	return L_137_arg0:FindFirstChild("HumanoidRootPart") or L_137_arg0:FindFirstChild("UpperTorso") or L_137_arg0:FindFirstChild("Torso") or L_137_arg0:FindFirstChild("Head") or L_137_arg0:FindFirstChildWhichIsA("BasePart")
end
local function L_23_func(L_138_arg0)
	return L_138_arg0 and L_138_arg0:FindFirstChildOfClass("Humanoid")
end
local function L_24_func(L_139_arg0, L_140_arg1)
	return L_139_arg0 and L_139_arg0:FindFirstChild(L_140_arg1)
end
local L_25_ = nil
local function L_26_func()
	local L_141_ = L_10_ and L_10_.CameraSubject
	if L_141_ then
		if L_141_:IsA("Humanoid") and L_141_.Parent and L_141_.Parent:IsA("Model") then
			L_25_ = L_141_.Parent
			return L_25_
		end
		if L_141_:IsA("BasePart") then
			local L_142_ = L_141_:FindFirstAncestorOfClass("Model")
			if L_142_ and L_18_func() and L_142_.Parent == L_18_func() then
				L_25_ = L_142_
				return L_25_
			end
		end
	end
	if L_9_.Character and L_22_func(L_9_.Character) then
		L_25_ = L_9_.Character
	end
	return L_25_
end

----------------------------------------------------------------
-- ITEM / GEAR HELPERS
----------------------------------------------------------------
local function L_27_func(L_143_arg0)
	if not L_143_arg0 then
		return "Unarmed", "none"
	end
	local L_144_ = L_143_arg0:FindFirstChild("Animator")
	if L_144_ then
		local L_145_ = L_144_:FindFirstChild("EquippedItem")
		if L_145_ and L_145_:IsA("StringValue") and L_145_.Value ~= "" and L_145_.Value ~= "[]" then
			local L_146_, L_147_ = pcall(function()
				return L_5_:JSONDecode(L_145_.Value)
			end)
			if L_146_ and type(L_147_) == "table" and L_147_.ItemName then
				local L_149_ = tostring(L_147_.ItemName)
				return L_149_, weaponCategory(L_149_)
			end
			local L_148_ = L_145_.Value:match('"ItemName"%s*:%s*"([^"]+)"')
			if L_148_ then
				return L_148_, weaponCategory(L_148_)
			end
		end
	end
	return "Unarmed", "none"
end
function weaponCategory(L_150_arg0)
	if not L_150_arg0 or L_150_arg0 == "Unarmed" then
		return "none"
	end
	local L_151_ = L_150_arg0:lower()
	if L_151_:find("knife") or L_151_:find("machete") or L_151_:find("bat") or L_151_:find("axe") or L_151_:find("crowbar") then
		return "melee"
	end
	if L_151_:find("med") or L_151_:find("bandage") or L_151_:find("drink") or L_151_:find("food") then
		return "util"
	end
    -- guns
	return "gun"
end
local function L_28_func(L_152_arg0, L_153_arg1)
	local L_154_ = L_152_arg0 and L_152_arg0:FindFirstChild("Equipment")
	if not L_154_ then
		return nil
	end
	for L_155_forvar0, L_156_forvar1 in ipairs(L_154_:GetChildren()) do
		if L_156_forvar1:GetAttribute("EquipSlot") == L_153_arg1 then
			return L_156_forvar1:GetAttribute("ItemName") or L_156_forvar1.Name
		end
		if L_153_arg1 == "Vest" and L_156_forvar1.Name:find("Vest") then
			return L_156_forvar1:GetAttribute("ItemName") or L_156_forvar1.Name
		end
		if L_153_arg1 == "Backpack" and L_156_forvar1.Name:find("Backpack") then
			return L_156_forvar1:GetAttribute("ItemName") or L_156_forvar1.Name
		end
	end
	return nil
end
local function L_29_func(L_157_arg0)
	local L_158_ = L_23_func(L_157_arg0)
	if not L_158_ then
		return "?"
	end
	if L_158_.Health <= 0 then
		return "Dead"
	end
	local L_159_ = L_158_:GetState()
	if L_159_ == Enum.HumanoidStateType.Dead then
		return "Dead"
	end
	if L_159_ == Enum.HumanoidStateType.FallingDown or L_159_ == Enum.HumanoidStateType.Ragdoll then
		return "Down"
	end
	if L_159_ == Enum.HumanoidStateType.Seated then
		return "Seat"
	end
	if L_158_.MoveDirection.Magnitude > 0.1 then
		return "Move"
	end
	return "Idle"
end
local function L_30_func(L_160_arg0)
	if not L_160_arg0 then
		return "?"
	end
	for L_162_forvar0, L_163_forvar1 in ipairs({
		"PlayerName",
		"Username",
		"DisplayName",
		"UseText"
	}) do
		local L_164_ = L_160_arg0:GetAttribute(L_163_forvar1)
		if type(L_164_) == "string" and L_164_ ~= "" and L_164_ ~= L_160_arg0.Name then
			return L_164_
		end
	end
	for L_165_forvar0, L_166_forvar1 in ipairs(L_160_arg0:GetDescendants()) do
		if L_166_forvar1:IsA("TextLabel") and (L_166_forvar1.Name == "NameLabel" or L_166_forvar1.Name == "Name") then
			if L_166_forvar1.Text ~= "" and # L_166_forvar1.Text < 28 then
				return L_166_forvar1.Text
			end
		end
	end
	local L_161_ = L_160_arg0.Name
	if # L_161_ == 36 and L_161_:find("-") then
		return L_161_:sub(1, 8)
	end
	return L_161_
end

-- Loot category from name
local function L_31_func(L_167_arg0)
	if not L_167_arg0 then
		return "other"
	end
	local L_168_ = L_167_arg0:lower()
	if L_168_:find("magazine") or L_168_:find("rd ") or L_168_:find("ammo") or L_168_:find("round") then
		return "ammo"
	end
	if L_168_:find("medkit") or L_168_:find("bandage") or L_168_:find("morphine") or L_168_:find("blood") or L_168_:find("splint") or L_168_:find("pain") then
		return "medical"
	end
	if L_168_:find("drink") or L_168_:find("food") or L_168_:find("beans") or L_168_:find("water") or L_168_:find("soda") or L_168_:find("mre") or L_168_:find("can") or L_168_:find("energy") then
		return "food"
	end
	if L_168_:find("vest") or L_168_:find("backpack") or L_168_:find("hat") or L_168_:find("shirt") or L_168_:find("pants") or L_168_:find("mask") or L_168_:find("belt") or L_168_:find("accessory") or L_168_:find("jacket") then
		return "clothing"
	end
	if L_168_:find("ak") or L_168_:find("m4") or L_168_:find("rifle") or L_168_:find("pistol") or L_168_:find("shotgun") or L_168_:find("smg") or L_168_:find("sniper") or L_168_:find("gun") or L_168_:find("svt") or L_168_:find("tec") or L_168_:find("glock") or L_168_:find("uzi") or L_168_:find("thompson") or L_168_:find("suppressor") or L_168_:find("sight") or L_168_:find("barrel") then
		return "weapon"
	end
	return "other"
end
local L_32_ = {
	Magazine = true,
	Base = true,
	Action = true,
	BarrelMount = true,
	Constant = true,
}
local function L_33_func(L_169_arg0)
	if not L_169_arg0 then
		return true
	end
	if L_32_[L_169_arg0] then
		return true
	end
	if # L_169_arg0 < 4 then
		return true
	end
	return false
end
local function L_34_func(L_170_arg0)
	if not L_170_arg0 then
		return false
	end
	for L_171_forvar0, L_172_forvar1 in ipairs(L_13_) do
		if L_170_arg0:lower():find(L_172_forvar1:lower(), 1, true) then
			return true
		end
	end
	return false
end

----------------------------------------------------------------
-- SQUAD
----------------------------------------------------------------
local L_35_ = {}
task.spawn(function()
	while true do
		local L_173_ = {}
		local L_174_ = L_9_:FindFirstChild("PlayerGui")
		if L_174_ then
			local function L_175_func(L_176_arg0, L_177_arg1)
				if L_177_arg1 > 12 then
					return
				end
				if L_176_arg0:IsA("TextLabel") and (L_176_arg0.Name == "NameLabel" or L_176_arg0.Name == "Name") then
					local L_178_ = L_176_arg0.Text
					if L_178_ and L_178_ ~= "" and L_178_ ~= L_9_.Name then
						L_173_[L_178_] = true
					end
				end
				for L_179_forvar0, L_180_forvar1 in ipairs(L_176_arg0:GetChildren()) do
					L_175_func(L_180_forvar1, L_177_arg1 + 1)
				end
			end
			for L_181_forvar0, L_182_forvar1 in ipairs({
				"PlayerList",
				"SquadList",
				"HUD",
				"Main",
				"Interface"
			}) do
				local L_183_ = L_174_:FindFirstChild(L_182_forvar1, true)
				if L_183_ then
					L_175_func(L_183_, 0)
				end
			end
		end
		L_35_ = L_173_
		task.wait(2)
	end
end)

----------------------------------------------------------------
-- VISIBILITY
----------------------------------------------------------------
local L_36_, L_37_ = {}, 0
local function L_38_func(L_184_arg0, L_185_arg1)
	if not L_185_arg1 then
		return false
	end
	local L_186_ = L_10_.CFrame.Position
	local L_187_ = RaycastParams.new()
	local L_188_ = {
		L_184_arg0
	}
	if L_25_ then
		table.insert(L_188_, L_25_)
	end
	local L_189_ = L_18_func()
	if L_189_ then
		for L_191_forvar0, L_192_forvar1 in ipairs(L_189_:GetChildren()) do
			table.insert(L_188_, L_192_forvar1)
		end
	end
	local L_190_ = L_19_func()
	if L_190_ then
		table.insert(L_188_, L_190_)
	end
	L_187_.FilterDescendantsInstances = L_188_
	L_187_.FilterType = Enum.RaycastFilterType.Exclude
	return L_6_:Raycast(L_186_, L_185_arg1.Position - L_186_, L_187_) == nil
end

----------------------------------------------------------------
-- DRAWING
----------------------------------------------------------------
local function L_39_func(L_193_arg0)
	local L_194_, L_195_ = pcall(function()
		local L_196_ = Drawing.new("Line")
		L_196_.Thickness = L_193_arg0 or 1
		L_196_.Visible = false
		return L_196_
	end)
	return L_194_ and L_195_ or nil
end
local function L_40_func(L_197_arg0)
	local L_198_, L_199_ = pcall(function()
		local L_200_ = Drawing.new("Text")
		L_200_.Size = L_197_arg0 or 13
		L_200_.Center = true
		L_200_.Outline = true
		L_200_.OutlineColor = Color3.new(0, 0, 0)
		L_200_.Font = Drawing.Fonts.Plex
		L_200_.Visible = false
		return L_200_
	end)
	return L_198_ and L_199_ or nil
end
local function L_41_func()
	local L_201_, L_202_ = pcall(function()
		local L_203_ = Drawing.new("Circle")
		L_203_.Thickness = 1
		L_203_.NumSides = 12
		L_203_.Filled = true
		L_203_.Visible = false
		return L_203_
	end)
	return L_201_ and L_202_ or nil
end
local function L_42_func()
	local L_204_, L_205_ = pcall(function()
		local L_206_ = Drawing.new("Triangle")
		L_206_.Filled = true
		L_206_.Visible = false
		return L_206_
	end)
	return L_204_ and L_205_ or nil
end
local function L_43_func(L_207_arg0)
	if not L_207_arg0 then
		return
	end
	for L_208_forvar0, L_209_forvar1 in ipairs(L_207_arg0) do
		if L_209_forvar1 then
			L_209_forvar1.Visible = false
		end
	end
end
local function L_44_func(L_210_arg0, L_211_arg1, L_212_arg2, L_213_arg3, L_214_arg4)
	if not L_210_arg0 then
		return
	end
	L_210_arg0.From, L_210_arg0.To, L_210_arg0.Color, L_210_arg0.Thickness, L_210_arg0.Visible = L_211_arg1, L_212_arg2, L_213_arg3, L_214_arg4 or 1.5, true
end
local function L_45_func()
	local L_215_ = {}
	for L_216_forvar0 = 1, 12 do
		L_215_[L_216_forvar0] = L_39_func(1.5)
	end
	return L_215_
end
local function L_46_func(L_217_arg0)
	if not L_217_arg0 then
		return nil
	end
	local L_218_ = L_10_:WorldToViewportPoint(L_217_arg0.Position + Vector3.new(0, 3, 0))
	local L_219_ = L_10_:WorldToViewportPoint(L_217_arg0.Position - Vector3.new(0, 3, 0))
	if L_218_.Z < 0 or L_219_.Z < 0 then
		return nil
	end
	local L_220_ = math.abs(L_218_.Y - L_219_.Y)
	local L_221_ = L_220_ * 0.55
	return L_218_.X - L_221_ / 2, math.min(L_218_.Y, L_219_.Y), L_221_, L_220_
end
local function L_47_func(L_222_arg0, L_223_arg1, L_224_arg2, L_225_arg3, L_226_arg4, L_227_arg5, L_228_arg6)
	local L_229_ = math.min(L_225_arg3, L_226_arg4) * 0.25
	L_44_func(L_222_arg0[1], Vector2.new(L_223_arg1, L_224_arg2), Vector2.new(L_223_arg1 + L_229_, L_224_arg2), L_227_arg5, L_228_arg6)
	L_44_func(L_222_arg0[2], Vector2.new(L_223_arg1, L_224_arg2), Vector2.new(L_223_arg1, L_224_arg2 + L_229_), L_227_arg5, L_228_arg6)
	L_44_func(L_222_arg0[3], Vector2.new(L_223_arg1 + L_225_arg3, L_224_arg2), Vector2.new(L_223_arg1 + L_225_arg3 - L_229_, L_224_arg2), L_227_arg5, L_228_arg6)
	L_44_func(L_222_arg0[4], Vector2.new(L_223_arg1 + L_225_arg3, L_224_arg2), Vector2.new(L_223_arg1 + L_225_arg3, L_224_arg2 + L_229_), L_227_arg5, L_228_arg6)
	L_44_func(L_222_arg0[5], Vector2.new(L_223_arg1, L_224_arg2 + L_226_arg4), Vector2.new(L_223_arg1 + L_229_, L_224_arg2 + L_226_arg4), L_227_arg5, L_228_arg6)
	L_44_func(L_222_arg0[6], Vector2.new(L_223_arg1, L_224_arg2 + L_226_arg4), Vector2.new(L_223_arg1, L_224_arg2 + L_226_arg4 - L_229_), L_227_arg5, L_228_arg6)
	L_44_func(L_222_arg0[7], Vector2.new(L_223_arg1 + L_225_arg3, L_224_arg2 + L_226_arg4), Vector2.new(L_223_arg1 + L_225_arg3 - L_229_, L_224_arg2 + L_226_arg4), L_227_arg5, L_228_arg6)
	L_44_func(L_222_arg0[8], Vector2.new(L_223_arg1 + L_225_arg3, L_224_arg2 + L_226_arg4), Vector2.new(L_223_arg1 + L_225_arg3, L_224_arg2 + L_226_arg4 - L_229_), L_227_arg5, L_228_arg6)
	for L_230_forvar0 = 9, 12 do
		if L_222_arg0[L_230_forvar0] then
			L_222_arg0[L_230_forvar0].Visible = false
		end
	end
end
local function L_48_func(L_231_arg0, L_232_arg1, L_233_arg2, L_234_arg3, L_235_arg4, L_236_arg5, L_237_arg6)
	L_44_func(L_231_arg0[1], Vector2.new(L_232_arg1, L_233_arg2), Vector2.new(L_232_arg1 + L_234_arg3, L_233_arg2), L_236_arg5, L_237_arg6)
	L_44_func(L_231_arg0[2], Vector2.new(L_232_arg1, L_233_arg2 + L_235_arg4), Vector2.new(L_232_arg1 + L_234_arg3, L_233_arg2 + L_235_arg4), L_236_arg5, L_237_arg6)
	L_44_func(L_231_arg0[3], Vector2.new(L_232_arg1, L_233_arg2), Vector2.new(L_232_arg1, L_233_arg2 + L_235_arg4), L_236_arg5, L_237_arg6)
	L_44_func(L_231_arg0[4], Vector2.new(L_232_arg1 + L_234_arg3, L_233_arg2), Vector2.new(L_232_arg1 + L_234_arg3, L_233_arg2 + L_235_arg4), L_236_arg5, L_237_arg6)
	for L_238_forvar0 = 5, 12 do
		if L_231_arg0[L_238_forvar0] then
			L_231_arg0[L_238_forvar0].Visible = false
		end
	end
end
local function L_49_func(L_239_arg0, L_240_arg1, L_241_arg2, L_242_arg3)
	local L_243_ = L_240_arg1.CFrame
	local L_244_, L_245_, L_246_ = 1.1, 2.6, 0.6
	local L_247_ = {
		Vector3.new(- L_244_, - L_245_, - L_246_),
		Vector3.new(L_244_, - L_245_, - L_246_),
		Vector3.new(L_244_, - L_245_, L_246_),
		Vector3.new(- L_244_, - L_245_, L_246_),
		Vector3.new(- L_244_, L_245_, - L_246_),
		Vector3.new(L_244_, L_245_, - L_246_),
		Vector3.new(L_244_, L_245_, L_246_),
		Vector3.new(- L_244_, L_245_, L_246_),
	}
	local L_248_ = {}
	for L_249_forvar0, L_250_forvar1 in ipairs(L_247_) do
		local L_251_, L_252_ = L_10_:WorldToViewportPoint(L_243_:PointToWorldSpace(L_250_forvar1))
		if not L_252_ or L_251_.Z < 0 then
			L_43_func(L_239_arg0)
			return
		end
		L_248_[L_249_forvar0] = Vector2.new(L_251_.X, L_251_.Y)
	end
	L_44_func(L_239_arg0[1], L_248_[1], L_248_[2], L_241_arg2, L_242_arg3)
	L_44_func(L_239_arg0[2], L_248_[2], L_248_[3], L_241_arg2, L_242_arg3)
	L_44_func(L_239_arg0[3], L_248_[3], L_248_[4], L_241_arg2, L_242_arg3)
	L_44_func(L_239_arg0[4], L_248_[4], L_248_[1], L_241_arg2, L_242_arg3)
	L_44_func(L_239_arg0[5], L_248_[5], L_248_[6], L_241_arg2, L_242_arg3)
	L_44_func(L_239_arg0[6], L_248_[6], L_248_[7], L_241_arg2, L_242_arg3)
	L_44_func(L_239_arg0[7], L_248_[7], L_248_[8], L_241_arg2, L_242_arg3)
	L_44_func(L_239_arg0[8], L_248_[8], L_248_[5], L_241_arg2, L_242_arg3)
	L_44_func(L_239_arg0[9], L_248_[1], L_248_[5], L_241_arg2, L_242_arg3)
	L_44_func(L_239_arg0[10], L_248_[2], L_248_[6], L_241_arg2, L_242_arg3)
	L_44_func(L_239_arg0[11], L_248_[3], L_248_[7], L_241_arg2, L_242_arg3)
	L_44_func(L_239_arg0[12], L_248_[4], L_248_[8], L_241_arg2, L_242_arg3)
end
local L_50_ = {
	{
		"Head",
		"UpperTorso"
	},
	{
		"UpperTorso",
		"LowerTorso"
	},
	{
		"UpperTorso",
		"LeftUpperArm"
	},
	{
		"LeftUpperArm",
		"LeftLowerArm"
	},
	{
		"LeftLowerArm",
		"LeftHand"
	},
	{
		"UpperTorso",
		"RightUpperArm"
	},
	{
		"RightUpperArm",
		"RightLowerArm"
	},
	{
		"RightLowerArm",
		"RightHand"
	},
	{
		"LowerTorso",
		"LeftUpperLeg"
	},
	{
		"LeftUpperLeg",
		"LeftLowerLeg"
	},
	{
		"LeftLowerLeg",
		"LeftFoot"
	},
	{
		"LowerTorso",
		"RightUpperLeg"
	},
	{
		"RightUpperLeg",
		"RightLowerLeg"
	},
	{
		"RightLowerLeg",
		"RightFoot"
	},
	{
		"Head",
		"Torso"
	},
	{
		"Torso",
		"Left Arm"
	},
	{
		"Torso",
		"Right Arm"
	},
	{
		"Torso",
		"Left Leg"
	},
	{
		"Torso",
		"Right Leg"
	},
}
local function L_51_func()
	local L_253_ = {}
	for L_254_forvar0 = 1, # L_50_ do
		L_253_[L_254_forvar0] = L_39_func(1.2)
	end
	return L_253_
end
local function L_52_func(L_255_arg0, L_256_arg1, L_257_arg2, L_258_arg3)
	for L_259_forvar0, L_260_forvar1 in ipairs(L_50_) do
		local L_261_, L_262_ = L_24_func(L_256_arg1, L_260_forvar1[1]), L_24_func(L_256_arg1, L_260_forvar1[2])
		if L_261_ and L_262_ and L_261_:IsA("BasePart") and L_262_:IsA("BasePart") then
			local L_263_, L_264_ = L_10_:WorldToViewportPoint(L_261_.Position)
			local L_265_, L_266_ = L_10_:WorldToViewportPoint(L_262_.Position)
			if L_264_ and L_266_ and L_263_.Z > 0 and L_265_.Z > 0 then
				L_44_func(L_255_arg0[L_259_forvar0], Vector2.new(L_263_.X, L_263_.Y), Vector2.new(L_265_.X, L_265_.Y), L_257_arg2, L_258_arg3)
			elseif L_255_arg0[L_259_forvar0] then
				L_255_arg0[L_259_forvar0].Visible = false
			end
		elseif L_255_arg0[L_259_forvar0] then
			L_255_arg0[L_259_forvar0].Visible = false
		end
	end
end
local function L_53_func()
	return {
		bg = L_39_func(4),
		fill = L_39_func(3)
	}
end
local function L_54_func(L_267_arg0, L_268_arg1, L_269_arg2, L_270_arg3, L_271_arg4, L_272_arg5)
	if not L_267_arg0 or not L_267_arg0.bg then
		return
	end
	local L_273_ = math.clamp(L_271_arg4 / math.max(L_272_arg5, 1), 0, 1)
	local L_274_ = Color3.fromRGB(math.floor(255 * (1 - L_273_)), math.floor(255 * L_273_), 40)
	L_44_func(L_267_arg0.bg, Vector2.new(L_268_arg1 - 6, L_269_arg2), Vector2.new(L_268_arg1 - 6, L_269_arg2 + L_270_arg3), Color3.fromRGB(20, 20, 20), 4)
	L_44_func(L_267_arg0.fill, Vector2.new(L_268_arg1 - 6, L_269_arg2 + L_270_arg3 - L_270_arg3 * L_273_), Vector2.new(L_268_arg1 - 6, L_269_arg2 + L_270_arg3), L_274_, 3)
end
local function L_55_func(L_275_arg0, L_276_arg1, L_277_arg2)
	if not L_275_arg0 then
		return
	end
	local L_278_, L_279_ = L_10_:WorldToViewportPoint(L_276_arg1)
	local L_280_, L_281_ = L_10_.ViewportSize.X, L_10_.ViewportSize.Y
	if L_279_ and L_278_.Z > 0 and L_278_.X > 25 and L_278_.X < L_280_ - 25 and L_278_.Y > 25 and L_278_.Y < L_281_ - 25 then
		L_275_arg0.Visible = false
		return
	end
	local L_282_ = Vector2.new(L_278_.X - L_280_ / 2, L_278_.Y - L_281_ / 2)
	if L_278_.Z < 0 then
		L_282_ = - L_282_
	end
	local L_283_ = math.max(L_282_.Magnitude, 1)
	L_282_ = L_282_ / L_283_
	local L_284_ = Vector2.new(L_280_ / 2, L_281_ / 2) + L_282_ * (math.min(L_280_, L_281_) * 0.42)
	local L_285_ = math.atan2(L_282_.Y, L_282_.X)
	local L_286_ = 10
	L_275_arg0.PointA = L_284_
	L_275_arg0.PointB = L_284_ + Vector2.new(math.cos(L_285_ + 2.5) * L_286_, math.sin(L_285_ + 2.5) * L_286_)
	L_275_arg0.PointC = L_284_ + Vector2.new(math.cos(L_285_ - 2.5) * L_286_, math.sin(L_285_ - 2.5) * L_286_)
	L_275_arg0.Color = L_277_arg2
	L_275_arg0.Visible = true
end
local function L_56_func(L_287_arg0, L_288_arg1, L_289_arg2)
	local L_290_ = Instance.new("BillboardGui")
	L_290_.AlwaysOnTop = true
	L_290_.Size = UDim2.new(0, 180, 0, 48)
	L_290_.StudsOffset = Vector3.new(0, 3.2, 0)
	L_290_.MaxDistance = 6000
	L_290_.Adornee = L_287_arg0
	L_290_.Parent = L_17_
	local L_291_ = Instance.new("TextLabel")
	L_291_.BackgroundTransparency = 1
	L_291_.Size = UDim2.new(1, 0, 1, 0)
	L_291_.Font = Enum.Font.GothamBold
	L_291_.TextSize = 13
	L_291_.TextColor3 = L_289_arg2 or Color3.fromRGB(255, 80, 80)
	L_291_.TextStrokeTransparency = 0.3
	L_291_.Text = L_288_arg1
	L_291_.TextWrapped = true
	L_291_.Parent = L_290_
	return L_290_, L_291_
end
local function L_57_func(L_292_arg0, L_293_arg1)
	local L_294_ = math.clamp(L_292_arg0 / L_293_arg1, 0, 1)
    -- near = warmer red, far = cooler
	return Color3.fromRGB(
        math.floor(255 * (1 - L_294_ * 0.3)), math.floor(80 + 100 * L_294_), math.floor(60 + 40 * L_294_))
end
local L_58_ = Color3.fromRGB(255, 60, 60)
local L_59_ = Color3.fromRGB(0, 255, 100)
local L_60_ = Color3.fromRGB(50, 150, 255)
local L_61_ = Color3.fromRGB(255, 180, 40)
local L_62_ = Color3.fromRGB(200, 200, 200)
local L_63_ = {
	weapon = Color3.fromRGB(255, 80, 80),
	ammo = Color3.fromRGB(255, 200, 60),
	medical = Color3.fromRGB(80, 220, 120),
	food = Color3.fromRGB(100, 180, 255),
	clothing = Color3.fromRGB(200, 140, 255),
	other = Color3.fromRGB(180, 180, 180),
}

----------------------------------------------------------------
-- DATA
----------------------------------------------------------------
local L_64_, L_65_, L_66_, L_67_, L_68_, L_69_ = {}, {}, {}, {}, {}, {}
local function L_70_func(L_295_arg0)
	local L_296_ = L_64_[L_295_arg0]
	if not L_296_ then
		return
	end
	if L_296_.highlight then
		pcall(function()
			L_296_.highlight:Destroy()
		end)
	end
	if L_296_.billboard then
		pcall(function()
			L_296_.billboard:Destroy()
		end)
	end
	if L_296_.box then
		L_43_func(L_296_.box)
		for L_297_forvar0, L_298_forvar1 in ipairs(L_296_.box) do
			pcall(function()
				if L_298_forvar1 then
					L_298_forvar1:Remove()
				end
			end)
		end
	end
	if L_296_.skel then
		L_43_func(L_296_.skel)
		for L_299_forvar0, L_300_forvar1 in ipairs(L_296_.skel) do
			pcall(function()
				if L_300_forvar1 then
					L_300_forvar1:Remove()
				end
			end)
		end
	end
	if L_296_.tracer then
		pcall(function()
			if L_296_.tracer then
				L_296_.tracer:Remove()
			end
		end)
	end
	if L_296_.text then
		pcall(function()
			if L_296_.text then
				L_296_.text:Remove()
			end
		end)
	end
	if L_296_.text2 then
		pcall(function()
			if L_296_.text2 then
				L_296_.text2:Remove()
			end
		end)
	end
	if L_296_.hpBar then
		pcall(function()
			if L_296_.hpBar.bg then
				L_296_.hpBar.bg:Remove()
			end
		end)
		pcall(function()
			if L_296_.hpBar.fill then
				L_296_.hpBar.fill:Remove()
			end
		end)
	end
	if L_296_.arrow then
		pcall(function()
			if L_296_.arrow then
				L_296_.arrow:Remove()
			end
		end)
	end
	if L_296_.headDot then
		pcall(function()
			if L_296_.headDot then
				L_296_.headDot:Remove()
			end
		end)
	end
	if L_296_.facing then
		pcall(function()
			if L_296_.facing then
				L_296_.facing:Remove()
			end
		end)
	end
	L_64_[L_295_arg0] = nil
	L_36_[L_295_arg0] = nil
end
local function L_71_func(L_301_arg0)
	if not L_301_arg0 then
		return
	end
	if L_301_arg0.highlight then
		L_301_arg0.highlight.Enabled = false
	end
	if L_301_arg0.billboard then
		L_301_arg0.billboard.Enabled = false
	end
	if L_301_arg0.box then
		L_43_func(L_301_arg0.box)
	end
	if L_301_arg0.skel then
		L_43_func(L_301_arg0.skel)
	end
	if L_301_arg0.tracer then
		L_301_arg0.tracer.Visible = false
	end
	if L_301_arg0.text then
		L_301_arg0.text.Visible = false
	end
	if L_301_arg0.text2 then
		L_301_arg0.text2.Visible = false
	end
	if L_301_arg0.hpBar then
		if L_301_arg0.hpBar.bg then
			L_301_arg0.hpBar.bg.Visible = false
		end
		if L_301_arg0.hpBar.fill then
			L_301_arg0.hpBar.fill.Visible = false
		end
	end
	if L_301_arg0.arrow then
		L_301_arg0.arrow.Visible = false
	end
	if L_301_arg0.headDot then
		L_301_arg0.headDot.Visible = false
	end
	if L_301_arg0.facing then
		L_301_arg0.facing.Visible = false
	end
end
local function L_72_func()
	for L_302_forvar0, L_303_forvar1 in pairs(L_64_) do
		L_71_func(L_303_forvar1)
	end
	for L_304_forvar0, L_305_forvar1 in pairs(L_65_) do
		if L_305_forvar1.highlight then
			L_305_forvar1.highlight.Enabled = false
		end
		if L_305_forvar1.billboard then
			L_305_forvar1.billboard.Enabled = false
		end
	end
	for L_306_forvar0, L_307_forvar1 in pairs(L_66_) do
		if L_307_forvar1.billboard then
			L_307_forvar1.billboard.Enabled = false
		end
	end
	for L_308_forvar0, L_309_forvar1 in pairs(L_67_) do
		if L_309_forvar1.highlight then
			L_309_forvar1.highlight.Enabled = false
		end
		if L_309_forvar1.billboard then
			L_309_forvar1.billboard.Enabled = false
		end
	end
	for L_310_forvar0, L_311_forvar1 in pairs(L_68_) do
		if L_311_forvar1.billboard then
			L_311_forvar1.billboard.Enabled = false
		end
	end
	for L_312_forvar0, L_313_forvar1 in pairs(L_69_) do
		if L_313_forvar1.billboard then
			L_313_forvar1.billboard.Enabled = false
		end
	end
end
local function L_73_func(L_314_arg0)
	if L_64_[L_314_arg0] or not L_314_arg0 or not L_314_arg0.Parent then
		return
	end
	local L_315_ = L_22_func(L_314_arg0)
	if not L_315_ then
		return
	end
	local L_316_ = Instance.new("Highlight")
	L_316_.FillTransparency = 0.45
	L_316_.OutlineTransparency = 0
	L_316_.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	L_316_.FillColor = L_58_
	L_316_.OutlineColor = L_58_
	L_316_.Adornee = L_314_arg0
	L_316_.Parent = L_17_

    -- Drawing labels only (no Billboard) — stops stacked/overlapping text
	L_64_[L_314_arg0] = {
		highlight = L_316_,
		billboard = nil,
		billboardLabel = nil,
		box = L_45_func(),
		skel = L_51_func(),
		tracer = L_39_func(1),
		text = L_40_func(13),
		text2 = L_40_func(12),
		hpBar = L_53_func(),
		arrow = L_42_func(),
		headDot = L_41_func(),
		facing = L_39_func(1.5),
		hrp = L_315_,
		hum = L_23_func(L_314_arg0),
		model = L_314_arg0,
		name = L_30_func(L_314_arg0),
	}
	if L_64_[L_314_arg0].text2 then
		L_64_[L_314_arg0].text2.Color = L_61_
	end
	local L_317_ = L_64_[L_314_arg0].hum
	if L_317_ then
		L_317_.Died:Connect(function()
			task.delay(0.4, function()
				L_70_func(L_314_arg0)
			end)
		end)
	end
end
local function L_74_func(L_318_arg0)
	local L_319_ = L_65_[L_318_arg0]
	if not L_319_ then
		return
	end
	if L_319_.highlight then
		pcall(function()
			L_319_.highlight:Destroy()
		end)
	end
	if L_319_.billboard then
		pcall(function()
			L_319_.billboard:Destroy()
		end)
	end
	L_65_[L_318_arg0] = nil
end
local function L_75_func(L_320_arg0)
	if L_65_[L_320_arg0] then
		return
	end
	local L_321_ = L_22_func(L_320_arg0)
	if not L_321_ then
		return
	end
	local L_322_
	if L_12_.ZombieChams then
		L_322_ = Instance.new("Highlight")
		L_322_.FillTransparency = 0.5
		L_322_.OutlineTransparency = 0
		L_322_.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		L_322_.FillColor = Color3.fromRGB(180, 40, 255)
		L_322_.OutlineColor = Color3.fromRGB(200, 80, 255)
		L_322_.Adornee = L_320_arg0
		L_322_.Parent = L_17_
	end
	local L_323_, L_324_ = L_56_func(L_321_, L_320_arg0.Name ~= "Infected Civilian" and L_320_arg0.Name or "Infected", Color3.fromRGB(180, 40, 255))
	L_323_.StudsOffset = Vector3.new(0, 2.5, 0)
	L_65_[L_320_arg0] = {
		highlight = L_322_,
		billboard = L_323_,
		billboardLabel = L_324_,
		hrp = L_321_,
		model = L_320_arg0
	}
end
local function L_76_func(L_325_arg0)
	local L_326_ = L_66_[L_325_arg0]
	if not L_326_ then
		return
	end
	if L_326_.billboard then
		pcall(function()
			L_326_.billboard:Destroy()
		end)
	end
	L_66_[L_325_arg0] = nil
end
local function L_77_func(L_327_arg0)
	for L_328_forvar0, L_329_forvar1 in ipairs(L_327_arg0:GetDescendants()) do
		if L_329_forvar1:IsA("VehicleSeat") or L_329_forvar1:IsA("Seat") then
			if L_329_forvar1.Occupant then
				return true
			end
		end
	end
	return false
end
local function L_78_func(L_330_arg0)
	if L_66_[L_330_arg0] then
		return
	end
	local L_331_ = L_330_arg0.PrimaryPart or L_330_arg0:FindFirstChildWhichIsA("BasePart", true)
	if not L_331_ then
		return
	end
	local L_332_, L_333_ = L_56_func(L_331_, "[VEH] " .. L_330_arg0.Name, Color3.fromRGB(255, 180, 40))
	L_332_.StudsOffset = Vector3.new(0, 4, 0)
	L_66_[L_330_arg0] = {
		billboard = L_332_,
		billboardLabel = L_333_,
		part = L_331_,
		model = L_330_arg0
	}
end
local function L_79_func(L_334_arg0)
	local L_335_ = L_67_[L_334_arg0]
	if not L_335_ then
		return
	end
	if L_335_.highlight then
		pcall(function()
			L_335_.highlight:Destroy()
		end)
	end
	if L_335_.billboard then
		pcall(function()
			L_335_.billboard:Destroy()
		end)
	end
	L_67_[L_334_arg0] = nil
end
local function L_80_func(L_336_arg0)
	if L_67_[L_336_arg0] then
		return
	end
	local L_337_ = L_336_arg0:FindFirstChild("HumanoidRootPart") or L_336_arg0:FindFirstChild("Head") or L_336_arg0:FindFirstChildWhichIsA("BasePart")
	if not L_337_ then
		return
	end
	local L_338_ = L_336_arg0:GetAttribute("UseText") or "Corpse"
	local L_339_ = {}
	if L_12_.CorpseGear then
		local L_344_ = L_28_func(L_336_arg0, "Vest")
		local L_345_ = L_28_func(L_336_arg0, "Backpack")
		if L_344_ then
			table.insert(L_339_, L_344_)
		end
		if L_345_ then
			table.insert(L_339_, L_345_)
		end
	end
	local L_340_ = "[CORPSE] " .. tostring(L_338_)
	if # L_339_ > 0 then
		L_340_ = L_340_ .. "\n" .. table.concat(L_339_, " | ")
	end
	local L_341_ = Instance.new("Highlight")
	L_341_.FillTransparency = 0.6
	L_341_.OutlineTransparency = 0.2
	L_341_.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	L_341_.FillColor = Color3.fromRGB(140, 140, 140)
	L_341_.OutlineColor = Color3.fromRGB(200, 200, 200)
	L_341_.Adornee = L_336_arg0
	L_341_.Parent = L_17_
	local L_342_, L_343_ = L_56_func(L_337_, L_340_, Color3.fromRGB(180, 180, 180))
	L_342_.StudsOffset = Vector3.new(0, 2, 0)
	L_67_[L_336_arg0] = {
		highlight = L_341_,
		billboard = L_342_,
		billboardLabel = L_343_,
		part = L_337_,
		model = L_336_arg0,
		name = L_338_
	}
end
local function L_81_func(L_346_arg0)
	local L_347_ = L_68_[L_346_arg0]
	if not L_347_ then
		return
	end
	if L_347_.billboard then
		pcall(function()
			L_347_.billboard:Destroy()
		end)
	end
	L_68_[L_346_arg0] = nil
end
local function L_82_func(L_348_arg0, L_349_arg1)
	if L_68_[L_348_arg0] then
		return
	end
	local L_350_ = L_348_arg0:IsA("BasePart") and L_348_arg0 or (L_348_arg0.PrimaryPart or L_348_arg0:FindFirstChildWhichIsA("BasePart", true))
	if not L_350_ then
		return
	end
	local L_351_ = L_31_func(L_349_arg1)
	local L_352_ = L_34_func(L_349_arg1) and Color3.fromRGB(255, 215, 0) or (L_63_[L_351_] or L_63_.other)
	local L_353_, L_354_ = L_56_func(L_350_, "[LOOT] " .. tostring(L_349_arg1), L_352_)
	L_353_.StudsOffset = Vector3.new(0, 1.5, 0)
	L_353_.MaxDistance = L_12_.LootMaxDist
	L_68_[L_348_arg0] = {
		billboard = L_353_,
		billboardLabel = L_354_,
		part = L_350_,
		model = L_348_arg0,
		name = L_349_arg1,
		cat = L_351_
	}
end
local function L_83_func(L_355_arg0)
	local L_356_ = L_69_[L_355_arg0]
	if not L_356_ then
		return
	end
	if L_356_.billboard then
		pcall(function()
			L_356_.billboard:Destroy()
		end)
	end
	L_69_[L_355_arg0] = nil
end
local function L_84_func(L_357_arg0)
	if L_69_[L_357_arg0] then
		return
	end
	local L_358_ = L_357_arg0:IsA("BasePart") and L_357_arg0 or L_357_arg0:FindFirstChildWhichIsA("BasePart", true)
	if not L_358_ then
		return
	end
	local L_359_, L_360_ = L_56_func(L_358_, "[FUEL]", Color3.fromRGB(255, 140, 40))
	L_359_.StudsOffset = Vector3.new(0, 3, 0)
	L_69_[L_357_arg0] = {
		billboard = L_359_,
		billboardLabel = L_360_,
		part = L_358_,
		model = L_357_arg0
	}
end

----------------------------------------------------------------
-- LOOT DETECTION (spawned only)
----------------------------------------------------------------
local L_85_ = {
	Base = true,
	BarrelMount = true,
	Action = true,
	Magazine = true,
	Constant = true,
	SightMount = true,
	UnderbarrelMount = true,
	Mesh = true,
	Handle = true,
	["1"] = true,
	["2"] = true,
	["3"] = true,
	["4"] = true,
	["5"] = true,
}
local function L_86_func(L_361_arg0)
	if not L_361_arg0 or L_85_[L_361_arg0] or L_361_arg0 == "Model" or L_361_arg0 == "Part" then
		return false
	end
	if # L_361_arg0 < 3 or not L_361_arg0:find("%a") then
		return false
	end
	return true
end
local function L_87_func(L_362_arg0)
	local L_363_ = L_362_arg0:GetAttribute("ItemName")
	if L_363_ and L_363_ ~= "" then
		return tostring(L_363_)
	end
	local L_364_ = nil
	for L_365_forvar0, L_366_forvar1 in ipairs(L_362_arg0:GetChildren()) do
		local L_367_ = L_366_forvar1:GetAttribute("ItemName")
		if L_367_ and L_367_ ~= "" then
			return tostring(L_367_)
		end
		if L_86_func(L_366_forvar1.Name) then
			if not L_364_ or # L_366_forvar1.Name > # L_364_ then
				L_364_ = L_366_forvar1.Name
			end
		end
	end
	return L_364_
end
local function L_88_func(L_368_arg0)
	if not L_368_arg0 or not L_368_arg0:IsA("Model") then
		return false
	end
	if L_368_arg0.Name == "FuelTank1" or L_368_arg0.Name == "FuelPump" then
		return false
	end
	local L_369_ = L_87_func(L_368_arg0)
	if not L_369_ then
		return false
	end
	if L_12_.LootIgnoreJunk and L_33_func(L_369_) then
		return false
	end
	local L_370_ = L_368_arg0:FindFirstChild("Base") ~= nil
	local L_371_ = L_368_arg0:FindFirstChild("BarrelMount") or L_368_arg0:FindFirstChild("Action") or L_368_arg0:FindFirstChild("Magazine")
	if L_370_ or L_371_ then
		return true, L_369_
	end
	local L_372_ = 0
	for L_373_forvar0, L_374_forvar1 in ipairs(L_368_arg0:GetChildren()) do
		if L_374_forvar1:IsA("BasePart") or L_374_forvar1:IsA("MeshPart") then
			L_372_ += 1
		end
	end
	if L_372_ > 0 and L_372_ <= 25 then
		return true, L_369_
	end
	return false
end
local function L_89_func(L_375_arg0)
	if not L_375_arg0 then
		return false
	end
	if L_18_func() and L_375_arg0:IsDescendantOf(L_18_func()) then
		return false
	end
	if L_21_func() and L_375_arg0:IsDescendantOf(L_21_func()) then
		return false
	end
	if L_19_func() and L_375_arg0:IsDescendantOf(L_19_func()) then
		return false
	end
	if L_20_func() and L_375_arg0:IsDescendantOf(L_20_func()) then
		return false
	end
	if L_375_arg0.Name == "LootNode" then
		return false
	end
	if L_7_:HasTag(L_375_arg0, "Entity Loot Node") then
		return false
	end
	if L_375_arg0:IsA("Model") then
		local L_376_, L_377_ = L_88_func(L_375_arg0)
		if L_376_ then
			local L_378_ = L_31_func(L_377_)
			if L_378_ == "weapon" and not L_12_.LootWeapons then
				return false
			end
			if L_378_ == "ammo" and not L_12_.LootAmmo then
				return false
			end
			if L_378_ == "medical" and not L_12_.LootMedical then
				return false
			end
			if L_378_ == "food" and not L_12_.LootFood then
				return false
			end
			if L_378_ == "clothing" and not L_12_.LootClothing then
				return false
			end
			if L_378_ == "other" and not L_12_.LootOther then
				return false
			end
			return true, L_377_
		end
	end
	return false
end

----------------------------------------------------------------
-- SCAN + HOOKS
----------------------------------------------------------------
local function L_90_func()
	L_26_func()
	local L_379_ = {}
	local L_380_ = L_18_func()
	if L_380_ then
		for L_381_forvar0, L_382_forvar1 in ipairs(L_380_:GetChildren()) do
			if L_382_forvar1:IsA("Model") and L_382_forvar1 ~= L_25_ then
				L_379_[L_382_forvar1] = true
				if not L_64_[L_382_forvar1] then
					L_73_func(L_382_forvar1)
				else
					local L_383_ = L_64_[L_382_forvar1]
					L_383_.hrp = L_22_func(L_382_forvar1) or L_383_.hrp
					L_383_.hum = L_23_func(L_382_forvar1) or L_383_.hum
					L_383_.name = L_30_func(L_382_forvar1)
					if L_383_.billboard and L_383_.hrp then
						L_383_.billboard.Adornee = L_383_.hrp
					end
				end
			elseif L_382_forvar1 == L_25_ and L_64_[L_382_forvar1] then
				L_70_func(L_382_forvar1)
			end
		end
	end
	for L_384_forvar0 in pairs(L_64_) do
		if not L_379_[L_384_forvar0] or not L_384_forvar0.Parent then
			L_70_func(L_384_forvar0)
		end
	end
end
local function L_91_func()
	local L_385_ = {}
	if L_12_.ZombieESP then
		local L_386_ = L_19_func()
		if L_386_ then
			for L_387_forvar0, L_388_forvar1 in ipairs(L_386_:GetChildren()) do
				if L_388_forvar1:IsA("Model") then
					L_385_[L_388_forvar1] = true
					L_75_func(L_388_forvar1)
				end
			end
		end
	end
	for L_389_forvar0 in pairs(L_65_) do
		if not L_385_[L_389_forvar0] or not L_389_forvar0.Parent then
			L_74_func(L_389_forvar0)
		end
	end
end
local function L_92_func()
	local L_390_ = {}
	if L_12_.VehicleESP then
		local L_391_ = L_20_func()
		if L_391_ then
			for L_392_forvar0, L_393_forvar1 in ipairs(L_391_:GetChildren()) do
				if L_393_forvar1:IsA("Model") then
					L_390_[L_393_forvar1] = true
					L_78_func(L_393_forvar1)
				end
			end
		end
	end
	for L_394_forvar0 in pairs(L_66_) do
		if not L_390_[L_394_forvar0] or not L_394_forvar0.Parent then
			L_76_func(L_394_forvar0)
		end
	end
end
local function L_93_func()
	local L_395_ = {}
	if L_12_.CorpseESP then
		local L_396_ = L_21_func()
		if L_396_ then
			for L_397_forvar0, L_398_forvar1 in ipairs(L_396_:GetChildren()) do
				if L_398_forvar1:IsA("Model") then
					L_395_[L_398_forvar1] = true
					L_80_func(L_398_forvar1)
				end
			end
		end
	end
	for L_399_forvar0 in pairs(L_67_) do
		if not L_395_[L_399_forvar0] or not L_399_forvar0.Parent then
			L_79_func(L_399_forvar0)
		end
	end
end
local function L_94_func()
	local L_400_ = {}
	if L_12_.LootESP then
		local L_401_ = L_6_:FindFirstChild("Map")
		local L_402_ = L_401_ and L_401_:FindFirstChild("Terrain")
		if L_402_ then
			for L_403_forvar0, L_404_forvar1 in ipairs(L_402_:GetChildren()) do
				for L_405_forvar0, L_406_forvar1 in ipairs(L_404_forvar1:GetChildren()) do
					if L_406_forvar1:IsA("Model") then
						local L_407_, L_408_ = L_89_func(L_406_forvar1)
						if L_407_ then
							L_400_[L_406_forvar1] = true
							L_82_func(L_406_forvar1, L_408_)
						end
					end
				end
			end
		end
	end
	for L_409_forvar0 in pairs(L_68_) do
		if not L_400_[L_409_forvar0] or not L_409_forvar0.Parent then
			L_81_func(L_409_forvar0)
		end
	end
end
local function L_95_func()
	local L_410_ = {}
	if L_12_.FuelESP then
		pcall(function()
			for L_413_forvar0, L_414_forvar1 in ipairs(L_7_:GetTagged("Entity Fuel Pump")) do
				L_410_[L_414_forvar1] = true
				L_84_func(L_414_forvar1)
			end
		end)
		local L_411_ = L_6_:FindFirstChild("Map")
		local L_412_ = L_411_ and L_411_:FindFirstChild("Terrain")
		if L_412_ then
			for L_415_forvar0, L_416_forvar1 in ipairs(L_412_:GetChildren()) do
				for L_417_forvar0, L_418_forvar1 in ipairs(L_416_forvar1:GetDescendants()) do
					if L_418_forvar1.Name == "FuelPump" or L_418_forvar1.Name == "FuelTank1" then
						L_410_[L_418_forvar1] = true
						L_84_func(L_418_forvar1)
					end
				end
			end
		end
	end
	for L_419_forvar0 in pairs(L_69_) do
		if not L_410_[L_419_forvar0] or not L_419_forvar0.Parent then
			L_83_func(L_419_forvar0)
		end
	end
end
local function L_96_func()
	pcall(L_90_func)
	pcall(L_91_func)
	pcall(L_92_func)
	pcall(L_93_func)
	pcall(L_94_func)
	pcall(L_95_func)
end
local function L_97_func(L_420_arg0, L_421_arg1, L_422_arg2)
	task.spawn(function()
		while true do
			local L_423_ = L_420_arg0()
			if L_423_ then
				for L_424_forvar0, L_425_forvar1 in ipairs(L_423_:GetChildren()) do
					pcall(L_421_arg1, L_425_forvar1)
				end
				L_423_.ChildAdded:Connect(function(L_426_arg0)
					task.defer(function()
						pcall(L_421_arg1, L_426_arg0)
					end)
				end)
				L_423_.ChildRemoved:Connect(function(L_427_arg0)
					pcall(L_422_arg2, L_427_arg0)
				end)
				L_423_.DescendantAdded:Connect(function(L_428_arg0)
					if L_428_arg0.Name == "HumanoidRootPart" and L_428_arg0.Parent and L_428_arg0.Parent:IsA("Model") then
						task.defer(function()
							pcall(L_421_arg1, L_428_arg0.Parent)
						end)
					end
				end)
				break
			end
			task.wait(1)
		end
	end)
end
L_97_func(L_18_func, function(L_429_arg0)
	if L_429_arg0:IsA("Model") and L_429_arg0 ~= L_26_func() then
		L_73_func(L_429_arg0)
	end
end, L_70_func)
L_97_func(L_19_func, function(L_430_arg0)
	if L_12_.ZombieESP and L_430_arg0:IsA("Model") then
		L_75_func(L_430_arg0)
	end
end, L_74_func)
L_97_func(L_20_func, function(L_431_arg0)
	if L_12_.VehicleESP and L_431_arg0:IsA("Model") then
		L_78_func(L_431_arg0)
	end
end, L_76_func)
L_97_func(L_21_func, function(L_432_arg0)
	if L_12_.CorpseESP and L_432_arg0:IsA("Model") then
		L_80_func(L_432_arg0)
	end
end, L_79_func)
task.spawn(function()
	local function L_433_func(L_434_arg0)
		for L_435_forvar0, L_436_forvar1 in ipairs(L_434_arg0:GetChildren()) do
			if L_12_.LootESP and L_436_forvar1:IsA("Model") then
				local L_437_, L_438_ = L_89_func(L_436_forvar1)
				if L_437_ then
					L_82_func(L_436_forvar1, L_438_)
				end
			end
		end
		L_434_arg0.ChildAdded:Connect(function(L_439_arg0)
			task.defer(function()
				if L_12_.LootESP and L_439_arg0:IsA("Model") then
					local L_440_, L_441_ = L_89_func(L_439_arg0)
					if L_440_ then
						L_82_func(L_439_arg0, L_441_)
					end
				end
			end)
		end)
		L_434_arg0.ChildRemoved:Connect(L_81_func)
	end
	while true do
		local L_442_ = L_6_:FindFirstChild("Map")
		local L_443_ = L_442_ and L_442_:FindFirstChild("Terrain")
		if L_443_ then
			for L_444_forvar0, L_445_forvar1 in ipairs(L_443_:GetChildren()) do
				L_433_func(L_445_forvar1)
			end
			L_443_.ChildAdded:Connect(function(L_446_arg0)
				task.defer(function()
					L_433_func(L_446_arg0)
				end)
			end)
			break
		end
		task.wait(1)
	end
end)
task.spawn(function()
	while true do
		L_96_func()
		task.wait(1.5)
	end
end)
task.defer(L_96_func)

----------------------------------------------------------------
-- ENV
----------------------------------------------------------------
local L_98_ = {
	Brightness = L_3_.Brightness,
	ClockTime = L_3_.ClockTime,
	FogEnd = L_3_.FogEnd,
	Ambient = L_3_.Ambient,
	OutdoorAmbient = L_3_.OutdoorAmbient,
}
local L_99_
local function L_100_func()
	if L_99_ then
		L_99_:Disconnect()
		L_99_ = nil
	end
	if L_12_.Fullbright or L_12_.NoFog then
		L_99_ = L_4_.RenderStepped:Connect(function()
			if L_12_.Fullbright then
				L_3_.Brightness = 2
				L_3_.ClockTime = 14
				L_3_.Ambient = Color3.fromRGB(180, 180, 180)
				L_3_.OutdoorAmbient = Color3.fromRGB(180, 180, 180)
			end
			if L_12_.NoFog or L_12_.Fullbright then
				L_3_.FogEnd = 1e6
			end
		end)
	else
		L_3_.Brightness = L_98_.Brightness
		L_3_.ClockTime = L_98_.ClockTime
		L_3_.FogEnd = L_98_.FogEnd
		L_3_.Ambient = L_98_.Ambient
		L_3_.OutdoorAmbient = L_98_.OutdoorAmbient
	end
end

----------------------------------------------------------------
-- UI
----------------------------------------------------------------
local L_101_ = Instance.new("ScreenGui")
L_101_.Name = "bScriptsAR2v40"
L_101_.ResetOnSpawn = false
L_101_.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function()
	L_101_.Parent = L_8_
end)
if not L_101_.Parent then
	L_101_.Parent = L_9_:WaitForChild("PlayerGui")
end
local L_102_ = Instance.new("Frame")
L_102_.Size = UDim2.new(0, 280, 0, 560)
L_102_.Position = UDim2.new(0.5, - 140, 0.5, - 280)
L_102_.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
L_102_.BorderSizePixel = 0
L_102_.ZIndex = 10
L_102_.Parent = L_101_
Instance.new("UICorner", L_102_).CornerRadius = UDim.new(0, 6)
local L_103_ = Instance.new("Frame")
L_103_.Size = UDim2.new(1, 0, 0, 4)
L_103_.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
L_103_.BorderSizePixel = 0
L_103_.ZIndex = 11
L_103_.Parent = L_102_
local L_104_ = Instance.new("TextLabel")
L_104_.Size = UDim2.new(1, - 40, 0, 36)
L_104_.Position = UDim2.new(0, 10, 0, 6)
L_104_.BackgroundTransparency = 1
L_104_.TextColor3 = Color3.fromRGB(255, 255, 255)
L_104_.Font = Enum.Font.Bangers
L_104_.TextSize = 20
L_104_.Text = "bScripts"
L_104_.TextXAlignment = Enum.TextXAlignment.Left
L_104_.ZIndex = 11
L_104_.Parent = L_102_
local L_105_ = Instance.new("TextLabel")
L_105_.Size = UDim2.new(1, - 40, 0, 16)
L_105_.Position = UDim2.new(0, 10, 0, 26)
L_105_.BackgroundTransparency = 1
L_105_.TextColor3 = Color3.fromRGB(100, 100, 100)
L_105_.Font = Enum.Font.Gotham
L_105_.TextSize = 11
L_105_.Text = "apoc2 · v0.1.1"
L_105_.TextXAlignment = Enum.TextXAlignment.Left
L_105_.ZIndex = 11
L_105_.Parent = L_102_
local L_106_ = Instance.new("TextButton")
L_106_.Size = UDim2.new(0, 28, 0, 28)
L_106_.Position = UDim2.new(1, - 34, 0, 8)
L_106_.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
L_106_.TextColor3 = Color3.fromRGB(180, 180, 180)
L_106_.Font = Enum.Font.GothamBold
L_106_.TextSize = 14
L_106_.Text = "×"
L_106_.BorderSizePixel = 0
L_106_.ZIndex = 11
L_106_.Parent = L_102_
local L_107_ = Instance.new("Frame")
L_107_.Size = UDim2.new(1, 0, 0, 1)
L_107_.Position = UDim2.new(0, 0, 0, 42)
L_107_.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
L_107_.BorderSizePixel = 0
L_107_.ZIndex = 11
L_107_.Parent = L_102_
local L_108_ = Instance.new("Frame")
L_108_.Size = UDim2.new(1, 0, 0, 32)
L_108_.Position = UDim2.new(0, 0, 0, 43)
L_108_.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
L_108_.BorderSizePixel = 0
L_108_.ZIndex = 11
L_108_.Parent = L_102_
local L_109_ = Instance.new("Frame")
L_109_.Size = UDim2.new(1, 0, 1, - 76)
L_109_.Position = UDim2.new(0, 0, 0, 76)
L_109_.BackgroundTransparency = 1
L_109_.ZIndex = 11
L_109_.Parent = L_102_
local L_110_ = false
local L_111_ = {
	"Players",
	"Loot",
	"World",
	"Misc"
}
local L_112_, L_113_ = {}, {}
local function L_114_func(L_447_arg0, L_448_arg1, L_449_arg2, L_450_arg3, L_451_arg4, L_452_arg5)
	local L_453_ = L_452_arg5 and 14 or 0
	local L_454_ = Instance.new("Frame")
	L_454_.Size = UDim2.new(1, - 20 - L_453_, 0, 22)
	L_454_.Position = UDim2.new(0, 10 + L_453_, 0, L_449_arg2)
	L_454_.BackgroundTransparency = 1
	L_454_.ZIndex = 12
	L_454_.Parent = L_447_arg0
	local L_455_ = Instance.new("Frame")
	L_455_.Size = UDim2.new(0, 14, 0, 14)
	L_455_.Position = UDim2.new(0, 0, 0.5, - 7)
	L_455_.BackgroundColor3 = L_450_arg3 and Color3.fromRGB(88, 101, 242) or Color3.fromRGB(30, 30, 30)
	L_455_.BorderSizePixel = 1
	L_455_.BorderColor3 = Color3.fromRGB(60, 60, 60)
	L_455_.ZIndex = 13
	L_455_.Parent = L_454_
	local L_456_ = Instance.new("TextLabel")
	L_456_.Size = UDim2.new(1, 0, 1, 0)
	L_456_.BackgroundTransparency = 1
	L_456_.TextColor3 = Color3.fromRGB(255, 255, 255)
	L_456_.Font = Enum.Font.GothamBold
	L_456_.TextSize = 10
	L_456_.Text = L_450_arg3 and "✓" or ""
	L_456_.ZIndex = 14
	L_456_.Parent = L_455_
	local L_457_ = Instance.new("TextLabel")
	L_457_.Size = UDim2.new(1, - 20, 1, 0)
	L_457_.Position = UDim2.new(0, 20, 0, 0)
	L_457_.BackgroundTransparency = 1
	L_457_.TextColor3 = L_452_arg5 and Color3.fromRGB(160, 160, 160) or Color3.fromRGB(200, 200, 200)
	L_457_.Font = Enum.Font.Gotham
	L_457_.TextSize = L_452_arg5 and 11 or 12
	L_457_.Text = L_448_arg1
	L_457_.TextXAlignment = Enum.TextXAlignment.Left
	L_457_.ZIndex = 13
	L_457_.Parent = L_454_
	local L_458_ = L_450_arg3 or false
	local L_459_ = Instance.new("TextButton")
	L_459_.Size = UDim2.new(1, 0, 1, 0)
	L_459_.BackgroundTransparency = 1
	L_459_.Text = ""
	L_459_.ZIndex = 15
	L_459_.Parent = L_454_
	L_459_.MouseButton1Click:Connect(function()
		L_458_ = not L_458_
		L_455_.BackgroundColor3 = L_458_ and Color3.fromRGB(88, 101, 242) or Color3.fromRGB(30, 30, 30)
		L_456_.Text = L_458_ and "✓" or ""
		if L_451_arg4 then
			L_451_arg4(L_458_)
		end
	end)
end
local function L_115_func(L_460_arg0, L_461_arg1, L_462_arg2, L_463_arg3, L_464_arg4, L_465_arg5)
	local L_466_ = Instance.new("Frame")
	L_466_.Size = UDim2.new(1, - 20, 0, 22)
	L_466_.Position = UDim2.new(0, 10, 0, L_462_arg2)
	L_466_.BackgroundTransparency = 1
	L_466_.ZIndex = 12
	L_466_.Parent = L_460_arg0
	local L_467_ = Instance.new("TextLabel")
	L_467_.Size = UDim2.new(0.45, 0, 1, 0)
	L_467_.BackgroundTransparency = 1
	L_467_.TextColor3 = Color3.fromRGB(200, 200, 200)
	L_467_.Font = Enum.Font.Gotham
	L_467_.TextSize = 12
	L_467_.Text = L_461_arg1
	L_467_.TextXAlignment = Enum.TextXAlignment.Left
	L_467_.ZIndex = 13
	L_467_.Parent = L_466_
	local L_468_ = Instance.new("TextButton")
	L_468_.Size = UDim2.new(0.5, 0, 0, 18)
	L_468_.Position = UDim2.new(0.5, 0, 0.5, - 9)
	L_468_.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	L_468_.TextColor3 = Color3.fromRGB(220, 220, 220)
	L_468_.Font = Enum.Font.GothamBold
	L_468_.TextSize = 11
	L_468_.Text = tostring(L_464_arg4)
	L_468_.BorderSizePixel = 1
	L_468_.BorderColor3 = Color3.fromRGB(60, 60, 60)
	L_468_.ZIndex = 13
	L_468_.Parent = L_466_
	local L_469_ = 1
	for L_470_forvar0, L_471_forvar1 in ipairs(L_463_arg3) do
		if L_471_forvar1 == L_464_arg4 then
			L_469_ = L_470_forvar0
			break
		end
	end
	L_468_.MouseButton1Click:Connect(function()
		L_469_ = L_469_ % # L_463_arg3 + 1
		L_468_.Text = L_463_arg3[L_469_]
		if L_465_arg5 then
			L_465_arg5(L_463_arg3[L_469_])
		end
	end)
end
local function L_116_func(L_472_arg0, L_473_arg1, L_474_arg2, L_475_arg3, L_476_arg4)
	local L_477_ = Instance.new("Frame")
	L_477_.Size = UDim2.new(1, - 20, 0, 24)
	L_477_.Position = UDim2.new(0, 10, 0, L_474_arg2)
	L_477_.BackgroundTransparency = 1
	L_477_.ZIndex = 12
	L_477_.Parent = L_472_arg0
	local L_478_ = Instance.new("TextLabel")
	L_478_.Size = UDim2.new(1, - 60, 1, 0)
	L_478_.BackgroundTransparency = 1
	L_478_.TextColor3 = Color3.fromRGB(200, 200, 200)
	L_478_.Font = Enum.Font.Gotham
	L_478_.TextSize = 12
	L_478_.Text = L_473_arg1
	L_478_.TextXAlignment = Enum.TextXAlignment.Left
	L_478_.ZIndex = 13
	L_478_.Parent = L_477_
	local L_479_ = Instance.new("TextButton")
	L_479_.Size = UDim2.new(0, 52, 0, 18)
	L_479_.Position = UDim2.new(1, - 52, 0.5, - 9)
	L_479_.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	L_479_.TextColor3 = Color3.fromRGB(200, 200, 200)
	L_479_.Font = Enum.Font.GothamBold
	L_479_.TextSize = 11
	L_479_.Text = L_475_arg3
	L_479_.BorderSizePixel = 1
	L_479_.BorderColor3 = Color3.fromRGB(60, 60, 60)
	L_479_.ZIndex = 13
	L_479_.Parent = L_477_
	local L_480_, L_481_ = false, L_475_arg3
	L_479_.MouseButton1Click:Connect(function()
		if L_110_ then
			return
		end
		L_480_ = true
		L_110_ = true
		L_479_.Text = "..."
		L_479_.TextColor3 = Color3.fromRGB(88, 101, 242)
	end)
	L_2_.InputBegan:Connect(function(L_482_arg0, L_483_arg1)
		if L_480_ then
			if L_482_arg0.KeyCode == Enum.KeyCode.Unknown then
				return
			end
			L_480_ = false
			L_110_ = false
			L_481_ = L_482_arg0.KeyCode.Name
			L_479_.Text = L_481_
			L_479_.TextColor3 = Color3.fromRGB(200, 200, 200)
		elseif not L_483_arg1 and L_482_arg0.KeyCode == Enum.KeyCode[L_481_] then
			if L_476_arg4 then
				L_476_arg4()
			end
		end
	end)
end

-- Players
local L_117_ = Instance.new("ScrollingFrame")
L_117_.Size = UDim2.new(1, 0, 1, 0)
L_117_.BackgroundTransparency = 1
L_117_.Visible = true
L_117_.ZIndex = 12
L_117_.BorderSizePixel = 0
L_117_.ScrollBarThickness = 3
L_117_.CanvasSize = UDim2.new(0, 0, 0, 560)
L_117_.Parent = L_109_
local L_118_ = 4
local function L_119_func(L_484_arg0)
	local L_485_ = L_118_
	L_118_ += L_484_arg0
	return L_485_
end
L_114_func(L_117_, "ESP Master", L_119_func(22), L_12_.ESP, function(L_486_arg0)
	L_12_.ESP = L_486_arg0
	if not L_486_arg0 then
		L_72_func()
	end
	L_15_func()
end)
L_114_func(L_117_, "Chams", L_119_func(22), L_12_.Chams, function(L_487_arg0)
	L_12_.Chams = L_487_arg0
	if not L_487_arg0 then
		for L_488_forvar0, L_489_forvar1 in pairs(L_64_) do
			if L_489_forvar1.highlight then
				L_489_forvar1.highlight.Enabled = false
			end
		end
	end
	L_15_func()
end, true)
L_114_func(L_117_, "Visible Check", L_119_func(22), L_12_.ChamsVisCheck, function(L_490_arg0)
	L_12_.ChamsVisCheck = L_490_arg0
	L_15_func()
end, true)
L_114_func(L_117_, "Box ESP", L_119_func(22), L_12_.Box, function(L_491_arg0)
	L_12_.Box = L_491_arg0
	if not L_491_arg0 then
		for L_492_forvar0, L_493_forvar1 in pairs(L_64_) do
			L_43_func(L_493_forvar1.box)
			if L_493_forvar1.hpBar then
				if L_493_forvar1.hpBar.bg then
					L_493_forvar1.hpBar.bg.Visible = false
				end
				if L_493_forvar1.hpBar.fill then
					L_493_forvar1.hpBar.fill.Visible = false
				end
			end
		end
	end
	L_15_func()
end, true)
L_115_func(L_117_, "Box Style", L_119_func(22), {
	"2D",
	"Corner",
	"3D"
}, L_12_.BoxStyle, function(L_494_arg0)
	L_12_.BoxStyle = L_494_arg0
	L_15_func()
end)
L_114_func(L_117_, "Skeleton", L_119_func(22), L_12_.Skeleton, function(L_495_arg0)
	L_12_.Skeleton = L_495_arg0
	if not L_495_arg0 then
		for L_496_forvar0, L_497_forvar1 in pairs(L_64_) do
			L_43_func(L_497_forvar1.skel)
		end
	end
	L_15_func()
end, true)
L_114_func(L_117_, "Tracers", L_119_func(22), L_12_.Tracers, function(L_498_arg0)
	L_12_.Tracers = L_498_arg0
	if not L_498_arg0 then
		for L_499_forvar0, L_500_forvar1 in pairs(L_64_) do
			if L_500_forvar1.tracer then
				L_500_forvar1.tracer.Visible = false
			end
		end
	end
	L_15_func()
end, true)
L_115_func(L_117_, "Tracer Origin", L_119_func(22), {
	"Bottom",
	"Center",
	"Top",
	"Mouse"
}, L_12_.TracerOrigin, function(L_501_arg0)
	L_12_.TracerOrigin = L_501_arg0
	L_15_func()
end)
L_114_func(L_117_, "Head Dot", L_119_func(22), L_12_.HeadDot, function(L_502_arg0)
	L_12_.HeadDot = L_502_arg0
	if not L_502_arg0 then
		for L_503_forvar0, L_504_forvar1 in pairs(L_64_) do
			if L_504_forvar1.headDot then
				L_504_forvar1.headDot.Visible = false
			end
		end
	end
	L_15_func()
end, true)
L_114_func(L_117_, "Facing Arrow", L_119_func(22), L_12_.Facing, function(L_505_arg0)
	L_12_.Facing = L_505_arg0
	if not L_505_arg0 then
		for L_506_forvar0, L_507_forvar1 in pairs(L_64_) do
			if L_507_forvar1.facing then
				L_507_forvar1.facing.Visible = false
			end
		end
	end
	L_15_func()
end, true)
L_114_func(L_117_, "Show Name", L_119_func(22), L_12_.ShowName, function(L_508_arg0)
	L_12_.ShowName = L_508_arg0
	L_15_func()
end, true)
L_114_func(L_117_, "Show Distance", L_119_func(22), L_12_.ShowDistance, function(L_509_arg0)
	L_12_.ShowDistance = L_509_arg0
	L_15_func()
end, true)
L_114_func(L_117_, "Show Health", L_119_func(22), L_12_.ShowHealth, function(L_510_arg0)
	L_12_.ShowHealth = L_510_arg0
	L_15_func()
end, true)
L_114_func(L_117_, "Health Bar", L_119_func(22), L_12_.ShowHealthBar, function(L_511_arg0)
	L_12_.ShowHealthBar = L_511_arg0
	if not L_511_arg0 then
		for L_512_forvar0, L_513_forvar1 in pairs(L_64_) do
			if L_513_forvar1.hpBar then
				if L_513_forvar1.hpBar.bg then
					L_513_forvar1.hpBar.bg.Visible = false
				end
				if L_513_forvar1.hpBar.fill then
					L_513_forvar1.hpBar.fill.Visible = false
				end
			end
		end
	end
	L_15_func()
end, true)
L_114_func(L_117_, "Show Weapon", L_119_func(22), L_12_.ShowWeapon, function(L_514_arg0)
	L_12_.ShowWeapon = L_514_arg0
	if not L_514_arg0 then
		for L_515_forvar0, L_516_forvar1 in pairs(L_64_) do
			if L_516_forvar1.text2 then
				L_516_forvar1.text2.Visible = false
			end
		end
	end
	L_15_func()
end, true)
L_114_func(L_117_, "Weapon Colors", L_119_func(22), L_12_.WeaponColors, function(L_517_arg0)
	L_12_.WeaponColors = L_517_arg0
	L_15_func()
end, true)
L_114_func(L_117_, "Show Armor / Vest", L_119_func(22), L_12_.ShowArmor, function(L_518_arg0)
	L_12_.ShowArmor = L_518_arg0
	L_15_func()
end, true)
L_114_func(L_117_, "Show Backpack", L_119_func(22), L_12_.ShowBackpack, function(L_519_arg0)
	L_12_.ShowBackpack = L_519_arg0
	L_15_func()
end, true)
L_114_func(L_117_, "Show State", L_119_func(22), L_12_.ShowState, function(L_520_arg0)
	L_12_.ShowState = L_520_arg0
	L_15_func()
end, true)
L_114_func(L_117_, "Squad Check", L_119_func(22), L_12_.SquadCheck, function(L_521_arg0)
	L_12_.SquadCheck = L_521_arg0
	L_15_func()
end)
L_114_func(L_117_, "Off-Screen Arrows", L_119_func(22), L_12_.OffScreen, function(L_522_arg0)
	L_12_.OffScreen = L_522_arg0
	if not L_522_arg0 then
		for L_523_forvar0, L_524_forvar1 in pairs(L_64_) do
			if L_524_forvar1.arrow then
				L_524_forvar1.arrow.Visible = false
			end
		end
	end
	L_15_func()
end)
L_114_func(L_117_, "Distance Fade", L_119_func(22), L_12_.DistFade, function(L_525_arg0)
	L_12_.DistFade = L_525_arg0
	L_15_func()
end)
L_114_func(L_117_, "Optimised far dots", L_119_func(22), L_12_.Optimised, function(L_526_arg0)
	L_12_.Optimised = L_526_arg0
	L_15_func()
end)

-- Loot
local L_120_ = Instance.new("ScrollingFrame")
L_120_.Size = UDim2.new(1, 0, 1, 0)
L_120_.BackgroundTransparency = 1
L_120_.Visible = false
L_120_.ZIndex = 12
L_120_.BorderSizePixel = 0
L_120_.ScrollBarThickness = 3
L_120_.CanvasSize = UDim2.new(0, 0, 0, 280)
L_120_.Parent = L_109_
L_118_ = 4
L_114_func(L_120_, "Loot ESP (spawned only)", L_119_func(24), L_12_.LootESP, function(L_527_arg0)
	L_12_.LootESP = L_527_arg0
	if not L_527_arg0 then
		for L_528_forvar0 in pairs(L_68_) do
			L_81_func(L_528_forvar0)
		end
	end
	L_15_func()
end)
L_114_func(L_120_, "Weapons", L_119_func(22), L_12_.LootWeapons, function(L_529_arg0)
	L_12_.LootWeapons = L_529_arg0
	L_15_func()
end, true)
L_114_func(L_120_, "Ammo / Mags", L_119_func(22), L_12_.LootAmmo, function(L_530_arg0)
	L_12_.LootAmmo = L_530_arg0
	L_15_func()
end, true)
L_114_func(L_120_, "Medical", L_119_func(22), L_12_.LootMedical, function(L_531_arg0)
	L_12_.LootMedical = L_531_arg0
	L_15_func()
end, true)
L_114_func(L_120_, "Food / Drink", L_119_func(22), L_12_.LootFood, function(L_532_arg0)
	L_12_.LootFood = L_532_arg0
	L_15_func()
end, true)
L_114_func(L_120_, "Clothing", L_119_func(22), L_12_.LootClothing, function(L_533_arg0)
	L_12_.LootClothing = L_533_arg0
	L_15_func()
end, true)
L_114_func(L_120_, "Other", L_119_func(22), L_12_.LootOther, function(L_534_arg0)
	L_12_.LootOther = L_534_arg0
	L_15_func()
end, true)
L_114_func(L_120_, "Ignore Junk Labels", L_119_func(22), L_12_.LootIgnoreJunk, function(L_535_arg0)
	L_12_.LootIgnoreJunk = L_535_arg0
	L_15_func()
end, true)

-- World
local L_121_ = Instance.new("Frame")
L_121_.Size = UDim2.new(1, 0, 1, 0)
L_121_.BackgroundTransparency = 1
L_121_.Visible = false
L_121_.ZIndex = 12
L_121_.Parent = L_109_
L_118_ = 4
L_114_func(L_121_, "Zombie / Infected ESP", L_119_func(24), L_12_.ZombieESP, function(L_536_arg0)
	L_12_.ZombieESP = L_536_arg0
	if not L_536_arg0 then
		for L_537_forvar0 in pairs(L_65_) do
			L_74_func(L_537_forvar0)
		end
	end
	L_15_func()
end)
L_114_func(L_121_, "Zombie Chams", L_119_func(22), L_12_.ZombieChams, function(L_538_arg0)
	L_12_.ZombieChams = L_538_arg0
	L_15_func()
end, true)
L_114_func(L_121_, "Vehicle ESP", L_119_func(22), L_12_.VehicleESP, function(L_539_arg0)
	L_12_.VehicleESP = L_539_arg0
	if not L_539_arg0 then
		for L_540_forvar0 in pairs(L_66_) do
			L_76_func(L_540_forvar0)
		end
	end
	L_15_func()
end)
L_114_func(L_121_, "Vehicle Occupancy", L_119_func(22), L_12_.VehicleOccupancy, function(L_541_arg0)
	L_12_.VehicleOccupancy = L_541_arg0
	L_15_func()
end, true)
L_114_func(L_121_, "Corpse ESP", L_119_func(22), L_12_.CorpseESP, function(L_542_arg0)
	L_12_.CorpseESP = L_542_arg0
	if not L_542_arg0 then
		for L_543_forvar0 in pairs(L_67_) do
			L_79_func(L_543_forvar0)
		end
	end
	L_15_func()
end)
L_114_func(L_121_, "Corpse Gear Preview", L_119_func(22), L_12_.CorpseGear, function(L_544_arg0)
	L_12_.CorpseGear = L_544_arg0
	L_15_func()
end, true)
L_114_func(L_121_, "Fuel Pump ESP", L_119_func(22), L_12_.FuelESP, function(L_545_arg0)
	L_12_.FuelESP = L_545_arg0
	if not L_545_arg0 then
		for L_546_forvar0 in pairs(L_69_) do
			L_83_func(L_546_forvar0)
		end
	end
	L_15_func()
end)
L_114_func(L_121_, "Fullbright", L_119_func(22), L_12_.Fullbright, function(L_547_arg0)
	L_12_.Fullbright = L_547_arg0
	L_100_func()
	L_15_func()
end)
L_114_func(L_121_, "No Fog", L_119_func(22), L_12_.NoFog, function(L_548_arg0)
	L_12_.NoFog = L_548_arg0
	L_100_func()
	L_15_func()
end)
local L_122_ = Instance.new("TextLabel")
L_122_.Size = UDim2.new(1, - 20, 0, 50)
L_122_.Position = UDim2.new(0, 10, 0, 250)
L_122_.BackgroundTransparency = 1
L_122_.TextColor3 = Color3.fromRGB(120, 120, 120)
L_122_.Font = Enum.Font.Gotham
L_122_.TextSize = 11
L_122_.TextXAlignment = Enum.TextXAlignment.Left
L_122_.TextYAlignment = Enum.TextYAlignment.Top
L_122_.ZIndex = 12
L_122_.Parent = L_121_
task.spawn(function()
	while L_122_.Parent do
		local L_549_, L_550_, L_551_, L_552_, L_553_, L_554_ = 0, 0, 0, 0, 0, 0
		for L_555_forvar0 in pairs(L_64_) do
			L_549_ += 1
		end
		for L_556_forvar0 in pairs(L_65_) do
			L_550_ += 1
		end
		for L_557_forvar0 in pairs(L_66_) do
			L_551_ += 1
		end
		for L_558_forvar0 in pairs(L_67_) do
			L_552_ += 1
		end
		for L_559_forvar0 in pairs(L_68_) do
			L_553_ += 1
		end
		for L_560_forvar0 in pairs(L_69_) do
			L_554_ += 1
		end
		L_122_.Text = string.format("P:%d Z:%d V:%d C:%d L:%d F:%d", L_549_, L_550_, L_551_, L_552_, L_553_, L_554_)
		task.wait(1)
	end
end)

-- Misc
local L_123_ = Instance.new("Frame")
L_123_.Size = UDim2.new(1, 0, 1, 0)
L_123_.BackgroundTransparency = 1
L_123_.Visible = false
L_123_.ZIndex = 12
L_123_.Parent = L_109_
L_116_func(L_123_, "Toggle GUI", 4, "PageUp", function()
	L_102_.Visible = not L_102_.Visible
end)
L_116_func(L_123_, "Panic Hide ESP", 32, "End", function()
	L_12_.ESP = false
	L_12_.LootESP = false
	L_12_.ZombieESP = false
	L_12_.VehicleESP = false
	L_12_.CorpseESP = false
	L_12_.FuelESP = false
	L_72_func()
end)

-- Credits
local L_124_ = Instance.new("TextLabel")
L_124_.Size = UDim2.new(1, - 20, 0, 22)
L_124_.Position = UDim2.new(0, 10, 0, 70)
L_124_.BackgroundTransparency = 1
L_124_.TextColor3 = Color3.fromRGB(180, 180, 180)
L_124_.Font = Enum.Font.GothamBold
L_124_.TextSize = 13
L_124_.TextXAlignment = Enum.TextXAlignment.Left
L_124_.Text = "Credits"
L_124_.ZIndex = 12
L_124_.Parent = L_123_
local L_125_ = Instance.new("TextLabel")
L_125_.Size = UDim2.new(1, - 20, 0, 50)
L_125_.Position = UDim2.new(0, 10, 0, 92)
L_125_.BackgroundTransparency = 1
L_125_.TextColor3 = Color3.fromRGB(140, 140, 140)
L_125_.Font = Enum.Font.Gotham
L_125_.TextSize = 12
L_125_.TextXAlignment = Enum.TextXAlignment.Left
L_125_.TextYAlignment = Enum.TextYAlignment.Top
L_125_.Text = "Made by Evol\nbScripts · Apocalypse Rising 2 ESP\nEverything off by default"
L_125_.ZIndex = 12
L_125_.Parent = L_123_
local L_126_ = Instance.new("TextButton")
L_126_.Size = UDim2.new(1, - 20, 0, 32)
L_126_.Position = UDim2.new(0, 10, 1, - 42)
L_126_.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
L_126_.TextColor3 = Color3.fromRGB(255, 255, 255)
L_126_.Font = Enum.Font.GothamBold
L_126_.TextSize = 12
L_126_.Text = "JOIN DISCORD"
L_126_.BorderSizePixel = 0
L_126_.ZIndex = 12
L_126_.Parent = L_123_
L_126_.MouseButton1Click:Connect(function()
	if setclipboard then
		setclipboard("https://discord.gg/aQUSCJmgxh")
		L_126_.Text = "LINK COPIED"
		task.delay(2, function()
			L_126_.Text = "JOIN DISCORD"
		end)
	end
end)
L_113_ = {
	L_117_,
	L_120_,
	L_121_,
	L_123_
}
for L_561_forvar0, L_562_forvar1 in ipairs(L_111_) do
	local L_563_ = Instance.new("TextButton")
	L_563_.Size = UDim2.new(1 / # L_111_, 0, 1, 0)
	L_563_.Position = UDim2.new((L_561_forvar0 - 1) / # L_111_, 0, 0, 0)
	L_563_.BackgroundColor3 = L_561_forvar0 == 1 and Color3.fromRGB(20, 20, 20) or Color3.fromRGB(10, 10, 10)
	L_563_.TextColor3 = L_561_forvar0 == 1 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(100, 100, 100)
	L_563_.Font = Enum.Font.GothamBold
	L_563_.TextSize = 11
	L_563_.Text = L_562_forvar1
	L_563_.BorderSizePixel = 0
	L_563_.ZIndex = 12
	L_563_.Parent = L_108_
	local L_564_ = Instance.new("Frame")
	L_564_.Size = UDim2.new(1, 0, 0, 2)
	L_564_.Position = UDim2.new(0, 0, 1, - 2)
	L_564_.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
	L_564_.BorderSizePixel = 0
	L_564_.Visible = L_561_forvar0 == 1
	L_564_.ZIndex = 13
	L_564_.Parent = L_563_
	L_112_[L_561_forvar0] = {
		btn = L_563_,
		underline = L_564_
	}
	L_563_.MouseButton1Click:Connect(function()
		for L_565_forvar0, L_566_forvar1 in ipairs(L_113_) do
			L_566_forvar1.Visible = false
			L_112_[L_565_forvar0].btn.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
			L_112_[L_565_forvar0].btn.TextColor3 = Color3.fromRGB(100, 100, 100)
			L_112_[L_565_forvar0].underline.Visible = false
		end
		L_113_[L_561_forvar0].Visible = true
		L_563_.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
		L_563_.TextColor3 = Color3.fromRGB(255, 255, 255)
		L_564_.Visible = true
	end)
end
local L_127_, L_128_, L_129_ = false, nil, nil
L_102_.InputBegan:Connect(function(L_567_arg0)
	if L_567_arg0.UserInputType == Enum.UserInputType.MouseButton1 then
		L_127_ = true
		L_128_ = L_567_arg0.Position
		L_129_ = L_102_.Position
	end
end)
L_102_.InputEnded:Connect(function(L_568_arg0)
	if L_568_arg0.UserInputType == Enum.UserInputType.MouseButton1 then
		L_127_ = false
	end
end)
L_2_.InputChanged:Connect(function(L_569_arg0)
	if L_127_ and L_569_arg0.UserInputType == Enum.UserInputType.MouseMovement then
		local L_570_ = L_569_arg0.Position - L_128_
		L_102_.Position = UDim2.new(L_129_.X.Scale, L_129_.X.Offset + L_570_.X, L_129_.Y.Scale, L_129_.Y.Offset + L_570_.Y)
	end
end)
L_106_.MouseButton1Click:Connect(function()
	L_102_.Visible = false
end)

----------------------------------------------------------------
-- RENDER
----------------------------------------------------------------
L_4_.RenderStepped:Connect(function()
	L_37_ += 1
	local L_571_ = L_37_ % 6 == 0
	local L_572_ = L_10_.ViewportSize
	L_26_func()
	local L_573_ = L_25_ and L_22_func(L_25_)
	local L_574_ = L_573_ and L_573_.Position or L_10_.CFrame.Position
	local L_575_
	if L_12_.TracerOrigin == "Center" then
		L_575_ = Vector2.new(L_572_.X / 2, L_572_.Y / 2)
	elseif L_12_.TracerOrigin == "Top" then
		L_575_ = Vector2.new(L_572_.X / 2, 0)
	elseif L_12_.TracerOrigin == "Mouse" then
		L_575_ = Vector2.new(L_11_.X, L_11_.Y + 36)
	else
		L_575_ = Vector2.new(L_572_.X / 2, L_572_.Y)
	end
	for L_576_forvar0, L_577_forvar1 in pairs(L_64_) do
		if not L_577_forvar1.model or not L_577_forvar1.model.Parent then
			L_70_func(L_576_forvar0)
			continue
		end
		if not L_577_forvar1.hrp or not L_577_forvar1.hrp.Parent then
			L_577_forvar1.hrp = L_22_func(L_577_forvar1.model)
			if not L_577_forvar1.hrp then
				if L_577_forvar1.highlight then
					L_577_forvar1.highlight.Enabled = false
				end
				if L_577_forvar1.billboard then
					L_577_forvar1.billboard.Enabled = false
				end
				continue
			end
			if L_577_forvar1.billboard then
				L_577_forvar1.billboard.Adornee = L_577_forvar1.hrp
			end
		end
		local L_578_ = (L_577_forvar1.hrp.Position - L_574_).Magnitude
		local L_579_ = math.floor(L_578_)
		local L_580_ = not L_12_.ESP or L_578_ > L_12_.MaxDist or L_578_ < L_12_.MinDist
		if L_580_ then
			L_71_func(L_577_forvar1)
			continue
		end
		if L_571_ then
			L_36_[L_576_forvar0] = L_38_func(L_577_forvar1.model, L_577_forvar1.hrp)
		end
		local L_581_ = L_36_[L_576_forvar0]
		if L_581_ == nil then
			L_581_ = true
		end
		local L_582_ = L_577_forvar1.name or L_30_func(L_577_forvar1.model)
		local L_583_ = L_12_.SquadCheck and L_35_[L_582_] == true
		local L_584_ = L_12_.Optimised and L_578_ >= 1200
		local L_585_ = L_583_ and L_60_ or (L_12_.ChamsVisCheck and (L_581_ and L_59_ or L_58_) or L_58_)
		if L_12_.DistFade then
			local L_592_ = L_57_func(L_578_, L_12_.MaxDist)
			if not L_583_ and not (L_12_.ChamsVisCheck and L_581_) then
				L_585_ = L_592_
			end
		end
		local L_586_, L_587_ = L_27_func(L_577_forvar1.model)
		local L_588_ = L_585_
		if L_12_.WeaponColors then
			if L_587_ == "gun" then
				L_588_ = L_61_
			elseif L_587_ == "melee" then
				L_588_ = L_62_
			end
		end
		if L_577_forvar1.billboard then
			L_577_forvar1.billboard.Enabled = false
		end
		if L_577_forvar1.highlight then
			L_577_forvar1.highlight.Enabled = L_12_.Chams and not L_584_
			if L_577_forvar1.highlight.Enabled then
				L_577_forvar1.highlight.FillColor = L_585_
				L_577_forvar1.highlight.OutlineColor = L_585_
			end
		end
		local L_589_, L_590_ = L_10_:WorldToViewportPoint(L_577_forvar1.hrp.Position)
		local L_591_ = L_590_ and L_589_.Z > 0
		if L_12_.OffScreen then
			L_55_func(L_577_forvar1.arrow, L_577_forvar1.hrp.Position, L_585_)
		elseif L_577_forvar1.arrow then
			L_577_forvar1.arrow.Visible = false
		end
		if L_12_.Tracers and L_591_ and not L_584_ and L_577_forvar1.tracer then
			L_577_forvar1.tracer.From = L_575_
			L_577_forvar1.tracer.To = Vector2.new(L_589_.X, L_589_.Y)
			L_577_forvar1.tracer.Color = L_585_
			L_577_forvar1.tracer.Visible = true
		elseif L_577_forvar1.tracer then
			L_577_forvar1.tracer.Visible = false
		end

        -- Head dot
		if L_12_.HeadDot and L_591_ and not L_584_ and L_577_forvar1.headDot then
			local L_593_ = L_24_func(L_577_forvar1.model, "Head")
			if L_593_ then
				local L_594_, L_595_ = L_10_:WorldToViewportPoint(L_593_.Position)
				if L_595_ and L_594_.Z > 0 then
					L_577_forvar1.headDot.Position = Vector2.new(L_594_.X, L_594_.Y)
					L_577_forvar1.headDot.Radius = math.clamp(40 / math.max(L_578_, 10), 2, 6)
					L_577_forvar1.headDot.Color = L_585_
					L_577_forvar1.headDot.Visible = true
				else
					L_577_forvar1.headDot.Visible = false
				end
			else
				L_577_forvar1.headDot.Visible = false
			end
		elseif L_577_forvar1.headDot then
			L_577_forvar1.headDot.Visible = false
		end

        -- Facing
		if L_12_.Facing and L_591_ and not L_584_ and L_577_forvar1.facing then
			local L_596_ = L_577_forvar1.hrp.CFrame.LookVector * 4
			local L_597_ = L_577_forvar1.hrp.Position + L_596_
			local L_598_ = L_10_:WorldToViewportPoint(L_577_forvar1.hrp.Position)
			local L_599_ = L_10_:WorldToViewportPoint(L_597_)
			if L_598_.Z > 0 and L_599_.Z > 0 then
				L_44_func(L_577_forvar1.facing, Vector2.new(L_598_.X, L_598_.Y), Vector2.new(L_599_.X, L_599_.Y), L_585_, 1.5)
			else
				L_577_forvar1.facing.Visible = false
			end
		elseif L_577_forvar1.facing then
			L_577_forvar1.facing.Visible = false
		end
		if L_12_.Box and not L_584_ and L_577_forvar1.box then
			if L_12_.BoxStyle == "3D" then
				L_49_func(L_577_forvar1.box, L_577_forvar1.hrp, L_585_, 1.5)
				if L_577_forvar1.hpBar then
					if L_577_forvar1.hpBar.bg then
						L_577_forvar1.hpBar.bg.Visible = false
					end
					if L_577_forvar1.hpBar.fill then
						L_577_forvar1.hpBar.fill.Visible = false
					end
				end
			else
				local L_600_, L_601_, L_602_, L_603_ = L_46_func(L_577_forvar1.hrp)
				if L_600_ then
					if L_12_.BoxStyle == "Corner" then
						L_47_func(L_577_forvar1.box, L_600_, L_601_, L_602_, L_603_, L_585_, 1.5)
					else
						L_48_func(L_577_forvar1.box, L_600_, L_601_, L_602_, L_603_, L_585_, 1.5)
					end
					if L_12_.ShowHealthBar and L_577_forvar1.hum then
						L_54_func(L_577_forvar1.hpBar, L_600_, L_601_, L_603_, L_577_forvar1.hum.Health, L_577_forvar1.hum.MaxHealth)
					elseif L_577_forvar1.hpBar then
						if L_577_forvar1.hpBar.bg then
							L_577_forvar1.hpBar.bg.Visible = false
						end
						if L_577_forvar1.hpBar.fill then
							L_577_forvar1.hpBar.fill.Visible = false
						end
					end
				else
					L_43_func(L_577_forvar1.box)
				end
			end
		else
			L_43_func(L_577_forvar1.box)
			if L_577_forvar1.hpBar then
				if L_577_forvar1.hpBar.bg then
					L_577_forvar1.hpBar.bg.Visible = false
				end
				if L_577_forvar1.hpBar.fill then
					L_577_forvar1.hpBar.fill.Visible = false
				end
			end
		end
		if L_12_.Skeleton and not L_584_ and L_577_forvar1.skel then
			L_52_func(L_577_forvar1.skel, L_577_forvar1.model, L_585_, 1.2)
		else
			L_43_func(L_577_forvar1.skel)
		end
		if L_591_ and L_577_forvar1.text then
			local L_604_ = {}
			if L_12_.ShowName then
				table.insert(L_604_, L_582_)
			end
			if L_12_.ShowDistance then
				table.insert(L_604_, L_579_ .. "m")
			end
			if L_12_.ShowHealth and L_577_forvar1.hum then
				table.insert(L_604_, math.floor(L_577_forvar1.hum.Health) .. "/" .. math.floor(L_577_forvar1.hum.MaxHealth))
			end
			if L_12_.ShowArmor then
				local L_605_ = L_28_func(L_577_forvar1.model, "Vest")
				if L_605_ then
					table.insert(L_604_, L_605_)
				end
			end
			if L_12_.ShowBackpack then
				local L_606_ = L_28_func(L_577_forvar1.model, "Backpack")
				if L_606_ then
					table.insert(L_604_, L_606_)
				end
			end
			if L_12_.ShowState then
				table.insert(L_604_, L_29_func(L_577_forvar1.model))
			end
			if # L_604_ > 0 then
				L_577_forvar1.text.Text = table.concat(L_604_, " | ")
				L_577_forvar1.text.Color = L_585_
				L_577_forvar1.text.Size = math.clamp(14 - L_578_ / 400, 10, 14)
				L_577_forvar1.text.Position = Vector2.new(L_589_.X, L_589_.Y - 30)
				L_577_forvar1.text.Visible = true
			else
				L_577_forvar1.text.Visible = false
			end
			if L_12_.ShowWeapon and not L_584_ and L_577_forvar1.text2 and L_586_ and L_586_ ~= "" then
				L_577_forvar1.text2.Text = L_586_
				L_577_forvar1.text2.Color = L_588_
				L_577_forvar1.text2.Position = Vector2.new(L_589_.X, L_589_.Y - 16)
				L_577_forvar1.text2.Visible = true
			elseif L_577_forvar1.text2 then
				L_577_forvar1.text2.Visible = false
			end
		else
			if L_577_forvar1.text then
				L_577_forvar1.text.Visible = false
			end
			if L_577_forvar1.text2 then
				L_577_forvar1.text2.Visible = false
			end
		end
	end

    -- Zombies
	for L_607_forvar0, L_608_forvar1 in pairs(L_65_) do
		if not L_12_.ZombieESP or not L_607_forvar0.Parent then
			if L_608_forvar1.highlight then
				L_608_forvar1.highlight.Enabled = false
			end
			if L_608_forvar1.billboard then
				L_608_forvar1.billboard.Enabled = false
			end
			continue
		end
		if not L_608_forvar1.hrp or not L_608_forvar1.hrp.Parent then
			L_608_forvar1.hrp = L_22_func(L_607_forvar0)
			if not L_608_forvar1.hrp then
				continue
			end
		end
		local L_609_ = (L_608_forvar1.hrp.Position - L_574_).Magnitude
		local L_610_ = L_609_ <= 600
		if L_608_forvar1.highlight then
			L_608_forvar1.highlight.Enabled = L_610_ and L_12_.ZombieChams
		end
		if L_608_forvar1.billboard then
			L_608_forvar1.billboard.Enabled = L_610_
			if L_608_forvar1.billboardLabel and L_610_ then
				local L_611_ = L_607_forvar0.Name
				if L_611_ == "Infected Civilian" then
					L_611_ = "Infected"
				end
				L_608_forvar1.billboardLabel.Text = string.format("%s  %dm", L_611_, math.floor(L_609_))
			end
		end
	end

    -- Vehicles
	for L_612_forvar0, L_613_forvar1 in pairs(L_66_) do
		if not L_12_.VehicleESP or not L_612_forvar0.Parent then
			if L_613_forvar1.billboard then
				L_613_forvar1.billboard.Enabled = false
			end
			continue
		end
		local L_614_ = (L_613_forvar1.part.Position - L_574_).Magnitude
		local L_615_ = L_614_ <= 1000
		if L_613_forvar1.billboard then
			L_613_forvar1.billboard.Enabled = L_615_
			if L_613_forvar1.billboardLabel and L_615_ then
				local L_616_ = L_12_.VehicleOccupancy and L_77_func(L_612_forvar0)
				L_613_forvar1.billboardLabel.Text = string.format("[VEH] %s%s  %dm", L_612_forvar0.Name, L_616_ and " [OCC]" or "", math.floor(L_614_))
			end
		end
	end

    -- Corpses
	for L_617_forvar0, L_618_forvar1 in pairs(L_67_) do
		if not L_12_.CorpseESP or not L_617_forvar0.Parent then
			if L_618_forvar1.highlight then
				L_618_forvar1.highlight.Enabled = false
			end
			if L_618_forvar1.billboard then
				L_618_forvar1.billboard.Enabled = false
			end
			continue
		end
		local L_619_ = (L_618_forvar1.part.Position - L_574_).Magnitude
		local L_620_ = L_619_ <= 350
		if L_618_forvar1.highlight then
			L_618_forvar1.highlight.Enabled = L_620_
		end
		if L_618_forvar1.billboard then
			L_618_forvar1.billboard.Enabled = L_620_
		end
	end

    -- Loot
	for L_621_forvar0, L_622_forvar1 in pairs(L_68_) do
		if not L_12_.LootESP or not L_621_forvar0.Parent then
			if L_622_forvar1.billboard then
				L_622_forvar1.billboard.Enabled = false
			end
			continue
		end
		local L_623_ = (L_622_forvar1.part.Position - L_574_).Magnitude
		local L_624_ = L_623_ <= L_12_.LootMaxDist
		if L_622_forvar1.billboard then
			L_622_forvar1.billboard.Enabled = L_624_
			if L_622_forvar1.billboardLabel and L_624_ then
				L_622_forvar1.billboardLabel.Text = string.format("[LOOT] %s  %dm", tostring(L_622_forvar1.name), math.floor(L_623_))
			end
		end
	end

    -- Fuel
	for L_625_forvar0, L_626_forvar1 in pairs(L_69_) do
		if not L_12_.FuelESP or not L_625_forvar0.Parent then
			if L_626_forvar1.billboard then
				L_626_forvar1.billboard.Enabled = false
			end
			continue
		end
		local L_627_ = (L_626_forvar1.part.Position - L_574_).Magnitude
		if L_626_forvar1.billboard then
			L_626_forvar1.billboard.Enabled = L_627_ <= 800
			if L_626_forvar1.billboardLabel then
				L_626_forvar1.billboardLabel.Text = string.format("[FUEL]  %dm", math.floor(L_627_))
			end
		end
	end
end)
print("[bScripts] AR2 ESP v0.1.1 loaded")
