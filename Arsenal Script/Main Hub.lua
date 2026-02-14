local library = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/SkidoLOL/ArsenalScript/main/Arsenal%20Script/Ui%20Lib/Shadow%20Lib.lua"))()

local Main = library:CreateWindow("Untitled Script Arsenal","Crimson")

local tab = Main:CreateTab("Main")
local tab3 = Main:CreateTab("Player")
local tab4 = Main:CreateTab("Weapons")
local tab5 = Main:CreateTab("Game")
local tab6 = Main:CreateTab("Visuals")

local qz = loadstring(game:HttpGet("https://raw.githubusercontent.com/FunpaySmartBot/ArsenalScript/refs/heads/main/Arsenal%20Script/Scripts%20For%20MainHub/EspSettings.lua"))()
local aj = {
    Players = false,
    Tracers = false,
    Names = false,
    Boxes = false,
    TeamColor = false,
    TeamMates = false,
    Color = Color3.fromRGB(255, 255, 255)
}

local originalMaterials = {}
local originalDecalsTextures = {}
local originalLightingSettings = {
    GlobalShadows = game.Lighting.GlobalShadows,
    FogEnd = game.Lighting.FogEnd,
    Brightness = game.Lighting.Brightness
}
local originalTerrainSettings = {
    WaterWaveSize = game.Workspace.Terrain.WaterWaveSize,
    WaterWaveSpeed = game.Workspace.Terrain.WaterWaveSpeed,
    WaterReflectance = game.Workspace.Terrain.WaterReflectance,
    WaterTransparency = game.Workspace.Terrain.WaterTransparency
}
local originalEffects = {}

local esp_data = {} 
local esp_title = 'dontask'

local function esps(parent, label)
    local BillboardGui = Instance.new('BillboardGui')
    local TextLabel = Instance.new('TextLabel')

    BillboardGui.Name = esp_title
    BillboardGui.Parent = parent
    BillboardGui.AlwaysOnTop = true
    BillboardGui.Size = UDim2.new(0, 50, 0, 50)
    BillboardGui.StudsOffset = Vector3.new(0, 2, 0)

    TextLabel.Parent = BillboardGui
    TextLabel.BackgroundColor3 = Color3.new(1, 1, 1)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Size = UDim2.new(1, 0, 1, 0)
    TextLabel.Text = label
    TextLabel.TextColor3 = Color3.new(1, 0, 0)
    TextLabel.TextScaled = false

    return BillboardGui
end

local function applyESP(object, label)
    if object:IsA('TouchTransmitter') then
        local parent = object.Parent
        if not parent:FindFirstChild(esp_title) then
            local newESP = esps(parent, label)
            esp_data[parent] = newESP
        end
    end
end

local function toggleESP(enable, name, label)
    if enable then
        for _, v in ipairs(game.Workspace:GetDescendants()) do
            if v:IsA('TouchTransmitter') and v.Parent.Name == name then
                applyESP(v, label)
            end
        end
        
        game.Workspace.DescendantAdded:Connect(function(descendant)
            if descendant:IsA('TouchTransmitter') and descendant.Parent.Name == name then
                applyESP(descendant, label)
            end
        end)
    else
        for parent, espElement in pairs(esp_data) do
            if parent and espElement then
                espElement:Destroy()
                esp_data[parent] = nil
            end
        end
    end
end


local ESP = tab6:CreateSection("> ESP V1 <")

ESP:CreateToggle("Enable Esp", function(K)
    qz:Toggle(K)
    aj.Players = K
end)

ESP:CreateToggle("Tracers Esp", function(K)
    aj.Tracers = K
end)

ESP:CreateToggle("Name Esp", function(K)
    aj.Names = K
end)

ESP:CreateToggle("Boxes Esp", function(K)
    aj.Boxes = K
end)

ESP:CreateToggle("Team Coordinate", function(L)
    aj.TeamColor = L
end)

ESP:CreateToggle("Teammates", function(L)
    aj.TeamMates = L
end)

local ESPOptions = tab6:CreateSection("> ESP Options <")

ESPOptions:CreateToggle("Ammo Box ESP", function(enabled)
    toggleESP(enabled, 'DeadAmmo', 'Ammo Box')
end)

