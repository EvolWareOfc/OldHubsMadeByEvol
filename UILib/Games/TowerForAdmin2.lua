local L_1_ = loadstring(
    game:HttpGet('https://raw.githubusercontent.com/EvolWareOfc/EvolWare/refs/heads/main/Library/WizardUILib.lua'))()

-- Create the main window for the UI
local L_2_ = L_1_:NewWindow('Tower For Admin 2')

-- Create a new section/tab in the main window
local L_3_ = L_2_:NewSection('Teleports')
local L_4_ = L_2_:NewSection('Spins')
local L_5_ = L_2_:NewSection('Admin')
L_3_:CreateButton('Finish Obby', function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(- 118.81855773925781, 149.1067352294922, 17.01189613342285)
end)
L_3_:CreateButton('Impossible Slap', function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(315.0761413574219, - 168.8494110107422, - 24.78889274597168)
end)
L_3_:CreateButton('OP Slap', function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(103.56002044677734, - 168.7475128173828, 189.558837890625)
end)
L_3_:CreateButton('Speed Coil', function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(69.78700256347656, - 168.5740203857422, 47.01857376098633)
end)
L_3_:CreateButton('Jump Coil', function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(70.04325866699219, - 168.5740203857422, 60.29585266113281)
end)
L_3_:CreateButton('Cloud', function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(70.28504943847656, - 168.5740203857422, 75.80719757080078)
end)
L_3_:CreateButton('Magic Carpet', function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(69.91064453125, - 168.5740203857422, 89.0545654296875)
end)
L_3_:CreateButton('Hammer', function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(70.482666015625, - 168.5740203857422, 101.37969207763672)
end)
L_3_:CreateButton('Group Section', function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(110.68772888183594, - 168.9240264892578, 13.29638671875)
end)
L_3_:CreateButton('Win', function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(- 120.16079711914062, 149.45651245117188, 11.442669868469238)
end)
local L_6_ = false
local L_7_ = CFrame.new(- 120.16079711914062, 149.45651245117188, 11.442669868469238)
L_3_:CreateToggle('Auto Win', function(L_15_arg0)
	L_6_ = L_15_arg0
	if L_6_ then
		task.spawn(function()
			while L_6_ do
				local L_16_ = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild('HumanoidRootPart')
				if L_16_ then
                    -- Teleport slightly forward
					L_16_.CFrame = L_7_ * CFrame.new(0, 0, 1)
					task.wait(0.1)
                    -- Teleport slightly backward
					L_16_.CFrame = L_7_ * CFrame.new(0, 0, - 1)
					task.wait(0.1)
				end
			end
		end)
	end
end)

--------------------------------------------------------------

-- Make sure TrollTab exists
local L_8_ = L_2_:NewSection('Troll Products')
local L_9_ = 3375558916
local L_10_ = 3375561745
L_8_:CreateButton('Kill All / Nuke', function()
	local L_17_ = game.Players.LocalPlayer
	game:GetService('MarketplaceService')
        :SignalPromptProductPurchaseFinished(L_17_.UserId, L_9_, true)
end)
L_8_:CreateButton('Kick All', function()
	local L_18_ = game.Players.LocalPlayer
	game:GetService('MarketplaceService')
        :SignalPromptProductPurchaseFinished(L_18_.UserId, L_10_, true)
end)

--------------------------------------------------------------
-- Spin 1
L_4_:CreateButton('Ban Hammer', function()
	game:GetService('ReplicatedStorage').Remotes.GiveSpinReward
        :FireServer('Spin1')
end)

-- Spin 2
L_4_:CreateButton('Speed Coil', function()
	game:GetService('ReplicatedStorage').Remotes.GiveSpinReward
        :FireServer('Spin2')
end)

-- Spin 3
L_4_:CreateButton('Rainbow Carpet', function()
	game:GetService('ReplicatedStorage').Remotes.GiveSpinReward
        :FireServer('Spin3')
end)

-- Spin 4
L_4_:CreateButton('Cloud', function()
	game:GetService('ReplicatedStorage').Remotes.GiveSpinReward
        :FireServer('Spin4')
end)

-- Spin 5
L_4_:CreateButton('Admin', function()
	game:GetService('ReplicatedStorage').Remotes.GiveSpinReward
        :FireServer('Spin5')
end)
L_4_:CreateButton('Inf Spins', function()
	local L_19_ = game.Players.LocalPlayer
	local L_20_ = L_19_:GetChildren()[6] -- this is where Spins seems to live
	if L_20_ then
		local L_21_ = L_20_:FindFirstChild('Spins')
		if L_21_ then
			local L_22_ = {
				L_21_,
				L_21_.Value + 1000000000000
			}
			game:GetService('ReplicatedStorage').Remotes.changerValue
                :FireServer(unpack(L_22_))
		end
	end
end)

--------------------------------------------------------------.

--------------------------------------------------------------
L_5_:CreateButton('Give Admin', function()
	Remotes.GiveAdmin:FireServer()
end)
local L_11_ = loadstring(
    game:HttpGet('https://raw.githubusercontent.com/EvolWareOfc/OldHubsMadeByEvol/refs/heads/main/UILib/Games/UniversalTab.lua'))()
L_11_(L_2_, L_1_)
local L_12_ = loadstring(
    game:HttpGet('https://raw.githubusercontent.com/EvolWareOfc/OldHubsMadeByEvol/refs/heads/main/UILib/Games/SupportedGames.lua'))()
L_12_(L_2_, L_1_)
local L_13_ = loadstring(
    game:HttpGet('https://raw.githubusercontent.com/EvolWareOfc/OldHubsMadeByEvol/refs/heads/main/UILib/Games/Misc.lua'))()
L_13_(L_2_, L_1_)
local L_14_ = loadstring(
    game:HttpGet('https://raw.githubusercontent.com/EvolWareOfc/OldHubsMadeByEvol/refs/heads/main/UILib/Games/Credits.lua'))()
L_14_(L_2_, L_1_)

-- Misc systems
loadstring(
    game:HttpGet('https://raw.githubusercontent.com/EvolWareOfc/OldHubsMadeByEvol/refs/heads/main/UILib/Games/Developer%20Detection%20System.lua'))()
loadstring(
    game:HttpGet('https://raw.githubusercontent.com/EvolWareOfc/OldHubsMadeByEvol/refs/heads/main/UILib/Games/DevTag.lua'))()
