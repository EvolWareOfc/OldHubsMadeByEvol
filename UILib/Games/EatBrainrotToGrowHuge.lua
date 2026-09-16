-- Load Wizard UI
local L_1_ = loadstring(
	Game:HttpGet('https://raw.githubusercontent.com/EvolWareOfc/EvolWare/refs/heads/main/Library/WizardUILib.lua'))()
local L_2_ = L_1_:NewWindow('Eat Brainrot To Grow HUGE')
local L_3_ = L_2_:NewSection('Options')
local L_4_ = L_2_:NewSection('Boosts')
local L_5_ = L_1_:NewWindow('Credits')
local L_6_ = L_5_:NewSection('Scripters')
local L_7_ = L_5_:NewSection('Other')
L_6_:CreateButton('UILib', function()
	print('UILib')
end)
L_6_:CreateButton('SyrexhubOfficialDev', function()
	print('SyrexhubOfficialDev')
end)
L_7_:CreateButton('UI By ...', function()
	print('UI By ...')
end)

-- =====================
-- Black Hole Gamepass
-- =====================
L_3_:CreateButton('Unlock Black Hole Gamepass', function()
	local L_16_ = game:GetService('ReplicatedStorage').Honeypot.Internal.RemoteStorage
			:FindFirstChild('BlackHoleGamepass - RemoteEvent')
	if L_16_ then
		L_16_:FireServer()
	end
end)

-- =====================
-- Magnet Gamepass
-- =====================
L_3_:CreateButton('Unlock Magnet Gamepass', function()
	local L_17_ = game:GetService('ReplicatedStorage').Honeypot.Internal.RemoteStorage
			:FindFirstChild('MagnetGamepass - RemoteEvent')
	if L_17_ then
		L_17_:FireServer()
	end
end)

-- =====================
-- RequestTeleport Button
-- =====================
L_3_:CreateButton('Teleport', function()
	local L_18_ = game:GetService('ReplicatedStorage').Honeypot.Internal.RemoteStorage
			:FindFirstChild('RequestTeleport - RemoteEvent')
	if L_18_ then
		L_18_:FireServer()
	end
end)

-- =====================
-- LogGift Button
-- =====================
L_3_:CreateButton('LogGift Once', function()
	local L_19_ = game:GetService('ReplicatedStorage').Honeypot.Internal.RemoteStorage
			:FindFirstChild('LogGift - RemoteEvent')
	if L_19_ then
		L_19_:FireServer({
			['TimerFinished'] = true,
			['Type'] = 'Leaving',
			['Maid'] = {
				['_TaskCount'] = 7,
				['_Tasks'] = {}
			},
			['TimerMilestones'] = {
				1,
				2,
				3,
				4,
				5,
				6,
				7,
				8,
				9,
				10,
				11,
				12,
				13,
				14,
				15,
				16,
				17,
				18,
				19,
				20,
				21,
				22,
				23,
				24,
				25,
				26,
				27,
				28,
				29,
				31,
				0,
			},
			['ID'] = '5bd061a8-7315-4fb3-bb94-f856300e36d7',
			['Frame'] = '.GiftFrame',
			['ReceivedTime'] = 1757286847314,
			['NewRemainingTime'] = 0.01,
		})
	end
end)

-- Utility function to claim a boost or reward
local function L_8_func(L_20_arg0, L_21_arg1)
	local L_22_ = game:GetService('ReplicatedStorage')
		:WaitForChild('Honeypot')
		:WaitForChild('Internal')
		:WaitForChild('RemoteStorage')
		:FindFirstChild('ClaimBoost - RemoteEvent')
	if L_22_ then
		L_22_:FireServer(L_20_arg0, L_21_arg1)
	else
		warn('ClaimBoost - RemoteEvent not found!')
	end
end

-- =====================
-- Rainbow Boost Toggle
-- =====================
local L_9_ = false
L_4_:CreateToggle('Rainbow Boost', function(L_23_arg0)
	L_9_ = L_23_arg0
	if L_9_ then
		task.spawn(function()
			while L_9_ do
				L_8_func('Rainbow', 300)
				task.wait(0.1)
			end
		end)
	end
end)

-- =====================
-- BlobSize Boost Toggle
-- =====================
local L_10_ = false
L_4_:CreateToggle('BlobSize Boost', function(L_24_arg0)
	L_10_ = L_24_arg0
	if L_10_ then
		task.spawn(function()
			while L_10_ do
				L_8_func('BlobSize', 300)
				task.wait(0.1)
			end
		end)
	end
end)

-- =====================
-- Claim Gift Toggle
-- =====================
local L_11_ = false
L_4_:CreateToggle('Claim Gift (+10k Size)', function(L_25_arg0)
	L_11_ = L_25_arg0
	if L_11_ then
		task.spawn(function()
			while L_11_ do
				-- Fire LogGift
				local L_26_ = {
					[1] = {
						['TimerMilestones'] = {
							1,
							2,
							3,
							4,
							5,
							6,
							7,
							8,
							9,
							10,
							11,
							12,
							13,
							14,
							15,
							16,
							17,
							18,
							19,
							20,
							21,
							22,
							23,
							24,
							25,
							26,
							27,
							28,
							29,
							30,
							31,
							0,
						},
						['Type'] = 'Leaving',
						['ReceivedTime'] = tick() * 1000,
						['TimerFinished'] = true,
						['ID'] = 'db8a0918-eded-4ae2-917f-0bba92e657b8',
						['Maid'] = {
							['_Tasks'] = {},
							['_TaskCount'] = 7
						},
						['NewRemainingTime'] = 30,
					},
				}
				game:GetService('ReplicatedStorage').Honeypot.Internal.RemoteStorage['LogGift - RemoteEvent']
					:FireServer(unpack(L_26_))

				-- Fire ClaimGift
				local L_27_ = {
					'db8a0918-eded-4ae2-917f-0bba92e657b8'
				}
				game:GetService('ReplicatedStorage').Honeypot.Internal.RemoteStorage['ClaimGift - RemoteEvent']
					:FireServer(unpack(L_27_))
				task.wait(0.1)
			end
		end)
	end
end)
local L_12_ = loadstring(
    game:HttpGet('https://raw.githubusercontent.com/EvolWareOfc/OldHubsMadeByEvol/refs/heads/main/UILib/Games/UniversalTab.lua'))()
L_12_(L_2_, L_1_)
local L_13_ = loadstring(
    game:HttpGet('https://raw.githubusercontent.com/EvolWareOfc/OldHubsMadeByEvol/refs/heads/main/UILib/Games/SupportedGames.lua'))()
L_13_(L_2_, L_1_)
local L_14_ = loadstring(
    game:HttpGet('https://raw.githubusercontent.com/EvolWareOfc/OldHubsMadeByEvol/refs/heads/main/UILib/Games/Misc.lua'))()
L_14_(L_2_, L_1_)
local L_15_ = loadstring(
    game:HttpGet('https://raw.githubusercontent.com/EvolWareOfc/OldHubsMadeByEvol/refs/heads/main/UILib/Games/Credits.lua'))()
L_15_(L_2_, L_1_)

-- Misc systems
loadstring(
    game:HttpGet('https://raw.githubusercontent.com/EvolWareOfc/OldHubsMadeByEvol/refs/heads/main/UILib/Games/Developer%20Detection%20System.lua'))()
loadstring(
    game:HttpGet('https://raw.githubusercontent.com/EvolWareOfc/OldHubsMadeByEvol/refs/heads/main/UILib/Games/DevTag.lua'))()
