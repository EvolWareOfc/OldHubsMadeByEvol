--[[
    bScripts — Apocalypse Rising 2 ESP 0.1.1
    Full visual suite · spawned-only loot · no aim features
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local Workspace = game:GetService("Workspace")
local CollectionService = game:GetService("CollectionService")
local CoreGui = game:GetService("CoreGui")

local localPlayer = Players.LocalPlayer
local camera = Workspace.CurrentCamera
local mouse = localPlayer:GetMouse()

----------------------------------------------------------------
-- CONFIG
----------------------------------------------------------------
local CFG = {
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

local HIGHLIGHT_KEYWORDS = { "Medkit", "M4", "AK", "Energy Drink", "Military", "Tactical" }

local settingsFile = "bscripts_ar2_v40.json"
local function saveSettings()
    if writefile then pcall(function() writefile(settingsFile, HttpService:JSONEncode(CFG)) end) end
end
local function loadSettings()
    if not (readfile and isfile and isfile(settingsFile)) then return end
    local ok, data = pcall(function() return HttpService:JSONDecode(readfile(settingsFile)) end)
    if ok and type(data) == "table" then
        for k, v in pairs(data) do
            if CFG[k] ~= nil and type(CFG[k]) == type(v) then CFG[k] = v end
        end
    end
end
loadSettings()

----------------------------------------------------------------
-- FOLDERS / HELPERS
----------------------------------------------------------------
local hlFolder = Instance.new("Folder")
hlFolder.Name = "bScriptsAR2_HL"
pcall(function() hlFolder.Parent = CoreGui end)
if not hlFolder.Parent then hlFolder.Parent = localPlayer:WaitForChild("PlayerGui") end

local function charsFolder() return Workspace:FindFirstChild("Characters") end
local function zombiesFolder() return Workspace:FindFirstChild("Zombies") end
local function vehiclesFolder() return Workspace:FindFirstChild("Vehicles") end
local function corpsesFolder() return Workspace:FindFirstChild("Corpses") end

local function getHRP(m)
    if not m then return nil end
    return m:FindFirstChild("HumanoidRootPart")
        or m:FindFirstChild("UpperTorso")
        or m:FindFirstChild("Torso")
        or m:FindFirstChild("Head")
        or m:FindFirstChildWhichIsA("BasePart")
end
local function getHum(m) return m and m:FindFirstChildOfClass("Humanoid") end
local function getPart(m, n) return m and m:FindFirstChild(n) end

local localCharModel = nil
local function refreshLocalChar()
    local sub = camera and camera.CameraSubject
    if sub then
        if sub:IsA("Humanoid") and sub.Parent and sub.Parent:IsA("Model") then
            localCharModel = sub.Parent
            return localCharModel
        end
        if sub:IsA("BasePart") then
            local m = sub:FindFirstAncestorOfClass("Model")
            if m and charsFolder() and m.Parent == charsFolder() then
                localCharModel = m
                return localCharModel
            end
        end
    end
    if localPlayer.Character and getHRP(localPlayer.Character) then
        localCharModel = localPlayer.Character
    end
    return localCharModel
end

----------------------------------------------------------------
-- ITEM / GEAR HELPERS
----------------------------------------------------------------
local function getEquipped(character)
    if not character then return "Unarmed", "none" end
    local anim = character:FindFirstChild("Animator")
    if anim then
        local eq = anim:FindFirstChild("EquippedItem")
        if eq and eq:IsA("StringValue") and eq.Value ~= "" and eq.Value ~= "[]" then
            local ok, data = pcall(function() return HttpService:JSONDecode(eq.Value) end)
            if ok and type(data) == "table" and data.ItemName then
                local name = tostring(data.ItemName)
                return name, weaponCategory(name)
            end
            local name = eq.Value:match('"ItemName"%s*:%s*"([^"]+)"')
            if name then return name, weaponCategory(name) end
        end
    end
    return "Unarmed", "none"
end

function weaponCategory(name)
    if not name or name == "Unarmed" then return "none" end
    local n = name:lower()
    if n:find("knife") or n:find("machete") or n:find("bat") or n:find("axe") or n:find("crowbar") then
        return "melee"
    end
    if n:find("med") or n:find("bandage") or n:find("drink") or n:find("food") then
        return "util"
    end
    -- guns
    return "gun"
end

local function getEquipmentSlot(model, slot)
    local eq = model and model:FindFirstChild("Equipment")
    if not eq then return nil end
    for _, c in ipairs(eq:GetChildren()) do
        if c:GetAttribute("EquipSlot") == slot then
            return c:GetAttribute("ItemName") or c.Name
        end
        if slot == "Vest" and c.Name:find("Vest") then return c:GetAttribute("ItemName") or c.Name end
        if slot == "Backpack" and c.Name:find("Backpack") then return c:GetAttribute("ItemName") or c.Name end
    end
    return nil
end

local function getState(model)
    local hum = getHum(model)
    if not hum then return "?" end
    if hum.Health <= 0 then return "Dead" end
    local st = hum:GetState()
    if st == Enum.HumanoidStateType.Dead then return "Dead" end
    if st == Enum.HumanoidStateType.FallingDown or st == Enum.HumanoidStateType.Ragdoll then return "Down" end
    if st == Enum.HumanoidStateType.Seated then return "Seat" end
    if hum.MoveDirection.Magnitude > 0.1 then return "Move" end
    return "Idle"
end

local function resolveName(model)
    if not model then return "?" end
    for _, key in ipairs({ "PlayerName", "Username", "DisplayName", "UseText" }) do
        local a = model:GetAttribute(key)
        if type(a) == "string" and a ~= "" and a ~= model.Name then return a end
    end
    for _, d in ipairs(model:GetDescendants()) do
        if d:IsA("TextLabel") and (d.Name == "NameLabel" or d.Name == "Name") then
            if d.Text ~= "" and #d.Text < 28 then return d.Text end
        end
    end
    local n = model.Name
    if #n == 36 and n:find("-") then return n:sub(1, 8) end
    return n
end

-- Loot category from name
local function lootCategory(name)
    if not name then return "other" end
    local n = name:lower()
    if n:find("magazine") or n:find("rd ") or n:find("ammo") or n:find("round") then return "ammo" end
    if n:find("medkit") or n:find("bandage") or n:find("morphine") or n:find("blood") or n:find("splint") or n:find("pain") then return "medical" end
    if n:find("drink") or n:find("food") or n:find("beans") or n:find("water") or n:find("soda") or n:find("mre") or n:find("can") or n:find("energy") then return "food" end
    if n:find("vest") or n:find("backpack") or n:find("hat") or n:find("shirt") or n:find("pants") or n:find("mask") or n:find("belt") or n:find("accessory") or n:find("jacket") then return "clothing" end
    if n:find("ak") or n:find("m4") or n:find("rifle") or n:find("pistol") or n:find("shotgun") or n:find("smg") or n:find("sniper")
        or n:find("gun") or n:find("svt") or n:find("tec") or n:find("glock") or n:find("uzi") or n:find("thompson")
        or n:find("suppressor") or n:find("sight") or n:find("barrel") then return "weapon" end
    return "other"
end

local JUNK_NAMES = {
    Magazine = true, Base = true, Action = true, BarrelMount = true, Constant = true,
}
local function isJunkLabel(name)
    if not name then return true end
    if JUNK_NAMES[name] then return true end
    if #name < 4 then return true end
    return false
end

local function isKeyword(name)
    if not name then return false end
    for _, k in ipairs(HIGHLIGHT_KEYWORDS) do
        if name:lower():find(k:lower(), 1, true) then return true end
    end
    return false
end

----------------------------------------------------------------
-- SQUAD
----------------------------------------------------------------
local squadMembers = {}
task.spawn(function()
    while true do
        local members = {}
        local pg = localPlayer:FindFirstChild("PlayerGui")
        if pg then
            local function scan(obj, depth)
                if depth > 12 then return end
                if obj:IsA("TextLabel") and (obj.Name == "NameLabel" or obj.Name == "Name") then
                    local t = obj.Text
                    if t and t ~= "" and t ~= localPlayer.Name then members[t] = true end
                end
                for _, c in ipairs(obj:GetChildren()) do scan(c, depth + 1) end
            end
            for _, name in ipairs({ "PlayerList", "SquadList", "HUD", "Main", "Interface" }) do
                local n = pg:FindFirstChild(name, true)
                if n then scan(n, 0) end
            end
        end
        squadMembers = members
        task.wait(2)
    end
end)

----------------------------------------------------------------
-- VISIBILITY
----------------------------------------------------------------
local visCache, visFrame = {}, 0
local function isVisible(character, rootPart)
    if not rootPart then return false end
    local origin = camera.CFrame.Position
    local rayParams = RaycastParams.new()
    local filter = { character }
    if localCharModel then table.insert(filter, localCharModel) end
    local cf = charsFolder()
    if cf then for _, c in ipairs(cf:GetChildren()) do table.insert(filter, c) end end
    local zf = zombiesFolder()
    if zf then table.insert(filter, zf) end
    rayParams.FilterDescendantsInstances = filter
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    return Workspace:Raycast(origin, rootPart.Position - origin, rayParams) == nil
end

----------------------------------------------------------------
-- DRAWING
----------------------------------------------------------------
local function newLine(thick)
    local ok, l = pcall(function()
        local x = Drawing.new("Line")
        x.Thickness = thick or 1
        x.Visible = false
        return x
    end)
    return ok and l or nil
end
local function newText(size)
    local ok, t = pcall(function()
        local x = Drawing.new("Text")
        x.Size = size or 13
        x.Center = true
        x.Outline = true
        x.OutlineColor = Color3.new(0, 0, 0)
        x.Font = Drawing.Fonts.Plex
        x.Visible = false
        return x
    end)
    return ok and t or nil
end
local function newCircle()
    local ok, c = pcall(function()
        local x = Drawing.new("Circle")
        x.Thickness = 1
        x.NumSides = 12
        x.Filled = true
        x.Visible = false
        return x
    end)
    return ok and c or nil
end
local function newTri()
    local ok, t = pcall(function()
        local x = Drawing.new("Triangle")
        x.Filled = true
        x.Visible = false
        return x
    end)
    return ok and t or nil
end
local function hideLines(lines)
    if not lines then return end
    for _, l in ipairs(lines) do if l then l.Visible = false end end
end
local function setLine(l, a, b, color, thick)
    if not l then return end
    l.From, l.To, l.Color, l.Thickness, l.Visible = a, b, color, thick or 1.5, true
end
local function createBoxLines()
    local box = {}
    for i = 1, 12 do box[i] = newLine(1.5) end
    return box
end
local function getBoxBounds(hrp)
    if not hrp then return nil end
    local top = camera:WorldToViewportPoint(hrp.Position + Vector3.new(0, 3, 0))
    local bot = camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
    if top.Z < 0 or bot.Z < 0 then return nil end
    local h = math.abs(top.Y - bot.Y)
    local w = h * 0.55
    return top.X - w / 2, math.min(top.Y, bot.Y), w, h
end
local function drawCornerBox(lines, x, y, w, h, color, thick)
    local c = math.min(w, h) * 0.25
    setLine(lines[1], Vector2.new(x, y), Vector2.new(x + c, y), color, thick)
    setLine(lines[2], Vector2.new(x, y), Vector2.new(x, y + c), color, thick)
    setLine(lines[3], Vector2.new(x + w, y), Vector2.new(x + w - c, y), color, thick)
    setLine(lines[4], Vector2.new(x + w, y), Vector2.new(x + w, y + c), color, thick)
    setLine(lines[5], Vector2.new(x, y + h), Vector2.new(x + c, y + h), color, thick)
    setLine(lines[6], Vector2.new(x, y + h), Vector2.new(x, y + h - c), color, thick)
    setLine(lines[7], Vector2.new(x + w, y + h), Vector2.new(x + w - c, y + h), color, thick)
    setLine(lines[8], Vector2.new(x + w, y + h), Vector2.new(x + w, y + h - c), color, thick)
    for i = 9, 12 do if lines[i] then lines[i].Visible = false end end
end
local function draw2DBox(lines, x, y, w, h, color, thick)
    setLine(lines[1], Vector2.new(x, y), Vector2.new(x + w, y), color, thick)
    setLine(lines[2], Vector2.new(x, y + h), Vector2.new(x + w, y + h), color, thick)
    setLine(lines[3], Vector2.new(x, y), Vector2.new(x, y + h), color, thick)
    setLine(lines[4], Vector2.new(x + w, y), Vector2.new(x + w, y + h), color, thick)
    for i = 5, 12 do if lines[i] then lines[i].Visible = false end end
end
local function draw3DBox(lines, hrp, color, thick)
    local cf = hrp.CFrame
    local sx, sy, sz = 1.1, 2.6, 0.6
    local offsets = {
        Vector3.new(-sx,-sy,-sz), Vector3.new(sx,-sy,-sz), Vector3.new(sx,-sy,sz), Vector3.new(-sx,-sy,sz),
        Vector3.new(-sx,sy,-sz), Vector3.new(sx,sy,-sz), Vector3.new(sx,sy,sz), Vector3.new(-sx,sy,sz),
    }
    local corners = {}
    for i, o in ipairs(offsets) do
        local sp, on = camera:WorldToViewportPoint(cf:PointToWorldSpace(o))
        if not on or sp.Z < 0 then hideLines(lines) return end
        corners[i] = Vector2.new(sp.X, sp.Y)
    end
    setLine(lines[1], corners[1], corners[2], color, thick)
    setLine(lines[2], corners[2], corners[3], color, thick)
    setLine(lines[3], corners[3], corners[4], color, thick)
    setLine(lines[4], corners[4], corners[1], color, thick)
    setLine(lines[5], corners[5], corners[6], color, thick)
    setLine(lines[6], corners[6], corners[7], color, thick)
    setLine(lines[7], corners[7], corners[8], color, thick)
    setLine(lines[8], corners[8], corners[5], color, thick)
    setLine(lines[9], corners[1], corners[5], color, thick)
    setLine(lines[10], corners[2], corners[6], color, thick)
    setLine(lines[11], corners[3], corners[7], color, thick)
    setLine(lines[12], corners[4], corners[8], color, thick)
end

local BONES = {
    {"Head","UpperTorso"},{"UpperTorso","LowerTorso"},
    {"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},
    {"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},
    {"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},
    {"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"},
    {"Head","Torso"},{"Torso","Left Arm"},{"Torso","Right Arm"},{"Torso","Left Leg"},{"Torso","Right Leg"},
}
local function createSkeletonLines()
    local lines = {}
    for i = 1, #BONES do lines[i] = newLine(1.2) end
    return lines
end
local function drawSkeleton(lines, model, color, thick)
    for i, pair in ipairs(BONES) do
        local a, b = getPart(model, pair[1]), getPart(model, pair[2])
        if a and b and a:IsA("BasePart") and b:IsA("BasePart") then
            local sa, ona = camera:WorldToViewportPoint(a.Position)
            local sb, onb = camera:WorldToViewportPoint(b.Position)
            if ona and onb and sa.Z > 0 and sb.Z > 0 then
                setLine(lines[i], Vector2.new(sa.X, sa.Y), Vector2.new(sb.X, sb.Y), color, thick)
            elseif lines[i] then lines[i].Visible = false end
        elseif lines[i] then lines[i].Visible = false end
    end
end

local function createHealthBar() return { bg = newLine(4), fill = newLine(3) } end
local function drawHealthBar(bar, x, y, h, health, maxHealth)
    if not bar or not bar.bg then return end
    local pct = math.clamp(health / math.max(maxHealth, 1), 0, 1)
    local col = Color3.fromRGB(math.floor(255 * (1 - pct)), math.floor(255 * pct), 40)
    setLine(bar.bg, Vector2.new(x - 6, y), Vector2.new(x - 6, y + h), Color3.fromRGB(20, 20, 20), 4)
    setLine(bar.fill, Vector2.new(x - 6, y + h - h * pct), Vector2.new(x - 6, y + h), col, 3)
end

local function drawOffScreenArrow(tri, worldPos, color)
    if not tri then return end
    local sp, on = camera:WorldToViewportPoint(worldPos)
    local sx, sy = camera.ViewportSize.X, camera.ViewportSize.Y
    if on and sp.Z > 0 and sp.X > 25 and sp.X < sx - 25 and sp.Y > 25 and sp.Y < sy - 25 then
        tri.Visible = false
        return
    end
    local dir = Vector2.new(sp.X - sx / 2, sp.Y - sy / 2)
    if sp.Z < 0 then dir = -dir end
    local mag = math.max(dir.Magnitude, 1)
    dir = dir / mag
    local center = Vector2.new(sx / 2, sy / 2) + dir * (math.min(sx, sy) * 0.42)
    local ang = math.atan2(dir.Y, dir.X)
    local size = 10
    tri.PointA = center
    tri.PointB = center + Vector2.new(math.cos(ang + 2.5) * size, math.sin(ang + 2.5) * size)
    tri.PointC = center + Vector2.new(math.cos(ang - 2.5) * size, math.sin(ang - 2.5) * size)
    tri.Color = color
    tri.Visible = true
end

local function makeBillboard(adornee, text, color)
    local bb = Instance.new("BillboardGui")
    bb.AlwaysOnTop = true
    bb.Size = UDim2.new(0, 180, 0, 48)
    bb.StudsOffset = Vector3.new(0, 3.2, 0)
    bb.MaxDistance = 6000
    bb.Adornee = adornee
    bb.Parent = hlFolder
    local tl = Instance.new("TextLabel")
    tl.BackgroundTransparency = 1
    tl.Size = UDim2.new(1, 0, 1, 0)
    tl.Font = Enum.Font.GothamBold
    tl.TextSize = 13
    tl.TextColor3 = color or Color3.fromRGB(255, 80, 80)
    tl.TextStrokeTransparency = 0.3
    tl.Text = text
    tl.TextWrapped = true
    tl.Parent = bb
    return bb, tl
end

local function distColor(dist, maxd)
    local t = math.clamp(dist / maxd, 0, 1)
    -- near = warmer red, far = cooler
    return Color3.fromRGB(
        math.floor(255 * (1 - t * 0.3)),
        math.floor(80 + 100 * t),
        math.floor(60 + 40 * t)
    )
end

local COL_ENEMY = Color3.fromRGB(255, 60, 60)
local COL_VIS = Color3.fromRGB(0, 255, 100)
local COL_SQUAD = Color3.fromRGB(50, 150, 255)
local COL_GUN = Color3.fromRGB(255, 180, 40)
local COL_MELEE = Color3.fromRGB(200, 200, 200)
local COL_LOOT = {
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
local espData, zombieData, vehicleData, corpseData, lootData, fuelData = {}, {}, {}, {}, {}, {}

local function destroyPlayerESP(model)
    local d = espData[model]
    if not d then return end
    if d.highlight then pcall(function() d.highlight:Destroy() end) end
    if d.billboard then pcall(function() d.billboard:Destroy() end) end
    if d.box then hideLines(d.box) for _, l in ipairs(d.box) do pcall(function() if l then l:Remove() end end) end end
    if d.skel then hideLines(d.skel) for _, l in ipairs(d.skel) do pcall(function() if l then l:Remove() end end) end end
    if d.tracer then pcall(function() if d.tracer then d.tracer:Remove() end end) end
    if d.text then pcall(function() if d.text then d.text:Remove() end end) end
    if d.text2 then pcall(function() if d.text2 then d.text2:Remove() end end) end
    if d.hpBar then pcall(function() if d.hpBar.bg then d.hpBar.bg:Remove() end end) pcall(function() if d.hpBar.fill then d.hpBar.fill:Remove() end end) end
    if d.arrow then pcall(function() if d.arrow then d.arrow:Remove() end end) end
    if d.headDot then pcall(function() if d.headDot then d.headDot:Remove() end end) end
    if d.facing then pcall(function() if d.facing then d.facing:Remove() end end) end
    espData[model] = nil
    visCache[model] = nil
end

local function addPlayerESP(model)
    if espData[model] or not model or not model.Parent then return end
    local hrp = getHRP(model)
    if not hrp then return end

    local hl = Instance.new("Highlight")
    hl.FillTransparency = 0.45
    hl.OutlineTransparency = 0
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.FillColor = COL_ENEMY
    hl.OutlineColor = COL_ENEMY
    hl.Adornee = model
    hl.Parent = hlFolder

    local bb, tl = makeBillboard(hrp, resolveName(model), COL_ENEMY)

    espData[model] = {
        highlight = hl, billboard = bb, billboardLabel = tl,
        box = createBoxLines(), skel = createSkeletonLines(),
        tracer = newLine(1), text = newText(13), text2 = newText(12),
        hpBar = createHealthBar(), arrow = newTri(),
        headDot = newCircle(), facing = newLine(1.5),
        hrp = hrp, hum = getHum(model), model = model, name = resolveName(model),
    }
    if espData[model].text2 then espData[model].text2.Color = COL_GUN end
    local hum = espData[model].hum
    if hum then
        hum.Died:Connect(function() task.delay(0.4, function() destroyPlayerESP(model) end) end)
    end
end

local function clearZombie(model)
    local d = zombieData[model]
    if not d then return end
    if d.highlight then pcall(function() d.highlight:Destroy() end) end
    if d.billboard then pcall(function() d.billboard:Destroy() end) end
    zombieData[model] = nil
end
local function addZombie(model)
    if zombieData[model] then return end
    local hrp = getHRP(model)
    if not hrp then return end
    local hl
    if CFG.ZombieChams then
        hl = Instance.new("Highlight")
        hl.FillTransparency = 0.5
        hl.OutlineTransparency = 0
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.FillColor = Color3.fromRGB(180, 40, 255)
        hl.OutlineColor = Color3.fromRGB(200, 80, 255)
        hl.Adornee = model
        hl.Parent = hlFolder
    end
    local bb, tl = makeBillboard(hrp, model.Name ~= "Infected Civilian" and model.Name or "Infected", Color3.fromRGB(180, 40, 255))
    bb.StudsOffset = Vector3.new(0, 2.5, 0)
    zombieData[model] = { highlight = hl, billboard = bb, billboardLabel = tl, hrp = hrp, model = model }
end

local function clearVehicle(model)
    local d = vehicleData[model]
    if not d then return end
    if d.billboard then pcall(function() d.billboard:Destroy() end) end
    vehicleData[model] = nil
end
local function vehicleOccupied(model)
    for _, d in ipairs(model:GetDescendants()) do
        if d:IsA("VehicleSeat") or d:IsA("Seat") then
            if d.Occupant then return true end
        end
    end
    return false
end
local function addVehicle(model)
    if vehicleData[model] then return end
    local part = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart", true)
    if not part then return end
    local bb, tl = makeBillboard(part, "[VEH] " .. model.Name, Color3.fromRGB(255, 180, 40))
    bb.StudsOffset = Vector3.new(0, 4, 0)
    vehicleData[model] = { billboard = bb, billboardLabel = tl, part = part, model = model }
end

local function clearCorpse(model)
    local d = corpseData[model]
    if not d then return end
    if d.highlight then pcall(function() d.highlight:Destroy() end) end
    if d.billboard then pcall(function() d.billboard:Destroy() end) end
    corpseData[model] = nil
end
local function addCorpse(model)
    if corpseData[model] then return end
    local part = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Head") or model:FindFirstChildWhichIsA("BasePart")
    if not part then return end
    local name = model:GetAttribute("UseText") or "Corpse"
    local gear = {}
    if CFG.CorpseGear then
        local vest = getEquipmentSlot(model, "Vest")
        local bag = getEquipmentSlot(model, "Backpack")
        if vest then table.insert(gear, vest) end
        if bag then table.insert(gear, bag) end
    end
    local label = "[CORPSE] " .. tostring(name)
    if #gear > 0 then label = label .. "\n" .. table.concat(gear, " | ") end
    local hl = Instance.new("Highlight")
    hl.FillTransparency = 0.6
    hl.OutlineTransparency = 0.2
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.FillColor = Color3.fromRGB(140, 140, 140)
    hl.OutlineColor = Color3.fromRGB(200, 200, 200)
    hl.Adornee = model
    hl.Parent = hlFolder
    local bb, tl = makeBillboard(part, label, Color3.fromRGB(180, 180, 180))
    bb.StudsOffset = Vector3.new(0, 2, 0)
    corpseData[model] = { highlight = hl, billboard = bb, billboardLabel = tl, part = part, model = model, name = name }
end

local function clearLoot(inst)
    local d = lootData[inst]
    if not d then return end
    if d.billboard then pcall(function() d.billboard:Destroy() end) end
    lootData[inst] = nil
end
local function addLoot(inst, label)
    if lootData[inst] then return end
    local part = inst:IsA("BasePart") and inst or (inst.PrimaryPart or inst:FindFirstChildWhichIsA("BasePart", true))
    if not part then return end
    local cat = lootCategory(label)
    local col = isKeyword(label) and Color3.fromRGB(255, 215, 0) or (COL_LOOT[cat] or COL_LOOT.other)
    local bb, tl = makeBillboard(part, "[LOOT] " .. tostring(label), col)
    bb.StudsOffset = Vector3.new(0, 1.5, 0)
    bb.MaxDistance = CFG.LootMaxDist
    lootData[inst] = { billboard = bb, billboardLabel = tl, part = part, model = inst, name = label, cat = cat }
end

local function clearFuel(inst)
    local d = fuelData[inst]
    if not d then return end
    if d.billboard then pcall(function() d.billboard:Destroy() end) end
    fuelData[inst] = nil
end
local function addFuel(inst)
    if fuelData[inst] then return end
    local part = inst:IsA("BasePart") and inst or inst:FindFirstChildWhichIsA("BasePart", true)
    if not part then return end
    local bb, tl = makeBillboard(part, "[FUEL]", Color3.fromRGB(255, 140, 40))
    bb.StudsOffset = Vector3.new(0, 3, 0)
    fuelData[inst] = { billboard = bb, billboardLabel = tl, part = part, model = inst }
end

----------------------------------------------------------------
-- LOOT DETECTION (spawned only)
----------------------------------------------------------------
local STRUCT_PARTS = {
    Base = true, BarrelMount = true, Action = true, Magazine = true, Constant = true,
    SightMount = true, UnderbarrelMount = true, Mesh = true, Handle = true,
    ["1"] = true, ["2"] = true, ["3"] = true, ["4"] = true, ["5"] = true,
}
local function isRealItemName(n)
    if not n or STRUCT_PARTS[n] or n == "Model" or n == "Part" then return false end
    if #n < 3 or not n:find("%a") then return false end
    return true
end
local function getSpawnedLootLabel(model)
    local attr = model:GetAttribute("ItemName")
    if attr and attr ~= "" then return tostring(attr) end
    local best = nil
    for _, c in ipairs(model:GetChildren()) do
        local iname = c:GetAttribute("ItemName")
        if iname and iname ~= "" then return tostring(iname) end
        if isRealItemName(c.Name) then
            if not best or #c.Name > #best then best = c.Name end
        end
    end
    return best
end
local function isTerrainGroundLoot(model)
    if not model or not model:IsA("Model") then return false end
    if model.Name == "FuelTank1" or model.Name == "FuelPump" then return false end
    local label = getSpawnedLootLabel(model)
    if not label then return false end
    if CFG.LootIgnoreJunk and isJunkLabel(label) then return false end
    local hasBase = model:FindFirstChild("Base") ~= nil
    local hasMount = model:FindFirstChild("BarrelMount") or model:FindFirstChild("Action") or model:FindFirstChild("Magazine")
    if hasBase or hasMount then return true, label end
    local parts = 0
    for _, c in ipairs(model:GetChildren()) do
        if c:IsA("BasePart") or c:IsA("MeshPart") then parts += 1 end
    end
    if parts > 0 and parts <= 25 then return true, label end
    return false
end
local function isLootCandidate(inst)
    if not inst then return false end
    if charsFolder() and inst:IsDescendantOf(charsFolder()) then return false end
    if corpsesFolder() and inst:IsDescendantOf(corpsesFolder()) then return false end
    if zombiesFolder() and inst:IsDescendantOf(zombiesFolder()) then return false end
    if vehiclesFolder() and inst:IsDescendantOf(vehiclesFolder()) then return false end
    if inst.Name == "LootNode" then return false end
    if CollectionService:HasTag(inst, "Entity Loot Node") then return false end
    if inst:IsA("Model") then
        local ok, label = isTerrainGroundLoot(inst)
        if ok then
            local cat = lootCategory(label)
            if cat == "weapon" and not CFG.LootWeapons then return false end
            if cat == "ammo" and not CFG.LootAmmo then return false end
            if cat == "medical" and not CFG.LootMedical then return false end
            if cat == "food" and not CFG.LootFood then return false end
            if cat == "clothing" and not CFG.LootClothing then return false end
            if cat == "other" and not CFG.LootOther then return false end
            return true, label
        end
    end
    return false
end

----------------------------------------------------------------
-- SCAN + HOOKS
----------------------------------------------------------------
local function scanPlayers()
    refreshLocalChar()
    local seen = {}
    local cf = charsFolder()
    if cf then
        for _, m in ipairs(cf:GetChildren()) do
            if m:IsA("Model") and m ~= localCharModel then
                seen[m] = true
                if not espData[m] then addPlayerESP(m)
                else
                    local d = espData[m]
                    d.hrp = getHRP(m) or d.hrp
                    d.hum = getHum(m) or d.hum
                    d.name = resolveName(m)
                    if d.billboard and d.hrp then d.billboard.Adornee = d.hrp end
                end
            elseif m == localCharModel and espData[m] then
                destroyPlayerESP(m)
            end
        end
    end
    for m in pairs(espData) do
        if not seen[m] or not m.Parent then destroyPlayerESP(m) end
    end
end

local function scanZombies()
    local seen = {}
    if CFG.ZombieESP then
        local zf = zombiesFolder()
        if zf then
            for _, m in ipairs(zf:GetChildren()) do
                if m:IsA("Model") then seen[m] = true addZombie(m) end
            end
        end
    end
    for m in pairs(zombieData) do if not seen[m] or not m.Parent then clearZombie(m) end end
end

local function scanVehicles()
    local seen = {}
    if CFG.VehicleESP then
        local vf = vehiclesFolder()
        if vf then
            for _, m in ipairs(vf:GetChildren()) do
                if m:IsA("Model") then seen[m] = true addVehicle(m) end
            end
        end
    end
    for m in pairs(vehicleData) do if not seen[m] or not m.Parent then clearVehicle(m) end end
end

local function scanCorpses()
    local seen = {}
    if CFG.CorpseESP then
        local cof = corpsesFolder()
        if cof then
            for _, m in ipairs(cof:GetChildren()) do
                if m:IsA("Model") then seen[m] = true addCorpse(m) end
            end
        end
    end
    for m in pairs(corpseData) do if not seen[m] or not m.Parent then clearCorpse(m) end end
end

local function scanLoot()
    local seen = {}
    if CFG.LootESP then
        local map = Workspace:FindFirstChild("Map")
        local terrain = map and map:FindFirstChild("Terrain")
        if terrain then
            for _, chunk in ipairs(terrain:GetChildren()) do
                for _, child in ipairs(chunk:GetChildren()) do
                    if child:IsA("Model") then
                        local ok, label = isLootCandidate(child)
                        if ok then seen[child] = true addLoot(child, label) end
                    end
                end
            end
        end
    end
    for m in pairs(lootData) do if not seen[m] or not m.Parent then clearLoot(m) end end
end

local function scanFuel()
    local seen = {}
    if CFG.FuelESP then
        pcall(function()
            for _, inst in ipairs(CollectionService:GetTagged("Entity Fuel Pump")) do
                seen[inst] = true
                addFuel(inst)
            end
        end)
        local map = Workspace:FindFirstChild("Map")
        local terrain = map and map:FindFirstChild("Terrain")
        if terrain then
            for _, chunk in ipairs(terrain:GetChildren()) do
                for _, child in ipairs(chunk:GetDescendants()) do
                    if child.Name == "FuelPump" or child.Name == "FuelTank1" then
                        seen[child] = true
                        addFuel(child)
                    end
                end
            end
        end
    end
    for m in pairs(fuelData) do if not seen[m] or not m.Parent then clearFuel(m) end end
end

local function scanAll()
    pcall(scanPlayers)
    pcall(scanZombies)
    pcall(scanVehicles)
    pcall(scanCorpses)
    pcall(scanLoot)
    pcall(scanFuel)
end

local function hookFolder(getFolder, onAdd, onRemove)
    task.spawn(function()
        while true do
            local f = getFolder()
            if f then
                for _, c in ipairs(f:GetChildren()) do pcall(onAdd, c) end
                f.ChildAdded:Connect(function(c) task.defer(function() pcall(onAdd, c) end) end)
                f.ChildRemoved:Connect(function(c) pcall(onRemove, c) end)
                f.DescendantAdded:Connect(function(d)
                    if d.Name == "HumanoidRootPart" and d.Parent and d.Parent:IsA("Model") then
                        task.defer(function() pcall(onAdd, d.Parent) end)
                    end
                end)
                break
            end
            task.wait(1)
        end
    end)
end
hookFolder(charsFolder, function(m) if m:IsA("Model") and m ~= refreshLocalChar() then addPlayerESP(m) end end, destroyPlayerESP)
hookFolder(zombiesFolder, function(m) if CFG.ZombieESP and m:IsA("Model") then addZombie(m) end end, clearZombie)
hookFolder(vehiclesFolder, function(m) if CFG.VehicleESP and m:IsA("Model") then addVehicle(m) end end, clearVehicle)
hookFolder(corpsesFolder, function(m) if CFG.CorpseESP and m:IsA("Model") then addCorpse(m) end end, clearCorpse)

task.spawn(function()
    local function hookChunk(chunk)
        for _, child in ipairs(chunk:GetChildren()) do
            if CFG.LootESP and child:IsA("Model") then
                local ok, label = isLootCandidate(child)
                if ok then addLoot(child, label) end
            end
        end
        chunk.ChildAdded:Connect(function(child)
            task.defer(function()
                if CFG.LootESP and child:IsA("Model") then
                    local ok, label = isLootCandidate(child)
                    if ok then addLoot(child, label) end
                end
            end)
        end)
        chunk.ChildRemoved:Connect(clearLoot)
    end
    while true do
        local map = Workspace:FindFirstChild("Map")
        local terrain = map and map:FindFirstChild("Terrain")
        if terrain then
            for _, chunk in ipairs(terrain:GetChildren()) do hookChunk(chunk) end
            terrain.ChildAdded:Connect(function(c) task.defer(function() hookChunk(c) end) end)
            break
        end
        task.wait(1)
    end
end)

task.spawn(function()
    while true do scanAll() task.wait(1.5) end
end)
task.defer(scanAll)

----------------------------------------------------------------
-- ENV
----------------------------------------------------------------
local orig = {
    Brightness = Lighting.Brightness, ClockTime = Lighting.ClockTime, FogEnd = Lighting.FogEnd,
    Ambient = Lighting.Ambient, OutdoorAmbient = Lighting.OutdoorAmbient,
}
local fbConn
local function applyEnv()
    if fbConn then fbConn:Disconnect() fbConn = nil end
    if CFG.Fullbright or CFG.NoFog then
        fbConn = RunService.RenderStepped:Connect(function()
            if CFG.Fullbright then
                Lighting.Brightness = 2
                Lighting.ClockTime = 14
                Lighting.Ambient = Color3.fromRGB(180, 180, 180)
                Lighting.OutdoorAmbient = Color3.fromRGB(180, 180, 180)
            end
            if CFG.NoFog or CFG.Fullbright then Lighting.FogEnd = 1e6 end
        end)
    else
        Lighting.Brightness = orig.Brightness
        Lighting.ClockTime = orig.ClockTime
        Lighting.FogEnd = orig.FogEnd
        Lighting.Ambient = orig.Ambient
        Lighting.OutdoorAmbient = orig.OutdoorAmbient
    end
end

----------------------------------------------------------------
-- UI
----------------------------------------------------------------
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "bScriptsAR2v40"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() screenGui.Parent = CoreGui end)
if not screenGui.Parent then screenGui.Parent = localPlayer:WaitForChild("PlayerGui") end

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 280, 0, 560)
frame.Position = UDim2.new(0.5, -140, 0.5, -280)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
frame.BorderSizePixel = 0
frame.ZIndex = 10
frame.Parent = screenGui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 4)
topBar.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
topBar.BorderSizePixel = 0
topBar.ZIndex = 11
topBar.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 0, 36)
title.Position = UDim2.new(0, 10, 0, 6)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.Bangers
title.TextSize = 20
title.Text = "bScripts"
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 11
title.Parent = frame

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, -40, 0, 16)
subtitle.Position = UDim2.new(0, 10, 0, 26)
subtitle.BackgroundTransparency = 1
subtitle.TextColor3 = Color3.fromRGB(100, 100, 100)
subtitle.Font = Enum.Font.Gotham
subtitle.TextSize = 11
subtitle.Text = "apoc2 · v0.1.1"
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.ZIndex = 11
subtitle.Parent = frame

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -34, 0, 8)
closeBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
closeBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.Text = "×"
closeBtn.BorderSizePixel = 0
closeBtn.ZIndex = 11
closeBtn.Parent = frame

local sep = Instance.new("Frame")
sep.Size = UDim2.new(1, 0, 0, 1)
sep.Position = UDim2.new(0, 0, 0, 42)
sep.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
sep.BorderSizePixel = 0
sep.ZIndex = 11
sep.Parent = frame

local tabsFrame = Instance.new("Frame")
tabsFrame.Size = UDim2.new(1, 0, 0, 32)
tabsFrame.Position = UDim2.new(0, 0, 0, 43)
tabsFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
tabsFrame.BorderSizePixel = 0
tabsFrame.ZIndex = 11
tabsFrame.Parent = frame

local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, 0, 1, -76)
contentFrame.Position = UDim2.new(0, 0, 0, 76)
contentFrame.BackgroundTransparency = 1
contentFrame.ZIndex = 11
contentFrame.Parent = frame

