---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.
  
  File [Rank] created at [13/06/2021 18:10]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

---@class Rank
---@field public id string
---@field public label string
---@field public color string
---@field public permissions table
Rank = {}
Rank.__index = Rank

setmetatable(Rank, {
    __call = function(_, id, label, color, permissions)
        local self = setmetatable({}, Rank);
        self.id = id
        self.label = label
        self.color = color
        self.permissions = permissions
        NarcosServer_RanksManager.list[self.id] = self
        return self;
    end
})

---@public
---@return number
function Rank:getId()
    return self.id
end

---@public
---@return string
function Rank:getLabel()
    return self.label
end

---@public
---@return string
function Rank:getColor()
    return self.color
end

---@public
---@return table
function Rank:getPermissions()
    return self.permissions
end

---@public
---@return boolean
function Rank:havePermission(permission)
    for k, v in pairs(self.permissions) do
        if v == permission then
            return true
        end
    end
    return false
end

---@public
---@return boolean
function Rank:havePermissions(permissions)
    print(json.encode(self:getPermissions()))
    local matches = 0
    for _, permission in pairs(permissions) do
        for _, rankPermission in pairs(self.permissions) do
            if rankPermission == permission then
                matches = (matches + 1)
            end
        end
    end
    print("Matches = "..matches)
    return (matches == #permissions)
end

function Rank:updatePermissions()
    NarcosServer_MySQL.query("SELECT * FROM ranks WHERE id = @a",{
        ['a'] = self.id
    }, function(result)
        if not result[1] then return end
        self.permissions = json.decode(result[1].permissions)
        NarcosServer.trace(("Permissions du rang ^3%s^7 mises à jour"):format(self.label), Narcos.prefixes.succes)
    end)
end
