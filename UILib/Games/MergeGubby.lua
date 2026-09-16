local L_1_ = loadstring(
    Game:HttpGet('https://raw.githubusercontent.com/EvolWareOfc/EvolWare/refs/heads/main/Library/WizardUILib.lua'))()
local L_2_ = L_1_:NewWindow('Merge Gubby')
local L_3_ = L_2_:NewSection('Cash')
local L_4_ = L_2_:NewSection('Gems')
local L_5_ = L_2_:NewSection('Gubby')
local L_6_ = L_2_:NewSection('Pets')
local L_7_ = L_2_:NewSection('Spins')
local L_8_ = L_2_:NewSection('Rebirths')
local L_9_ = L_2_:NewSection('Trails')
local L_10_ = L_2_:NewSection('Upgrades')
local L_11_ = L_2_:NewSection('Potions')

--Cash Tab
local L_12_ = false
local L_13_ = false
local L_14_ = false
L_3_:CreateToggle('X2 Cash', function(L_31_arg0)
	L_12_ = L_31_arg0
	task.spawn(function()
		while L_12_ do
			local L_32_ = {
				[1] = 6,
			}
			game:GetService('ReplicatedStorage')
                :WaitForChild('Remotes', 9e9)
                :WaitForChild('SpinWheelPrizeEvent', 9e9)
                :FireServer(unpack(L_32_))
			task.wait(0.01) -- small delay to prevent spamming too fast
		end
	end)
end)
L_3_:CreateToggle('+100 cash', function(L_33_arg0)
	L_14_ = L_33_arg0
	task.spawn(function()
		while L_14_ do
			local L_34_ = {
				[1] = 2,
			}
			game:GetService('ReplicatedStorage')
                :WaitForChild('Remotes', 9e9)
                :WaitForChild('SpinWheelPrizeEvent', 9e9)
                :FireServer(unpack(L_34_))
			task.wait(0.01) -- small delay to prevent spamming too fast
		end
	end)
end)
L_3_:CreateToggle('+10M Cash', function(L_35_arg0)
	L_13_ = L_35_arg0
	task.spawn(function()
		while L_13_ do
			local L_36_ = {
				[1] = 10,
			}
			game:GetService('ReplicatedStorage')
                :WaitForChild('Remotes', 9e9)
                :WaitForChild('SpinWheelPrizeEvent', 9e9)
                :FireServer(unpack(L_36_))
			task.wait(0.01) -- small delay to prevent spamming too fast
		end
	end)
end)
L_3_:CreateButton('Inf Cash', function()
	local L_37_ = {
		[1] = 'Cash',
		[2] = 250000000000000000000000000000000000000000000000000000,
	}
	game:GetService('ReplicatedStorage')
        :WaitForChild('Remotes', 9e9)
        :WaitForChild('AddRewardEvent', 9e9)
        :FireServer(unpack(L_37_))
end)
--Gems Tab
local L_15_ = false
local L_16_ = false
L_4_:CreateToggle('+500 Gems', function(L_38_arg0)
	L_16_ = L_38_arg0
	task.spawn(function()
		while L_16_ do
			local L_39_ = {
				[1] = 5,
			}
			game:GetService('ReplicatedStorage')
                :WaitForChild('Remotes', 9e9)
                :WaitForChild('SpinWheelPrizeEvent', 9e9)
                :FireServer(unpack(L_39_))
			task.wait(0.01) -- small delay to prevent spamming too fast
		end
	end)
end)
L_4_:CreateToggle('+1K Gems', function(L_40_arg0)
	L_15_ = L_40_arg0
	task.spawn(function()
		while L_15_ do
			local L_41_ = {
				[1] = 9,
			}
			game:GetService('ReplicatedStorage')
                :WaitForChild('Remotes', 9e9)
                :WaitForChild('SpinWheelPrizeEvent', 9e9)
                :FireServer(unpack(L_41_))
			task.wait(0.01) -- small delay to prevent spamming too fast
		end
	end)
end)
L_4_:CreateButton('Inf Gems', function()
	local L_42_ = {
		[1] = 'Gems',
		[2] = 250000000000000000000000000000000000000000000000000000,
	}
	game:GetService('ReplicatedStorage')
        :WaitForChild('Remotes', 9e9)
        :WaitForChild('AddRewardEvent', 9e9)
        :FireServer(unpack(L_42_))
end)