local anyListening = false
local tabNames = { "Players", "Loot", "World", "Misc" }
local tabButtons, tabContents = {}, {}

local function createCheckbox(parent, labelText, yPos, default, callback, indent)
    local indentSize = indent and 14 or 0
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -20 - indentSize, 0, 22)
    row.Position = UDim2.new(0, 10 + indentSize, 0, yPos)
    row.BackgroundTransparency = 1
    row.ZIndex = 12
    row.Parent = parent
    local box = Instance.new("Frame")
    box.Size = UDim2.new(0, 14, 0, 14)
    box.Position = UDim2.new(0, 0, 0.5, -7)
    box.BackgroundColor3 = default and Color3.fromRGB(88, 101, 242) or Color3.fromRGB(30, 30, 30)
    box.BorderSizePixel = 1
    box.BorderColor3 = Color3.fromRGB(60, 60, 60)
    box.ZIndex = 13
    box.Parent = row
    local tick = Instance.new("TextLabel")
    tick.Size = UDim2.new(1, 0, 1, 0)
    tick.BackgroundTransparency = 1
    tick.TextColor3 = Color3.fromRGB(255, 255, 255)
    tick.Font = Enum.Font.GothamBold
    tick.TextSize = 10
    tick.Text = default and "✓" or ""
    tick.ZIndex = 14
    tick.Parent = box
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 1, 0)
    label.Position = UDim2.new(0, 20, 0, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = indent and Color3.fromRGB(160, 160, 160) or Color3.fromRGB(200, 200, 200)
    label.Font = Enum.Font.Gotham
    label.TextSize = indent and 11 or 12
    label.Text = labelText
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 13
    label.Parent = row
    local enabled = default or false
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.ZIndex = 15
    btn.Parent = row
    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        box.BackgroundColor3 = enabled and Color3.fromRGB(88, 101, 242) or Color3.fromRGB(30, 30, 30)
        tick.Text = enabled and "✓" or ""
        if callback then callback(enabled) end
    end)
