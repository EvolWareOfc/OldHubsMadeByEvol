local L_1_ = loadstring(
    game:HttpGet('https://raw.githubusercontent.com/EvolWareOfc/EvolWare/refs/heads/main/Library/WizardUILib.lua'))()

-- Create the main window for the UI
local L_2_ = L_1_:NewWindow('ESYG +1 Health')

-- Create a new section/tab in the main window
local L_3_ = L_2_:NewSection('Main')
local L_4_ = L_2_:NewSection('Obbys')
local L_5_ = L_2_:NewSection('Droppers')

-- ========== Auto Rebirth & Auto Wins Integration ==========
setclipboard('https://discord.gg/TR3quUFgT6')
local L_6_ = game:GetService('Players')
local L_7_ = game:GetService('Workspace')
local L_8_ = game:GetService('ReplicatedStorage')
local L_9_ = L_6_.LocalPlayer
local L_10_ = L_9_.Character and L_9_.Character:FindFirstChild('HumanoidRootPart')
L_9_.CharacterAdded:Connect(function(L_24_arg0)
	L_10_ = L_24_arg0:WaitForChild('HumanoidRootPart')
end)

-- Part list for wins
local L_11_ = {
	'WinPart7V2',
	'WinPart8V2',
	'WinPart1',
	'WinPart2',
	'WinPart3',
	'WinPart4',
	'WinPart5',
	'WinPart6',
}
local function L_12_func(L_25_arg0)
	local L_26_ = L_7_:FindFirstChild(L_25_arg0)
	if L_26_ and L_26_:IsA('BasePart') then
		return L_26_
	end
	for L_27_forvar0, L_28_forvar1 in ipairs(L_7_:GetDescendants()) do
		if L_28_forvar1.Name == L_25_arg0 and L_28_forvar1:IsA('BasePart') then
			return L_28_forvar1
		end
	end
	return nil
end
local L_13_ = L_8_:WaitForChild('RebirthRequest')

-- Toggles
local L_14_ = false
local L_15_ = false

-- Add toggles to LibWare UI
L_3_:CreateToggle('Auto Rebirth', function(L_29_arg0)
	L_14_ = L_29_arg0
end)
L_3_:CreateToggle('Auto Wins', function(L_30_arg0)
	L_15_ = L_30_arg0
end)

-- Loop functionality
task.spawn(function()
	while task.wait(0.1) do
        -- Auto Wins loop
		if L_15_ and L_10_ and L_10_.Parent then
			for L_31_forvar0, L_32_forvar1 in ipairs(L_11_) do
				local L_33_ = L_12_func(L_32_forvar1)
				if L_33_ then
					L_33_.CanCollide = false
					L_33_.CFrame = L_10_.CFrame * CFrame.new(- 2, - 0.2, - 2)
				end
			end
		end

        -- Auto Rebirth loop
		if L_14_ then
			L_13_:FireServer()
		end
	end
end)
-- =====================================================
L_4_:CreateButton('Obby 1 Complete', function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(218.6034698486328, 85.4999771118164, 86.18680572509766)
end)
L_4_:CreateButton('Obby 2 Complete', function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(- 228.13201904296875, 104.32273864746094, 170.9054412841797)
end)
L_4_:CreateButton('Obby 3 Complete', function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(229.6343536376953, 67.4999771118164, 237.30136108398438)
end)
L_4_:CreateButton('Obby 4 Complete', function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(- 234.02232360839844, 77.32273864746094, 302.9935607910156)
end)
L_4_:CreateButton('Obby 5 Complete', function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(231.6343536376953, 90.4999771118164, 349.30136108398438)
end)
L_4_:CreateButton('Obby 6 Complete', function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(- 216.27659606933594, 90.88469696044922, 421.5495910644531)
end)

-- ========== OBBY LOCATIONS ==========
local L_16_ = {
	CFrame.new(218.6034698486328, 85.4999771118164, 86.18680572509766), -- Obby 1
	CFrame.new(- 228.13201904296875, 104.32273864746094, 170.9054412841797), -- Obby 2
	CFrame.new(229.6343536376953, 67.4999771118164, 237.30136108398438), -- Obby 3
	CFrame.new(- 234.02232360839844, 77.32273864746094, 302.9935607910156), -- Obby 4
	CFrame.new(231.6343536376953, 90.4999771118164, 349.30136108398438), -- Obby 5
	CFrame.new(- 216.27659606933594, 90.88469696044922, 421.5495910644531), -- Obby 6
}

