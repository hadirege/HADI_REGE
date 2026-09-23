local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local VirtualUser = game:GetService("VirtualUser")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer

-- ====================================================================
-- ANTI-AFK (Mencegah Kick 20 Menit)
-- ====================================================================
player.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
end)

-- ====================================================================
-- DAFTAR ITEM WHITELIST & FITUR EKSTRA
-- ====================================================================
local itemPilihan = {
    ["kemenyan"] = true,
    ["dupa"] = true,
    ["kepiting sungai"] = true,
    ["bunga melati"] = true,
    ["jamur kuburan"] = true,
    ["gagak"] = true,
}

_G.AutoFarmAktif = false

local fitureEkstra = {
    LoopFullSpeed = false,
    LoopFullBright = false,
    AntiLag = false
}

local OriginalLighting = {
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    FogEnd = Lighting.FogEnd,
    GlobalShadows = Lighting.GlobalShadows,
    Ambient = Lighting.Ambient
}

-- Logika 1: Loop Full Speed
RunService.Stepped:Connect(function()
    if fitureEkstra.LoopFullSpeed and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = 32
    end
end)

-- Logika 2: Loop Full Bright
RunService.RenderStepped:Connect(function()
    if fitureEkstra.LoopFullBright then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 786543
        Lighting.GlobalShadows = false
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
    end
end)

-- Logika 3: Anti Lag
local function aktifkanAntiLag()
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Material = Enum.Material.SmoothPlastic
            v.Reflectance = 0
        elseif v:IsA("Decal") or v:IsA("Texture") then
            v:Destroy()
        elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") then
            v.Enabled = false
        end
    end
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    pcall(function()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    end)
end

-- ====================================================================
-- GUI PANEL
-- ====================================================================
local guiExist = CoreGui:FindFirstChild("AutoFarmGuiOriginal") or player:WaitForChild("PlayerGui"):FindFirstChild("AutoFarmGuiOriginal")
if guiExist then guiExist:Destroy() end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoFarmGuiOriginal"
screenGui.ResetOnSpawn = false

