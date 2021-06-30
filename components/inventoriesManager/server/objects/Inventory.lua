---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.
  
  File [Inventory] created at [16/06/2021 12:10]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

---@class Inventory
---@field public identifier string
---@field public label string
---@field public capacity number
---@field public type number
---@field public content table
---@field public weight number
---@field public diffItems number
Inventory = {}
Inventory.__index = Inventory

setmetatable(Inventory, {
    __call = function(_, identifier, label, capacity, type, content)
        local self = setmetatable({}, Inventory);
        self.identifier = identifier
        self.label = label
        self.capacity = (capacity*1.00)
        self.type = type
        self.content = content
        self.weight = self:calcWeight(self.content)
        self.diffItems = self:getTypesCount()
        NarcosServer_InventoriesManager.list[self.identifier] = self
        return self;
    end
})

---getTypesCount
---@public
---@return number
function Inventory:getTypesCount()
    local c = 0
    for k, v in pairs(self.content) do
        c = c + 1
    end
    return c
end

---getContent
---@public
---@return table
function Inventory:getContent()
    return self.content
end

---calcWeight
---@public
---@return number
function Inventory:calcWeight(incomingContent)
    if incomingContent == nil then
        print("Incoming content is nil")
        incomingContent = self.content
    end
    local total = 0
    for k,v in pairs(incomingContent) do
        local weight = NarcosServer_ItemsManager.getItemWeight(k)
        total = (total + (weight*v))
    end
    return (total*1.00)
end

---saveInventory
---@public
---@return void
function Inventory:saveInventory()
    NarcosServer_MySQL.execute("UPDATE inventories SET content = @a WHERE identifier = @b", {
        ['a'] = json.encode(self.content),
        ['b'] = self.identifier
    })
end

---clear
---@public
---@return void
function Inventory:clear(cb)
    self.content = {}
    if cb ~= nil then
        cb()
    end
end

---canAddItem
---@public
---@return function
function Inventory:canAddItem(item, qty)
    if qty == nil then
        qty = 1
    end
    qty = math.abs(qty)
    if not NarcosServer_ItemsManager.exists(item) then
        return
    end

    local fake = {}
    for k, v in pairs(self.content) do
        fake[k] = v
    end

    if not fake[item] then
        fake[item] = 0
    end
    fake[item] = (fake[item] + qty)

    return (self:calcWeight(fake) <= self.capacity)
end

---addItem
---@public
---@return function
function Inventory:addItem(item, cb, qty)
    if qty == nil then
        qty = 1
    end
    qty = math.abs(qty)
    if not NarcosServer_ItemsManager.exists(item) then
        return
    end
    local fakeContent = self:getContent()
    if not fakeContent[item] then
        fakeContent[item] = 0
    end
    fakeContent[item] = (fakeContent[item] + qty)
    local fakeWeight = self:calcWeight(fakeContent)
    if fakeWeight > self.capacity then
        NarcosServer_ErrorsManager.die(NarcosEnums.Errors.INV_CAPACITY_EXCEEDED, self.identifier)
    end
    self.content = fakeContent
    self.weight = self:calcWeight(self.content)
    self.diffItems = self:getTypesCount()
    self:saveInventory()
    NarcosServer.trace(("Inventaire %s: +%s %s"):format(self.identifier, NarcosServer_ItemsManager.getItemLabel(item), qty), Narcos.prefixes.dev)
    cb(self)
end

---removeItem
---@public
---@return function
function Inventory:removeItem(item, cb, qty)
    if qty == nil then
        qty = 1
    end
    qty = math.abs(qty)
    if not NarcosServer_ItemsManager.exists(item) then
        return
    end
    local fakeContent = self:getContent()
    if not fakeContent[item] then
        NarcosServer_ErrorsManager.die(NarcosEnums.Errors.INV_NO_ITEM, ("%s - %s"):format(self.identifier, item))
    end
    fakeContent[item] = (fakeContent[item] - qty)
    if fakeContent[item] <= 0 then
        fakeContent[item] = nil
    end
    self.content = fakeContent
    self.weight = self:calcWeight(self.content)
    self.diffItems = self:getTypesCount()
    self:saveInventory()
    NarcosServer.trace(("Inventaire %s: -%s %s"):format(self.identifier, NarcosServer_ItemsManager.getItemLabel(item), qty), Narcos.prefixes.dev)
    cb(self)

end