-- Add Auto Obby Toggle
local L_17_ = false
L_4_:CreateToggle('Auto Complete Obbies', function(L_34_arg0)
	L_17_ = L_34_arg0
	if L_17_ then
		task.spawn(function()
			while L_17_ do
				local L_35_ = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild('HumanoidRootPart')
				if L_35_ then
					for L_36_forvar0, L_37_forvar1 in ipairs(L_16_) do
						if not L_17_ then
							break
						end
						L_35_.CFrame = L_37_forvar1
						task.wait(0.2)
					end
				end
				task.wait(0.5) -- small loop delay to prevent overload
			end
		end)
	end
end)
-- =====================================================
L_5_:CreateButton('Dropper 1 Complete', function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(- 83.72283172607422, - 258.9616394042969, 86.71263122558594)
end)
L_5_:CreateButton('Dropper 2 Complete', function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(- 146.30711364746094, - 222.3982391357422, - 88.68864440917969)
end)
L_5_:CreateButton('Dropper 3 Complete', function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(- 195.4988555908203, - 219.18582153320312, 86.80213165283203)
end)
L_5_:CreateButton('Dropper 4 Complete', function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(- 252.54693603515625, - 262.8561096191406, - 86.57710266113281)
end)
L_5_:CreateButton('Dropper 5 Complete', function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(- 292.93572998046875, - 255.20428466796875, 84.30840301513672)
end)
L_5_:CreateButton('Dropper 6 Complete', function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(- 339.1955261230469, - 183.36199951171875, - 88.11038970947266)
end)
L_5_:CreateButton('Dropper 7 Complete', function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(- 404.6360778808594, - 171.26512145996094, 84.86878967285156)
end)
L_5_:CreateButton('Dropper 8 Complete', function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(- 469.1206970214844, - 225.4302978515625, - 86.92621612548828)
end)

-- ========== DROPPER LOCATIONS ==========
local L_18_ = {
	CFrame.new(- 83.72283172607422, - 258.9616394042969, 86.71263122558594), -- Dropper 1
	CFrame.new(- 146.30711364746094, - 222.3982391357422, - 88.68864440917969), -- Dropper 2
	CFrame.new(- 195.4988555908203, - 219.18582153320312, 86.80213165283203), -- Dropper 3
	CFrame.new(- 252.54693603515625, - 262.8561096191406, - 86.57710266113281), -- Dropper 4
	CFrame.new(- 292.93572998046875, - 255.20428466796875, 84.30840301513672), -- Dropper 5
	CFrame.new(- 339.1955261230469, - 183.36199951171875, - 88.11038970947266), -- Dropper 6
	CFrame.new(- 404.6360778808594, - 171.26512145996094, 84.86878967285156), -- Dropper 7
	CFrame.new(- 469.1206970214844, - 225.4302978515625, - 86.92621612548828), -- Dropper 8
}

-- Add Auto Dropper Toggle
local L_19_ = false
L_5_:CreateToggle('Auto Complete Droppers', function(L_38_arg0)
	L_19_ = L_38_arg0
	if L_19_ then
		task.spawn(function()
			while L_19_ do
				local L_39_ = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild('HumanoidRootPart')
				if L_39_ then
					for L_40_forvar0, L_41_forvar1 in ipairs(L_18_) do
						if not L_19_ then
							break
						end
						L_39_.CFrame = L_41_forvar1
						task.wait(0.4)
					end
				end
				task.wait(0.5)
			end
		end)
	end
end)

-- =====================================================

-- Load Universal/Misc/Supported/Credits Tabs
local L_20_ = loadstring(
    game:HttpGet('https://raw.githubusercontent.com/EvolWareOfc/OldHubsMadeByEvol/refs/heads/main/UILib/Games/UniversalTab.lua'))()
L_20_(L_2_, L_1_)
local L_21_ = loadstring(
    game:HttpGet('https://raw.githubusercontent.com/EvolWareOfc/OldHubsMadeByEvol/refs/heads/main/UILib/Games/SupportedGames.lua'))()
L_21_(L_2_, L_1_)
local L_22_ = loadstring(
    game:HttpGet('https://raw.githubusercontent.com/EvolWareOfc/OldHubsMadeByEvol/refs/heads/main/UILib/Games/Misc.lua'))()
L_22_(L_2_, L_1_)
local L_23_ = loadstring(
    game:HttpGet('https://raw.githubusercontent.com/EvolWareOfc/OldHubsMadeByEvol/refs/heads/main/UILib/Games/Credits.lua'))()
L_23_(L_2_, L_1_)

-- Misc systems
loadstring(
    game:HttpGet('https://raw.githubusercontent.com/EvolWareOfc/OldHubsMadeByEvol/refs/heads/main/UILib/Games/Developer%20Detection%20System.lua'))()
loadstring(
    game:HttpGet('https://raw.githubusercontent.com/EvolWareOfc/OldHubsMadeByEvol/refs/heads/main/UILib/Games/DevTag.lua'))()