local parentTarget = pcall(function() return CoreGui end) and CoreGui or player:WaitForChild("PlayerGui")
screenGui.Parent = parentTarget

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 220, 0, 300)
mainFrame.Position = UDim2.new(0.02, 0, 0.25, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local topBar = Instance.new("Frame")
topBar.Name = "TopBar"
topBar.Size = UDim2.new(1, 0, 0, 30)
topBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
topBar.BorderSizePixel = 0
topBar.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -60, 1, 0)
titleLabel.Position = UDim2.new(0, 8, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "HADI_REGE"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 14
titleLabel.Parent = topBar

local btnClose = Instance.new("TextButton")
btnClose.Size = UDim2.new(0, 25, 0, 25)
btnClose.Position = UDim2.new(1, -28, 0, 2)
btnClose.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
btnClose.Text = "X"
btnClose.TextColor3 = Color3.fromRGB(255, 255, 255)
btnClose.Font = Enum.Font.SourceSansBold
btnClose.TextSize = 14
btnClose.Parent = topBar

local btnMinimize = Instance.new("TextButton")
btnMinimize.Size = UDim2.new(0, 25, 0, 25)
btnMinimize.Position = UDim2.new(1, -56, 0, 2)
btnMinimize.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
btnMinimize.Text = "-"
btnMinimize.TextColor3 = Color3.fromRGB(255, 255, 255)
btnMinimize.Font = Enum.Font.SourceSansBold
btnMinimize.TextSize = 16
btnMinimize.Parent = topBar

local contentFrame = Instance.new("Frame")
contentFrame.Name = "Content"
contentFrame.Size = UDim2.new(1, 0, 1, -30)
contentFrame.Position = UDim2.new(0, 0, 0, 30)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(1, -16, 0, 32)
toggleBtn.Position = UDim2.new(0, 8, 0, 6)
toggleBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
toggleBtn.Text = "Auto Farm: OFF"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.TextSize = 14
toggleBtn.Parent = contentFrame

toggleBtn.MouseButton1Click:Connect(function()
    _G.AutoFarmAktif = not _G.AutoFarmAktif
    if _G.AutoFarmAktif then
        toggleBtn.BackgroundColor3 = Color3.fromRGB(40, 160, 60)
        toggleBtn.Text = "Auto Farm: ON"
    else
        toggleBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
        toggleBtn.Text = "Auto Farm: OFF"
    end
end)

local scrollList = Instance.new("ScrollingFrame")
scrollList.Size = UDim2.new(1, -16, 1, -48)
scrollList.Position = UDim2.new(0, 8, 0, 44)
scrollList.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
scrollList.BorderSizePixel = 0
scrollList.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollList.ScrollBarThickness = 4
scrollList.Parent = contentFrame

local uiListLayout = Instance.new("UIListLayout")
uiListLayout.Parent = scrollList
uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
uiListLayout.Padding = UDim.new(0, 3)

local totalHeight = 0

for namaItem, status in pairs(itemPilihan) do
    local itemBtn = Instance.new("TextButton")
    itemBtn.Size = UDim2.new(1, -6, 0, 26)
    itemBtn.Font = Enum.Font.SourceSans
    itemBtn.TextSize = 13
    
    local function updateItemVisual()
        if itemPilihan[namaItem] then
            itemBtn.BackgroundColor3 = Color3.fromRGB(40, 120, 50)
            itemBtn.Text = namaItem:upper() .. ": ON"
            itemBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            itemBtn.BackgroundColor3 = Color3.fromRGB(80, 30, 30)
            itemBtn.Text = namaItem:upper() .. ": OFF"
            itemBtn.TextColor3 = Color3.fromRGB(170, 170, 170)
        end
    end
    
    updateItemVisual()
    
    itemBtn.MouseButton1Click:Connect(function()
        itemPilihan[namaItem] = not itemPilihan[namaItem]
        updateItemVisual()
    end)
    
    itemBtn.Parent = scrollList
    totalHeight = totalHeight + 29
end

local divider = Instance.new("Frame")
divider.Size = UDim2.new(1, -6, 0, 2)
divider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
divider.BorderSizePixel = 0
divider.Parent = scrollList
totalHeight = totalHeight + 5

local function buatToggleFitur(namaTampil, keyFitur, callbackCustom)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -6, 0, 26)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 13
    
    local function updateVisual()
        if fitureEkstra[keyFitur] then
            btn.BackgroundColor3 = Color3.fromRGB(0, 120, 180)
            btn.Text = namaTampil .. ": ON"
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            btn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
            btn.Text = namaTampil .. ": OFF"
            btn.TextColor3 = Color3.fromRGB(170, 170, 170)
        end
    end
    
    updateVisual()
    
    btn.MouseButton1Click:Connect(function()
        fitureEkstra[keyFitur] = not fitureEkstra[keyFitur]
        updateVisual()
        if callbackCustom then callbackCustom(fitureEkstra[keyFitur]) end
    end)
    
    btn.Parent = scrollList
    totalHeight = totalHeight + 29
end

buatToggleFitur("FULL SPEED", "LoopFullSpeed", function(state)
    if not state and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = 16
    end
end)

buatToggleFitur("FULL BRIGHT", "LoopFullBright", function(state)
    if not state then
        Lighting.Brightness = OriginalLighting.Brightness
        Lighting.ClockTime = OriginalLighting.ClockTime
        Lighting.FogEnd = OriginalLighting.FogEnd
        Lighting.GlobalShadows = OriginalLighting.GlobalShadows
        Lighting.Ambient = OriginalLighting.Ambient
    end
end)

buatToggleFitur("ANTI LAG", "AntiLag", function(state)
    if state then
        aktifkanAntiLag()
    end
end)

scrollList.CanvasSize = UDim2.new(0, 0, 0, totalHeight)

local isMinimized = false
btnMinimize.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        contentFrame.Visible = false
        mainFrame.Size = UDim2.new(0, 220, 0, 30)
        btnMinimize.Text = "+"
    else
        contentFrame.Visible = true
        mainFrame.Size = UDim2.new(0, 220, 0, 300)
        btnMinimize.Text = "-"
    end
end)

btnClose.MouseButton1Click:Connect(function()
    _G.AutoFarmAktif = false
    screenGui:Destroy()
end)

-- ====================================================================
-- FUNGSI MENCARI ITEM
-- ====================================================================
local function isItemDiToko(prompt)
    local obj = prompt
    for i = 1, 6 do
        if not obj or obj == Workspace then break end
        local namaObj = string.lower(obj.Name)
        
        if string.find(namaObj, "rak") or 
           string.find(namaObj, "toko") or 
           string.find(namaObj, "lapak") or 
           string.find(namaObj, "shelf") or 
           string.find(namaObj, "rack") or 
           string.find(namaObj, "display") or 
           string.find(namaObj, "stand") or 
           string.find(namaObj, "bench") or 
           string.find(namaObj, string.lower(player.Name)) then
            return true
        end
        obj = obj.Parent
    end
    return false
