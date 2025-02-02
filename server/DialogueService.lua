---------- Required Modules -----------
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local MasterDebug = require(ReplicatedStorage.Common.Util:WaitForChild("MasterDebug"))
local Types = require(ReplicatedStorage.Common.Types.Shared)

---------- Module Instance ------------

local DialogueService = Knit.CreateService({
	Name = "DialogueService",
	Client = {
		RegisterDialogueObject = Knit.CreateSignal(),
		PlayDialogueSequence = Knit.CreateSignal(),
		ForceSequence = Knit.CreateSignal(),
	},
})

local DEFAULT_TYPE_DELAY = 0.05
local DEFAULT_PAUSE_DELAY = 3

local IMAGE_LOOKUP = {
	Unknown = "rbxassetid://18684712485",
	
	Nurse = "rbxassetid://18684609792",
	Nurse_ANGRY = "rbxassetid://18684602093",
	Nurse_NEUTRAL = "rbxassetid://18684605477",
	Nurse_HAPPY = "rbxassetid://18684609792",
	Nurse_JOY = "rbxassetid://18684614181",
	Nurse_SURPRISE = "rbxassetid://18684619058",

	Frank = "rbxassetid://18684629608",
	Frank_ANGRY = "rbxassetid://18684625605",
	Frank_NEUTRAL = "rbxassetid://18684629608",
	Frank_HAPPY = "rbxassetid://18684633494",
	Frank_JOY = "rbxassetid://18684637359",
	Frank_SURPRISE = "rbxassetid://18684640444",

	PA = "rbxassetid://18725321737",
}

local SOUND_GROUP = "Universal" --the sound will play regardless of player region

local SOUND_TABLE = {
	Default = "DialogueRockSound",
	Nurse = "DialogueRockSoundHighPitch",
	Unknown = "DialogueBoomSound",
	Frank = "DialogueRockSound",
	PA = "DialogueRockSound",
}

---------- Private functions ----------

--[[
	Returns a tuple with the image link and entity name and sound name
]]
function DialogueService:_processPlayerOrChar(player: Player | string): (string, string, string)
	local image = nil
	local name = nil
	local sound = nil

	if type(player) ~= "string" and player:IsA("Player") then
		--player character
		local userId = player.UserId
		local thumType = Enum.ThumbnailType.HeadShot
		local thumSize = Enum.ThumbnailSize.Size420x420
		image = game.Players:GetUserThumbnailAsync(userId, thumType, thumSize)
		name = player.DisplayName
		sound = SOUND_TABLE["Default"]
	else
		--fictional character
		image = IMAGE_LOOKUP[player]
		name = string.split(player, "_")[1]
		sound = SOUND_TABLE[name]
	end

	return image, name, sound
end

---------- Public functions -----------

--[[
	Create a package with relevant dialogue data

	@text
		the text of the dialogue

	@player
		the player or fictional character speaking. If a player object is passed, it will
		get data from it. If a string is passed, it will lookup the relevant data for the
		fictional character

	@sequenceId
		a unique identifier for this group of dialogue objects

	@sequenceNum
		the order in which this dialogue object will be shown

	@typeDelay
		the amount of delay between displaying a new character during the typewriter effect

	@pauseDelay
		the amount of time paused after the dialogue is completed


]]
function DialogueService:ShipDialogueObj(
	text: string,
	player: Player | string,
	sequenceId: string,
	sequenceNum: number,
	typeDelay: number?,
	pauseDelay: number
)
	local data: Types.DialogueData = {}
	data.Text = text
	data.Image, data.Name, data.Sound = self:_processPlayerOrChar(player)
	data.TypeDelay = typeDelay or DEFAULT_TYPE_DELAY
	data.SoundGroup = SOUND_GROUP
	data.SequenceId = sequenceId
	data.SequenceNum = sequenceNum
	data.PauseDelay = pauseDelay or DEFAULT_PAUSE_DELAY

	self.Client.RegisterDialogueObject:FireAll(data)
end

--[[
	Skips ahead in the queue to this sequence. Any added
	objectives will also be skipped
]]
function DialogueService:ForceSequence(sequenceId: number, player: Player?)
	if player then
		self.Client.ForceSequence:Fire(player, sequenceId)
	else
		self.Client.ForceSequence:FireAll(sequenceId)
	end
end

--[[
	Play a dialogue sequence for a specific player, or for all players

	@sequenceId
		The unique id the dialogue sequence has
	@player (OPTIONAL)
		the player to send the dialogue to. If omitted, sends dialogue to all players

]]
function DialogueService:PlayDialogueSequence(sequenceId: string, player: Player?)
	print("Playing the sequence", sequenceId, player)

	if player then
		self.Client.PlayDialogueSequence:Fire(player, sequenceId)
	else
		self.Client.PlayDialogueSequence:FireAll(sequenceId)
	end
end

--[[
	For reference
	<b>bold text</b> <i>italic text</i> <u>underline text</u> <s>strikethrough text</s> <font color= "rgb(240, 40, 10)">red text</font> <font size="32">bigger text</font>
]]

---------- Utility functions ----------

function DialogueService:KnitInit()
	if MasterDebug.IsEnabled("DialogueService") then
	end
end

function DialogueService:KnitStart()
	if MasterDebug.IsEnabled("DialogueService") then
	end
end

return DialogueService
