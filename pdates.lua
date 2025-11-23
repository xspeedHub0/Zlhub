
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local TweenService = game:GetService("TweenService")

local function crearToast(texto, duracion, posicionY)
    
    local toastGui = Instance.new("ScreenGui")
    toastGui.Name = "RainbowToast"
    toastGui.ResetOnSpawn = false
    toastGui.Parent = playerGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 240, 0, 70)
    frame.Position = UDim2.new(1, -260, 0, posicionY) -- posición Y personalizada
    frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
    frame.BorderSizePixel = 0
    frame.Parent = toastGui
    frame.ClipsDescendants = true
    frame.BackgroundTransparency = 0.15

    local uiStroke = Instance.new("UIStroke")
    uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    uiStroke.Thickness = 2
    uiStroke.Parent = frame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0,12)
    corner.Parent = frame

    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1, -10, 1, -10)
    text.Position = UDim2.new(0,5,0,5)
    text.BackgroundTransparency = 1
    text.Text = texto
    text.TextWrapped = true
    text.Font = Enum.Font.GothamSemibold
    text.TextSize = 16
    text.Parent = frame

    local function rainbow(obj)
        task.spawn(function()
            while obj.Parent do
                for i = 0, 1, 0.005 do
                    local c = Color3.fromHSV(i, 1, 1)
                    if obj:IsA("TextLabel") then
                        obj.TextColor3 = c
                    else
                        obj.Color = c
                    end
                    task.wait()
                end
            end
        end)
    end

    rainbow(uiStroke)
    rainbow(text)

    frame.Position = UDim2.new(1, -260, -0.2, 0)
    frame.BackgroundTransparency = 1
    text.TextTransparency = 1
    uiStroke.Transparency = 1

    TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {
        Position = UDim2.new(1, -260, 0, posicionY),
        BackgroundTransparency = 0.15
    }):Play()

    TweenService:Create(text, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
    TweenService:Create(uiStroke, TweenInfo.new(0.5), {Transparency = 0}):Play()

    task.wait(duracion)

    local t1 = TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {
        Position = UDim2.new(1, -260, -0.2, 0),
        BackgroundTransparency = 1
    })
    local t2 = TweenService:Create(text, TweenInfo.new(0.5), {TextTransparency = 1})
    local t3 = TweenService:Create(uiStroke, TweenInfo.new(0.5), {Transparency = 1})

    t1:Play()
    t2:Play()
    t3:Play()

    t1.Completed:Connect(function()
        toastGui:Destroy()
    end)

end

crearToast("sistema recuperado perdon por los inconvenientes", 10, 20)

if setclipboard then
    setclipboard("https://discord.gg/MXK4XdHG8z")
end

crearToast("DISCORD COPIADO AUTOMÁTICAMENTE PARA INFORMACIÓN", 10, 95)