end

local function dapatkanObjekTerdekat()
    local karakter = player.Character
    if not karakter or not karakter:FindFirstChild("HumanoidRootPart") then return nil end
    
    local jarakTerdekat = math.huge
    local targetTerpilih = nil
    
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("ProximityPrompt") and v.Enabled then
            if not isItemDiToko(v) then
                local parentPart = v.Parent
                if parentPart and parentPart:IsA("BasePart") then
                    
                    local namaParent = string.lower(parentPart.Name)
                    local teksObjek = string.lower(v.ObjectText)
                    local teksAksi = string.lower(v.ActionText)
                    
                    if itemPilihan[namaParent] or itemPilihan[teksObjek] or itemPilihan[teksAksi] then
                        local jarak = (karakter.HumanoidRootPart.Position - parentPart.Position).Magnitude
                        if jarak < jarakTerdekat then
                            jarakTerdekat = jarak
                            targetTerpilih = v
                        end
                    end
                    
                end
            end
        end
    end
    return targetTerpilih
end

-- ====================================================================
-- LOOP UTAMA (DENGAN ROTASI KAMERA KE ITEM)
-- ====================================================================
task.spawn(function()
    while true do
        if _G.AutoFarmAktif then
            local karakter = player.Character
            local promptTarget = dapatkanObjekTerdekat()
            
            if promptTarget and karakter and karakter:FindFirstChild("HumanoidRootPart") then
                local partUtama = promptTarget.Parent
                local hrp = karakter.HumanoidRootPart
                local camera = Workspace.CurrentCamera
                
                if partUtama and partUtama:IsA("BasePart") then
                    local isKepiting = string.find(string.lower(partUtama.Name), "kepiting") 
                        or string.find(string.lower(promptTarget.ObjectText), "kepiting")

                    -- Posisi berdiri langsung di titik item (tetap pertahankan rotasi bawaan karakter)
                    local tinggiOffset = isKepiting and Vector3.new(0, 0.5, 0) or Vector3.new(0, 1.5, 0)
                    local posisiLamaRotation = hrp.CFrame.Rotation
                    
                    -- Pindahkan posisi TANPA mengubah arah hadap karakter
                    hrp.CFrame = CFrame.new(partUtama.Position + tinggiOffset) * posisiLamaRotation
                    
                    -- ROTASI KAMERA: Hanya memutar pandangan kamera ke arah item
                    if camera then
                        local posisiKamera = camera.CFrame.Position
                        camera.CFrame = CFrame.lookAt(posisiKamera, partUtama.Position)
                    end
                    
                    hrp.AssemblyLinearVelocity = Vector3.new(0,0,0)
                    hrp.Anchored = true
                    
                    -- Modifikasi sementara batas jarak ProximityPrompt agar 100% tervalidasi oleh server
                    local reqLOS = promptTarget.RequiresLineOfSight
                    local maxDist = promptTarget.MaxActivationDistance
                    
                    promptTarget.RequiresLineOfSight = false
                    promptTarget.MaxActivationDistance = 30
                    
                    -- Jeda lebih manusiawi (0.2s) agar server sempat mencatat lokasi terbaru karakter
                    task.wait(0.2)
                    
                    pcall(function()
                        promptTarget:InputHoldBegin()
                        
                        local durasiHold = promptTarget.HoldDuration
                        if durasiHold <= 0 then durasiHold = 0.2 end
                        
                        -- Memberi buffer ekstra (0.35s) saat menahan tombol agar server memvalidasi penekanan tombol secara penuh
                        task.wait(durasiHold + 0.35)
                        
                        promptTarget:InputHoldEnd()
                    end)
                    
                    -- Kembalikan properti asli item
                    pcall(function()
                        promptTarget.RequiresLineOfSight = reqLOS
                        promptTarget.MaxActivationDistance = maxDist
                    end)
                    
                    -- Lepas kuncian dan beri jeda lebih stabil (0.3s) agar item benar-benar masuk inventaris
                    task.wait(0.3)
                    hrp.Anchored = false
                    task.wait(0.3)
                end
            else
                task.wait(0.3)
            end
        else
            task.wait(0.3)
        end
    end
end)