end

local function createDropdown(parent, labelText, yPos, options, current, callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -20, 0, 22)
    row.Position = UDim2.new(0, 10, 0, yPos)
    row.BackgroundTransparency = 1
    row.ZIndex = 12
    row.Parent = parent
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.45, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.Text = labelText
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 13
    label.Parent = row
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.5, 0, 0, 18)
    btn.Position = UDim2.new(0.5, 0, 0.5, -9)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.Text = tostring(current)
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.fromRGB(60, 60, 60)
    btn.ZIndex = 13
    btn.Parent = row
    local idx = 1
    for i, o in ipairs(options) do if o == current then idx = i break end end
    btn.MouseButton1Click:Connect(function()
        idx = idx % #options + 1
        btn.Text = options[idx]
        if callback then callback(options[idx]) end
    end)
end

local function createKeybind(parent, labelText, yPos, defaultKey, callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -20, 0, 24)
    row.Position = UDim2.new(0, 10, 0, yPos)
    row.BackgroundTransparency = 1
    row.ZIndex = 12
    row.Parent = parent
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.Text = labelText
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 13
    label.Parent = row
    local keyBtn = Instance.new("TextButton")
    keyBtn.Size = UDim2.new(0, 52, 0, 18)
    keyBtn.Position = UDim2.new(1, -52, 0.5, -9)
    keyBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    keyBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    keyBtn.Font = Enum.Font.GothamBold
    keyBtn.TextSize = 11
    keyBtn.Text = defaultKey
    keyBtn.BorderSizePixel = 1
    keyBtn.BorderColor3 = Color3.fromRGB(60, 60, 60)
    keyBtn.ZIndex = 13
    keyBtn.Parent = row
    local listening, currentKey = false, defaultKey
    keyBtn.MouseButton1Click:Connect(function()
        if anyListening then return end
        listening = true
        anyListening = true
        keyBtn.Text = "..."
        keyBtn.TextColor3 = Color3.fromRGB(88, 101, 242)
    end)
    UserInputService.InputBegan:Connect(function(input, gp)
        if listening then
            if input.KeyCode == Enum.KeyCode.Unknown then return end
            listening = false
            anyListening = false
            currentKey = input.KeyCode.Name
            keyBtn.Text = currentKey
            keyBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        elseif not gp and input.KeyCode == Enum.KeyCode[currentKey] then
            if callback then callback() end
        end
    end)
