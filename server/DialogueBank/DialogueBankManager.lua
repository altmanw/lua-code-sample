---------- Required Modules -----------

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

---------- Module Instance ------------

local DialogueBankManager = {}

---------- Private functions ----------

function DialogueBankManager:_requireBanks(root)
	for _, dialogueBank in pairs(root:GetChildren()) do
		if dialogueBank:IsA("Folder") then
			self:_requireBanks(dialogueBank)
		else
			local dialogueBankObj = require(dialogueBank)
			self.BankList[dialogueBankObj.BankName] = dialogueBankObj
		end
	end
end

---------- Public functions -----------

--[[
	All banks return DialogueBuilder:Finish() which is a table of objectives assigned


]]
function DialogueBankManager:ExecuteDialogue(bankName: string, dialogueName: string, ...): {}
	return self.BankList[bankName].DialogueBanks[dialogueName](...)
end

---------- Utility functions ----------

function DialogueBankManager:New()
	local o = {}
	setmetatable(o, self)
	self.__index = self

	self.BankList = {}
	self:_requireBanks(Knit.Modules.GameStateUtility.DialogueBank.StateDialogues)

	return o
end

return DialogueBankManager
