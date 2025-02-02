--[[
    this file is an example of using dialogue banks within the gameplay logic - it is for demonstration purposes in this sample
]]

--[[

.... gameplay logic

]]

local DialogueBankManager = require(Knit.Modules.GameStateUtility.DialogueBank.DialogueBankManager):New()
local greenKeyObj = DialogueBankManager:ExecuteDialogue("DefaultTutorialBank", "FindTheKey")[1] --returns a table of assigned objectives, only 1 objective here so we can take it from the table right now

--[[

.... gameplay logic

]]

ObjectiveService:CompleteObjective(greenKeyObj) 

--[[

.... gameplay logic

]]