end

-- Players
local playersContent = Instance.new("ScrollingFrame")
playersContent.Size = UDim2.new(1, 0, 1, 0)
playersContent.BackgroundTransparency = 1
playersContent.Visible = true
playersContent.ZIndex = 12
playersContent.BorderSizePixel = 0
playersContent.ScrollBarThickness = 3
playersContent.CanvasSize = UDim2.new(0, 0, 0, 560)
playersContent.Parent = contentFrame

local y = 4
local function py(dy) local p = y y += dy return p end
createCheckbox(playersContent, "ESP Master", py(22), CFG.ESP, function(v) CFG.ESP = v saveSettings() end)
createCheckbox(playersContent, "Chams", py(22), CFG.Chams, function(v) CFG.Chams = v saveSettings() end, true)
createCheckbox(playersContent, "Visible Check", py(22), CFG.ChamsVisCheck, function(v) CFG.ChamsVisCheck = v saveSettings() end, true)
createCheckbox(playersContent, "Box ESP", py(22), CFG.Box, function(v) CFG.Box = v saveSettings() end, true)
createDropdown(playersContent, "Box Style", py(22), { "2D", "Corner", "3D" }, CFG.BoxStyle, function(v) CFG.BoxStyle = v saveSettings() end)
createCheckbox(playersContent, "Skeleton", py(22), CFG.Skeleton, function(v) CFG.Skeleton = v saveSettings() end, true)
createCheckbox(playersContent, "Tracers", py(22), CFG.Tracers, function(v) CFG.Tracers = v saveSettings() end, true)
createDropdown(playersContent, "Tracer Origin", py(22), { "Bottom", "Center", "Top", "Mouse" }, CFG.TracerOrigin, function(v) CFG.TracerOrigin = v saveSettings() end)
createCheckbox(playersContent, "Head Dot", py(22), CFG.HeadDot, function(v) CFG.HeadDot = v saveSettings() end, true)
createCheckbox(playersContent, "Facing Arrow", py(22), CFG.Facing, function(v) CFG.Facing = v saveSettings() end, true)
createCheckbox(playersContent, "Show Name", py(22), CFG.ShowName, function(v) CFG.ShowName = v saveSettings() end, true)
createCheckbox(playersContent, "Show Distance", py(22), CFG.ShowDistance, function(v) CFG.ShowDistance = v saveSettings() end, true)
createCheckbox(playersContent, "Show Health", py(22), CFG.ShowHealth, function(v) CFG.ShowHealth = v saveSettings() end, true)
createCheckbox(playersContent, "Health Bar", py(22), CFG.ShowHealthBar, function(v) CFG.ShowHealthBar = v saveSettings() end, true)
createCheckbox(playersContent, "Show Weapon", py(22), CFG.ShowWeapon, function(v) CFG.ShowWeapon = v saveSettings() end, true)
createCheckbox(playersContent, "Weapon Colors", py(22), CFG.WeaponColors, function(v) CFG.WeaponColors = v saveSettings() end, true)
createCheckbox(playersContent, "Show Armor / Vest", py(22), CFG.ShowArmor, function(v) CFG.ShowArmor = v saveSettings() end, true)
createCheckbox(playersContent, "Show Backpack", py(22), CFG.ShowBackpack, function(v) CFG.ShowBackpack = v saveSettings() end, true)
createCheckbox(playersContent, "Show State", py(22), CFG.ShowState, function(v) CFG.ShowState = v saveSettings() end, true)
createCheckbox(playersContent, "Squad Check", py(22), CFG.SquadCheck, function(v) CFG.SquadCheck = v saveSettings() end)
createCheckbox(playersContent, "Off-Screen Arrows", py(22), CFG.OffScreen, function(v) CFG.OffScreen = v saveSettings() end)
createCheckbox(playersContent, "Distance Fade", py(22), CFG.DistFade, function(v) CFG.DistFade = v saveSettings() end)
createCheckbox(playersContent, "Optimised far dots", py(22), CFG.Optimised, function(v) CFG.Optimised = v saveSettings() end)

