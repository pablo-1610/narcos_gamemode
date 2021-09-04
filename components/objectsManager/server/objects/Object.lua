---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.
  
  File [Object] created at [04/09/2021 03:06]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

---@class Object
---@field public id number
---@field public model string
---@field public position table
---@field public restricted boolean
---@field public allowed table
Object = {}
Object.__index = Object

setmetatable(Object, {
    __call = function(_, model, frozen, position, restricted, allowed)
        local self = setmetatable({}, Object);
        self.id = #NarcosServer_ObjectsManager.list + 1
        self.position = position
        self.model = model
        self.frozen = frozen
        self.restricted = restricted
        self.allowed = allowed or {}
        self.invincible = false
        NarcosServer_ObjectsManager.list[self.id] = self
        return self;
    end
})

---setRestriction
---@public
---@return void
function Object:setRestriction(boolean)
    self.restricted = boolean
end

---isRestricted
---@public
---@return boolean
function Object:isRestricted()
    return self.restricted
end

---clearAllowed
---@public
---@return void
function Object:clearAllowed()
    self.allowed = {}
end

---isAllowed
---@public
---@return boolean
function Object:isAllowed(source)
    return self.allowed[source] ~= nil
end

---addAllowed
---@public
---@return void
function Object:addAllowed(source)
    self.allowed[source] = true
end

---removeAllowed
---@public
---@return void
function Object:removeAllowed(source)
    self.allowed[source] = nil
end

---setInvincible
---@public
---@return void
function Object:setInvincible(boolean)
    self.invincible = boolean
end