
-- Custom MM2 Duper GUI Script (Revised for Item-Specific Duplication)

-- Create Screen GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Main Frame (Draggable with Fade-in Animation)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 400, 0, 400)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = screenGui
mainFrame.Active = true
mainFrame.Draggable = true

-- Fade-in Animation
mainFrame.Visible = true
mainFrame.BackgroundTransparency = 1
mainFrame:TweenSizeAndPosition(UDim2.new(0, 400, 0, 400), UDim2.new(0.5, -200, 0.5, -200), "Out", "Quad", 0.3, true)
for i = 1, 0, -0.1 do
    mainFrame.BackgroundTransparency = i
    wait(0.05)
end

-- Header with MM2 Theme
local header = Instance.new("TextLabel")
header.Size = UDim2.new(1, 0, 0, 50)
header.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
header.BorderSizePixel = 0
header.Text = "🔪 Mm2 Duper 💎"
header.TextColor3 = Color3.fromRGB(255, 255, 255)
header.TextSize = 24
header.Font = Enum.Font.SourceSansBold
header.Parent = mainFrame

-- Multiplier Input Section
local multiplierLabel = Instance.new("TextLabel")
multiplierLabel.Size = UDim2.new(0, 380, 0, 30)
multiplierLabel.Position = UDim2.new(0, 10, 0, 70)
multiplierLabel.BackgroundTransparency = 1
multiplierLabel.Text = "Set Dupe Multiplier (Default: 2)"
multiplierLabel.TextColor3 = Color3.fromRGB(235, 235, 245)
multiplierLabel.TextSize = 18
multiplierLabel.Font = Enum.Font.SourceSans
multiplierLabel.Parent = mainFrame

local multiplierInput = Instance.new("TextBox")
multiplierInput.Size = UDim2.new(0, 380, 0, 40)
multiplierInput.Position = UDim2.new(0, 10, 0, 110)
multiplierInput.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
multiplierInput.BorderSizePixel = 0
multiplierInput.Text = "2"
multiplierInput.TextColor3 = Color3.fromRGB(255, 255, 255)
multiplierInput.TextSize = 20
multiplierInput.Font = Enum.Font.SourceSans
multiplierInput.Parent = mainFrame

-- Item Name Input Section
local itemNameLabel = Instance.new("TextLabel")
itemNameLabel.Size = UDim2.new(0, 380, 0, 30)
itemNameLabel.Position = UDim2.new(0, 10, 0, 170)
itemNameLabel.BackgroundTransparency = 1
itemNameLabel.Text = "Item Name for Specific Dupe"
itemNameLabel.TextColor3 = Color3.fromRGB(235, 235, 245)
itemNameLabel.TextSize = 18
itemNameLabel.Font = Enum.Font.SourceSans
itemNameLabel.Parent = mainFrame

local itemNameInput = Instance.new("TextBox")
itemNameInput.Size = UDim2.new(0, 380, 0, 40)
itemNameInput.Position = UDim2.new(0, 10, 0, 210)
itemNameInput.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
itemNameInput.BorderSizePixel = 0
itemNameInput.Text = ""
itemNameInput.TextColor3 = Color3.fromRGB(255, 255, 255)
itemNameInput.TextSize = 20
itemNameInput.Font = Enum.Font.SourceSans
itemNameInput.PlaceholderText = "Enter Item Name"
itemNameInput.Parent = mainFrame

-- Notification Function with Slide-In Animation
local function showNotification(content)
    local notification = Instance.new("TextLabel")
    notification.Size = UDim2.new(0, 300, 0, 50)
    notification.Position = UDim2.new(0.5, -150, 0, -60)
    notification.BackgroundColor3 = Color3.fromRGB(85, 170, 85)
    notification.BorderSizePixel = 0
    notification.Text = content
    notification.TextColor3 = Color3.fromRGB(255, 255, 255)
    notification.TextSize = 18
    notification.Font = Enum.Font.SourceSansBold
    notification.Parent = screenGui

    notification:TweenPosition(UDim2.new(0.5, -150, 0, 10), "Out", "Quad", 0.5, true)
    wait(2)
    notification:TweenPosition(UDim2.new(0.5, -150, 0, -60), "Out", "Quad", 0.5, true)
    wait(0.5)
    notification:Destroy()
end

-- Apply Button with Click Animation
local applyButton = Instance.new("TextButton")
applyButton.Size = UDim2.new(0, 380, 0, 50)
applyButton.Position = UDim2.new(0, 10, 0, 270)
applyButton.BackgroundColor3 = Color3.fromRGB(85, 170, 85)
applyButton.BorderSizePixel = 0
applyButton.Text = "Apply Dupe Multiplier"
applyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
applyButton.TextSize = 20
applyButton.Font = Enum.Font.SourceSansBold
applyButton.Parent = mainFrame

-- Function to Apply Multiplier
applyButton.MouseButton1Click:Connect(function()
    local multiplier = tonumber(multiplierInput.Text)
    local itemName = itemNameInput.Text
    if not multiplier or itemName == "" then
        showNotification("Enter valid multiplier and item name.")
        return
    end

    -- Access inventory and duplicate specific item
    local player = game.Players.LocalPlayer
    local success = false
    if player and player:FindFirstChild("PlayerGui") and player.PlayerGui:FindFirstChild("MainGUI") then
        local mainGUI = player.PlayerGui.MainGUI
        local inventory = mainGUI:FindFirstChild("Inventory") or mainGUI:FindFirstChild("Lobby").Screens:FindFirstChild("Inventory")
        
        if inventory and inventory:FindFirstChild("Main") then
            local container = inventory.Main.Weapons.Items.Container
            for _, item in pairs(container:GetChildren()) do
                if item:IsA("Frame") and item.Container:FindFirstChild("ItemName") then
                    local name = item.Container.ItemName.Label.Text
                    if name == itemName then
                        local amountText = item.Container.Amount.Text
                        local amount = tonumber(amountText:match("x(%d+)")) or 1
                        item.Container.Amount.Text = "x" .. tostring(amount * multiplier)
                        success = true
                    end
                end
            end
        end
    end

    if success then
        showNotification("Multiplier applied to " .. itemName)
    else
        showNotification("Item not found or error in applying multiplier.")
    end
end)

-- Credits Label
local creditsLabel = Instance.new("TextLabel")
creditsLabel.Size = UDim2.new(0, 380, 0, 30)
creditsLabel.Position = UDim2.new(0, 10, 0, 330)
creditsLabel.BackgroundTransparency = 1
creditsLabel.Text = "Made by: 🔮Vyxrion🔮"
creditsLabel.TextColor3 = Color3.fromRGB(150, 150, 160)
creditsLabel.TextSize = 14
creditsLabel.Font = Enum.Font.SourceSansItalic
creditsLabel.Parent = mainFrame