--Gubby Tab
local L_17_ = false
local L_18_ = false
local L_19_ = false
L_5_:CreateToggle('X2 Max Gubby', function(L_43_arg0)
	L_18_ = L_43_arg0
	task.spawn(function()
		while L_18_ do
			local L_44_ = {
				[1] = 8,
			}
			game:GetService('ReplicatedStorage')
                :WaitForChild('Remotes', 9e9)
                :WaitForChild('SpinWheelPrizeEvent', 9e9)
                :FireServer(unpack(L_44_))
			task.wait(0.01) -- small delay to prevent spamming too fast
		end
	end)
end)
L_5_:CreateToggle('+10 Gubby', function(L_45_arg0)
	L_19_ = L_45_arg0
	task.spawn(function()
		while L_19_ do
			local L_46_ = {
				[1] = 1,
			}
			game:GetService('ReplicatedStorage')
                :WaitForChild('Remotes', 9e9)
                :WaitForChild('SpinWheelPrizeEvent', 9e9)
                :FireServer(unpack(L_46_))
			task.wait(0.1) -- small delay to prevent spamming too fast
		end
	end)
end)
L_5_:CreateToggle('+50 Gubby (Laggy)', function(L_47_arg0)
	L_17_ = L_47_arg0
	task.spawn(function()
		while L_17_ do
			local L_48_ = {
				[1] = 7,
			}
			game:GetService('ReplicatedStorage')
                :WaitForChild('Remotes', 9e9)
                :WaitForChild('SpinWheelPrizeEvent', 9e9)
                :FireServer(unpack(L_48_))
			task.wait(0.5) -- small delay to prevent spamming too fast
		end
	end)
end)

--PetTab
local L_20_ = false
L_6_:CreateToggle('+1 Mythic Pet', function(L_49_arg0)
	L_20_ = L_49_arg0
	task.spawn(function()
		while L_20_ do
			local L_50_ = {
				[1] = 4,
			}
			game:GetService('ReplicatedStorage')
                :WaitForChild('Remotes', 9e9)
                :WaitForChild('SpinWheelPrizeEvent', 9e9)
                :FireServer(unpack(L_50_))
			task.wait(0.01) -- small delay to prevent spamming too fast
		end
	end)
end)

--SpinsTab
local L_21_ = false
L_7_:CreateToggle('+1 Spin', function(L_51_arg0)
	L_21_ = L_51_arg0
	task.spawn(function()
		while L_21_ do
			local L_52_ = {
				[1] = 3,
			}
			game:GetService('ReplicatedStorage')
                :WaitForChild('Remotes', 9e9)
                :WaitForChild('SpinWheelPrizeEvent', 9e9)
                :FireServer(unpack(L_52_))
			task.wait(0.01) -- small delay to prevent spamming too fast
		end
	end)
end)
L_7_:CreateButton('Inf Spins', function()
	local L_53_ = {
		[1] = 'Spins',
		[2] = 2500000000000000,
	}
	game:GetService('ReplicatedStorage')
        :WaitForChild('Remotes', 9e9)
        :WaitForChild('AddRewardEvent', 9e9)
        :FireServer(unpack(L_53_))
end)

--Rebirths Tab
local L_22_ = false
L_8_:CreateToggle('Auto Rebirth', function(L_54_arg0)
	L_22_ = L_54_arg0
	task.spawn(function()
		while L_22_ do
			local L_55_ = {
				[1] = 2,
				[2] = 0,
				[3] = 10000000000000000,
			}
			game:GetService('ReplicatedStorage')
                :WaitForChild('Remotes', 9e9)
                :WaitForChild('RebirthConfirmEvent', 9e9)
                :FireServer(unpack(L_55_))
			task.wait(0.0001) -- rebirth every 1 second (adjust if needed)
		end
	end)
end)
L_8_:CreateButton('+1 Rebirth', function()
	local L_56_ = {
		[1] = 1000000000,
		[2] = 0,
		[3] = 10000000000000000,
	}
	game:GetService('ReplicatedStorage')
        :WaitForChild('Remotes', 9e9)
        :WaitForChild('RebirthConfirmEvent', 9e9)
        :FireServer(unpack(L_56_))
end)

--Trail Tab

-- Buy All Regular Trails Button
L_9_:CreateButton('Buy All Regular Trails', function()
	local L_57_ = {
		'Red',
		'Blue',
		'Yellow',
		'Green',
		'Purple',
		'Pink',
		'White',
		'Black',
		'Fire',
		'Neon',
	}
	for L_58_forvar0, L_59_forvar1 in ipairs(L_57_) do
		local L_60_ = {
			[1] = L_59_forvar1,
			[2] = 0, -- regular trails
		}
		game:GetService('ReplicatedStorage')
            :WaitForChild('Remotes', 9e9)
            :WaitForChild('BuyTrailEvent', 9e9)
            :FireServer(unpack(L_60_))
		task.wait(0.1) -- small delay to avoid spamming too hard
	end
end)

