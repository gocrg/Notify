-- custom notify 
-- Mikuware Notification System
local TweenService = game:GetService("TweenService")
local TextService = game:GetService("TextService")
local CoreGui = game:GetService("CoreGui")

-- Miku Color Scheme
local MIKU_TEAL = Color3.fromRGB(57, 197, 187)
local MIKU_LIGHT = Color3.fromRGB(180, 240, 255)
local MIKU_PINK = Color3.fromRGB(255, 119, 168)
local MIKU_DARK = Color3.fromRGB(0, 72, 83)
local MIKU_WHITE = Color3.fromRGB(255, 255, 255)

-- Create notification container if it doesn't exist
if not game:GetService("CoreGui"):FindFirstChild("MikuwareNotifications") then
    local notifyContainer = Instance.new("ScreenGui")
    notifyContainer.Name = "MikuwareNotifications"
    notifyContainer.ResetOnSpawn = false
    notifyContainer.Parent = CoreGui
end

local function MikuNotify(message, duration)
    duration = duration or 3
    
    -- Calculate text size
    local textSize = TextService:GetTextSize(message, 20, Enum.Font.GothamBold, Vector2.new(500, 100))
    
    -- Create notification frame
    local notifyFrame = Instance.new("Frame")
    notifyFrame.Name = "MikuNotify_"..tostring(tick())
    notifyFrame.Size = UDim2.new(0, math.clamp(textSize.X + 40, 200, 500), 0, 60)
    notifyFrame.Position = UDim2.new(0, -500, 0.1, 0)
    notifyFrame.BackgroundColor3 = MIKU_DARK
    notifyFrame.BackgroundTransparency = 0.2
    notifyFrame.BorderSizePixel = 0
    notifyFrame.Parent = CoreGui:FindFirstChild("MikuwareNotifications")
    
    -- Miku gradient background
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, MIKU_TEAL),
        ColorSequenceKeypoint.new(1, MIKU_LIGHT)
    })
    gradient.Rotation = 90
    gradient.Parent = notifyFrame
    
    -- Pink accent bar
    local accentBar = Instance.new("Frame")
    accentBar.Name = "AccentBar"
    accentBar.Size = UDim2.new(1, 0, 0, 4)
    accentBar.Position = UDim2.new(0, 0, 1, -4)
    accentBar.BackgroundColor3 = MIKU_PINK
    accentBar.BorderSizePixel = 0
    accentBar.Parent = notifyFrame
    
    -- Decorative corners
    local function createCorner(size, position)
        local corner = Instance.new("Frame")
        corner.Size = UDim2.new(0, size, 0, size)
        corner.Position = position
        corner.BackgroundColor3 = MIKU_PINK
        corner.BorderSizePixel = 0
        corner.Parent = notifyFrame
    end
    
    createCorner(8, UDim2.new(0, 0, 0, 0)) -- Top-left
    createCorner(8, UDim2.new(1, -8, 0, 0)) -- Top-right
    
    -- White border
    local stroke = Instance.new("UIStroke")
    stroke.Color = MIKU_WHITE
    stroke.Thickness = 2
    stroke.Transparency = 0
    stroke.Parent = notifyFrame
    
    -- Notification text
    local textLabel = Instance.new("TextLabel")
    textLabel.Text = message
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextSize = 20
    textLabel.TextColor3 = MIKU_WHITE
    textLabel.Size = UDim2.new(1, -20, 1, -10)
    textLabel.Position = UDim2.new(0, 10, 0, 5)
    textLabel.BackgroundTransparency = 1
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.TextYAlignment = Enum.TextYAlignment.Center
    textLabel.TextWrapped = true
    textLabel.Parent = notifyFrame
    
    -- Text glow effect
    local textStroke = Instance.new("UIStroke")
    textStroke.Color = MIKU_TEAL
    textStroke.Thickness = 2
    textStroke.Transparency = 0
    textStroke.Parent = textLabel
    
    -- Animation sequence
    notifyFrame.Visible = true
    
    -- Slide in animation
    TweenService:Create(notifyFrame, TweenInfo.new(0.7, Enum.EasingStyle.Quint), {
        Position = UDim2.new(0, 20, 0.1, 0)
    }):Play()
    
    -- Pulse animation for accent bar
    task.spawn(function()
        local pulseTime = 0.8
        local halfPulse = pulseTime/2
        while notifyFrame.Parent do
            TweenService:Create(accentBar, TweenInfo.new(halfPulse, Enum.EasingStyle.Linear), {
                BackgroundColor3 = MIKU_LIGHT
            }):Play()
            task.wait(halfPulse)
            if not notifyFrame.Parent then break end
            TweenService:Create(accentBar, TweenInfo.new(halfPulse, Enum.EasingStyle.Linear), {
                BackgroundColor3 = MIKU_PINK
            }):Play()
            task.wait(halfPulse)
        end
    end)
    
    -- Auto-dismiss after duration
    task.wait(duration)
    
    -- Slide out animation
    local slideOut = TweenService:Create(notifyFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {
        Position = UDim2.new(0, -500, 0.1, 0)
    })
    slideOut.Completed:Connect(function()
        notifyFrame:Destroy()
    end)
    slideOut:Play()
end

-- Example usage:
-- MikuNotify("Hello World!", 3) -- Shows for 3 seconds
-- MikuNotify("This is a notification") -- Default duration (3 seconds)