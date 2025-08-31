-- الخدمات
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local player = Players.LocalPlayer

-- تأكد من leaderstats.Credit
if not player:FindFirstChild("leaderstats") then
    local ls = Instance.new("Folder")
    ls.Name = "leaderstats"
    ls.Parent = player
end

if not player.leaderstats:FindFirstChild("Credit") then
    local credit = Instance.new("IntValue")
    credit.Name = "Credit"
    credit.Value = 0
    credit.Parent = player.leaderstats
end

-- إنشاء RemoteEvent إذا لم يكن موجود
local remote = ReplicatedStorage:FindFirstChild("AddCredits")
if not remote then
    remote = Instance.new("RemoteEvent")
    remote.Name = "AddCredits"
    remote.Parent = ReplicatedStorage
end

-- إنشاء GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CreditGUI"
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 350, 0, 200)
frame.Position = UDim2.new(0.5, -175, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local creditLabel = Instance.new("TextLabel")
creditLabel.Size = UDim2.new(0, 330, 0, 40)
creditLabel.Position = UDim2.new(0, 10, 0, 10)
creditLabel.BackgroundTransparency = 1
creditLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
creditLabel.TextScaled = true
creditLabel.Font = Enum.Font.GothamBold
creditLabel.Text = "نقاطك: " .. player.leaderstats.Credit.Value
creditLabel.Parent = frame

local amountBox = Instance.new("TextBox")
amountBox.Size = UDim2.new(0, 200, 0, 50)
amountBox.Position = UDim2.new(0.5, -100, 0, 60)
amountBox.PlaceholderText = "اكتب عدد النقاط"
amountBox.ClearTextOnFocus = true
amountBox.TextScaled = true
amountBox.Font = Enum.Font.Gotham
amountBox.Parent = frame

local claimButton = Instance.new("TextButton")
claimButton.Size = UDim2.new(0, 120, 0, 50)
claimButton.Position = UDim2.new(0.5, -60, 0, 120)
claimButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
claimButton.TextColor3 = Color3.fromRGB(255, 255, 255)
claimButton.TextScaled = true
claimButton.Font = Enum.Font.GothamBold
claimButton.Text = "استلم"
claimButton.Parent = frame

local successLabel = Instance.new("TextLabel")
successLabel.Size = UDim2.new(0, 330, 0, 30)
successLabel.Position = UDim2.new(0, 10, 0, 180)
successLabel.BackgroundTransparency = 1
successLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
successLabel.TextScaled = true
successLabel.Font = Enum.Font.GothamBold
successLabel.Text = ""
successLabel.Parent = frame

-- تحديث النقاط في الوقت الفعلي
player.leaderstats.Credit:GetPropertyChangedSignal("Value"):Connect(function()
    creditLabel.Text = "نقاطك: " .. player.leaderstats.Credit.Value
end)

-- إرسال الرقم للسيرفر عند الضغط
claimButton.MouseButton1Click:Connect(function()
    local amount = tonumber(amountBox.Text)
    if amount and amount > 0 then
        remote:FireServer(amount)
        amountBox.Text = ""
        successLabel.Text = "تم إرسال النقاط!"
        task.delay(2, function() successLabel.Text = "" end)
    else
        successLabel.Text = "اكتب رقم صحيح"
        task.delay(2, function() successLabel.Text = "" end)
    end
end)

-- ==== سيرفر داخلي: إنشاء Script تلقائي في ServerScriptService إذا لم يكن موجود ===
if not ServerScriptService:FindFirstChild("AddCredits_ServerScript") then
    local serverScript = Instance.new("Script")
    serverScript.Name = "AddCredits_ServerScript"
    serverScript.Parent = ServerScriptService
    serverScript.Source = [[
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local remote = ReplicatedStorage:WaitForChild("AddCredits")
        remote.OnServerEvent:Connect(function(player, amount)
            if player:FindFirstChild("leaderstats") and player.leaderstats:FindFirstChild("Credit") then
                player.leaderstats.Credit.Value = player.leaderstats.Credit.Value + amount
            end
        end)
    ]]
end
