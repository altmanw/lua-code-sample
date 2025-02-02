---------- Required Modules -----------

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local ObjectiveService = Knit.GetService("ObjectiveService")
local DialogueService = Knit.GetService("DialogueService")

---------- Module Instance ------------

local DialogueBuilder = {}

---------- Private functions ----------

---------- Public functions -----------

--[[
    IMPORTANT: Call this function RIGHT BEFORE you call the funciton to
               add the dialogue you want it to appear with.
]]
function DialogueBuilder:AddObjective(text: string, plr: Player?)
	local uid = self.SequenceName .. self.ObjectiveNum

	ObjectiveService:RegisterObjectiveWithDialogue(text, uid, self.SequenceName, self.SequenceNum, plr)
	self.ObjectiveNum += 1

	table.insert(self.ObjectiveNameMap, uid)
end

--[[
    To add a display time but not a speed, substitute the speed variable for nil
]]
function DialogueBuilder:AddDialogue(text: string, actor: string | Player, speed: number?, displayTime: number?)
	DialogueService:ShipDialogueObj(text, actor, self.SequenceName, self.SequenceNum, speed, displayTime)
	self.SequenceNum += 1
end

--[[
	@forceSequence
		skip the current dialogue queue and play this specific sequence

	@specificPlayer
		only send the dialogue to this player


	Returns a table of all objectives assigned during the sequence
]]
function DialogueBuilder:Finish(forceSequence: boolean?, specificPlayer: Player?): {}
	local success, response = pcall(function()
		DialogueService:PlayDialogueSequence(self.SequenceName, specificPlayer)

		if forceSequence == true then
			print("Forcing the sequence", self.SequenceName, specificPlayer)
			DialogueService:ForceSequence(self.SequenceName, specificPlayer)
		else
			print("NOT forcing the sequence", self.SequenceName)
		end
	end)

	if not success then
		warn("UNABLE TO PLAY DIALOGUE", self.SequenceName, response)
	end

	return self.ObjectiveNameMap
end

---------- Utility functions ----------

function DialogueBuilder:New(sequenceName: string)
	local o = {}
	setmetatable(o, self)
	self.__index = self

	o.SequenceNum = 1
	o.ObjectiveNum = 1
	o.SequenceName = sequenceName
	o.ObjectiveNameMap = {}

	return o
end

return DialogueBuilder
