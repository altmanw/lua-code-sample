---------- Required Modules -----------

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local DialogueBank = require(Knit.Modules.GameStateUtility.DialogueBank.DialogueBank)

---------- Module Instance ------------

local DefaultTutorialBank = {}
DefaultTutorialBank.__index = DefaultTutorialBank
setmetatable(DefaultTutorialBank, DialogueBank)

DefaultTutorialBank.BankName = script.Name

DefaultTutorialBank.DialogueBanks = {}

---------- Dialogue functions ----------

function DefaultTutorialBank.DialogueBanks.FindTheKey()
	local dialogueBuilder = DefaultTutorialBank:_getBuilder(DefaultTutorialBank.BankName, "FindTheKey")
	local actor1 = DefaultTutorialBank:_getRandomActor()

	dialogueBuilder:AddDialogue("<i>W A K E U P</i>", "Unknown", 0.03, 4)
	dialogueBuilder:AddDialogue("This is " .. DefaultTutorialBank.StylizedText["Todd"], "Unknown", 0.075, 4)
	dialogueBuilder:AddDialogue(
		DefaultTutorialBank.StylizedText["Todd"] .. " is <b>very ill</b> and needs your help.",
		"Unknown",
		0.075,
		4
	)
	dialogueBuilder:AddDialogue("<i>Really?</i>", actor1)
	dialogueBuilder:AddDialogue("Even with a cheeky smile like that? <font size='44'>😏</font>", actor1, nil, 2)
	dialogueBuilder:AddDialogue("<i><b>SILENCE, " .. actor1.DisplayName .. "</b></i>", "Unknown", 0.075, 4)

	dialogueBuilder:AddObjective("Find the <font color= 'rgb(48, 214, 11)'>Green Key</font>")
	dialogueBuilder:AddDialogue(
		"Find the <font color= 'rgb(48, 214, 11)'>Green Key,</font> and then we may continue.",
		"Unknown",
		0.075,
		4
	)

	return dialogueBuilder:Finish(true) --force the dialogue to play over any current dialogue
end

function DefaultTutorialBank.DialogueBanks.FindTheDoor()
	local dialogueBuilder = DefaultTutorialBank:_getBuilder(DefaultTutorialBank.BankName, "FindTheDoor")

	dialogueBuilder:AddDialogue("Good work. Now, enter the hallway and find the next room.", "Unknown")
	dialogueBuilder:AddObjective("Find the Next Room")

	return dialogueBuilder:Finish(true)
end

function DefaultTutorialBank.DialogueBanks.UseDirectionPanel()
	local dialogueBuilder = DefaultTutorialBank:_getBuilder(DefaultTutorialBank.BankName, "UseDirectionPanel")

	dialogueBuilder:AddDialogue("The hallways can be maze-like, but they are navigable.", "Unknown")
	dialogueBuilder:AddObjective("Use the Direction Panel")
	dialogueBuilder:AddDialogue("Use that <i>Direction Panel</i> to figure out where to go.", "Unknown")

	return dialogueBuilder:Finish(true)
end

function DefaultTutorialBank.DialogueBanks.FindTheLoot(playerWhoTriggered: Player)
	local dialogueBuilder = DefaultTutorialBank:_getBuilder(DefaultTutorialBank.BankName, "FindTheLoot")

	dialogueBuilder:AddDialogue("Nice work, " .. playerWhoTriggered.DisplayName .. ".", "Unknown")
	dialogueBuilder:AddObjective("Find the Equipment")
	dialogueBuilder:AddDialogue(
		"Enter the green door, grab the equipment in the supply room, then bring it back to the nurse!",
		"Unknown"
	)

	return dialogueBuilder:Finish(true)
end

function DefaultTutorialBank.DialogueBanks.ReturnEquipment()
	local dialogueBuilder = DefaultTutorialBank:_getBuilder(DefaultTutorialBank.BankName, "ReturnEquipment")

	dialogueBuilder:AddObjective("Return the Equipment to the Nurse")
	dialogueBuilder:AddDialogue("Excellent. Now, return the equipment to the nurse.", "Unknown")
	dialogueBuilder:AddDialogue(
		"And remember, if it any point in time you feel lost or forget what to do, <b>check your clipboard</b> for a reminder!",
		"Unknown",
		nil,
		6
	)

	return dialogueBuilder:Finish(true)
end

function DefaultTutorialBank.DialogueBanks.SaveTodd()
	local dialogueBuilder = DefaultTutorialBank:_getBuilder(DefaultTutorialBank.BankName, "SaveTodd")

	dialogueBuilder:AddDialogue("Hurry! " .. DefaultTutorialBank.StylizedText["Todd"] .. " needs CPR!", "Unknown")
	dialogueBuilder:AddObjective("Save " .. DefaultTutorialBank.StylizedText["Todd"])
	dialogueBuilder:AddDialogue(
		"Walk up to " .. DefaultTutorialBank.StylizedText["Todd"] .. " and perfom CPR!",
		"Unknown"
	)

	return dialogueBuilder:Finish(true)
end

---------- Public functions ----------

---------- Utility functions ----------

return DefaultTutorialBank