-- Buy All Robux Trails Button
L_9_:CreateButton('Buy All Robux Trails', function()
	local L_61_ = {
		'Rainbow',
		'Aurora',
	}
	for L_62_forvar0, L_63_forvar1 in ipairs(L_61_) do
		local L_64_ = {
			[1] = L_63_forvar1,
			[2] = 0, -- regular trails
		}
		game:GetService('ReplicatedStorage')
            :WaitForChild('Remotes', 9e9)
            :WaitForChild('BuyTrailEvent', 9e9)
            :FireServer(unpack(L_64_))
		task.wait(0.1) -- small delay to avoid spamming too hard
	end
end)

--UpgradeTab
L_10_:CreateButton('Max Lucky Merge', function()
	local L_65_ = {
		[1] = 'LuckyMergeLevel',
		[2] = 1000000000,
		[3] = 0,
	}
	game:GetService('ReplicatedStorage')
        :WaitForChild('Remotes', 9e9)
        :WaitForChild('UpgradeEvent', 9e9)
        :FireServer(unpack(L_65_))
end)
L_10_:CreateButton('Max Drop Rate', function()
	local L_66_ = {
		[1] = 'CashRateLevel',
		[2] = 1000000000,
		[3] = 0,
	}
	game:GetService('ReplicatedStorage')
        :WaitForChild('Remotes', 9e9)
        :WaitForChild('UpgradeEvent', 9e9)
        :FireServer(unpack(L_66_))
end)
L_10_:CreateButton('Max Auto Merge', function()
	local L_67_ = {
		[1] = 'AutoMergeLevel',
		[2] = 1000000000,
		[3] = 0,
	}
	game:GetService('ReplicatedStorage')
        :WaitForChild('Remotes', 9e9)
        :WaitForChild('UpgradeEvent', 9e9)
        :FireServer(unpack(L_67_))
end)
L_10_:CreateButton('Max Spawn Tier', function()
	local L_68_ = {
		[1] = 'SpawnTierLevel',
		[2] = 1000000000,
		[3] = 0,
	}
	game:GetService('ReplicatedStorage')
        :WaitForChild('Remotes', 9e9)
        :WaitForChild('UpgradeEvent', 9e9)
        :FireServer(unpack(L_68_))
end)
L_10_:CreateButton('Max Max Gubby', function()
	local L_69_ = {
		[1] = 'MaxBlocksLevel',
		[2] = 1000000000,
		[3] = 0,
	}
	game:GetService('ReplicatedStorage')
        :WaitForChild('Remotes', 9e9)
        :WaitForChild('UpgradeEvent', 9e9)
        :FireServer(unpack(L_69_))
end)
L_10_:CreateButton('Max Spawn Rate', function()
	local L_70_ = {
		[1] = 'SpawnRateLevel',
		[2] = 1000000000,
		[3] = 0,
	}
	game:GetService('ReplicatedStorage')
        :WaitForChild('Remotes', 9e9)
        :WaitForChild('UpgradeEvent', 9e9)
        :FireServer(unpack(L_70_))
end)
L_10_:CreateButton('Max Cash Multipler', function()
	local L_71_ = {
		[1] = 'CashMultiplier',
		[2] = 1000000000,
	}
	game:GetService('ReplicatedStorage')
        :WaitForChild('Remotes', 9e9)
        :WaitForChild('MultiplierEvent', 9e9)
        :FireServer(unpack(L_71_))
end)
L_10_:CreateButton('Max Max Pets', function()
	local L_72_ = {
		[1] = 'MaxPets',
		[2] = 1000000000,
	}
	game:GetService('ReplicatedStorage')
        :WaitForChild('Remotes', 9e9)
        :WaitForChild('MultiplierEvent', 9e9)
        :FireServer(unpack(L_72_))
end)
L_10_:CreateButton('Max All', function()
	local L_73_ = {
		{
			'LuckyMergeLevel',
			1000000000
		},
		{
			'CashRateLevel',
			1000000000
		},
		{
			'AutoMergeLevel',
			1000000000
		},
		{
			'SpawnTierLevel',
			1000000000
		},
		{
			'MaxBlocksLevel',
			1000000000
		},
		{
			'SpawnRateLevel',
			1000000000
		},
	}
	for L_74_forvar0, L_75_forvar1 in ipairs(L_73_) do
		local L_76_ = {
			[1] = L_75_forvar1[1],
			[2] = L_75_forvar1[2],
			[3] = 0,
		}
		game:GetService('ReplicatedStorage')
            :WaitForChild('Remotes', 9e9)
            :WaitForChild('UpgradeEvent', 9e9)
            :FireServer(unpack(L_76_))
		task.wait(0.01)
	end
end)

