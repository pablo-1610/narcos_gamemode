---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.
  
  File [main] created at [04/09/2021 02:29]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

local function split(s, delimiter)
    result = {};
    for match in (s .. delimiter):gmatch("(.-)" .. delimiter) do
        table.insert(result, match);
    end
    return result;
end

local postprocessed = {}
local preprocessed = {
    ["firstnames"] = "Ales, Apple, Ash, Bald, Bay, Bed, Bell, Birdling, Black, Blue, Bow, Bran, Brass, Bright, Brown, Bruns, Bulls, Camp, Cherry, Clark, Clarks, Clay, Clear, Copper, Corn, Cross, Crystal, Dark, Deep, Deer, Drac, Eagle, Earth, Elk, Elles, Elm, Ester, Ewes, Fair, Falcon, Ferry, Fire, Fleet, Fox, Gold, Grand, Green, Grey, Guild, Hammer, Hart, Hawks, Hay, Haze, Hazel, Hemlock, Ice, Iron, Kent, Kings, Knox, Layne, Lint, Lor, Mable, Maple, Marble, Mare, Marsh, Mist, Mor, Mud, Nor, Oak, Orms, Ox, Oxen, Pear, Pine, Pitts, Port, Purple, Red, Rich, Roch, Rock, Rose, Ross, Rye, Salis, Salt, Shadow, Silver, Skeg, Smith, Snow, Sows, Spring, Spruce, Staff, Star, Steel, Still, Stock, Stone, Strong, Summer, Swan, Swine, Sword, Yellow, Val, Wart, Water, Well, Wheat, White, Wild, Winter, Wolf, Wool, Wor",
    ["pre_end"] = "bank, borne, borough, brook, burg, burgh, bury, castle, cester, cliff, crest, croft, dale, dam, dorf, edge, field, ford, gate, grad, hall, ham, hollow, holm, hurst, keep, kirk, land, ley, lyn, mere, mill, minster, mont, moor, mouth, ness, pool, river, shire, shore, side, stead, stoke, ston, thorpe, ton, town, vale, ville, way, wich, wick, wood, worth",
    ["final"] = "Annex, Barrens, Barrow, Corner, Cove, Crossing, Dell, Dales, Estates, Forest, Furnace, Grove, Haven, Heath, Hill, Junction, Landing, Meadow, Park, Plain, Point, Reserve, Retreat, Ridge, Springs, View, Village, Wells, Woods"
}

for k, v in pairs(preprocessed) do
    local parts = split(v, ", ")
    postprocessed[k] = {}
    for id, datapart in pairs(parts) do
        table.insert(postprocessed[k], datapart)
    end
end

NarcosShared_Generator = {}

function NarcosShared_Generator.getRandomFullName()
    local first, prelast, sufix = postprocessed["firstnames"][math.random(1, #postprocessed["firstnames"])], postprocessed["final"][math.random(1, #postprocessed["final"])], (math.random(2) == 1 and postprocessed["pre_end"][math.random(#postprocessed["pre_end"])] or "")
    return ("%s %s%s"):format(first, prelast, sufix)
end