-- Loot
local lootContent = Instance.new("ScrollingFrame")
lootContent.Size = UDim2.new(1, 0, 1, 0)
lootContent.BackgroundTransparency = 1
lootContent.Visible = false
lootContent.ZIndex = 12
lootContent.BorderSizePixel = 0
lootContent.ScrollBarThickness = 3
lootContent.CanvasSize = UDim2.new(0, 0, 0, 280)
lootContent.Parent = contentFrame
y = 4
createCheckbox(lootContent, "Loot ESP (spawned only)", py(24), CFG.LootESP, function(v)
    CFG.LootESP = v
    if not v then for m in pairs(lootData) do clearLoot(m) end end
    saveSettings()
end)
createCheckbox(lootContent, "Weapons", py(22), CFG.LootWeapons, function(v) CFG.LootWeapons = v saveSettings() end, true)
createCheckbox(lootContent, "Ammo / Mags", py(22), CFG.LootAmmo, function(v) CFG.LootAmmo = v saveSettings() end, true)
createCheckbox(lootContent, "Medical", py(22), CFG.LootMedical, function(v) CFG.LootMedical = v saveSettings() end, true)
createCheckbox(lootContent, "Food / Drink", py(22), CFG.LootFood, function(v) CFG.LootFood = v saveSettings() end, true)
createCheckbox(lootContent, "Clothing", py(22), CFG.LootClothing, function(v) CFG.LootClothing = v saveSettings() end, true)
createCheckbox(lootContent, "Other", py(22), CFG.LootOther, function(v) CFG.LootOther = v saveSettings() end, true)
createCheckbox(lootContent, "Ignore Junk Labels", py(22), CFG.LootIgnoreJunk, function(v) CFG.LootIgnoreJunk = v saveSettings() end, true)

