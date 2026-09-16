local L_1_ = loadstring(
	Game:HttpGet('https://raw.githubusercontent.com/EvolWareOfc/EvolWare/refs/heads/main/Library/WizardUILib.lua'))()
local L_2_ = L_1_:NewWindow('Color Game')
local L_3_ = L_2_:NewSection('Inf Stuff')
local L_4_ = L_2_:NewSection('Spinny Wheel')
local L_5_ = L_2_:NewSection('Give Stuff')
local L_6_ = L_2_:NewSection('Misc')
local L_7_ = L_1_:NewWindow('Credits')
local L_8_ = L_7_:NewSection('Scripters')
local L_9_ = L_7_:NewSection('Other')
L_8_:CreateButton('UILib', function()
	print('UILib')
end)
L_9_:CreateButton('UI By ...', function()
	print('UI By ...')
end)

--infTab
L_3_:CreateButton('Coins', function()
	local L_30_ = {
		[1] = 'Cash',
		[2] = 9223372036854776000,
	}
	game:GetService('ReplicatedStorage')
		:WaitForChild('Remotes')
		:WaitForChild('AddRewardEvent')
		:FireServer(unpack(L_30_))
end)
L_3_:CreateButton('Gold Bombs', function()
	local L_31_ = {
		[1] = 'Gold Bombs',
		[2] = 1000000000000000000,
	}
	game:GetService('ReplicatedStorage')
		:WaitForChild('Remotes')
		:WaitForChild('AddRewardEvent')
		:FireServer(unpack(L_31_))
end)
L_3_:CreateButton('Bombs', function()
	local L_32_ = {
		[1] = 'Bombs',
		[2] = 1000000000000000000,
	}
	game:GetService('ReplicatedStorage')
		:WaitForChild('Remotes')
		:WaitForChild('AddRewardEvent')
		:FireServer(unpack(L_32_))
end)
L_3_:CreateButton('Spins', function()
	local L_33_ = {
		[1] = 'Spins',
		[2] = 1000000000000000000,
	}
	game:GetService('ReplicatedStorage')
		:WaitForChild('Remotes')
		:WaitForChild('AddRewardEvent')
		:FireServer(unpack(L_33_))
end)
L_3_:CreateButton('Revives', function()
	local L_34_ = {
		[1] = 'Revives',
		[2] = 1000000000000000000,
	}
	game:GetService('ReplicatedStorage')
		:WaitForChild('Remotes')
		:WaitForChild('AddRewardEvent')
		:FireServer(unpack(L_34_))
end)
local L_10_ = false
L_4_:CreateToggle('x5 Cash (Be Careful)', function(L_35_arg0)
	L_10_ = L_35_arg0
	task.spawn(function()
		while L_10_ do
			local L_36_ = {
				[1] = 10,
			}
			game:GetService('ReplicatedStorage')
				:WaitForChild('Remotes', 9e9)
				:WaitForChild('SpinWheelPrizeEvent', 9e9)
				:FireServer(unpack(L_36_))
			task.wait(0) -- small delay to prevent spamming too fast
		end
	end)
end)
local L_11_ = false
L_4_:CreateToggle('+1 Nuke', function(L_37_arg0)
	L_11_ = L_37_arg0
	task.spawn(function()
		while L_11_ do
			local L_38_ = {
				[1] = 7,
			}
			game:GetService('ReplicatedStorage')
				:WaitForChild('Remotes', 9e9)
				:WaitForChild('SpinWheelPrizeEvent', 9e9)
				:FireServer(unpack(L_38_))
			task.wait(0) -- small delay to prevent spamming too fast
		end
	end)
end)
local L_12_ = false
L_4_:CreateToggle('+1 Revive', function(L_39_arg0)
	L_12_ = L_39_arg0
	task.spawn(function()
		while L_12_ do
			local L_40_ = {
				[1] = 4,
			}
			game:GetService('ReplicatedStorage')
				:WaitForChild('Remotes', 9e9)
				:WaitForChild('SpinWheelPrizeEvent', 9e9)
				:FireServer(unpack(L_40_))
			task.wait(0) -- small delay to prevent spamming too fast
		end
	end)
end)
local L_13_ = false
L_4_:CreateToggle('+1 Spin', function(L_41_arg0)
	L_13_ = L_41_arg0
	task.spawn(function()
		while L_13_ do
			local L_42_ = {
				[1] = 3,
			}
			game:GetService('ReplicatedStorage')
				:WaitForChild('Remotes', 9e9)
				:WaitForChild('SpinWheelPrizeEvent', 9e9)
				:FireServer(unpack(L_42_))
			task.wait(0) -- small delay to prevent spamming too fast
		end
	end)
end)
local L_14_ = false
L_4_:CreateToggle('+1K Cash', function(L_43_arg0)
	L_14_ = L_43_arg0
	task.spawn(function()
		while L_14_ do
			local L_44_ = {
				[1] = 6,
			}
			game:GetService('ReplicatedStorage')
				:WaitForChild('Remotes', 9e9)
				:WaitForChild('SpinWheelPrizeEvent', 9e9)
				:FireServer(unpack(L_44_))
			task.wait(0) -- small delay to prevent spamming too fast
		end
	end)
end)
local L_15_ = false
L_4_:CreateToggle('+500 cash', function(L_45_arg0)
	L_15_ = L_45_arg0
	task.spawn(function()
		while L_15_ do
			local L_46_ = {
				[1] = 2,
			}
			game:GetService('ReplicatedStorage')
				:WaitForChild('Remotes', 9e9)
				:WaitForChild('SpinWheelPrizeEvent', 9e9)
				:FireServer(unpack(L_46_))
			task.wait(0) -- small delay to prevent spamming too fast
		end
	end)
end)
local L_16_ = false
L_4_:CreateToggle('+250 Cash', function(L_47_arg0)
	L_16_ = L_47_arg0
	task.spawn(function()
		while L_16_ do
			local L_48_ = {
				[1] = 8,
			}
			game:GetService('ReplicatedStorage')
				:WaitForChild('Remotes', 9e9)
				:WaitForChild('SpinWheelPrizeEvent', 9e9)
				:FireServer(unpack(L_48_))
			task.wait(0) -- small delay to prevent spamming too fast
		end
	end)
end)

