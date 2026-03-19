--!strict

local MarketplaceService = game:GetService("MarketplaceService")

local VERSION = {}

export type ProductInfo = {
	Description: string,
}

function VERSION.getVersion() : string
	return "Tome3 v1.2.d-4"
end

local function extractVersionsFromDescription(description: string) : {string}
	local versions: {string} = {}
	
	for index: number, version: string in string.split(description, "\n") do
		table.insert(versions, version)
	end
	
	return versions
end

local function formatVersionArray(versions: {string}) : string
	local currentVersion: string = VERSION.getVersion()
	local latestVersion: string = versions[1]
	
	local formattedVersion: string = "\n"
	
	if currentVersion ~= latestVersion then
		formattedVersion ..= "A new version of Tome is available!\n"
	end
	
	formattedVersion ..= "The latest version of Tome is: '" .. latestVersion .. "'\n\n"
	formattedVersion ..= "Latest versions:\n"
	
	local foundVersion: boolean = false
	local bulletPoint: string = utf8.char(0x2022)
	
	for index: number, version: string in versions do
		formattedVersion ..= `  {bulletPoint} `
		
		if version == latestVersion and version ~= currentVersion then
			formattedVersion ..= version .. " <-- Latest version \n"
		elseif version == currentVersion then
			formattedVersion ..= version .. " <-- You are using this version \n"
			
			foundVersion = true
		else
			formattedVersion ..= version .. "\n"
		end
	end
	
	if not foundVersion then
		formattedVersion ..= "\nWe couldn't determine what version of Tome you're using. It's recommended to upgrade to the latest version!\n"
	end
	
	if currentVersion == latestVersion then
		formattedVersion ..= "\nYou're up to date with the latest version of Tome.\n"
	end
	
	return string.format(formattedVersion)
end

do
	local TOME_PLACE_ID: number = 134275459302272
	
	function VERSION.getVersionDescription() : string
		local attempts: number = 0
		
		while true do
			local success: boolean, productInfo: ProductInfo = pcall(function()
				return MarketplaceService:GetProductInfoAsync(TOME_PLACE_ID, Enum.InfoType.Asset)
			end)
			
			if success then
				return productInfo.Description
			end
			
			attempts += 1
			if attempts > 10 then
				error("Failed to get Tome version.")
			end
			
			task.wait(attempts * 0.5)
		end
	end
	
	function VERSION.getLatestVersionAsync() : string
		return extractVersionsFromDescription(VERSION.getVersionDescription())[1]
	end
end

function VERSION.upToDate() : boolean
	return VERSION.getLatestVersionAsync() == VERSION.getVersion()
end

function VERSION.getVersionFormat() : string
	return formatVersionArray(extractVersionsFromDescription(VERSION.getVersionDescription()))
end

do
	local checkedAlready: boolean = false

	function VERSION.checkForNewVersion(printFunction: any) : ()
		if checkedAlready then
			return
		end
		checkedAlready = true
		
		(printFunction or warn)(VERSION.getVersionFormat())
	end
end

return VERSION