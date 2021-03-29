
--[[

2142239
]]

local addonName, alt = ...

local L = alt.Locales

-- borrowed this directly from DataStore, as we'll be accessing the saved var this key will used in our own saved var to keep things simple
local THIS_ACCOUNT = "Default"
local THIS_REALM = GetRealmName()
local THIS_CHAR = UnitName("player")
local THIS_CHARKEY = format("%s.%s.%s", THIS_ACCOUNT, THIS_REALM, THIS_CHAR)

local UI_WIDTH = 1000;
local UI_HEIGHT = 600;

local CONTENT_FRAME_HEIGHT = 560;
local CONTENT_FRAME_WIDTH = 730;

alt.ui = {}

-- parent frame
alt.ui.frame = CreateFrame('FRAME', 'AltasiaUI', UIParent, "UIPanelDialogTemplate")
alt.ui.frame:SetPoint('CENTER', 0, 0)
alt.ui.frame:SetSize(UI_WIDTH, UI_HEIGHT)
alt.ui.frame.background = alt.ui.frame:CreateTexture("$parentBackground", 'ARTWORK')
alt.ui.frame.background:SetPoint('TOPLEFT', 6, -28)
alt.ui.frame.background:SetPoint('BOTTOMRIGHT', -6, 6)
alt.ui.frame.background:SetHorizTile(true)
alt.ui.frame.background:SetVertTile(true)
alt.ui.frame.background:SetAtlas("UI-Frame-Neutral-BackgroundTile", true)
alt:MakeFrameMoveable(alt.ui.frame)
























-- main menu frame, topleft menu buttons
alt.ui.mainMenu = CreateFrame("FRAME", "AltasiaMainMenu", alt.ui.frame)
alt.ui.mainMenu:SetPoint("TOPLEFT", 16, -30)
alt.ui.mainMenu:SetSize(240, 120)
alt.ui.mainMenu.background = alt.ui.mainMenu:CreateTexture(nil, 'BACKGROUND')
alt.ui.mainMenu.background:SetAtlas("auctionhouse-background-auctions", false)
alt.ui.mainMenu.background:SetAllPoints(alt.ui.mainMenu)

function alt:LoadMainMenuButtons()
    alt.ui.mainMenu.characters = alt:NewMainMenuButton("AltasiaMainMenuButtonCharacters", alt.ui.mainMenu, "TOPLEFT", 0, 0)
    local atlas = string.format("raceicon128-%s-%s", ALT_ACC.characters[THIS_CHARKEY].Race, ALT_ACC.characters[THIS_CHARKEY].Gender)
    alt.ui.mainMenu.characters:SetBackground_Atlas(atlas)
    if IsAddOnLoaded('DataStore_Characters') then
        alt.ui.mainMenu.characters.tooltipText = "Character";
        alt.ui.mainMenu.characters.contentFrameKey = "characterSummary";
    else
        alt.ui.mainMenu.characters:Disable()
        alt.ui.mainMenu.characters.tooltipText = "DataStore_Characters not loaded"
    end

    alt.ui.mainMenu.crafts = alt:NewMainMenuButton("AltasiaMainMenuButtonCrafts", alt.ui.mainMenu, "TOPLEFT", 60, 0)
    alt.ui.mainMenu.crafts:SetBackground_Atlas("Mobile-Blacksmithing")
    if IsAddOnLoaded('DataStore_Crafts') then
        alt.ui.mainMenu.crafts.tooltipText = "Crafts"
        alt.ui.mainMenu.crafts.contentFrameKey = "craftsSummary";
    else
        alt.ui.mainMenu.crafts:Disable()
        alt.ui.mainMenu.crafts.tooltipText = "DataStore_Crafts not loaded"
    end

    alt.ui.mainMenu.containers = alt:NewMainMenuButton("AltasiaMainMenuButtonContainers", alt.ui.mainMenu, "TOPLEFT", 120, 0)
    alt.ui.mainMenu.containers:SetBackground_Atlas("bonusloot-chest")
    if IsAddOnLoaded('DataStore_Containers') then
        alt.ui.mainMenu.containers.tooltipText = "Containers"
        alt.ui.mainMenu.containers.contentFrameKey = "containerSummary";
    else
        alt.ui.mainMenu.containers:Disable()
        alt.ui.mainMenu.containers.tooltipText = "DataStore_Containers not loaded"
    end

    alt.ui.mainMenu.quests = alt:NewMainMenuButton("AltasiaMainMenuButtonQuests", alt.ui.mainMenu, "TOPLEFT", 180, 0)
    alt.ui.mainMenu.quests:SetBackground_Atlas("Mobile-QuestIcon-Desaturated")
    if IsAddOnLoaded('DataStore_Quests') then
        alt.ui.mainMenu.quests.tooltipText = "Quests"
        alt.ui.mainMenu.quests.contentFrameKey = "questSummary";
    else
        alt.ui.mainMenu.quests:Disable()
        alt.ui.mainMenu.quests.tooltipText = "DataStore_Quests not loaded"
    end

    alt.ui.mainMenu.mail = alt:NewMainMenuButton("AltasiaMainMenuButtonMail", alt.ui.mainMenu, "TOPLEFT", 0, -60)
    alt.ui.mainMenu.mail:SetBackground_Atlas("communities-icon-invitemail")
    if IsAddOnLoaded('DataStore_Mails') then
        alt.ui.mainMenu.mail.tooltipText = "Mail"
        alt.ui.mainMenu.mail.contentFrameKey = "mailSummary";
    else
        alt.ui.mainMenu.mail:Disable()
        alt.ui.mainMenu.mail.tooltipText = "DataStore_Mail not loaded"
    end

    alt.ui.mainMenu.settings = alt:NewMainMenuButton("AltasiaMainMenuButtonSettings", alt.ui.mainMenu, "TOPLEFT", 180, -60)
    alt.ui.mainMenu.settings:SetBackground_Atlas("Mobile-Enginnering")
    alt.ui.mainMenu.settings.tooltipText = "Settings"
    alt.ui.mainMenu.settings.contentFrameKey = "settings";