--Potions Tab

-- x2 Cash Potion
local L_23_ = false
L_11_:CreateToggle('x2 Cash', function(L_77_arg0)
	L_23_ = L_77_arg0
	task.spawn(function()
		while L_23_ do
			local L_78_ = {
				[1] = 'Potion1',
				[2] = 0,
			}
			game:GetService('ReplicatedStorage')
                :WaitForChild('Remotes', 9e9)
                :WaitForChild('BuyPotionEvent', 9e9)
                :FireServer(unpack(L_78_))
			task.wait(0.01) -- repeat every second
		end
	end)
end)

-- x2 Spawn Rate Potion
local L_24_ = false
L_11_:CreateToggle('x2 Spawn Rate', function(L_79_arg0)
	L_24_ = L_79_arg0
	task.spawn(function()
		while L_24_ do
			local L_80_ = {
				[1] = 'Potion2',
				[2] = 0,
			}
			game:GetService('ReplicatedStorage')
                :WaitForChild('Remotes', 9e9)
                :WaitForChild('BuyPotionEvent', 9e9)
                :FireServer(unpack(L_80_))
			task.wait(0.01)
		end
	end)
end)

-- x2Gubbys Potion
local L_25_ = false
L_11_:CreateToggle('x2 Max Gubbys', function(L_81_arg0)
	L_25_ = L_81_arg0
	task.spawn(function()
		while L_25_ do
			local L_82_ = {
				[1] = 'Potion3',
				[2] = 0,
			}
			game:GetService('ReplicatedStorage')
                :WaitForChild('Remotes', 9e9)
                :WaitForChild('BuyPotionEvent', 9e9)
                :FireServer(unpack(L_82_))
			task.wait(0.01)
		end
	end)
end)

-- Add All Potions Toggle
local L_26_ = false
L_11_:CreateToggle('Add All Potions', function(L_83_arg0)
	L_26_ = L_83_arg0
	task.spawn(function()
		while L_26_ do
			local L_84_ = {
				'Potion1',
				'Potion2',
				'Potion3'
			}
			for L_85_forvar0, L_86_forvar1 in ipairs(L_84_) do
				local L_87_ = {
					[1] = L_86_forvar1,
					[2] = 0,
				}
				game:GetService('ReplicatedStorage')
                    :WaitForChild('Remotes', 9e9)
                    :WaitForChild('BuyPotionEvent', 9e9)
                    :FireServer(unpack(L_87_))
			end
			task.wait(0.01)
		end
	end)
end)
local L_27_ = loadstring(
    game:HttpGet('https://raw.githubusercontent.com/EvolWareOfc/OldHubsMadeByEvol/refs/heads/main/UILib/Games/UniversalTab.lua'))()
L_27_(MainWindow, L_1_)
local L_28_ = loadstring(
    game:HttpGet('https://raw.githubusercontent.com/EvolWareOfc/OldHubsMadeByEvol/refs/heads/main/UILib/Games/SupportedGames.lua'))()
L_28_(MainWindow, L_1_)
local L_29_ = loadstring(
    game:HttpGet('https://raw.githubusercontent.com/EvolWareOfc/OldHubsMadeByEvol/refs/heads/main/UILib/Games/Misc.lua'))()
L_29_(MainWindow, L_1_)
local L_30_ = loadstring(
    game:HttpGet('https://raw.githubusercontent.com/EvolWareOfc/OldHubsMadeByEvol/refs/heads/main/UILib/Games/Credits.lua'))()
L_30_(MainWindow, L_1_)

-- Misc systems
loadstring(
    game:HttpGet('https://raw.githubusercontent.com/EvolWareOfc/OldHubsMadeByEvol/refs/heads/main/UILib/Games/Developer%20Detection%20System.lua'))()
loadstring(
    game:HttpGet('https://raw.githubusercontent.com/EvolWareOfc/OldHubsMadeByEvol/refs/heads/main/UILib/Games/DevTag.lua'))()