ESPOptions:CreateToggle("HP Jug ESP", function(enabled)
    toggleESP(enabled, 'DeadHP', 'HP Jar')
end)

local Performance = tab6:CreateSection("> Performance <")

Performance:CreateToggle("Anti Lag", function(state)
    if state then
        for ai, O in pairs(game:GetService("Workspace"):GetDescendants()) do
            if O:IsA("BasePart") and not O.Parent:FindFirstChild("Humanoid") then
                originalMaterials[O] = O.Material
                O.Material = Enum.Material.SmoothPlastic
                if O:IsA("Texture") then
                    table.insert(originalDecalsTextures, O)
                    O:Destroy()
                end
            end
        end
    else
        for O, material in pairs(originalMaterials) do
            if O and O:IsA("BasePart") then
                O.Material = material
            end
        end
        originalMaterials = {}
    end
end)

Performance:CreateToggle("FPS Boost", function(state)
    if state then
        local g = game
        local w = g.Workspace
        local l = g.Lighting
        local t = w.Terrain
        originalTerrainSettings.WaterWaveSize = t.WaterWaveSize
        originalTerrainSettings.WaterWaveSpeed = t.WaterWaveSpeed
        originalTerrainSettings.WaterReflectance = t.WaterReflectance
        originalTerrainSettings.WaterTransparency = t.WaterTransparency

        t.WaterWaveSize = 0
        t.WaterWaveSpeed = 0
        t.WaterReflectance = 0
        t.WaterTransparency = 0
        l.GlobalShadows = false
        l.FogEnd = 9e9
        l.Brightness = 0
        settings().Rendering.QualityLevel = "Level01"

        for i, v in pairs(g:GetDescendants()) do
            if v:IsA("Part") or v:IsA("Union") or v:IsA("CornerWedgePart") or v:IsA("TrussPart") then
                originalMaterials[v] = v.Material
                v.Material = "Plastic"
                v.Reflectance = 0
            elseif v:IsA("Decal") or v:IsA("Texture") then
                table.insert(originalDecalsTextures, v)
                v.Transparency = 1
            elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                v.Lifetime = NumberRange.new(0)
            elseif v:IsA("Explosion") then
                v.BlastPressure = 1
                v.BlastRadius = 1
            elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") then
                v.Enabled = false
            elseif v:IsA("MeshPart") then
                originalMaterials[v] = v.Material
                v.Material = "Plastic"
                v.Reflectance = 0
                v.TextureID = 10385902758728957
            end
        end

        for i, e in pairs(l:GetChildren()) do
            if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then
                originalEffects[e] = e.Enabled
                e.Enabled = false
            end
        end
    else
        local t = game.Workspace.Terrain
        t.WaterWaveSize = originalTerrainSettings.WaterWaveSize
        t.WaterWaveSpeed = originalTerrainSettings.WaterWaveSpeed
        t.WaterReflectance = originalTerrainSettings.WaterReflectance
        t.WaterTransparency = originalTerrainSettings.WaterTransparency

        game.Lighting.GlobalShadows = originalLightingSettings.GlobalShadows
        game.Lighting.FogEnd = originalLightingSettings.FogEnd
        game.Lighting.Brightness = originalLightingSettings.Brightness

        settings().Rendering.QualityLevel = "Automatic"

        for v, material in pairs(originalMaterials) do
            if v and v:IsA("BasePart") then
                v.Material = material
                v.Reflectance = 0
            end
        end
        originalMaterials = {}

        for e, enabled in pairs(originalEffects) do
            if e then
                e.Enabled = enabled
            end
        end
        originalEffects = {}
        
        for _, v in pairs(originalDecalsTextures) do
            if v and v.Parent then
                v.Transparency = 0
            end
        end
        originalDecalsTextures = {}
    end
end)

local fullBrightEnabled = false
Performance:CreateToggle("Full Bright", function(enabled)
    fullBrightEnabled = enabled 

    local Light = game:GetService("Lighting")

    local function doFullBright()
        if fullBrightEnabled then
            Light.Ambient = Color3.new(1, 1, 1)
            Light.ColorShift_Bottom = Color3.new(1, 1, 1)
            Light.ColorShift_Top = Color3.new(1, 1, 1)
        else
            Light.Ambient = Color3.new(0.5, 0.5, 0.5)
            Light.ColorShift_Bottom = Color3.new(0, 0, 0)
            Light.ColorShift_Top = Color3.new(0, 0, 0)
        end
    end

    doFullBright()

    Light.LightingChanged:Connect(doFullBright)
end)

