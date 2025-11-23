--// Toast Rainbow (10 segundos)

local Players = game:GetService("Players")

local player = Players.LocalPlayer

local playerGui = player:WaitForChild("PlayerGui")

-- Gui principal

local toastGui = Instance.new("ScreenGui")

toastGui.Name = "RainbowToast"

toastGui.ResetOnSpawn = false

toastGui.Parent = playerGui

-- Marco del toast

local frame = Instance.new("Frame")

frame.Size = UDim2.new(0, 240, 0, 70)

frame.Position = UDim2.new(1, -260, 0, 20) -- arriba derecha

frame.BackgroundColor3 = Color3.fromRGB(20,20,20)

frame.BorderSizePixel = 0

frame.Active = false

frame.Parent = toastGui

frame.AnchorPoint = Vector2.new(0,0)

frame.ClipsDescendants = true

frame.BackgroundTransparency = 0.15

-- Rainbow Border

local uiStroke = Instance.new("UIStroke")

uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

uiStroke.Thickness = 2

uiStroke.Parent = frame

-- Corner redondo

local corner = Instance.new("UICorner")

corner.CornerRadius = UDim.new(0,12)

corner.Parent = frame

-- Texto

local text = Instance.new("TextLabel")

text.Size = UDim2.new(1, -10, 1, -10)

text.Position = UDim2.new(0,5,0,5)

text.BackgroundTransparency = 1

text.Text = "HEMOS SIDO HACKEADOS\n por favor espere mientras solucionamos el problema "

text.TextWrapped = true

text.Font = Enum.Font.GothamSemibold

text.TextSize = 16

text.Parent = frame

-- Función para animación rainbow

local function rainbow(obj)

	task.spawn(function()		while obj.Parent do

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

-- Animar borde rainbow y texto rainbow

rainbow(uiStroke)

rainbow(text)

-- Animación de aparición

frame.Position = UDim2.new(1, -260, -0.2, 0)

frame.BackgroundTransparency = 1

text.TextTransparency = 1

uiStroke.Transparency = 1

game:GetService("TweenService"):Create(

	frame,

	TweenInfo.new(0.5, Enum.EasingStyle.Quint),

	{Position = UDim2.new(1, -260, 0, 20), BackgroundTransparency = 0.15}

):Play()

game:GetService("TweenService"):Create(

	text,

	TweenInfo.new(0.5),

	{TextTransparency = 0}

):Play()

game:GetService("TweenService"):Create(

	uiStroke,

	TweenInfo.new(0.5),

	{Transparency = 0}

):Play()

-- Espera 10 segundos

task.wait(10)

-- Desaparición

local t1 = game:GetService("TweenService"):Create(

	frame,

	TweenInfo.new(0.5, Enum.EasingStyle.Quint),

	{Position = UDim2.new(1, -260, -0.2, 0), BackgroundTransparency = 1}

)

t1:Play()

local t2 = game:GetService("TweenService"):Create(

	text,

	TweenInfo.new(0.5),

	{TextTransparency = 1}

)

t2:Play()

local t3 = game:GetService("TweenService"):Create(

	uiStroke,

	TweenInfo.new(0.5),

	{Transparency = 1}

)

t3:Play()

t1.Completed:Connect(function()

	toastGui:Destroy()

end)
