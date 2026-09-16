local Library = loadstring(
	Game:HttpGet('https://raw.githubusercontent.com/EvolWareOfc/EvolWare/refs/heads/main/Library/WizardUILib.lua'))()
local Window = Library:NewWindow('Color Game')
local infTab = Window:NewSection('Inf Stuff')
local WheelTab = Window:NewSection('Spinny Wheel')
local GiveTab = Window:NewSection('Give Stuff')
local MiscTab = Window:NewSection('Misc')
local CreditsnWindow = Library:NewWindow('Credits')
local CreditsnFolder = CreditsnWindow:NewSection('Scripters')
local OCreditsnFolder = CreditsnWindow:NewSection('Other')
CreditsnFolder:CreateButton('UILib', function()
	print('UILib')
end)
OCreditsnFolder:CreateButton('UI By ...', function()
	print('UI By ...')
end)

--infTab
infTab:CreateButton('Coins', function()
	local args = {
		[1] = 'Cash',
		[2] = 9223372036854776000,
	}
	game:GetService('ReplicatedStorage')
		:WaitForChild('Remotes')
		:WaitForChild('AddRewardEvent')
		:FireServer(unpack(args))
end)
infTab:CreateButton('Gold Bombs', function()
	local args = {
		[1] = 'Gold Bombs',
		[2] = 1000000000000000000,
	}
	game:GetService('ReplicatedStorage')
		:WaitForChild('Remotes')
		:WaitForChild('AddRewardEvent')
		:FireServer(unpack(args))
end)
infTab:CreateButton('Bombs', function()
	local args = {
		[1] = 'Bombs',
		[2] = 1000000000000000000,
	}
	game:GetService('ReplicatedStorage')
		:WaitForChild('Remotes')
		:WaitForChild('AddRewardEvent')
		:FireServer(unpack(args))
end)
infTab:CreateButton('Spins', function()
	local args = {
		[1] = 'Spins',
		[2] = 1000000000000000000,
	}
	game:GetService('ReplicatedStorage')
		:WaitForChild('Remotes')
		:WaitForChild('AddRewardEvent')
		:FireServer(unpack(args))
end)
infTab:CreateButton('Revives', function()
	local args = {
		[1] = 'Revives',
		[2] = 1000000000000000000,
	}
	game:GetService('ReplicatedStorage')
		:WaitForChild('Remotes')
		:WaitForChild('AddRewardEvent')
		:FireServer(unpack(args))
end)
local autox5cash = false
WheelTab:CreateToggle('x5 Cash (Be Careful)', function(value)
	autox5cash = value
	task.spawn(function()
		while autox5cash do
			local args = {
				[1] = 10,
			}
			game:GetService('ReplicatedStorage')
				:WaitForChild('Remotes', 9e9)
				:WaitForChild('SpinWheelPrizeEvent', 9e9)
				:FireServer(unpack(args))
			task.wait(0) -- small delay to prevent spamming too fast
		end
	end)
end)
local auto1nuke = false
WheelTab:CreateToggle('+1 Nuke', function(value)
	auto1nuke = value
	task.spawn(function()
		while auto1nuke do
			local args = {
				[1] = 7,
			}
			game:GetService('ReplicatedStorage')
				:WaitForChild('Remotes', 9e9)
				:WaitForChild('SpinWheelPrizeEvent', 9e9)
				:FireServer(unpack(args))
			task.wait(0) -- small delay to prevent spamming too fast
		end
	end)
end)
local auto1revive = false
WheelTab:CreateToggle('+1 Revive', function(value)
	auto1revive = value
	task.spawn(function()
		while auto1revive do
			local args = {
				[1] = 4,
			}
			game:GetService('ReplicatedStorage')
				:WaitForChild('Remotes', 9e9)
				:WaitForChild('SpinWheelPrizeEvent', 9e9)
				:FireServer(unpack(args))
			task.wait(0) -- small delay to prevent spamming too fast
		end
	end)
end)
local auto1spin = false
WheelTab:CreateToggle('+1 Spin', function(value)
	auto1spin = value
	task.spawn(function()
		while auto1spin do
			local args = {
				[1] = 3,
			}
			game:GetService('ReplicatedStorage')
				:WaitForChild('Remotes', 9e9)
				:WaitForChild('SpinWheelPrizeEvent', 9e9)
				:FireServer(unpack(args))
			task.wait(0) -- small delay to prevent spamming too fast
		end
	end)
end)
local auto1kcash = false
WheelTab:CreateToggle('+1K Cash', function(value)
	auto1kcash = value
	task.spawn(function()
		while auto1kcash do
			local args = {
				[1] = 6,
			}
			game:GetService('ReplicatedStorage')
				:WaitForChild('Remotes', 9e9)
				:WaitForChild('SpinWheelPrizeEvent', 9e9)
				:FireServer(unpack(args))
			task.wait(0) -- small delay to prevent spamming too fast
		end
	end)
end)
local auto500cash = false
WheelTab:CreateToggle('+500 cash', function(value)
	auto500cash = value
	task.spawn(function()
		while auto500cash do
			local args = {
				[1] = 2,
			}
			game:GetService('ReplicatedStorage')
				:WaitForChild('Remotes', 9e9)
				:WaitForChild('SpinWheelPrizeEvent', 9e9)
				:FireServer(unpack(args))
			task.wait(0) -- small delay to prevent spamming too fast
		end
	end)
end)
local auto250cash2 = false
WheelTab:CreateToggle('+250 Cash', function(value)
	auto250cash2 = value
	task.spawn(function()
		while auto250cash2 do
			local args = {
				[1] = 8,
			}
			game:GetService('ReplicatedStorage')
				:WaitForChild('Remotes', 9e9)
				:WaitForChild('SpinWheelPrizeEvent', 9e9)
				:FireServer(unpack(args))
			task.wait(0) -- small delay to prevent spamming too fast
		end
	end)
end)

