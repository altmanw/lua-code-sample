---------- Required Modules -----------

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local PlayerService = Knit.GetService("PlayerService")
local DialogueBuilder = require(Knit.Modules.GameStateUtility.DialogueBank.DialogueBuilder)

---------- Module Instance ------------

local DialogueBank = {}
DialogueBank.__index = DialogueBank
DialogueBank.BankName = "This DialogueBank abstract class should not be instantiated"
DialogueBank.Knit = Knit
DialogueBank.GameStateService = Knit.GetService("GameStateService")

DialogueBank.StylizedText = {
	Todd = "<font color= 'rgb(47, 254, 255)'>Todd</font>",
	Todds = "<font color= 'rgb(47, 254, 255)'>Todd's</font>",
	DrT = "<font color= 'rgb(18, 220, 220)'>Dr. Thompson</font>",
	Frank = "<font color= 'rgb(255,129,0)'>Frank</font>",
}

---------- Private functions ----------

--[[
	@...
		Players to avoid selecting


]]
function DialogueBank:_getRandomActor(...): Player
	local playerTable = PlayerService:GetPlayers() --get all players active in the game, excluding players spectating

	--for debugging
	if #playerTable == 0 then
		table.insert(playerTable, { DisplayName = "DEBUG" })
	end

	local avoid = { ... }
	local selectedPlayer = playerTable[math.random(#playerTable)]

	if #avoid > 0 and #playerTable > #avoid then
		repeat
			selectedPlayer = playerTable[math.random(#playerTable)]
		until table.find(avoid, selectedPlayer) == nil
	end

	return selectedPlayer
end

function DialogueBank:_getBuilder(bankName: string, sequenceName: string)
	return DialogueBuilder:New(bankName .. sequenceName)
end

---------- Public functions -----------

---------- Utility functions ----------

return DialogueBank