end











































-- character listview menu, lower left
alt.ui.charactersListview = CreateFrame("ScrollFrame", "AltasiaCharacterScrollFrame", alt.ui.frame, "UIPanelScrollFrameTemplate")
alt.ui.charactersListview:SetPoint("TOPLEFT", alt.ui.frame, 'TOPLEFT', 6, -160)
alt.ui.charactersListview:SetPoint("BOTTOMRIGHT", alt.ui.frame, 'BOTTOMLEFT', 226, 20)
alt.ui.charactersListview:SetScript("OnMouseWheel", function(self, delta)
    local newValue = self:GetVerticalScroll() - (delta * 20)
    if (newValue < 0) then
        newValue = 0;
    elseif (newValue > self:GetVerticalScrollRange()) then
        newValue = self:GetVerticalScrollRange()
    end
    self:SetVerticalScroll(newValue)
end)
local characterScrollChild = CreateFrame("Frame", "AltasiaCharacterScrollFrameChild", alt.ui.charactersListview)
characterScrollChild:SetPoint("TOP", 0, 0)
characterScrollChild:SetSize(250, 340)
alt.ui.charactersListview:SetScrollChild(characterScrollChild)
alt.ui.charactersListview.background = alt.ui.charactersListview:CreateTexture(nil, 'BACKGROUND')
alt.ui.charactersListview.background:SetPoint('TOPLEFT', alt.ui.charactersListview, 'TOPLEFT', 0, 6)
alt.ui.charactersListview.background:SetPoint('BOTTOMRIGHT', alt.ui.charactersListview, 'BOTTOMRIGHT', 36, -16)
alt.ui.charactersListview.background:SetAtlas("UI-Frame-Neutral-CardParchment", false)































-- character summary frame
alt.ui.characterSummary = CreateFrame("FRAME", "AltasiaCharacterSummary", alt.ui.frame)
alt.ui.characterSummary:SetPoint('TOPLEFT', 264, -30)
alt.ui.characterSummary:SetSize(CONTENT_FRAME_WIDTH, CONTENT_FRAME_HEIGHT)
alt.ui.characterSummary:SetScript("OnShow", function()
    alt:ParseCharacters()
    alt:CharacterSummaryListview_Refresh()
end)
alt.ui.characterSummary.background = alt.ui.characterSummary:CreateTexture(nil, 'ARTWORK')
alt.ui.characterSummary.background:SetAllPoints(alt.ui.characterSummary)
alt.ui.characterSummary.background:SetAtlas("UI-Frame-Neutral-CardParchmentWider", false)

alt.ui.characterSummary.listview = CreateFrame("FRAME", "AltasiaCharacterSummaryListview", alt.ui.characterSummary)
alt.ui.characterSummary.listview:SetPoint("TOPLEFT", 10, -50)
alt.ui.characterSummary.listview:SetSize(700, 480)
alt.ui.characterSummary.listview.rows = {}
for i = 1, 20 do
    alt.ui.characterSummary.listview.rows[i] = CreateFrame("FRAME", "AltasiaCharacterSummaryListview"..i, alt.ui.characterSummary.listview, "AltasiaListviewItem_CharacterSummary")
    alt.ui.characterSummary.listview.rows[i]:SetPoint("TOPLEFT", 5, (i-1) * -24)
    alt.ui.characterSummary.listview.rows[i]:Hide()
end

function alt:CharacterSummaryListview_Clear()
    for i = 1, 20 do
        self.ui.characterSummary.listview.rows[i]:Hide()
    end
end

function alt:CharacterSummaryListview_Refresh()
    local scrollPos = math.floor(self.ui.characterSummary.scrollBar:GetValue())
    if scrollPos == 0 then
        scrollPos = 1
    end
    local character = nil;
    for i = 1, 20 do
        if alt.charactersSummary[(i - 1) + scrollPos] then
            character = alt.charactersSummary[(i - 1) + scrollPos]
            self.ui.characterSummary.listview.rows[i]:SetName(character.Name)
            self.ui.characterSummary.listview.rows[i]:SetRace_Atlas(string.format("raceicon128-%s-%s", character.Race:lower(), character.Gender))
            self.ui.characterSummary.listview.rows[i].bio = { Race = character.Race, Gender = character.Gender, Class = character.Class, }
            self.ui.characterSummary.listview.rows[i]:SetClass_Atlas(string.format("classicon-%s", character.Class:lower()))
            self.ui.characterSummary.listview.rows[i]:SetItemLevel(string.format("%0.2f", character.ilvl))
            self.ui.characterSummary.listview.rows[i]:SetLevel(string.format("%02d", character.Level))
            self.ui.characterSummary.listview.rows[i]:SetLevelXP(string.format("%s%%", character.XP))
            self.ui.characterSummary.listview.rows[i]:SetLevelXPRested(string.format("%s%%", character.RestedXP))
            self.ui.characterSummary.listview.rows[i]:SetProf1_Atlas(string.format("Mobile-%s", character.Prof1))
            self.ui.characterSummary.listview.rows[i].prof1 = character.Prof1
            self.ui.characterSummary.listview.rows[i]:SetProf2_Atlas(string.format("Mobile-%s", character.Prof2))
            self.ui.characterSummary.listview.rows[i].prof2 = character.Prof2
            self.ui.characterSummary.listview.rows[i]:SetMoney(character.Money)
            self.ui.characterSummary.listview.rows[i]:SetRestedIcon(character.isRested)
            self.ui.characterSummary.listview.rows[i]:SetCurrentLocation(character.Location)
            
            self.ui.characterSummary.listview.rows[i]:Show()
        end
    end
end

