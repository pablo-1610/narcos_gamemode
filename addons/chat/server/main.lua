---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.
  
  File [main] created at [22/06/2021 23:48]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

NarcosServer_Chat = {}
NarcosServer_Chat.commands = {}

NarcosServer_Chat.setCommand = function(command, help,isStaff)
    NarcosServer_Chat.commands[command] = {help = (help or ''), staff = isStaff or false}
    NarcosServer.trace(("Ajout d'une commande ^3%s"):format(command), Narcos.prefixes.dev)
end

Narcos.netRegisterAndHandle("chatRequestAutocompletion", function()
    local _src = source
    NarcosServer.toClient("chatCbAutocompletion", _src, NarcosServer_Chat.commands)
end)