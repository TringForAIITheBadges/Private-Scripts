-- \\ Simple Device Check by TringForAllTheBadges //
-- This is just a clone of my previous one but simple.

local UserInputService = game:GetService("UserInputService")

local function checkDevice()
	local deviceInfo = {}

	deviceInfo.keyboardEnabled = UserInputService.KeyboardEnabled
	deviceInfo.mouseEnabled = UserInputService.MouseEnabled
	deviceInfo.gamepadEnabled = UserInputService.GamepadEnabled
	deviceInfo.touchEnabled = UserInputService.TouchEnabled

	print("Device Information:")
	for key, value in pairs(deviceInfo) do
		print(key .. ": " .. tostring(value))
	end
end

checkDevice()