--Bombs
local L_17_ = false
L_4_:CreateToggle('+3 Bombs', function(L_49_arg0)
	L_17_ = L_49_arg0
	task.spawn(function()
		while L_17_ do
			local L_50_ = {
				[1] = 5,
			}
			game:GetService('ReplicatedStorage')
				:WaitForChild('Remotes', 9e9)
				:WaitForChild('SpinWheelPrizeEvent', 9e9)
				:FireServer(unpack(L_50_))
			task.wait(0) -- small delay to prevent spamming too fast
		end
	end)
end)
local L_18_ = false
L_4_:CreateToggle('+2 Bombs', function(L_51_arg0)
	L_18_ = L_51_arg0
	task.spawn(function()
		while L_18_ do
			local L_52_ = {
				[1] = 9,
			}
			game:GetService('ReplicatedStorage')
				:WaitForChild('Remotes', 9e9)
				:WaitForChild('SpinWheelPrizeEvent', 9e9)
				:FireServer(unpack(L_52_))
			task.wait(0) -- small delay to prevent spamming too fast
		end
	end)
end)
local L_19_ = false
L_4_:CreateToggle('+1 Bomb', function(L_53_arg0)
	L_19_ = L_53_arg0
	task.spawn(function()
		while L_19_ do
			local L_54_ = {
				[1] = 1,
			}
			game:GetService('ReplicatedStorage')
				:WaitForChild('Remotes', 9e9)
				:WaitForChild('SpinWheelPrizeEvent', 9e9)
				:FireServer(unpack(L_54_))
			task.wait(0) -- small delay to prevent spamming too fast
		end
	end)
end)