-- World
local worldContent = Instance.new("Frame")
worldContent.Size = UDim2.new(1, 0, 1, 0)
worldContent.BackgroundTransparency = 1
worldContent.Visible = false
worldContent.ZIndex = 12
worldContent.Parent = contentFrame
y = 4
createCheckbox(worldContent, "Zombie / Infected ESP", py(24), CFG.ZombieESP, function(v)
    CFG.ZombieESP = v
    if not v then for m in pairs(zombieData) do clearZombie(m) end end
    saveSettings()
end)
createCheckbox(worldContent, "Zombie Chams", py(22), CFG.ZombieChams, function(v) CFG.ZombieChams = v saveSettings() end, true)
createCheckbox(worldContent, "Vehicle ESP", py(22), CFG.VehicleESP, function(v)
    CFG.VehicleESP = v
    if not v then for m in pairs(vehicleData) do clearVehicle(m) end end
    saveSettings()
end)
createCheckbox(worldContent, "Vehicle Occupancy", py(22), CFG.VehicleOccupancy, function(v) CFG.VehicleOccupancy = v saveSettings() end, true)
createCheckbox(worldContent, "Corpse ESP", py(22), CFG.CorpseESP, function(v)
    CFG.CorpseESP = v
    if not v then for m in pairs(corpseData) do clearCorpse(m) end end
    saveSettings()
end)
createCheckbox(worldContent, "Corpse Gear Preview", py(22), CFG.CorpseGear, function(v) CFG.CorpseGear = v saveSettings() end, true)
createCheckbox(worldContent, "Fuel Pump ESP", py(22), CFG.FuelESP, function(v)
    CFG.FuelESP = v
    if not v then for m in pairs(fuelData) do clearFuel(m) end end
    saveSettings()
end)
createCheckbox(worldContent, "Fullbright", py(22), CFG.Fullbright, function(v) CFG.Fullbright = v applyEnv() saveSettings() end)
createCheckbox(worldContent, "No Fog", py(22), CFG.NoFog, function(v) CFG.NoFog = v applyEnv() saveSettings() end)

