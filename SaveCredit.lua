-- خدمات
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataStoreService = game:GetService("DataStoreService")

-- DataStore للاعبين
local creditStore = DataStoreService:GetDataStore("PlayerCredits")

-- إنشاء RemoteEvent إذا لم يكن موجود
local remote = ReplicatedStorage:FindFirstChild("AddCredits")
if not remote then
    remote = Instance.new("RemoteEvent")
    remote.Name = "AddCredits"
    remote.Parent = ReplicatedStorage
end

-- عند دخول اللاعب، تحميل النقاط
game.Players.PlayerAdded:Connect(function(player)
    -- إنشاء leaderstats إذا لم يكن موجود
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

    -- تحميل النقاط من DataStore
    local success, data = pcall(function()
        return creditStore:GetAsync(player.UserId)
    end)
    if success and data then
        player.leaderstats.Credit.Value = data
    end
end)

-- استقبال طلب إضافة النقاط من اللاعبين
remote.OnServerEvent:Connect(function(player, amount)
    if amount and amount > 0 then
        player.leaderstats.Credit.Value = player.leaderstats.Credit.Value + amount
        -- حفظ النقاط
        local success, err = pcall(function()
            creditStore:SetAsync(player.UserId, player.leaderstats.Credit.Value)
        end)
        if not success then
            warn("حدث خطأ في حفظ النقاط: " .. tostring(err))
        end
    end
end)
