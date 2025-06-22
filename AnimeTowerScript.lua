-- ✅ Load Rayfield UI
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

-- 🌟 Create Main Window with Custom Loading
local Window = Rayfield:CreateWindow({
    Name = "Anime Tower Script",
    LoadingTitle = "Android Hub",
    LoadingSubtitle = "discord.gg/ringta",
    ConfigurationSaving = {
        Enabled = false
    },
    KeySystem = false
})

-- 🔐 Power Control Variables
local powerToRun = nil
local powerTargeted = false

-- === 🟩 Green GO Button (Fixed, Not Draggable) ===
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PowerExecutor"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = gethui and gethui() or game:GetService("CoreGui")

local Frame = Instance.new("TextButton")
Frame.Size = UDim2.new(0, 50, 0, 50)
Frame.Position = UDim2.new(1, -60, 0.5, -25)
Frame.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
Frame.BorderSizePixel = 0
Frame.AutoButtonColor = false
Frame.Text = ""
Frame.Visible = false
Frame.Parent = ScreenGui
Instance.new("UICorner", Frame).CornerRadius = UDim.new(1, 0)

-- === 👥 Target Player Selector GUI ===
local TargetGui = Instance.new("Frame")
TargetGui.Size = UDim2.new(0, 200, 0, 250)
TargetGui.Position = UDim2.new(0.5, -100, 0.5, -125)
TargetGui.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
TargetGui.BorderSizePixel = 0
TargetGui.Visible = false
TargetGui.Parent = ScreenGui
Instance.new("UICorner", TargetGui).CornerRadius = UDim.new(0, 10)

local Scrolling = Instance.new("ScrollingFrame", TargetGui)
Scrolling.Size = UDim2.new(1, 0, 1, 0)
Scrolling.CanvasSize = UDim2.new(0, 0, 0, 0)
Scrolling.ScrollBarThickness = 4
Scrolling.BackgroundTransparency = 1
Scrolling.BorderSizePixel = 0
Scrolling.AutomaticCanvasSize = Enum.AutomaticSize.Y

local UIListLayout = Instance.new("UIListLayout", Scrolling)
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

local selectorOpen = false

-- 🟢 GO Button Behavior
Frame.MouseButton1Click:Connect(function()
    if powerToRun then
        if powerTargeted then
            if selectorOpen then
                TargetGui.Visible = false
                selectorOpen = false
                return
            end

            for _, child in pairs(Scrolling:GetChildren()) do
                if child:IsA("TextButton") then
                    child:Destroy()
                end
            end

            for _, plr in pairs(game:GetService("Players"):GetPlayers()) do
                if plr ~= game.Players.LocalPlayer then
                    local btn = Instance.new("TextButton")
                    btn.Size = UDim2.new(1, -10, 0, 30)
                    btn.Text = plr.Name
                    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                    btn.TextColor3 = Color3.new(1, 1, 1)
                    btn.BorderSizePixel = 0
                    btn.Font = Enum.Font.Gotham
                    btn.TextSize = 14
                    btn.Parent = Scrolling

                    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

                    btn.MouseButton1Click:Connect(function()
                        TargetGui.Visible = false
                        selectorOpen = false
                        game:GetService("ReplicatedStorage"):WaitForChild("SkillEvent"):FireServer(unpack({powerToRun, plr}))
                    end)
                end
            end

            Scrolling.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
            TargetGui.Visible = true
            selectorOpen = true

        else
            game:GetService("ReplicatedStorage"):WaitForChild("SkillEvent"):FireServer(unpack({powerToRun}))
        end
    end
end)

-- === 🧬 Morph Tab (Old Power Tab) ===
local MorphTab = Window:CreateTab("Morph", "🧬")
MorphTab:CreateParagraph({
    Title = "Morph Selection",
    Content = "Click any character to morph."
})
for _, morphName in pairs({"SuperGojo", "Gogeta", "Tokito", "Naruto6Path", "HeianSukuna", "Sukuna", "Kokushibo", "Gojo"}) do
    MorphTab:CreateButton({
        Name = morphName,
        Callback = function()
            game:GetService("ReplicatedStorage"):WaitForChild("MorphRequest"):FireServer(morphName)
        end
    })
end

-- === ⚡ Power Tab (Now Below Morph) ===
local PowerTab = Window:CreateTab("Power", "⚡")
PowerTab:CreateParagraph({
    Title = "Power Setup",
    Content = "Tap a power to load it into the GO button."
})
local powers = {
    {Name = "Gogeta", Targeted = false},
    {Name = "Tokito", Targeted = false},
    {Name = "Naruto6Path", Targeted = false},
    {Name = "HeianSukuna", Targeted = true},
    {Name = "SuperGojo", Targeted = true},
    {Name = "Sukuna", Targeted = true},
    {Name = "Kokushibo", Targeted = false},
    {Name = "Gojo", Targeted = true}
}
for _, p in pairs(powers) do
    PowerTab:CreateButton({
        Name = p.Name .. (p.Targeted and " (Needs target)" or ""),
        Callback = function()
            powerToRun = p.Name
            powerTargeted = p.Targeted
            Frame.Visible = true
            Rayfield:Notify({
                Title = "Power Loaded",
                Content = "GO will use: " .. p.Name,
                Duration = 2
            })
        end
    })
end

-- === 🧰 Misc Tab ===
local MiscTab = Window:CreateTab("Misc", nil)

MiscTab:CreateButton({
    Name = "Anti AFK",
    Callback = function()
        local VirtualUser = game:GetService("VirtualUser")
        game:GetService("Players").LocalPlayer.Idled:Connect(function()
            VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            task.wait()
            VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        end)
    end
})

MiscTab:CreateButton({
    Name = "Load Infinite Yield",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    end
})

local WalkEnabled = false
MiscTab:CreateToggle({
    Name = "WalkSpeed Enabled",
    CurrentValue = false,
    Callback = function(value)
        WalkEnabled = value
    end
})

MiscTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 200},
    Increment = 1,
    CurrentValue = 16,
    Callback = function(value)
        if WalkEnabled then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
        end
    end
})

MiscTab:CreateToggle({
    Name = "Fly (toggle)",
    CurrentValue = false,
    Callback = function(v)
        if v then
            loadstring(game:HttpGet("https://pastebin.com/raw/Yj8bPYAa"))() -- Fly script from Infinite Yield
        end
    end
})

-- Bring Function with Textbox
MiscTab:CreateButton({
    Name = "Bring",
    Callback = function()
        local displayName = bringTarget or ""
        for _, plr in pairs(game.Players:GetPlayers()) do
            if plr.DisplayName:lower():find(displayName:lower()) then
                local args = {
                    "Pain",
                    plr
                }
                game:GetService("ReplicatedStorage"):WaitForChild("SkillEvent"):FireServer(unpack(args))
                break
            end
        end
    end
})

MiscTab:CreateInput({
    Name = "Target (Display Name)",
    PlaceholderText = "e.g. noober",
    RemoveTextAfterFocusLost = false,
    Callback = function(text)
        bringTarget = text
    end
})

-- 🧼 Destroy GUI Button
PowerTab:CreateButton({
    Name = "Destroy GUI",
    Callback = function()
        Rayfield:Destroy()
        ScreenGui:Destroy()
    end
})
