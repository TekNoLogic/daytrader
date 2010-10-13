
-- Most of this code is grennon's from AltClickToAddItem, I just removed the dependancy on AceHooks
-- AltClickToAddItem based on GMail 1.x which was ported from CT_MailMod pre-1.5

local targ, bag, slot


local orig1 = ContainerFrameItemButton_OnModifiedClick
ContainerFrameItemButton_OnModifiedClick = function(self, button, ...)
  if button == "LeftButton" and IsAltKeyDown() and not CursorHasItem() then
    bag, slot = self:GetParent():GetID(), self:GetID()
		if TradeFrame:IsVisible() then
      for i=1,6 do
        if not GetTradePlayerItemLink(i) then
					PickupContainerItem(bag, slot)
          ClickTradeButton(i)
					bag, slot = nil, nil
					return
        end
      end
    elseif not CursorHasItem() and UnitExists("target") and UnitIsFriend("player", "target") and UnitIsPlayer("target") and CheckInteractDistance("target", 2) then
      targ = UnitName("target")
      InitiateTrade("target")
      return
    end
  end
  orig1(self, button, ...)
end


local function posthook(...)
  if targ and not CursorHasItem() and UnitName("target") == targ then
    PickupContainerItem(bag, slot)
    ClickTradeButton(1)
  end
  targ, bag, slot = nil, nil, nil

	return ...
end


local orig2 = TradeFrame:GetScript("OnShow")
TradeFrame:SetScript("OnShow", function(...)
	if orig2 then return posthook(orig2(...))
	else posthook() end
end)

