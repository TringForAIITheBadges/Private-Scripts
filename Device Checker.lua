local sv = game:GetService("UserInputService")
local rs = game:GetService("RunService")

local function xor(str, key)
	return (str:gsub('.', function(c)
		return string.char(bit32.bxor(c:byte(), key:byte((#str-1) % #key + 1)))
	end))
end

local key = "h4x0r"..tostring(math.random(1000,9999))
local funcs = {
	xor("TouchEnabled", key),
	xor("MouseEnabled", key),
	xor("KeyboardEnabled", key),
	xor("GamepadEnabled", key)
}

local function sniff()
	local d, c = "s", {0,0,0,0}
	for _ = 1, 30 do
		for j = 1, 4 do
			if sv[xor(funcs[j], key)] then c[j] = c[j] + 1 end
		end
		task.wait()
	end
	if c[1] > 25 and c[2] < 5 then d = "m"
	elseif c[3] > 25 and c[2] > 25 then d = "p"
	elseif c[4] > 25 then d = "c" end
	return d, c[1]+c[2]+c[3]+c[4] > 35 or c[1]+c[2]+c[3]+c[4] < 25
end

local lastCheck, sus = 0, 0
rs.Heartbeat:Connect(function()
	if tick() - lastCheck > math.random(5, 15) then
		lastCheck = tick()
		local d, s = sniff()
		if s then
			sus = sus + 1
			if sus > 3 then
				warn(xor(xor("Suspicious device activity detected", key), key))
				sus = 0
			end
		else
			sus = math.max(0, sus - 1)
		end
	end
end)