tab:CreateButton("Aimbot",function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/FunpaySmartBot/ArsenalScript/refs/heads/main/Arsenal%20Script/Scripts%20For%20MainHub/Arsenal%20AimBot.lua"))()
end)

tab:CreateButton("Silent Aim",function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/FunpaySmartBot/ArsenalScript/refs/heads/main/Arsenal%20Script/Scripts%20For%20MainHub/Silent%20Aim.lua"))()
end)

tab3:CreateButton("Speed Bypass",function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/FunpaySmartBot/ArsenalScript/refs/heads/main/Arsenal%20Script/Scripts%20For%20MainHub/GuiSpeed.lua"))()
end)

tab4:CreateButton("Modded Guns",function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/FunpaySmartBot/ArsenalScript/refs/heads/main/Arsenal%20Script/Scripts%20For%20MainHub/GunSettings.lua"))()
end)

tab4:CreateButton("Inf Ammo",function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/FunpaySmartBot/ArsenalScript/refs/heads/main/Arsenal%20Script/Scripts%20For%20MainHub/InfAmmo.lua"))()
end)

tab5:CreateButton("Rejoin Server",function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/FunpaySmartBot/ArsenalScript/refs/heads/main/Arsenal%20Script/Scripts%20For%20MainHub/Rejoin.lua"))()
end)

tab3:CreateButton("Fly Press E",function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/FunpaySmartBot/ArsenalScript/refs/heads/main/Arsenal%20Script/Scripts%20For%20MainHub/Fly.lua"))()
end)

tab3:CreateButton("Inf Jump",function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/FunpaySmartBot/ArsenalScript/refs/heads/main/Arsenal%20Script/Scripts%20For%20MainHub/Inf%20Jump.lua"))()
end)

tab5:CreateButton("Mod Bypass",function()

local getgenv, getnamecallmethod, hookmetamethod, newcclosure, checkcaller, stringlower = getgenv, getnamecallmethod, hookmetamethod, newcclosure, checkcaller, string.low

if getgenv().ED_AntiKick then
    return
end



local Players, StarterGui, OldNamecall = game:GetService("Players"), game:GetService("StarterGui")


getgenv().ED_AntiKick = {
    Enabled = true, 
    SendNotifications = true, 
    CheckCaller = false 
}

--Main

OldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(...)
    if (getgenv().ED_AntiKick.CheckCaller and not checkcaller() or true) and stringlower(getnamecallmethod()) == "kick" and ED_AntiKick.Enabled then
        if getgenv().ED_AntiKick.SendNotifications then
            StarterGui:SetCore("SendNotification", {
                Title = "Anti Mod-ban",
                Text = "The script has successfully intercepted an attempt to ban you.",
                Icon = "rbxassetid://6238540373",
                Duration = 2,
            })
        end

        return nil
    end

    return OldNamecall(...)
end))

if getgenv().ED_AntiKick.SendNotifications then
    StarterGui:SetCore("SendNotification", {
        Title = "AntiDetect",
        Text = "Anti ModBan script loaded!",
        Icon = "rbxassetid://6238537240",
        Duration = 3,
    })
end
end)

tab5:CreateButton("Name Protect",function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/SkidoLOL/ArsenalScript/main/Arsenal%20Script/Scripts%20For%20MainHub/NameProtect.lua"))()
end)

tab4:CreateButton("Rgb Weapons",function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/SkidoLOL/ArsenalScript/main/Arsenal%20Script/Scripts%20For%20MainHub/Rainbow%20Weapons.lua"))()
end)

tab:Show()

game:GetService("StarterGui"):SetCore("SendNotification",{
Title = "Script loaded enjoy!",
Text = "Made By SkidoLOL And qqwizzixxxx(Now FunpaySmartBot)", 

Button1 = "o0o0o0o",
Button1 = "Play And Enjoy!",
Duration = 30 
})



