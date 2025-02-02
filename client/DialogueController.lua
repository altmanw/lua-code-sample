---------- Required Modules -----------

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local MasterDebug = require(ReplicatedStorage.Common.Util:WaitForChild("MasterDebug"))
local Types = require(ReplicatedStorage.Common.Types.Shared)

---------- Module Instance ------------

local DialogueController = Knit.CreateController({
	Name = "DialogueController",
	Bindable = {
		DialogueFinished = Instance.new("BindableEvent"), --Fires at the end of a dialogueobj
	},
})

---------- Private functions ----------

--[[
	All dialogue objects should be registered before executing a sequence
]]
function DialogueController:_registerDialogueObject(data: Types.DialogueData)
	local sequenceId = data.SequenceId
	local sequenceNum = data.SequenceNum

	if self.DialogueTable[sequenceId] == nil then
		self.DialogueTable[sequenceId] = {}
	end

	self.DialogueTable[sequenceId][sequenceNum] = data
end

function DialogueController:_playDialogueSequence(sequenceId: string)
	local group = self.DialogueTable[sequenceId]

	local indx = 1

	while group[indx] ~= nil do
		self.DialogueGui:AddToQueueAsync(group[indx])
		indx += 1
	end
end

---------- Public functions -----------

---------- Utility functions ----------

function DialogueController:KnitInit()
	if MasterDebug.IsEnabled("ObjectiveController") then
		self.DialogueTable = {}
	end
end

function DialogueController:KnitStart()
	if MasterDebug.IsEnabled("ObjectiveController") then
		self.DialogueService = Knit.GetService("DialogueService")

		self.DialogueGui = require(Knit.Modules.Screen.GuiElements.DialogueGui):New()

		--[[
            Setup connections
        ]]
		--no need for a trove to clean up signals, this will never be shut down

		self.DialogueService.RegisterDialogueObject:Connect(function(data)
			self:_registerDialogueObject(data)
		end)

		self.DialogueService.PlayDialogueSequence:Connect(function(sequenceId)
			self:_playDialogueSequence(sequenceId)
		end)

		--Forcing a sequence is done independently of dialogue objects. The dialogue object must still be registered ahead of time
		self.DialogueService.ForceSequence:Connect(function(sequenceId)
			self.DialogueGui:ForceSequence(sequenceId)
		end)

		--confirms the client has loaded this script after first connection
		Knit.GetController("GuiController"):SignalScriptLoaded(script.Name)
	end
end

return DialogueController