--other
L_5_:CreateButton('Robux Trails', function()
	local L_55_ = {
		'Rainbow',
		'Electric',
		'Banana'
	}
	for L_56_forvar0, L_57_forvar1 in ipairs(L_55_) do
		local L_58_ = {
			[1] = L_57_forvar1,
			[2] = 0,
		}
		game:GetService('ReplicatedStorage')
			:WaitForChild('Remotes')
			:WaitForChild('BuyTrailEvent')
			:FireServer(unpack(L_58_))
	end
end)
L_5_:CreateButton('Regular Trails', function()
	local L_59_ = {
		'Red',
		'Yellow',
		'Blue',
		'Green',
		'Purple',
		'Pink',
		'White',
		'Black',
		'Hacker',
		'Fire',
		'Blossom',
		'Frost',
	}
	for L_60_forvar0, L_61_forvar1 in ipairs(L_59_) do
		local L_62_ = {
			[1] = L_61_forvar1,
			[2] = 0,
		}
		game:GetService('ReplicatedStorage')
			:WaitForChild('Remotes')
			:WaitForChild('BuyTrailEvent')
			:FireServer(unpack(L_62_))
	end
end)
L_5_:CreateButton('All Skins', function()
	local L_63_ = {
		'Grass',
		'Wood',
		'Stone',
		'Brick',
		'Rock',
		'Obsidian',
		'Amethyst',
		'Magma',
		'Lava',
		'Gold Ore',
		'Diamond Ore',
		'Diamonds',
		'Space',
		'Rainbow',
		'Meme Dog',
		'Meme Cat',
		'Hungry Cat',
		'Cute Cat',
		'Backrooms',
		'Water',
		'Sahur',
		'Trallalero',
		'Cappuccino',
		'Robux',
		'Dollar',
		'Warning',
		'Cards',
		'Chess',
		'Stars',
		'Squid',
		'Doge',
		'Labubu',
		'Troll',
		'Smile Dog',
		'Fluffy Dog',
		'Drip Dog',
	}
	for L_64_forvar0, L_65_forvar1 in ipairs(L_63_) do
		local L_66_ = {
			[1] = L_65_forvar1,
			[2] = 0, -- Change this if skins cost Robux or points
		}
		game:GetService('ReplicatedStorage')
			:WaitForChild('Remotes', 9e9)
			:WaitForChild('BuySkinEvent', 9e9)
			:FireServer(unpack(L_66_))
	end
end)
local L_20_ = false
L_6_:CreateToggle('Level Up', function(L_67_arg0)
	L_20_ = L_67_arg0

	-- Keep firing while the toggle is on
	while L_20_ do
		local L_68_ = {}
		game:GetService('ReplicatedStorage')
			:WaitForChild('Remotes', 9e9)
			:WaitForChild('BuyLevelWithCoinsEvent', 9e9)
			:FireServer(unpack(L_68_))
		task.wait(0.1) -- Wait 1 second between attempts to avoid spamming too fast
	end
end)
local L_21_ = false
L_6_:CreateToggle('Collect Level Gifts', function(L_69_arg0)
	L_21_ = L_69_arg0
	task.spawn(function()
		while L_21_ do
			for L_70_forvar0 = 1, 100 do
				local L_71_ = {
					[1] = L_70_forvar0,
				}
				game:GetService('ReplicatedStorage')
					:WaitForChild('Remotes', 9e9)
					:WaitForChild('ClaimLevelRewardEvent', 9e9)
					:FireServer(unpack(L_71_))
				task.wait(0.1) -- Small delay to avoid spamming too fast
			end
			task.wait(5) -- Wait before looping again to re-check any unclaimed rewards
		end
	end)
end)
local L_22_ = false
L_6_:CreateToggle('Auto Place Nukes', function(L_72_arg0)
	L_22_ = L_72_arg0
	task.spawn(function()
		while L_22_ do
			local L_73_ = {
				[1] = 3, -- nuke type
			}
			game:GetService('ReplicatedStorage')
				:WaitForChild('Remotes', 9e9)
				:WaitForChild('BombEvent2', 9e9)
				:FireServer(unpack(L_73_))
			task.wait(0.5) -- small delay to avoid spamming too fast
		end
	end)
end)
local L_23_ = false
L_6_:CreateToggle('Auto Place Gold Bombs', function(L_74_arg0)
	L_23_ = L_74_arg0
	task.spawn(function()
		while L_23_ do
			local L_75_ = {
				[1] = 2, -- nuke type
			}
			game:GetService('ReplicatedStorage')
				:WaitForChild('Remotes', 9e9)
				:WaitForChild('BombEvent2', 9e9)
				:FireServer(unpack(L_75_))
			task.wait(0.5) -- small delay to avoid spamming too fast
		end
	end)
end)
local L_24_ = false
L_6_:CreateToggle('Auto Place Bombs', function(L_76_arg0)
	L_24_ = L_76_arg0
	task.spawn(function()
		while L_24_ do
			local L_77_ = {
				[1] = 1, -- nuke type
			}
			game:GetService('ReplicatedStorage')
				:WaitForChild('Remotes', 9e9)
				:WaitForChild('BombEvent2', 9e9)
				:FireServer(unpack(L_77_))
			task.wait(0.5) -- small delay to avoid spamming too fast
		end
	end)
end)
local L_25_ = false
local L_26_ = loadstring(
    game:HttpGet('https://raw.githubusercontent.com/EvolWareOfc/OldHubsMadeByEvol/refs/heads/main/UILib/Games/UniversalTab.lua'))()
L_26_(MainWindow, L_1_)
local L_27_ = loadstring(
    game:HttpGet('https://raw.githubusercontent.com/EvolWareOfc/OldHubsMadeByEvol/refs/heads/main/UILib/Games/SupportedGames.lua'))()
L_27_(MainWindow, L_1_)
local L_28_ = loadstring(
    game:HttpGet('https://raw.githubusercontent.com/EvolWareOfc/OldHubsMadeByEvol/refs/heads/main/UILib/Games/Misc.lua'))()
L_28_(MainWindow, L_1_)
local L_29_ = loadstring(
    game:HttpGet('https://raw.githubusercontent.com/EvolWareOfc/OldHubsMadeByEvol/refs/heads/main/UILib/Games/Credits.lua'))()
L_29_(MainWindow, L_1_)

-- Misc systems
loadstring(
    game:HttpGet('https://raw.githubusercontent.com/EvolWareOfc/OldHubsMadeByEvol/refs/heads/main/UILib/Games/Developer%20Detection%20System.lua'))()
loadstring(
    game:HttpGet('https://raw.githubusercontent.com/EvolWareOfc/OldHubsMadeByEvol/refs/heads/main/UILib/Games/DevTag.lua'))()