--Bombs
local auto3bombs = false
WheelTab:CreateToggle('+3 Bombs', function(value)
	auto3bombs = value
	task.spawn(function()
		while auto3bombs do
			local args = {
				[1] = 5,
			}
			game:GetService('ReplicatedStorage')
				:WaitForChild('Remotes', 9e9)
				:WaitForChild('SpinWheelPrizeEvent', 9e9)
				:FireServer(unpack(args))
			task.wait(0) -- small delay to prevent spamming too fast
		end
	end)
end)
local auto2bomb = false
WheelTab:CreateToggle('+2 Bombs', function(value)
	auto2bomb = value
	task.spawn(function()
		while auto2bomb do
			local args = {
				[1] = 9,
			}
			game:GetService('ReplicatedStorage')
				:WaitForChild('Remotes', 9e9)
				:WaitForChild('SpinWheelPrizeEvent', 9e9)
				:FireServer(unpack(args))
			task.wait(0) -- small delay to prevent spamming too fast
		end
	end)
end)
local autoBomb = false
WheelTab:CreateToggle('+1 Bomb', function(value)
	autoBomb = value
	task.spawn(function()
		while autoBomb do
			local args = {
				[1] = 1,
			}
			game:GetService('ReplicatedStorage')
				:WaitForChild('Remotes', 9e9)
				:WaitForChild('SpinWheelPrizeEvent', 9e9)
				:FireServer(unpack(args))
			task.wait(0) -- small delay to prevent spamming too fast
		end
	end)
end)