local statusLbl = Instance.new("TextLabel")
statusLbl.Size = UDim2.new(1, -20, 0, 50)
statusLbl.Position = UDim2.new(0, 10, 0, 250)
statusLbl.BackgroundTransparency = 1
statusLbl.TextColor3 = Color3.fromRGB(120, 120, 120)
statusLbl.Font = Enum.Font.Gotham
statusLbl.TextSize = 11
statusLbl.TextXAlignment = Enum.TextXAlignment.Left
statusLbl.TextYAlignment = Enum.TextYAlignment.Top
statusLbl.ZIndex = 12
statusLbl.Parent = worldContent
task.spawn(function()
    while statusLbl.Parent do
        local pc, zc, vc, cc, lc, fc = 0, 0, 0, 0, 0, 0
        for _ in pairs(espData) do pc += 1 end
        for _ in pairs(zombieData) do zc += 1 end
        for _ in pairs(vehicleData) do vc += 1 end
        for _ in pairs(corpseData) do cc += 1 end
        for _ in pairs(lootData) do lc += 1 end
        for _ in pairs(fuelData) do fc += 1 end
        statusLbl.Text = string.format("P:%d Z:%d V:%d C:%d L:%d F:%d", pc, zc, vc, cc, lc, fc)
        task.wait(1)
    end
end)

-- Misc
local miscContent = Instance.new("Frame")
miscContent.Size = UDim2.new(1, 0, 1, 0)
miscContent.BackgroundTransparency = 1
miscContent.Visible = false
miscContent.ZIndex = 12
miscContent.Parent = contentFrame
createKeybind(miscContent, "Toggle GUI", 4, "PageUp", function() frame.Visible = not frame.Visible end)
createKeybind(miscContent, "Panic Hide ESP", 32, "End", function()
    CFG.ESP = false
    CFG.LootESP = false
    CFG.ZombieESP = false
    CFG.VehicleESP = false
    CFG.CorpseESP = false
    CFG.FuelESP = false
    for _, d in pairs(espData) do
        if d.highlight then d.highlight.Enabled = false end
        if d.billboard then d.billboard.Enabled = false end
    end
end)

-- Credits
local creditsTitle = Instance.new("TextLabel")
creditsTitle.Size = UDim2.new(1, -20, 0, 22)
creditsTitle.Position = UDim2.new(0, 10, 0, 70)
creditsTitle.BackgroundTransparency = 1
creditsTitle.TextColor3 = Color3.fromRGB(180, 180, 180)
creditsTitle.Font = Enum.Font.GothamBold
creditsTitle.TextSize = 13
creditsTitle.TextXAlignment = Enum.TextXAlignment.Left
creditsTitle.Text = "Credits"
creditsTitle.ZIndex = 12
creditsTitle.Parent = miscContent

local creditsBody = Instance.new("TextLabel")
creditsBody.Size = UDim2.new(1, -20, 0, 50)
creditsBody.Position = UDim2.new(0, 10, 0, 92)
creditsBody.BackgroundTransparency = 1
creditsBody.TextColor3 = Color3.fromRGB(140, 140, 140)
creditsBody.Font = Enum.Font.Gotham
creditsBody.TextSize = 12
creditsBody.TextXAlignment = Enum.TextXAlignment.Left
creditsBody.TextYAlignment = Enum.TextYAlignment.Top
creditsBody.Text = "Made by Evol\nbScripts · Apocalypse Rising 2 ESP\nEverything off by default"
creditsBody.ZIndex = 12
creditsBody.Parent = miscContent

local discordBtn = Instance.new("TextButton")
discordBtn.Size = UDim2.new(1, -20, 0, 32)
discordBtn.Position = UDim2.new(0, 10, 1, -42)
discordBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
discordBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
discordBtn.Font = Enum.Font.GothamBold
discordBtn.TextSize = 12
discordBtn.Text = "JOIN DISCORD"
discordBtn.BorderSizePixel = 0
discordBtn.ZIndex = 12
discordBtn.Parent = miscContent
discordBtn.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard("https://discord.gg/aQUSCJmgxh")
        discordBtn.Text = "LINK COPIED"
        task.delay(2, function() discordBtn.Text = "JOIN DISCORD" end)
    end
end)