local charListviewHeaders = {
    { Text = 'Name', offsetX = 14, width = 159, sort = "Name" },
    { Text = 'ilvl', offsetX = 172, width = 56, sort = "ilvl" },
    { Text = 'Level', offsetX = 227, width = 55, sort = "Level" },
    { Text = 'XP', offsetX = 281, width = 65, sort = "XP" },
    { Text = 'Rested', offsetX = 345, width = 65, sort = "RestedXP" },
    { Text = 'Prof', offsetX = 409, width = 50, sort = "Prof" },
    { Text = 'Location', offsetX = 458, width = 140, sort = "Location" },
    { Text = 'Money', offsetX = 597, width = 100, sort = "Money" },
}

for k, b in ipairs(charListviewHeaders) do
    local button = CreateFrame("BUTTON", "AltasiaCharacterSummaryListviewHeader"..b.Text, alt.ui.characterSummary, "UIPanelButtonTemplate")
    button:SetPoint('TOPLEFT', b.offsetX, -20)
    button:SetSize(b.width, 28)
    button:SetText(b.Text)
    button.sort = b.sort
    button:RegisterForClicks("anyDown")
    button:SetScript("OnClick", function(self, button)
        table.sort(alt.charactersSummary, function(a,b)
            if button == "LeftButton" then
                if self.sort == "Prof" then
                    if a.Prof1 == b.Prof1 then
                        return a.Prof2 < b.Prof2
                    else
                        return a.Prof1 < b.Prof1
                    end
                else
                    return a[self.sort] < b[self.sort]
                end
            else
                if self.sort == "Prof" then
                    if a.Prof1 == b.Prof1 then
                        return a.Prof2 > b.Prof2
                    else
                        return a.Prof1 > b.Prof1
                    end
                else
                    return a[self.sort] > b[self.sort]
                end
            end
        end)
        alt:CharacterSummaryListview_Refresh()
    end)
end

alt.ui.characterSummary.scrollBar = CreateFrame('SLIDER', 'AltasiaCharacterSummaryListviewScrollBar', alt.ui.characterSummary.listview, "Altasia_UIPanelScrollBarTemplate")
alt.ui.characterSummary.scrollBar:SetPoint('TOPLEFT', alt.ui.characterSummary.listview, 'TOPRIGHT', -10, -16)
alt.ui.characterSummary.scrollBar:SetPoint('BOTTOMRIGHT', alt.ui.characterSummary.listview, 'BOTTOMRIGHT', 6, 16)
alt.ui.characterSummary.scrollBar:EnableMouse(true)
alt.ui.characterSummary.scrollBar:SetValueStep(1)
alt.ui.characterSummary.scrollBar:SetValue(1)
alt.ui.characterSummary.scrollBar:SetMinMaxValues(1, 1)

-- alt.ui.characterSummary.nameBanner = alt.ui.characterSummary:CreateTexture(nil, 'ARTWORK')
-- alt.ui.characterSummary.nameBanner:SetPoint('TOP', 0, -10)
-- alt.ui.characterSummary.nameBanner:SetSize(500, 70)
-- alt.ui.characterSummary.nameBanner:SetAtlas("UI-Frame-Neutral-Ribbon", false)






























-- container summary frame
alt.ui.containerSummary = CreateFrame("FRAME", "AltasiaContainerSummary", alt.ui.frame)
alt.ui.containerSummary:SetPoint('TOPLEFT', 264, -30)
alt.ui.containerSummary:SetSize(CONTENT_FRAME_WIDTH, CONTENT_FRAME_HEIGHT)
alt.ui.containerSummary:SetScript("OnShow", function()
    alt:ParseContainers()
    alt:ContainerSummaryListview_ClearRows()
    alt:ContainerSummaryListview_RefreshRows()
end)
alt.ui.containerSummary.filtered = false

alt.ui.containerSummary.background = alt.ui.containerSummary:CreateTexture(nil, 'ARTWORK')
alt.ui.containerSummary.background:SetAllPoints(alt.ui.containerSummary)
alt.ui.containerSummary.background:SetAtlas("UI-Frame-Neutral-CardParchmentWider", false)

alt.ui.containerSummary.searchInput = CreateFrame('EDITBOX', 'AltasiaContainerSummarySearchInput', alt.ui.containerSummary, "InputBoxTemplate")
alt.ui.containerSummary.searchInput:SetPoint('TOPLEFT', 26, -12)
alt.ui.containerSummary.searchInput:SetSize(200, 22)
alt.ui.containerSummary.searchInput:ClearFocus()
alt.ui.containerSummary.searchInput:SetAutoFocus(false)
alt.ui.containerSummary.searchInput:SetMaxLetters(15)
alt.ui.containerSummary.searchInput.header = alt.ui.containerSummary.searchInput:CreateFontString('$parentHeader', 'OVERLAY', 'GameFontNormalSmall')
alt.ui.containerSummary.searchInput.header:SetPoint('LEFT', alt.ui.containerSummary.searchInput, 'LEFT', 2, 0)
alt.ui.containerSummary.searchInput.header:SetText('Search')
alt.ui.containerSummary.searchInput.header:SetTextColor(0.5,0.5,0.5,0.7)