--other
GiveTab:CreateButton('Robux Trails', function()
	local trails = {
		'Rainbow',
		'Electric',
		'Banana'
	}
	for _, trail in ipairs(trails) do
		local args = {
			[1] = trail,
			[2] = 0,
		}
		game:GetService('ReplicatedStorage')
			:WaitForChild('Remotes')
			:WaitForChild('BuyTrailEvent')
			:FireServer(unpack(args))
	end
end)
GiveTab:CreateButton('Regular Trails', function()
	local trails = {
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
	for _, trail in ipairs(trails) do
		local args = {
			[1] = trail,
			[2] = 0,
		}
		game:GetService('ReplicatedStorage')
			:WaitForChild('Remotes')
			:WaitForChild('BuyTrailEvent')
			:FireServer(unpack(args))
	end
end)
GiveTab:CreateButton('All Skins', function()
	local skins = {
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
	for _, skin in ipairs(skins) do
		local args = {
			[1] = skin,
			[2] = 0, -- Change this if skins cost Robux or points
		}
		game:GetService('ReplicatedStorage')
			:WaitForChild('Remotes', 9e9)
			:WaitForChild('BuySkinEvent', 9e9)
			:FireServer(unpack(args))
	end
end)
local autoLevelUp = false
MiscTab:CreateToggle('Level Up', function(value)
	autoLevelUp = value

	-- Keep firing while the toggle is on
	while autoLevelUp do
		local args = {}
		game:GetService('ReplicatedStorage')
			:WaitForChild('Remotes', 9e9)
			:WaitForChild('BuyLevelWithCoinsEvent', 9e9)
			:FireServer(unpack(args))
		task.wait(0.1) -- Wait 1 second between attempts to avoid spamming too fast
	end
end)
local autoCollectGifts = false
MiscTab:CreateToggle('Collect Level Gifts', function(value)
	autoCollectGifts = value
	task.spawn(function()
		while autoCollectGifts do
			for level = 1, 100 do
				local args = {
					[1] = level,
				}
				game:GetService('ReplicatedStorage')
					:WaitForChild('Remotes', 9e9)
					:WaitForChild('ClaimLevelRewardEvent', 9e9)
					:FireServer(unpack(args))
				task.wait(0.1) -- Small delay to avoid spamming too fast
			end
			task.wait(5) -- Wait before looping again to re-check any unclaimed rewards
		end
	end)
end)
local autoPlaceNukes = false
MiscTab:CreateToggle('Auto Place Nukes', function(value)
	autoPlaceNukes = value
	task.spawn(function()
		while autoPlaceNukes do
			local args = {
				[1] = 3, -- nuke type
			}
			game:GetService('ReplicatedStorage')
				:WaitForChild('Remotes', 9e9)
				:WaitForChild('BombEvent2', 9e9)
				:FireServer(unpack(args))
			task.wait(0.5) -- small delay to avoid spamming too fast
		end
	end)
end)
local autoPlaceGoldBombs = false
MiscTab:CreateToggle('Auto Place Gold Bombs', function(value)
	autoPlaceGoldBombs = value
	task.spawn(function()
		while autoPlaceGoldBombs do
			local args = {
				[1] = 2, -- nuke type
			}
			game:GetService('ReplicatedStorage')
				:WaitForChild('Remotes', 9e9)
				:WaitForChild('BombEvent2', 9e9)
				:FireServer(unpack(args))
			task.wait(0.5) -- small delay to avoid spamming too fast
		end
	end)
end)
local autoPlaceBombs = false
MiscTab:CreateToggle('Auto Place Bombs', function(value)
	autoPlaceBombs = value
	task.spawn(function()
		while autoPlaceBombs do
			local args = {
				[1] = 1, -- nuke type
			}
			game:GetService('ReplicatedStorage')
				:WaitForChild('Remotes', 9e9)
				:WaitForChild('BombEvent2', 9e9)
				:FireServer(unpack(args))
			task.wait(0.5) -- small delay to avoid spamming too fast
		end
	end)
end)
local autoPlaceRNukes = false
local SupportedFunc = loadstring(
    game:HttpGet('https://raw.githubusercontent.com/DozeIsOkLol/LibWare/refs/heads/main/games/Tabs/SupportedGames.lua'))()

-- Execute the Supported Games function, passing the main window and library
SupportedFunc(Window, Library)
local miscFunc = loadstring(
    game:HttpGet('https://raw.githubusercontent.com/DozeIsOkLol/LibWare/refs/heads/main/games/Tabs/Misc.lua'))()

-- Execute the Misc tab function
miscFunc(Window, Library)
loadstring(
    game:HttpGet('https://raw.githubusercontent.com/DozeIsOkLol/LibWare/refs/heads/main/games/Misc/Developer%20Detection%20System.lua'))()
loadstring(
    game:HttpGet('https://raw.githubusercontent.com/DozeIsOkLol/LibWare/refs/heads/main/games/Misc/DevTag.lua'))()
