local DataTypeFlexModule = {}

_G.DataTypes = {
	['string'] = 'StringValue';
	['number'] = 'NumberValue';
	['boolean'] = 'BoolValue';
	['BrickColor'] = 'BrickColorValue';
	['Vector3'] = 'Vector3Value';
	['CFrame'] = 'CFrameValue';
	['Color3'] = 'Color3Value';
	['Ray'] = 'RayValue';
	['Instance'] = 'ObjectValue';
	['Enum'] = 'StringValue';
	['DateTime'] = 'NumberValue';
	['Region3'] = 'Vector3Value';
	['UDim'] = 'Vector2Value';
	['UDim2'] = 'Vector3Value';
	['NumberSequence'] = 'StringValue';
	['ColorSequence'] = 'StringValue';
	['NumberRange'] = 'Vector2Value';
	['Rect'] = 'Vector4Value';
	['PhysicalProperties'] = 'Vector3Value';
	['Font'] = 'StringValue';
}

_G.ToTableFuncs = {
	['BrickColor'] = function(v) return {__SPECTYPE='BrickColor', v.Name} end;
	['Vector3'] = function(v) return {__SPECTYPE='Vector3', v.X, v.Y, v.Z} end;
	['CFrame'] = function(v) return {__SPECTYPE='CFrame', table.pack(v:GetComponents())} end;
	['Color3'] = function(v) return {__SPECTYPE='Color3', v.R, v.G, v.B} end;
	['Ray'] = function(v) return {__SPECTYPE='Ray', v.Origin.X, v.Origin.Y, v.Origin.Z, v.Direction.X, v.Direction.Y, v.Direction.Z} end;
	['Instance'] = function(v) return {__SPECTYPE='Instance', v:GetFullName()} end;
	['Enum'] = function(v) return {__SPECTYPE='Enum', tostring(v)} end;
	['DateTime'] = function(v) return {__SPECTYPE='DateTime', v.UnixTimestampMillis} end;
	['Region3'] = function(v) return {__SPECTYPE='Region3', v.CFrame:GetComponents()} end;
	['UDim'] = function(v) return {__SPECTYPE='UDim', v.Scale, v.Offset} end;
	['UDim2'] = function(v) return {__SPECTYPE='UDim2', v.X.Scale, v.X.Offset, v.Y.Scale, v.Y.Offset} end;
	['NumberSequence'] = function(v) return {__SPECTYPE='NumberSequence', v:GetPoints()} end;
	['ColorSequence'] = function(v) return {__SPECTYPE='ColorSequence', v:GetPoints()} end;
	['NumberRange'] = function(v) return {__SPECTYPE='NumberRange', v.Min, v.Max} end;
	['Rect'] = function(v) return {__SPECTYPE='Rect', v.Min.X, v.Min.Y, v.Max.X, v.Max.Y} end;
	['PhysicalProperties'] = function(v) return {__SPECTYPE='PhysicalProperties', v.Density, v.Friction, v.Elasticity, v.FrictionWeight, v.ElasticityWeight} end;
	['Font'] = function(v) return {__SPECTYPE='Font', v.Family, v.Weight, v.Style} end;
}

_G.ToInstanceFuncs = {
	['BrickColor'] = function(t) return BrickColor.new(t[1]) end;
	['Vector3'] = function(t) return Vector3.new(t[1], t[2], t[3]) end;
	['CFrame'] = function(t) return CFrame.new(table.unpack(t[1])) end;
	['Color3'] = function(t) return Color3.new(t[1], t[2], t[3]) end;
	['Ray'] = function(t) return Ray.new(Vector3.new(t[1], t[2], t[3]), Vector3.new(t[4], t[5], t[6])) end;
	['Instance'] = function(t) return game:GetService('HttpService'):JSONDecode(t[1]) end;
	['Enum'] = function(t) return Enum[t[1]] end;
	['DateTime'] = function(t) return DateTime.fromUnixTimestampMillis(t[1]) end;
	['Region3'] = function(t) return Region3.new(CFrame.new(table.unpack(t))) end;
	['UDim'] = function(t) return UDim.new(t[1], t[2]) end;
	['UDim2'] = function(t) return UDim2.new(t[1], t[2], t[3], t[4]) end;
	['NumberSequence'] = function(t) return NumberSequence.new(t) end;
	['ColorSequence'] = function(t) return ColorSequence.new(t) end;
	['NumberRange'] = function(t) return NumberRange.new(t[1], t[2]) end;
	['Rect'] = function(t) return Rect.new(t[1], t[2], t[3], t[4]) end;
	['PhysicalProperties'] = function(t) return PhysicalProperties.new(t[1], t[2], t[3], t[4], t[5]) end;
	['Font'] = function(t) return Font.new(t[1], t[2], t[3]) end;
}

function DataTypeFlexModule:ToTable(folder)
	local result = {}
	for _, v in pairs(folder:GetChildren()) do
		local dataType = typeof(v.Value)
		if v:IsA('Folder') then
			result[v.Name] = self:ToTable(v)
		elseif _G.DataTypes[dataType] then
			result[v.Name] = v.Value
		else
			result[v.Name] = _G.ToTableFuncs[dataType](v.Value)
		end
	end
	return result
end

function DataTypeFlexModule:ToInstance(tbl, folder)
	for k, v in pairs(tbl) do
		local currentType = type(v)
		if currentType == 'table' and v.__SPECTYPE then
			local obj = Instance.new(_G.DataTypes[v.__SPECTYPE])
			obj.Name = k
			obj.Parent = folder
			obj.Value = _G.ToInstanceFuncs[v.__SPECTYPE](v)
		elseif currentType == 'table' then
			local newFolder = Instance.new('Folder')
			newFolder.Name = k
			newFolder.Parent = folder
			self:ToInstance(v, newFolder)
		else
			local obj = Instance.new(_G.DataTypes[typeof(v)])
			obj.Name = k
			obj.Parent = folder
			obj.Value = v
		end
	end
	return folder
end

return DataTypeFlexModule