local filteredResults = {}
alt.ui.containerSummary.searchInput:SetScript("OnTextChanged", function(self)
    if self:GetText():len() < 1 then
        self.header:Show()
    else
        self.header:Hide()

        -- local itemID, itemType, itemSubType, itemEquipLoc, icon, itemClassID, itemSubClassID = GetItemInfoInstant(self:GetText())
        -- print(itemID)
        if self:GetText():len() > 2 then
            wipe(filteredResults)
            for k, item in ipairs(alt.containersSummary) do
                if item.ItemLink:lower():find(self:GetText():lower(), 1, true) then
                    table.insert(filteredResults, item)
                end
            end
            --print(#filteredResults)
            alt:ContainerSummaryListview_ClearRows()
            alt:ContainerSummaryListview_RefreshRows(true)
            alt.ui.containerSummary.filtered = true
        else
            alt:ContainerSummaryListview_ClearRows()
            alt:ContainerSummaryListview_RefreshRows()
            alt.ui.containerSummary.filtered = false
        end
    end
end)

-- alt.ui.containerSummary.searchDropdown = CreateFrame("Frame", )
-- alt.ui.containerSummary.searchDropdown.background = 
-- alt.ui.containerSummary.searchDropdown.background:SetAtlas("UI-Frame-Neutral-PortraitWiderDisable")


alt.ui.containerSummary.listview = CreateFrame("FRAME", "AltasiaContainerSummaryListview", alt.ui.containerSummary)
alt.ui.containerSummary.listview:SetPoint("TOPLEFT", 10, -70)
alt.ui.containerSummary.listview:SetSize(700, 480)
alt.ui.containerSummary.listview.rows = {}
for i = 1, 20 do
    alt.ui.containerSummary.listview.rows[i] = CreateFrame("FRAME", "AltasiaContainerSummaryListview"..i, alt.ui.containerSummary.listview, "AltasiaListviewItem_ContainerSummary")
    alt.ui.containerSummary.listview.rows[i]:SetPoint("TOPLEFT", 5, (i-1) * -24)
    alt.ui.containerSummary.listview.rows[i]:Hide()
end

function alt:ContainerSummaryListview_ClearRows()
    for i = 1, 20 do
        self.ui.containerSummary.listview.rows[i]:Hide()
    end
    --alt.ui.containerSummary.scrollBar:SetValue(1)
end


-- if filter is passed as true then this uses whatever is in the filteredResult table
function alt:ContainerSummaryListview_RefreshRows(filtered)
    local scrollPos = math.floor(self.ui.containerSummary.scrollBar:GetValue())
    if scrollPos == 0 then
        scrollPos = 1
    end
    local item = nil;
    for i = 1, 20 do
        if filtered then
            if filteredResults[(i - 1) + scrollPos] then
                item = filteredResults[(i - 1) + scrollPos]
                self.ui.containerSummary.listview.rows[i]:SetItemIcon(item.ItemIcon)
                self.ui.containerSummary.listview.rows[i]:SetItemID(item.ItemID)
                self.ui.containerSummary.listview.rows[i]:SetItemLink(item.ItemLink)
                self.ui.containerSummary.listview.rows[i]:SetCharacter(item.Character)
                self.ui.containerSummary.listview.rows[i]:SetCount(item.Count)
                self.ui.containerSummary.listview.rows[i]:Show()
            end
            if #filteredResults < 21 then
                alt.ui.containerSummary.scrollBar:SetMinMaxValues(1, 1)
            else
                alt.ui.containerSummary.scrollBar:SetMinMaxValues(1, #filteredResults - 19)
            end
        else
            if alt.containersSummary[(i - 1) + scrollPos] then
                item = alt.containersSummary[(i - 1) + scrollPos]
                self.ui.containerSummary.listview.rows[i]:SetItemIcon(item.ItemIcon)
                self.ui.containerSummary.listview.rows[i]:SetItemID(item.ItemID)
                self.ui.containerSummary.listview.rows[i]:SetItemLink(item.ItemLink)
                self.ui.containerSummary.listview.rows[i]:SetCharacter(item.Character)
                self.ui.containerSummary.listview.rows[i]:SetCount(item.Count)
                self.ui.containerSummary.listview.rows[i]:Show()
            end
            if #self.containersSummary < 21 then
                alt.ui.containerSummary.scrollBar:SetMinMaxValues(1, 1)
            else
                alt.ui.containerSummary.scrollBar:SetMinMaxValues(1, #self.containersSummary - 19)
            end
        end
    end
end


alt.ui.containerSummary.scrollBar = CreateFrame('SLIDER', 'AltasiaContainerSummaryListviewScrollBar', alt.ui.containerSummary.listview, "Altasia_UIPanelScrollBarTemplate")
alt.ui.containerSummary.scrollBar:SetPoint('TOPLEFT', alt.ui.containerSummary.listview, 'TOPRIGHT', -10, -16)
alt.ui.containerSummary.scrollBar:SetPoint('BOTTOMRIGHT', alt.ui.containerSummary.listview, 'BOTTOMRIGHT', 6, 16)
alt.ui.containerSummary.scrollBar:EnableMouse(true)
alt.ui.containerSummary.scrollBar:SetValueStep(1)
alt.ui.containerSummary.scrollBar:SetValue(1)
alt.ui.containerSummary.scrollBar:SetMinMaxValues(1, 1)
alt.ui.containerSummary.scrollBar:SetScript("OnValueChanged", function(self)
    alt:ContainerSummaryListview_ClearRows()
    if alt.ui.containerSummary.filtered == true then
        if #filteredResults < 21 then
            alt.ui.containerSummary.scrollBar:SetMinMaxValues(1, 1)
        else
            alt.ui.containerSummary.scrollBar:SetMinMaxValues(1, #filteredResults - 19)
        end
        alt:ContainerSummaryListview_RefreshRows(true)
    else
        alt:ContainerSummaryListview_RefreshRows()
    end
end)

local containerSummaryHeaderButtons = {
    { Text = 'Item link', offsetX = 18, width = 385, sort = "ItemLink" },
    { Text = 'Item ID', offsetX = 402, width = 80, sort = "ItemID" },
    { Text = 'Character', offsetX = 480, width = 135, sort = "Character" },
    { Text = 'Count', offsetX = 614, width = 80, sort = "Count" },
    -- { Text = 'Prof', offsetX = 372, width = 50, sort = "Prof" },
    -- { Text = 'Location', offsetX = 421, width = 170, sort = "Location" },
    -- { Text = 'Money', offsetX = 590, width = 106, sort = "Money" },
}

for k, b in ipairs(containerSummaryHeaderButtons) do
    local button = CreateFrame("BUTTON", "AltasiaContainerSummaryListviewHeader"..b.Text, alt.ui.containerSummary, "UIPanelButtonTemplate")
    button:SetPoint('TOPLEFT', b.offsetX, -40)
    button:SetSize(b.width, 28)
    button:SetText(b.Text)
    button.sort = b.sort
    button:RegisterForClicks("anyDown")
    button:SetScript("OnClick", function(self, button)
        table.sort(alt.containersSummary, function(a,b)
            if button == "LeftButton" then
                if a[self.sort] == b[self.sort] then
                    return a.Character < b.Character
                else
                    return a[self.sort] < b[self.sort]
                end
            else
                if a[self.sort] == b[self.sort] then
                    return a.Character > b.Character
                else
                    return a[self.sort] > b[self.sort]
                end
            end
        end)
        alt:ContainerSummaryListview_RefreshRows()
    end)
end
























-- character detail frame
alt.ui.characterDetail = CreateFrame("FRAME", "AltasiaCharacterDetail", alt.ui.frame)
alt.ui.characterDetail:SetPoint('TOPLEFT', 264, -30)
alt.ui.characterDetail:SetSize(CONTENT_FRAME_WIDTH, CONTENT_FRAME_HEIGHT)
alt.ui.characterDetail.background = alt.ui.characterDetail:CreateTexture(nil, 'ARTWORK')
alt.ui.characterDetail.background:SetAllPoints(alt.ui.characterDetail)
alt.ui.characterDetail.background:SetAtlas("UI-Frame-Neutral-CardParchmentWider", false)

alt.ui.characterDetail.name = alt.ui.characterDetail:CreateFontString(nil, 'OVERLAY', "GameFontNormalLarge")
alt.ui.characterDetail.name:SetPoint('TOP', 0, -10)
alt.ui.characterDetail.name:SetJustifyH("CENTER")
alt.ui.characterDetail.name:SetJustifyV("CENTER")
alt.ui.characterDetail.name:SetSize(500, 70)

local characterDetailFontStrings = {
    { dataStoreKey = "played", fontStringLabel = "Time played", fontStringKey = "" },
    { dataStoreKey = "playedThisLevel", fontStringLabel = "Time played this level", fontStringKey = "" },
    { dataStoreKey = "bindLocation", fontStringLabel = "Hearthstone location", fontStringKey = "" },
    { dataStoreKey = "guildName", fontStringLabel = "Guild", fontStringKey = "" },
    { dataStoreKey = "guildRankName", fontStringLabel = "Guild rank name", fontStringKey = "" },
    { dataStoreKey = "zone", fontStringLabel = "Zone", fontStringKey = "" },
    { dataStoreKey = "subZone", fontStringLabel = "Sub zone", fontStringKey = "" },
    { dataStoreKey = "money", fontStringLabel = "Money", fontStringKey = "" },
    { dataStoreKey = "lastLogoutTimestamp", fontStringLabel = "Last logout", fontStringKey = "" },
}

for k, fs in ipairs(characterDetailFontStrings) do
    alt.ui.characterDetail[fs.dataStoreKey..'Label'] = alt.ui.characterDetail:CreateFontString("$parent"..fs.dataStoreKey, 'OVERLAY', 'GameFontNormal')
    alt.ui.characterDetail[fs.dataStoreKey..'Label']:SetPoint('TOPLEFT', 50, (k * -24) - 100)
    alt.ui.characterDetail[fs.dataStoreKey..'Label']:SetText(fs.fontStringLabel)
    alt.ui.characterDetail[fs.dataStoreKey..'Label']:SetTextColor(1,1,1,1)

    alt.ui.characterDetail[fs.dataStoreKey] = alt.ui.characterDetail:CreateFontString("$parent"..fs.dataStoreKey, 'OVERLAY', 'GameFontNormal')
    alt.ui.characterDetail[fs.dataStoreKey]:SetPoint('TOPLEFT', 250, (k * -24) - 100)
    alt.ui.characterDetail[fs.dataStoreKey]:SetTextColor(1,1,1,1)
end











































-- quest frame
alt.ui.questSummary = CreateFrame("FRAME", "AltasiaQuestSummary", alt.ui.frame)
alt.ui.questSummary:SetPoint('TOPLEFT', 264, -30)
alt.ui.questSummary:SetSize(CONTENT_FRAME_WIDTH, CONTENT_FRAME_HEIGHT)
alt.ui.questSummary:SetScript("OnShow", function()
    alt:ParseQuests()
    alt:HideQuestSummaryZoneButtons()
    alt:RefreshQuestSummaryZoneListview()
end)
alt.ui.questSummary.background = alt.ui.questSummary:CreateTexture(nil, 'ARTWORK')
alt.ui.questSummary.background:SetAllPoints(alt.ui.questSummary)
alt.ui.questSummary.background:SetAtlas("UI-Frame-Neutral-CardParchmentWider", false)

alt.ui.questSummary.zoneListview = CreateFrame("ScrollFrame", "AltasiaQuestSummaryZoneScrollFrame", alt.ui.questSummary, "UIPanelScrollFrameTemplate")
alt.ui.questSummary.zoneListview:SetPoint("TOPLEFT", alt.ui.questSummary, 'TOPLEFT', 10, -10)
alt.ui.questSummary.zoneListview:SetPoint("BOTTOMRIGHT", alt.ui.questSummary, 'BOTTOMLEFT', 190, 20)
alt.ui.questSummary.zoneListview:SetScript("OnMouseWheel", function(self, delta)
    local newValue = self:GetVerticalScroll() - (delta * 20)
    if (newValue < 0) then
        newValue = 0;
    elseif (newValue > self:GetVerticalScrollRange()) then
        newValue = self:GetVerticalScrollRange()
    end
    self:SetVerticalScroll(newValue)
end)
local questSummaryZoneScrollChild = CreateFrame("Frame", "AltasiaQuestSummaryZoneScrollFrameChild", alt.ui.questSummary.zoneListview)
questSummaryZoneScrollChild:SetPoint("TOP", 0, 0)
questSummaryZoneScrollChild:SetSize(180, 340)
alt.ui.questSummary.zoneListview:SetScrollChild(questSummaryZoneScrollChild)

alt.ui.questSummary.zoneButtons = {}
function alt:RefreshQuestSummaryZoneListview()
    if self.questsSummary and next(self.questsSummary) then
        for i = 1, #self.questsSummaryKeys do
            if not alt.ui.questSummary.zoneButtons[i] then
                alt.ui.questSummary.zoneButtons[i] = CreateFrame("FRAME", "AltasiaQuestSummaryZoneListviewButton"..i, questSummaryZoneScrollChild, "AltasiaListviewItem_QuestSummary_Zone")
            end
            alt.ui.questSummary.zoneButtons[i]:SetPoint('TOP', 6, (i * -40) + 40)
            alt.ui.questSummary.zoneButtons[i]:SetZoneText(self.questsSummaryKeys[i])
            alt.ui.questSummary.zoneButtons[i].quests = self.questsSummary[self.questsSummaryKeys[i]]
            alt.ui.questSummary.zoneButtons[i]:Show()
        end
        questSummaryZoneScrollChild:SetHeight((#self.questsSummaryKeys - 1) * 40)
    end
end

function alt:QuestSummaryZoneButtons_PurgeSelectedStates()
    if self.ui.questSummary.zoneButtons and next(self.ui.questSummary.zoneButtons) then
        for k, button in ipairs(self.ui.questSummary.zoneButtons) do
            button.selected = false;
            button.Selected:Hide()
        end
    end
end

function alt:HideQuestSummaryZoneButtons()
    if self.ui.questSummary.zoneButtons and next(self.ui.questSummary.zoneButtons) then
        for k, button in ipairs(self.ui.questSummary.zoneButtons) do
            button:Hide()
        end
    end
end


alt.ui.questSummary.questListview = CreateFrame("ScrollFrame", "AltasiaQuestSummaryQuestScrollFrame", alt.ui.questSummary, "UIPanelScrollFrameTemplate")
alt.ui.questSummary.questListview:SetPoint("TOPLEFT", alt.ui.questSummary.zoneListview, 'TOPRIGHT', 24, 0)
alt.ui.questSummary.questListview:SetPoint("BOTTOMRIGHT", alt.ui.questSummary.zoneListview, 'BOTTOMRIGHT', 224, 0)
alt.ui.questSummary.questListview:SetScript("OnMouseWheel", function(self, delta)
    local newValue = self:GetVerticalScroll() - (delta * 20)
    if (newValue < 0) then
        newValue = 0;
    elseif (newValue > self:GetVerticalScrollRange()) then
        newValue = self:GetVerticalScrollRange()
    end
    self:SetVerticalScroll(newValue)
end)
local questSummaryQuestScrollChil = CreateFrame("Frame", "AltasiaQuestSummaryZoneScrollFrameChild", alt.ui.questSummary.questListview)
questSummaryQuestScrollChil:SetPoint("TOP", 0, 0)
questSummaryQuestScrollChil:SetSize(200, 340)
alt.ui.questSummary.questListview:SetScrollChild(questSummaryQuestScrollChil)


alt.ui.questSummary.questButtons = {}
function alt:RefreshQuestSummaryListview(zone)
    if zone and next(zone) then
        local i = 1;
        for quest, characters in pairs(zone) do
            if not alt.ui.questSummary.questButtons[i] then
                alt.ui.questSummary.questButtons[i] = CreateFrame("FRAME", "AltasiaQuestSummaryQuestListviewButton"..i, alt.ui.questSummary.questListview:GetScrollChild(), "AltasiaListviewItem_QuestSummary_Quest")
                --print('made button', i, quest)
            end
            alt.ui.questSummary.questButtons[i]:SetPoint('TOP', 16, (i * -40) + 40)
            alt.ui.questSummary.questButtons[i].quests = quests
            alt.ui.questSummary.questButtons[i]:Show()
            i = i + 1;
        end
        alt.ui.questSummary.questListview:GetScrollChild():SetHeight((i - 1) * 40)
    end
end

function alt:QuestSummaryQuestButtons_PurgeSelectedStates()
    if self.ui.questSummary.questButtons and next(self.ui.questSummary.questButtons) then
        for k, button in ipairs(self.ui.questSummary.questButtons) do
            button.selected = false;
            button.Selected:Hide()
        end
    end
end

function alt:HideQuestSummaryQuestButtons()
    if self.ui.questSummary.questButtons and next(self.ui.questSummary.questButtons) then
        for k, button in ipairs(self.ui.questSummary.questButtons) do
            button:Hide()
        end
    end
end


alt.ui.questSummary.questDetailFrame = CreateFrame("FRAME", "AltasiaQuestSummaryQuestDetailFrame", alt.ui.questSummary)
alt.ui.questSummary.questDetailFrame:SetPoint("TOPLEFT", alt.ui.questSummary.questListview, "TOPRIGHT", 24, 0)
alt.ui.questSummary.questDetailFrame:SetPoint("BOTTOMRIGHT", alt.ui.questSummary, "BOTTOMRIGHT", -20, 20)
alt.ui.questSummary.questDetailFrame.background = alt.ui.questSummary.questDetailFrame:CreateTexture(nil, "BACKGROUND")
alt.ui.questSummary.questDetailFrame.background:SetAllPoints(alt.ui.questSummary.questDetailFrame)
alt.ui.questSummary.questDetailFrame.background:SetAtlas("questdetailsbackgrounds")

alt.ui.questSummary.questDetailFrame.header = alt.ui.questSummary.questDetailFrame:CreateTexture(nil, 'BACKGROUND')
alt.ui.questSummary.questDetailFrame.header:SetPoint('TOPLEFT', 0, 0)
alt.ui.questSummary.questDetailFrame.header:SetPoint('TOPRIGHT', 0, 0)
alt.ui.questSummary.questDetailFrame.header:SetHeight(50)
alt.ui.questSummary.questDetailFrame.header:SetAtlas("questdetails-topoverlay")

alt.ui.questSummary.questDetailFrame.questTitle = alt.ui.questSummary.questDetailFrame:CreateFontString(nil, "OVERLAY", 'GameFontNormal')
alt.ui.questSummary.questDetailFrame.questTitle:SetPoint('CENTER', alt.ui.questSummary.questDetailFrame, 'TOP', 0, -25)
alt.ui.questSummary.questDetailFrame.questTitle:SetSize(200, 50)
alt.ui.questSummary.questDetailFrame.questTitle:SetTextColor(1,1,1,1)


alt.ui.questSummary.questDetailFrame.ScrollFrame = CreateFrame("ScrollFrame", "AltasiaQuestSummaryQuestDetailScrollFrame", alt.ui.questSummary.questDetailFrame, "UIPanelScrollFrameTemplate")
alt.ui.questSummary.questDetailFrame.ScrollFrame:SetPoint("TOPLEFT", 0, -50)
alt.ui.questSummary.questDetailFrame.ScrollFrame:SetPoint("BOTTOMRIGHT", -24, 290)
alt.ui.questSummary.questDetailFrame.ScrollFrame:SetScript("OnMouseWheel", function(self, delta)
    local newValue = self:GetVerticalScroll() - (delta * 20)
    if (newValue < 0) then
        newValue = 0;
    elseif (newValue > self:GetVerticalScrollRange()) then
        newValue = self:GetVerticalScrollRange()
    end
    self:SetVerticalScroll(newValue)
end)
local questSummaryQuestDetailScrollChild = CreateFrame("Frame", "AltasiaQuestSummaryZoneScrollFrameChild", alt.ui.questSummary.questDetailFrame)
questSummaryQuestDetailScrollChild:SetPoint("TOP", 0, 0)
questSummaryQuestDetailScrollChild:SetSize(200, 360)
alt.ui.questSummary.questDetailFrame.ScrollFrame:SetScrollChild(questSummaryQuestDetailScrollChild)



local questObjectives = questSummaryQuestDetailScrollChild:CreateFontString(nil, "OVERLAY", "QuestFont_Shadow_Huge")
questObjectives:SetPoint("TOPLEFT", 6, 0)
questObjectives:SetSize(240, 20)
questObjectives:SetTextColor(0.121, 0.054, 0.007)
questObjectives:SetJustifyH("LEFT")
questObjectives:SetJustifyV("TOP")
questObjectives:SetText(L['Objectives'])

alt.ui.questSummary.questDetailFrame.questObjectives = questSummaryQuestDetailScrollChild:CreateFontString(nil, "OVERLAY", 'GameFontNormal_NoShadow')
alt.ui.questSummary.questDetailFrame.questObjectives:SetPoint("TOPLEFT", 6, -20)
alt.ui.questSummary.questDetailFrame.questObjectives:SetSize(240, 80)
alt.ui.questSummary.questDetailFrame.questObjectives:SetTextColor(0.121, 0.054, 0.007)
alt.ui.questSummary.questDetailFrame.questObjectives:SetJustifyH("LEFT")
alt.ui.questSummary.questDetailFrame.questObjectives:SetJustifyV("TOP")

local questDescription = questSummaryQuestDetailScrollChild:CreateFontString(nil, "OVERLAY", "QuestFont_Shadow_Huge")
questDescription:SetPoint("TOPLEFT", 6, -90)
questDescription:SetSize(240, 20)
questDescription:SetTextColor(0.121, 0.054, 0.007)
questDescription:SetJustifyH("LEFT")
questDescription:SetJustifyV("TOP")
questDescription:SetText(L['Description'])

alt.ui.questSummary.questDetailFrame.questDescription = questSummaryQuestDetailScrollChild:CreateFontString(nil, "OVERLAY", 'GameFontNormal_NoShadow')
alt.ui.questSummary.questDetailFrame.questDescription:SetPoint("TOPLEFT", 6, -110)
alt.ui.questSummary.questDetailFrame.questDescription:SetSize(240, 220)
alt.ui.questSummary.questDetailFrame.questDescription:SetTextColor(0.121, 0.054, 0.007)
alt.ui.questSummary.questDetailFrame.questDescription:SetJustifyH("LEFT")
alt.ui.questSummary.questDetailFrame.questDescription:SetJustifyV("TOP")

local charactersOnQuest = alt.ui.questSummary.questDetailFrame:CreateFontString(nil, "OVERLAY", "QuestFont_Shadow_Huge")
charactersOnQuest:SetPoint("TOPLEFT", 6, -250)
charactersOnQuest:SetSize(260, 20)
charactersOnQuest:SetTextColor(0.121, 0.054, 0.007)
charactersOnQuest:SetJustifyH("LEFT")
charactersOnQuest:SetJustifyV("TOP")
charactersOnQuest:SetText(L['CharactersOnQuest'])

alt.ui.questSummary.questDetailFrame.questCharacters = alt.ui.questSummary.questDetailFrame:CreateFontString(nil, "OVERLAY", 'GameFontNormal_NoShadow')
alt.ui.questSummary.questDetailFrame.questCharacters:SetPoint("TOPLEFT", 6, -280)
alt.ui.questSummary.questDetailFrame.questCharacters:SetSize(260, 160)
alt.ui.questSummary.questDetailFrame.questCharacters:SetTextColor(0.121, 0.054, 0.007)
alt.ui.questSummary.questDetailFrame.questCharacters:SetJustifyH("LEFT")
alt.ui.questSummary.questDetailFrame.questCharacters:SetJustifyV("TOP")


alt.ui.questSummary.questDetailFrame.rewardsFrame = CreateFrame("FRAME", "AltasiaQuestSummaryQuestDetailRewardFrame", alt.ui.questSummary.questDetailFrame) --, "RewardsFrameTemplate")
alt.ui.questSummary.questDetailFrame.rewardsFrame:SetPoint("BOTTOMLEFT", 0, 0)
alt.ui.questSummary.questDetailFrame.rewardsFrame:SetPoint("BOTTOMRIGHT", 0, 0)
alt.ui.questSummary.questDetailFrame.rewardsFrame:SetHeight(160)

alt.ui.questSummary.questDetailFrame.rewardsFrame.background = alt.ui.questSummary.questDetailFrame.rewardsFrame:CreateTexture(nil, "BACKGROUND")
alt.ui.questSummary.questDetailFrame.rewardsFrame.background:SetAllPoints(alt.ui.questSummary.questDetailFrame.rewardsFrame)
alt.ui.questSummary.questDetailFrame.rewardsFrame.background:SetAtlas("AdventureMapQuest-RewardsPanel")

alt.ui.questSummary.questDetailFrame.rewardsFrame.backgroundTop = alt.ui.questSummary.questDetailFrame:CreateTexture(nil, "ARTWORK")
alt.ui.questSummary.questDetailFrame.rewardsFrame.backgroundTop:SetPoint("TOPLEFT", 0, 5)
alt.ui.questSummary.questDetailFrame.rewardsFrame.backgroundTop:SetPoint("TOPRIGHT", 0, 5)
alt.ui.questSummary.questDetailFrame.rewardsFrame.backgroundTop:SetHeight(25)
alt.ui.questSummary.questDetailFrame.rewardsFrame.backgroundTop:SetAtlas("questlog_topdetail")

alt.ui.questSummary.questDetailFrame.rewardsFrame.backgroundMiddle = alt.ui.questSummary.questDetailFrame:CreateTexture(nil, "ARTWORK")
alt.ui.questSummary.questDetailFrame.rewardsFrame.backgroundMiddle:SetPoint("LEFT", 0, 22)
alt.ui.questSummary.questDetailFrame.rewardsFrame.backgroundMiddle:SetPoint("RIGHT", 0, 22)
alt.ui.questSummary.questDetailFrame.rewardsFrame.backgroundMiddle:SetHeight(25)
alt.ui.questSummary.questDetailFrame.rewardsFrame.backgroundMiddle:SetAtlas("questlog_divider_normalquests")

alt.ui.questSummary.questDetailFrame.rewardsFrame.backgroundBottom = alt.ui.questSummary.questDetailFrame.rewardsFrame:CreateTexture(nil, "ARTWORK")
alt.ui.questSummary.questDetailFrame.rewardsFrame.backgroundBottom:SetPoint("BOTTOMLEFT", 0, 0)
alt.ui.questSummary.questDetailFrame.rewardsFrame.backgroundBottom:SetPoint("BOTTOMRIGHT", 0, 0)
alt.ui.questSummary.questDetailFrame.rewardsFrame.backgroundBottom:SetHeight(25)
alt.ui.questSummary.questDetailFrame.rewardsFrame.backgroundBottom:SetAtlas("questlog_bottomdetail")

















-- local but = CreateFrame("BUTTON", "abcdefg", alt.ui.questSummary, "UIPanelButtonTemplate")
-- but:SetPoint('TOP')
-- but:SetSize(100, 20)
-- but:SetScript('OnClick', function()
--     alt:ParseQuests()
-- end)

alt.ui.questSummary:SetScript("OnHyperlinkClick", function(self)
    --print('test')
    --SetItemRef("|Hquest:9625:4|h[Elekks Are Serious Business]|h|r", "fucking link", but, nil)
    --ItemRefTooltip:SetOwner(UIParent, "ANCHOR_PRESERVE");
    --ItemRefTooltip:ItemRefSetHyperlink("|Hquest:9625:4|h[Elekks Are Serious Business]|h|r");
    ItemRefTooltip:SetOwner(UIParent, "ANCHOR_PRESERVE");
    ItemRefTooltip:ItemRefSetHyperlink("|Hquest:26689:13|h[The Rotting Orchard]|h|r");
    ItemRefTooltip:Hide()
    ItemRefTooltip:SetOwner(UIParent, "ANCHOR_PRESERVE");
    ItemRefTooltip:ItemRefSetHyperlink("|Hquest:26685:13|h[Classy Glass]|h|r");
    ItemRefTooltip:Hide()
    --QuestMapFrame_OpenToQuestDetails(26689)
    -- ChatEdit_TryInsertQuestLinkForQuestID(9625)
    -- QuestMapFrame_ShowQuestDetails(9625)
    --Alt_QuestLogPopupDetailFrame_Show()


end)

ItemRefTooltip:HookScript("OnShow", function(self)
    if self:IsVisible() then
        for i = 1, select("#", self:GetRegions()) do
            local region = select(i, self:GetRegions())
            if region and region:GetObjectType() == "FontString" then
                local text = region:GetText() -- string or nil
                if text ~= nil and text:len() > 1 then
                    --print(text)
                end
            end
        end
    end
end)

function alt:HideAllUIContentFrames()
    self.ui.characterDetail:Hide()
    self.ui.characterSummary:Hide()
    self.ui.questSummary:Hide()
    self.ui.containerSummary:Hide()
end

function Alt_QuestLogPopupDetailFrame_Show()
	local questID = 26689;
	if ( QuestLogPopupDetailFrame.questID == questID and QuestLogPopupDetailFrame:IsShown() ) then
		HideUIPanel(QuestLogPopupDetailFrame);
		return;
	end

	QuestLogPopupDetailFrame.questID = questID;
	-- C_QuestLog.SetSelectedQuest(questID);
	-- StaticPopup_Hide("ABANDON_QUEST");
	-- StaticPopup_Hide("ABANDON_QUEST_WITH_ITEMS");
	-- C_QuestLog.SetAbandonQuest();

	QuestMapFrame_UpdateQuestDetailsButtons();

	QuestLogPopupDetailFrame_Update(true);
	ShowUIPanel(QuestLogPopupDetailFrame);
	PlaySound(SOUNDKIT.IG_QUEST_LOG_OPEN);

	-- portrait
	local questPortrait, questPortraitText, questPortraitName, questPortraitMount = GetQuestLogPortraitGiver();
	if (questPortrait and questPortrait ~= 0 and QuestLogShouldShowPortrait()) then
		QuestFrame_ShowQuestPortrait(QuestLogPopupDetailFrame, questPortrait, questPortraitMount, questPortraitText, questPortraitName, -3, -42);
	else
		QuestFrame_HideQuestPortrait();
	end
end