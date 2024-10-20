local CollectionService = game:GetService("CollectionService")
local TweenService = game:GetService("TweenService")
local money2 = game.ReplicatedStorage:WaitForChild("money")
local chaching = game.ReplicatedStorage:WaitForChild("chaching")
local invincible = false

local tweenTable = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.In, 0)
local SendBuffUI = game.ReplicatedStorage:WaitForChild("SendBuffUI")

game.Players.PlayerAdded:Connect(function(plr)
	
	local folder = Instance.new("Folder")
	folder.Name = "leaderstats"
	folder.Parent = plr
	
	local money = Instance.new("IntValue")
	money.Name = "Money"
	money.Parent = folder
	money.Value = 500
	
	plr.CharacterAdded:Connect(function(char)
		local rootpart = char:WaitForChild("HumanoidRootPart")
		local hum = char:WaitForChild("Humanoid")
		
		hum.Died:Connect(function()
			print("player dead")
			
			if money.Value > 1 then
				
				local randomNum = math.random(1, money.Value / 5)
				money.Value -= randomNum
				print("money taken away: " .. randomNum)
				local AmountofMoneytoDrop = math.random(3,8)
				local moneyPerDollar = randomNum / AmountofMoneytoDrop / 2
				print(moneyPerDollar)
				for i = 1, AmountofMoneytoDrop do
					local moneyClone = money2:Clone()
					local clickdetector = moneyClone.ClickDetector
					moneyClone.Parent = workspace:WaitForChild("Debris")
					moneyClone:SetAttribute("amount", moneyPerDollar)
					moneyClone.Position = rootpart.Position
					clickdetector.MouseClick:Connect(function(plr)
						print("clicked")
						plr.leaderstats.Money.Value += moneyPerDollar
						moneyClone:Destroy()
						chaching:Play()

					end)
				end
				
				
				
				plr.CharacterAdded:Connect(function()
					local UI = plr.PlayerGui:FindFirstChild("deathUI")
					UI.Enabled = true
					repeat -- i know i could've used tweenservice for this
						wait(0.1)
						UI.youDied.smTook.Text = "someone took " .. randomNum .. "$ away from you while you were unconcious." 
						UI.youDied.TextTransparency -= 0.1
						UI.youDied.UIStroke.Transparency -= 0.1

						UI.youDied.smTook.TextTransparency -= 0.1
						UI.youDied.smTook.UIStroke.Transparency -= 0.1
					until UI.youDied.TextTransparency <= 0
					
					wait(3)
					
					repeat
						wait(0.1)
						UI.youDied.TextTransparency += 0.1
						UI.youDied.UIStroke.Transparency += 0.1
						
						UI.youDied.smTook.TextTransparency += 0.1
						UI.youDied.smTook.UIStroke.Transparency += 0.1
					until UI.youDied.TextTransparency >= 1
					UI.Enabled = false
					
				end)
				
			end
		end)
	end)
	
end)



for i, _ in CollectionService:GetTagged("deathBrick") do
	_.Touched:Connect(function(touch)
		local humanoid = touch.Parent:FindFirstChild("Humanoid")
		if humanoid and invincible == false then
			humanoid.Health = 0
		elseif humanoid and invincible == true then
			print("player invincible cant kill")
		end
	end)
end

for i, _ in CollectionService:GetTagged("buff") do
	
	local touched = nil
	_.Touched:Connect(function(touch)
		local humanoid = touch.Parent:FindFirstChild("Humanoid")
		if humanoid then
			if touched == nil or touched == false then
				touched = true
				if _:GetAttribute("speed1") then
					humanoid.WalkSpeed = 30
					local timer = 15
					local player = game.Players:GetPlayerFromCharacter(touch.Parent)
					SendBuffUI:FireClient(player, "speed1", timer)
					for i = 1, timer do
						wait(1)
						timer -= 1
						if timer == 0 then
							humanoid.WalkSpeed = 16
							touched = nil
						end
					end
				elseif _:GetAttribute("jump1") then
					humanoid.JumpHeight = 25
					local timer = 15
					local player = game.Players:GetPlayerFromCharacter(touch.Parent)
					SendBuffUI:FireClient(player, "jump1", timer)
					for i = 1, timer do
						wait(1)
						timer -= 1
						if timer == 0 then
							humanoid.JumpHeight = 7.2
							touched = nil
						end
					end
				elseif _:GetAttribute("invincible") then
					invincible = true
					local timer = 20
					local player = game.Players:GetPlayerFromCharacter(touch.Parent)
					SendBuffUI:FireClient(player, "invincible", timer)
					for i = 1, timer do
						wait(1)
						timer -= 1
						if timer == 0 then
							invincible = false
							touched = nil
						end
					end
				end
				
				
			elseif touched == true then
				
			end
		end
	end)
end