tabContents = { playersContent, lootContent, worldContent, miscContent }
for i, tabName in ipairs(tabNames) do
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(1 / #tabNames, 0, 1, 0)
    tabBtn.Position = UDim2.new((i - 1) / #tabNames, 0, 0, 0)
    tabBtn.BackgroundColor3 = i == 1 and Color3.fromRGB(20, 20, 20) or Color3.fromRGB(10, 10, 10)
    tabBtn.TextColor3 = i == 1 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(100, 100, 100)
    tabBtn.Font = Enum.Font.GothamBold
    tabBtn.TextSize = 11
    tabBtn.Text = tabName
    tabBtn.BorderSizePixel = 0
    tabBtn.ZIndex = 12
    tabBtn.Parent = tabsFrame
    local underline = Instance.new("Frame")
    underline.Size = UDim2.new(1, 0, 0, 2)
    underline.Position = UDim2.new(0, 0, 1, -2)
    underline.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    underline.BorderSizePixel = 0
    underline.Visible = i == 1
    underline.ZIndex = 13
    underline.Parent = tabBtn
    tabButtons[i] = { btn = tabBtn, underline = underline }
    tabBtn.MouseButton1Click:Connect(function()
        for j, content in ipairs(tabContents) do
            content.Visible = false
            tabButtons[j].btn.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
            tabButtons[j].btn.TextColor3 = Color3.fromRGB(100, 100, 100)
            tabButtons[j].underline.Visible = false
        end
        tabContents[i].Visible = true
        tabBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        underline.Visible = true
    end)
end

local dragging, dragStart, startPos = false, nil, nil
frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
    end
end)
frame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
closeBtn.MouseButton1Click:Connect(function() frame.Visible = false end)

----------------------------------------------------------------
-- RENDER
----------------------------------------------------------------
RunService.RenderStepped:Connect(function()
    visFrame += 1
    local doVis = visFrame % 6 == 0
    local screenSize = camera.ViewportSize
    refreshLocalChar()
    local localHRP = localCharModel and getHRP(localCharModel)
    local localPos = localHRP and localHRP.Position or camera.CFrame.Position

    local tracerOrigin
    if CFG.TracerOrigin == "Center" then
        tracerOrigin = Vector2.new(screenSize.X / 2, screenSize.Y / 2)
    elseif CFG.TracerOrigin == "Top" then
        tracerOrigin = Vector2.new(screenSize.X / 2, 0)
    elseif CFG.TracerOrigin == "Mouse" then
        tracerOrigin = Vector2.new(mouse.X, mouse.Y + 36)
    else
        tracerOrigin = Vector2.new(screenSize.X / 2, screenSize.Y)
    end

    for model, data in pairs(espData) do
        if not data.model or not data.model.Parent then destroyPlayerESP(model) continue end
        if not data.hrp or not data.hrp.Parent then
            data.hrp = getHRP(data.model)
            if not data.hrp then
                if data.highlight then data.highlight.Enabled = false end
                if data.billboard then data.billboard.Enabled = false end
                continue
            end
            if data.billboard then data.billboard.Adornee = data.hrp end
        end

        local dist = (data.hrp.Position - localPos).Magnitude
        local distFloor = math.floor(dist)
        local hide = not CFG.ESP or dist > CFG.MaxDist or dist < CFG.MinDist

        if hide then
            if data.highlight then data.highlight.Enabled = false end
            if data.billboard then data.billboard.Enabled = false end
            hideLines(data.box) hideLines(data.skel)
            if data.tracer then data.tracer.Visible = false end
            if data.text then data.text.Visible = false end
            if data.text2 then data.text2.Visible = false end
            if data.hpBar then if data.hpBar.bg then data.hpBar.bg.Visible = false end if data.hpBar.fill then data.hpBar.fill.Visible = false end end
            if data.arrow then data.arrow.Visible = false end
            if data.headDot then data.headDot.Visible = false end
            if data.facing then data.facing.Visible = false end
            continue
        end

        if doVis then visCache[model] = isVisible(data.model, data.hrp) end
        local visible = visCache[model]
        if visible == nil then visible = true end

        local displayName = data.name or resolveName(data.model)
        local isSquad = CFG.SquadCheck and squadMembers[displayName] == true
        local dotMode = CFG.Optimised and dist >= 1200

        local color = isSquad and COL_SQUAD or (CFG.ChamsVisCheck and (visible and COL_VIS or COL_ENEMY) or COL_ENEMY)
        if CFG.DistFade then
            local dc = distColor(dist, CFG.MaxDist)
            if not isSquad and not (CFG.ChamsVisCheck and visible) then color = dc end
        end

        local wepName, wepCat = getEquipped(data.model)
        local wepColor = color
        if CFG.WeaponColors then
            if wepCat == "gun" then wepColor = COL_GUN
            elseif wepCat == "melee" then wepColor = COL_MELEE end
        end

        -- Billboard
        if data.billboard then
            data.billboard.Enabled = true
            local parts = {}
            if CFG.ShowName then table.insert(parts, displayName) end
            if CFG.ShowDistance then table.insert(parts, distFloor .. "m") end
            if CFG.ShowHealth and data.hum then table.insert(parts, math.floor(data.hum.Health) .. "hp") end
            local line2 = {}
            if CFG.ShowWeapon then table.insert(line2, wepName) end
            if CFG.ShowArmor then
                local vest = getEquipmentSlot(data.model, "Vest")
                if vest then table.insert(line2, vest) end
            end
            if CFG.ShowBackpack then
                local bag = getEquipmentSlot(data.model, "Backpack")
                if bag then table.insert(line2, bag) end
            end
            if CFG.ShowState then table.insert(line2, getState(data.model)) end
            local text = table.concat(parts, " | ")
            if #line2 > 0 then text = text .. "\n" .. table.concat(line2, " | ") end
            if data.billboardLabel then
                data.billboardLabel.Text = text
                data.billboardLabel.TextColor3 = color
                data.billboardLabel.TextSize = math.clamp(14 - dist / 500, 10, 14)
            end
        end

        if data.highlight then
            data.highlight.Enabled = CFG.Chams and not dotMode
            data.highlight.FillColor = color
            data.highlight.OutlineColor = color
        end

        local rootScreen, onScreen = camera:WorldToViewportPoint(data.hrp.Position)
        local fullyOn = onScreen and rootScreen.Z > 0

        if CFG.OffScreen then drawOffScreenArrow(data.arrow, data.hrp.Position, color)
        elseif data.arrow then data.arrow.Visible = false end

        if CFG.Tracers and fullyOn and not dotMode and data.tracer then
            data.tracer.From = tracerOrigin
            data.tracer.To = Vector2.new(rootScreen.X, rootScreen.Y)
            data.tracer.Color = color
            data.tracer.Visible = true
        elseif data.tracer then data.tracer.Visible = false end

        -- Head dot
        if CFG.HeadDot and fullyOn and not dotMode and data.headDot then
            local head = getPart(data.model, "Head")
            if head then
                local hp, hon = camera:WorldToViewportPoint(head.Position)
                if hon and hp.Z > 0 then
                    data.headDot.Position = Vector2.new(hp.X, hp.Y)
                    data.headDot.Radius = math.clamp(40 / math.max(dist, 10), 2, 6)
                    data.headDot.Color = color
                    data.headDot.Visible = true
                else data.headDot.Visible = false end
            else data.headDot.Visible = false end
        elseif data.headDot then data.headDot.Visible = false end

        -- Facing
        if CFG.Facing and fullyOn and not dotMode and data.facing then
            local look = data.hrp.CFrame.LookVector * 4
            local tip = data.hrp.Position + look
            local a = camera:WorldToViewportPoint(data.hrp.Position)
            local b = camera:WorldToViewportPoint(tip)
            if a.Z > 0 and b.Z > 0 then
                setLine(data.facing, Vector2.new(a.X, a.Y), Vector2.new(b.X, b.Y), color, 1.5)
            else data.facing.Visible = false end
        elseif data.facing then data.facing.Visible = false end

        if CFG.Box and not dotMode and data.box then
            if CFG.BoxStyle == "3D" then
                draw3DBox(data.box, data.hrp, color, 1.5)
                if data.hpBar then if data.hpBar.bg then data.hpBar.bg.Visible = false end if data.hpBar.fill then data.hpBar.fill.Visible = false end end
            else
                local x, y, w, h = getBoxBounds(data.hrp)
                if x then
                    if CFG.BoxStyle == "Corner" then drawCornerBox(data.box, x, y, w, h, color, 1.5)
                    else draw2DBox(data.box, x, y, w, h, color, 1.5) end
                    if CFG.ShowHealthBar and data.hum then
                        drawHealthBar(data.hpBar, x, y, h, data.hum.Health, data.hum.MaxHealth)
                    elseif data.hpBar then
                        if data.hpBar.bg then data.hpBar.bg.Visible = false end
                        if data.hpBar.fill then data.hpBar.fill.Visible = false end
                    end
                else hideLines(data.box) end
            end
        else
            hideLines(data.box)
            if data.hpBar then if data.hpBar.bg then data.hpBar.bg.Visible = false end if data.hpBar.fill then data.hpBar.fill.Visible = false end end
        end

        if CFG.Skeleton and not dotMode and data.skel then
            drawSkeleton(data.skel, data.model, color, 1.2)
        else hideLines(data.skel) end

        if fullyOn and data.text then
            local parts = {}
            if CFG.ShowName then table.insert(parts, displayName) end
            if CFG.ShowDistance then table.insert(parts, distFloor .. "m") end
            if CFG.ShowHealth and data.hum then
                table.insert(parts, math.floor(data.hum.Health) .. "/" .. math.floor(data.hum.MaxHealth))
            end
            data.text.Text = table.concat(parts, " | ")
            data.text.Color = color
            data.text.Size = math.clamp(14 - dist / 400, 10, 14)
            data.text.Position = Vector2.new(rootScreen.X, rootScreen.Y - 30)
            data.text.Visible = #parts > 0
            if CFG.ShowWeapon and not dotMode and data.text2 then
                data.text2.Text = wepName
                data.text2.Color = wepColor
                data.text2.Position = Vector2.new(rootScreen.X, rootScreen.Y - 16)
                data.text2.Visible = true
            elseif data.text2 then data.text2.Visible = false end
        else
            if data.text then data.text.Visible = false end
            if data.text2 then data.text2.Visible = false end
        end
    end

    -- Zombies
    for model, data in pairs(zombieData) do
        if not CFG.ZombieESP or not model.Parent then
            if data.highlight then data.highlight.Enabled = false end
            if data.billboard then data.billboard.Enabled = false end
            continue
        end
        if not data.hrp or not data.hrp.Parent then data.hrp = getHRP(model) if not data.hrp then continue end end
        local dist = (data.hrp.Position - localPos).Magnitude
        local show = dist <= 600
        if data.highlight then data.highlight.Enabled = show and CFG.ZombieChams end
        if data.billboard then
            data.billboard.Enabled = show
            if data.billboardLabel and show then
                local tname = model.Name
                if tname == "Infected Civilian" then tname = "Infected" end
                data.billboardLabel.Text = string.format("%s  %dm", tname, math.floor(dist))
            end
        end
    end

    -- Vehicles
    for model, data in pairs(vehicleData) do
        if not CFG.VehicleESP or not model.Parent then
            if data.billboard then data.billboard.Enabled = false end
            continue
        end
        local dist = (data.part.Position - localPos).Magnitude
        local show = dist <= 1000
        if data.billboard then
            data.billboard.Enabled = show
            if data.billboardLabel and show then
                local occ = CFG.VehicleOccupancy and vehicleOccupied(model)
                data.billboardLabel.Text = string.format("[VEH] %s%s  %dm", model.Name, occ and " [OCC]" or "", math.floor(dist))
            end
        end
    end

    -- Corpses
    for model, data in pairs(corpseData) do
        if not CFG.CorpseESP or not model.Parent then
            if data.highlight then data.highlight.Enabled = false end
            if data.billboard then data.billboard.Enabled = false end
            continue
        end
        local dist = (data.part.Position - localPos).Magnitude
        local show = dist <= 350
        if data.highlight then data.highlight.Enabled = show end
        if data.billboard then data.billboard.Enabled = show end
    end

    -- Loot
    for inst, data in pairs(lootData) do
        if not CFG.LootESP or not inst.Parent then
            if data.billboard then data.billboard.Enabled = false end
            continue
        end
        local dist = (data.part.Position - localPos).Magnitude
        local show = dist <= CFG.LootMaxDist
        if data.billboard then
            data.billboard.Enabled = show
            if data.billboardLabel and show then
                data.billboardLabel.Text = string.format("[LOOT] %s  %dm", tostring(data.name), math.floor(dist))
            end
        end
    end

    -- Fuel
    for inst, data in pairs(fuelData) do
        if not CFG.FuelESP or not inst.Parent then
            if data.billboard then data.billboard.Enabled = false end
            continue
        end
        local dist = (data.part.Position - localPos).Magnitude
        if data.billboard then
            data.billboard.Enabled = dist <= 800
            if data.billboardLabel then
                data.billboardLabel.Text = string.format("[FUEL]  %dm", math.floor(dist))
            end
        end
    end
end)

print("[bScripts] AR2 ESP v0.1.1 loaded")
