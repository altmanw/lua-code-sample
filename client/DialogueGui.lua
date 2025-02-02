
---------- Required Modules -----------

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local LocalizationService = game:GetService("LocalizationService")
local Players = game:GetService("Players")
local SuperSoundController = Knit.GetController("SuperSoundController")
local DialogueService = Knit.GetService("DialogueService")
local DialogueController = Knit.GetController("DialogueController")
local Types = require(ReplicatedStorage.Common.Types.Shared)

---------- Module Instance ------------

local DialogueGui = {}

local SOURCE_LOCALE = "en"

---------- Private functions ----------

function DialogueGui:_loadTranslator()
	pcall(function()
		self.Translator = LocalizationService:GetTranslatorForPlayerAsync(Players.LocalPlayer)
	end)
	if not self.Translator then
		pcall(function()
			self.Translator = LocalizationService:GetTranslatorForLocaleAsync(SOURCE_LOCALE)
		end)
	end
end

--[[
	<b>bold text</b> <i>italic text</i> <u>underline text</u> <s>strikethrough text</s> <font color= "rgb(240, 40, 10)">red text</font> <font size="32">bigger text</font>
]]
function DialogueGui:_typeWrite(
	text: string,
	soundGroup: string,
	soundName: string,
	typeDelay: number,
	sequenceId: number
)
	self.DialogueBox.Visible = true
	self.DialogueBox.AutoLocalize = false
	local displayText: string = text

	-- Translate text if possible
	if self.Translator then
		displayText = self.Translator:Translate(self.DialogueBox, text)
	end

	-- Replace line break tags so grapheme loop will not miss those characters
	displayText = displayText:gsub("<br%s*/>", "\n")

	self.DialogueBox.Text = displayText

	-- Remove RichText tags since char-by-char animation will break the tags
	displayText = displayText:gsub("<[^<>]->", "")

	local index = 0
	for _, _ in utf8.graphemes(displayText) do
		index += 1
		self.DialogueBox.MaxVisibleGraphemes = index

		SuperSoundController:PlaySoundGlobally(soundName, soundGroup)
		task.wait(typeDelay)

		--allows us to stop mid-word to allow priority dialogue to play
		if self.ForcedSequence ~= nil and self.ForcedSequence ~= sequenceId then
			break
		end
	end
end

function DialogueGui:_toggle(enabled: boolean)
	self.Container.Enabled = enabled
end

function DialogueGui:_tryPlayDialogue()
	if self.Active == false then
		self.Active = true
		task.spawn(function()
			self.ForcedSequence = nil --if we're just starting, this is redudant and can cause bugs

			self:_toggle(true)

			while #self.MessageQueue > 0 do
				local myDialogueObj: Types.DialogueData = table.remove(self.MessageQueue, 1)

				--[[
					Allows us to skip ahead in the dialogue queue if there is a
					priority dialogue sequence that needs to be played (e.g. skip
					exposition to play a mission completed dialogue sequence)
				]]
				if self.ForcedSequence ~= nil and myDialogueObj.SequenceId ~= self.ForcedSequence then
					continue
				else
					--Reset once we've reached the forced sequence
					self.ForcedSequence = nil
				end

				self.Image.Image = myDialogueObj.Image
				self.Name.Text = myDialogueObj.Name

				--blocks
				self:_typeWrite(
					myDialogueObj.Text,
					myDialogueObj.SoundGroup,
					myDialogueObj.Sound,
					myDialogueObj.TypeDelay,
					myDialogueObj.SequenceId
				)

				if self.ForcedSequence == nil or myDialogueObj.SequenceId == self.ForcedSequence then
					DialogueController.Bindable.DialogueFinished:Fire(
						myDialogueObj.SequenceId,
						myDialogueObj.SequenceNum
					)
					task.wait(myDialogueObj.PauseDelay)
				else
					task.wait(0.5) --so we don't skip dialogue immediately
				end
			end

			--cleanup once all dialogue has played
			self:_toggle(false)

			self.Active = false
			self.ForcedSequence = nil --redundancy
		end)
	end
end

---------- Public functions -----------

--[[
	Prevents all sequences but this from displaying
	Once the forced sequence starts, this ban is lifted.
]]
function DialogueGui:ForceSequence(sequenceId: number)
	self.ForcedSequence = sequenceId
end

function DialogueGui:AddToQueueAsync(dialogueObj: Types.DialogueData)
	table.insert(self.MessageQueue, dialogueObj)

	self:_tryPlayDialogue()
end

---------- Utility functions ----------

function DialogueGui:New()
	local o = {}
	setmetatable(o, self)
	self.__index = self

	o:_loadTranslator()

	o.PlayerGui = game.Players.LocalPlayer.PlayerGui
	o.Container = o.PlayerGui:WaitForChild("SuperDialogue")
	o.OuterFrame = o.Container:WaitForChild("OuterFrame")
	o.Image = o.OuterFrame:WaitForChild("PictureFrame"):WaitForChild("Image")
	o.Name = o.OuterFrame:WaitForChild("PictureFrame"):WaitForChild("PlayerName")
	o.DialogueBox = o.OuterFrame:WaitForChild("DialogueFrame"):WaitForChild("DialogueBox")

	o.MessageQueue = {}
	o.ForcedSequence = nil
	o.Active = false

	return o
end

return DialogueGui
