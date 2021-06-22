---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.
  
  File [main] created at [22/06/2021 22:45]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

local function safeParameters(params)
    if nil == params then
        return {[''] = ''}
    end

    assert(type(params) == "table", "A table is expected")

    if next(params) == nil then
        return {[''] = ''}
    end

    return params
end

NarcosServer_MySQL = {}

NarcosServer_MySQL.execute = function(query, params, func)
    exports[GetCurrentResourceName()]:mysql_execute(query, safeParameters(params), func)
end

NarcosServer_MySQL.query = function(query, params, func)
    exports[GetCurrentResourceName()]: mysql_fetch_all(query, safeParameters(params), func)
end

NarcosServer_MySQL.insert = function(query, params, func)
    exports[GetCurrentResourceName()]:mysql_insert(query, safeParameters(params), func)
end
