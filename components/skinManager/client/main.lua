---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.
  
  File [main] created at [28/05/2021 00:32]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

NarcosClient_SkinManager = {}
NarcosClient_SkinManager.Character = {}

NarcosClient_SkinManager.trad = {
    ['face'] = 'Visage',
    ['skin'] = 'Peau',
    ['age_1'] = 'Rides',
    ['age_2'] = 'Épaisseur rides',
    ['beard_1'] = 'Type barbe',
    ['beard_2'] = 'Taille barbe',
    ['beard_3'] = 'Couleur barbe 1',
    ['beard_4'] = 'Couleur barbe 2',
    ['hair_1'] = 'Cheveux 1',
    ['hair_2'] = 'Cheveux 2',
    ['hair_color_1'] = 'Couleur cheveux 1',
    ['hair_color_2'] = 'Couleur cheveux 2',
    ['eye_color'] = 'lentilles colorées',
    ['eyebrows_1'] = 'Type sourcils',
    ['eyebrows_2'] = 'Taille sourcils',
    ['eyebrows_3'] = 'Couleur sourcils 1',
    ['eyebrows_4'] = 'Couleur sourcils 2',
    ['makeup_type'] = 'type maquillage',
    ['makeup_thickness'] = 'épaisseur maquillage',
    ['makeup_color_1'] = 'couleur maquillage 1',
    ['makeup_color_2'] = 'couleur maquillage 2',
    ['lipstick_type'] = 'type lipstick',
    ['lipstick_thickness'] = 'épaisseur lipstick',
    ['lipstick_color_1'] = 'couleur lipstick 1',
    ['lipstick_color_2'] = 'couleur lipstick 2',
    ['ear_accessories'] = 'accessoire oreilles',
    ['ear_accessories_color'] = 'couleur accessoire',
    ['tshirt_1'] = 't-Shirt 1',
    ['tshirt_2'] = 't-Shirt 2',
    ['torso_1'] = 'torse 1',
    ['torso_2'] = 'torse 2',
    ['decals_1'] = 'calques 1',
    ['decals_2'] = 'calques 2',
    ['arms'] = 'bras',
    ['arms_2'] = 'bras 2',
    ['pants_1'] = 'jambes 1',
    ['pants_2'] = 'jambes 2',
    ['shoes_1'] = 'chaussures 1',
    ['shoes_2'] = 'chaussures 2',
    ['mask_1'] = 'masque 1',
    ['mask_2'] = 'masque 2',
    ['bproof_1'] = 'gilet pare-balle 1',
    ['bproof_2'] = 'gilet pare-balle 2',
    ['chain_1'] = 'chaine 1',
    ['chain_2'] = 'chaine 2',
    ['helmet_1'] = 'casque 1',
    ['helmet_2'] = 'casque 2',
    ['watches_1'] = 'montre 1',
    ['watches_2'] = 'montre 2',
    ['bracelets_1'] = 'bracelet 1',
    ['bracelets_2'] = 'bracelet 2',
    ['glasses_1'] = 'lunettes 1',
    ['glasses_2'] = 'lunettes 2',
    ['bag'] = 'sac',
    ['bag_color'] = 'couleur sac',
    ['blemishes'] = 'Boutons',
    ['blemishes_size'] = 'opacité des boutons',
    ['ageing'] = 'vieillissement',
    ['ageing_1'] = 'opacité du vieillissement',
    ['blush'] = 'rougeur',
    ['blush_1'] = 'opacité rougeur',
    ['blush_color'] = 'couleur rougeur',
    ['complexion'] = 'teint',
    ['complexion_1'] = 'opacité teint',
    ['sun'] = 'dommages UV',
    ['sun_1'] = 'opacité dommages UV',
    ['freckles'] = 'taches de rousseur',
    ['freckles_1'] = 'opacité rousseur',
    ['chest_hair'] = 'pillositée torse',
    ['chest_hair_1'] = 'opacité pillositée',
    ['chest_color'] = 'couleur pillositée',
    ['bodyb'] = 'imperfections du corps',
    ['bodyb_size'] = 'opacité imperfections',
}

local function _U(str)
    return NarcosClient_SkinManager.trad[str]
end

local Components = {
    { label = "Sexe", name = 'sex', value = 1, min = 0, zoomOffset = 0.6, camOffset = 0.65 },
    { label = _U('face'), name = 'face', value = 0, min = 0, zoomOffset = 0.6, camOffset = 0.65 },
    { label = _U('skin'), name = 'skin', value = 0, min = 0, zoomOffset = 0.6, camOffset = 0.65 },
    { label = _U('hair_1'), name = 'hair_1', value = 0, min = 0, zoomOffset = 0.6, camOffset = 0.65 },
    { label = _U('hair_2'), name = 'hair_2', value = 0, min = 0, zoomOffset = 0.6, camOffset = 0.65 },
    { label = _U('hair_color_1'), name = 'hair_color_1', value = 0, min = 0, zoomOffset = 0.6, camOffset = 0.65 },
    { label = _U('hair_color_2'), name = 'hair_color_2', value = 0, min = 0, zoomOffset = 0.6, camOffset = 0.65 },
    { label = _U('tshirt_1'), name = 'tshirt_1', value = 0, min = 0, zoomOffset = 0.75, camOffset = 0.15, componentId = 8 },
    { label = _U('tshirt_2'), name = 'tshirt_2', value = 0, min = 0, zoomOffset = 0.75, camOffset = 0.15, textureof = 'tshirt_1' },
    { label = _U('torso_1'), name = 'torso_1', value = 0, min = 0, zoomOffset = 0.75, camOffset = 0.15, componentId = 11 },
    { label = _U('torso_2'), name = 'torso_2', value = 0, min = 0, zoomOffset = 0.75, camOffset = 0.15, textureof = 'torso_1' },
    { label = _U('decals_1'), name = 'decals_1', value = 0, min = 0, zoomOffset = 0.75, camOffset = 0.15, componentId = 10 },
    { label = _U('decals_2'), name = 'decals_2', value = 0, min = 0, zoomOffset = 0.75, camOffset = 0.15, textureof = 'decals_1' },
    { label = _U('arms'), name = 'arms', value = 0, min = 0, zoomOffset = 0.75, camOffset = 0.15 },
    { label = _U('arms_2'), name = 'arms_2', value = 0, min = 0, zoomOffset = 0.75, camOffset = 0.15 },
    { label = _U('pants_1'), name = 'pants_1', value = 0, min = 0, zoomOffset = 0.8, camOffset = -0.5, componentId = 4 },
    { label = _U('pants_2'), name = 'pants_2', value = 0, min = 0, zoomOffset = 0.8, camOffset = -0.5, textureof = 'pants_1' },
    { label = _U('shoes_1'), name = 'shoes_1', value = 0, min = 0, zoomOffset = 0.8, camOffset = -0.8, componentId = 6 },
    { label = _U('shoes_2'), name = 'shoes_2', value = 0, min = 0, zoomOffset = 0.8, camOffset = -0.8, textureof = 'shoes_1' },
    { label = _U('mask_1'), name = 'mask_1', value = 0, min = 0, zoomOffset = 0.6, camOffset = 0.65, componentId = 1 },
    { label = _U('mask_2'), name = 'mask_2', value = 0, min = 0, zoomOffset = 0.6, camOffset = 0.65, textureof = 'mask_1' },
    { label = _U('bproof_1'), name = 'bproof_1', value = 0, min = 0, zoomOffset = 0.75, camOffset = 0.15, componentId = 9 },
    { label = _U('bproof_2'), name = 'bproof_2', value = 0, min = 0, zoomOffset = 0.75, camOffset = 0.15, textureof = 'bproof_1' },
    { label = _U('chain_1'), name = 'chain_1', value = 0, min = 0, zoomOffset = 0.6, camOffset = 0.65, componentId = 7 },
    { label = _U('chain_2'), name = 'chain_2', value = 0, min = 0, zoomOffset = 0.6, camOffset = 0.65, textureof = 'chain_1' },
    { label = _U('helmet_1'), name = 'helmet_1', value = -1, min = -1, zoomOffset = 0.6, camOffset = 0.65, componentId = 0 },
    { label = _U('helmet_2'), name = 'helmet_2', value = 0, min = 0, zoomOffset = 0.6, camOffset = 0.65, textureof = 'helmet_1' },
    { label = _U('glasses_1'), name = 'glasses_1', value = 0, min = 0, zoomOffset = 0.6, camOffset = 0.65, componentId = 1 },
    { label = _U('glasses_2'), name = 'glasses_2', value = 0, min = 0, zoomOffset = 0.6, camOffset = 0.65, textureof = 'glasses_1' },
    { label = _U('watches_1'), name = 'watches_1', value = -1, min = -1, zoomOffset = 0.75, camOffset = 0.15, componentId = 6 },
    { label = _U('watches_2'), name = 'watches_2', value = 0, min = 0, zoomOffset = 0.75, camOffset = 0.15, textureof = 'watches_1' },
    { label = _U('bracelets_1'), name = 'bracelets_1', value = -1, min = -1, zoomOffset = 0.75, camOffset = 0.15, componentId = 7 },
    { label = _U('bracelets_2'), name = 'bracelets_2', value = 0, min = 0, zoomOffset = 0.75, camOffset = 0.15, textureof = 'bracelets_1' },
    { label = _U('bag'), name = 'bags_1', value = 0, min = 0, zoomOffset = 0.75, camOffset = 0.15, componentId = 5 },
    { label = _U('bag_color'), name = 'bags_2', value = 0, min = 0, zoomOffset = 0.75, camOffset = 0.15, textureof = 'bags_1' },
    { label = _U('eye_color'), name = 'eye_color', value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65 },
    { label = _U('eyebrow_size'), name = 'eyebrows_2', value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65 },
    { label = _U('eyebrow_type'), name = 'eyebrows_1', value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65 },
    { label = _U('eyebrow_color_1'), name = 'eyebrows_3', value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65 },
    { label = _U('eyebrow_color_2'), name = 'eyebrows_4', value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65 },
    { label = _U('makeup_type'), name = 'makeup_1', value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65 },
    { label = _U('makeup_thickness'), name = 'makeup_2', value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65 },
    { label = _U('makeup_color_1'), name = 'makeup_3', value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65 },
    { label = _U('makeup_color_2'), name = 'makeup_4', value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65 },
    { label = _U('lipstick_type'), name = 'lipstick_1', value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65 },
    { label = _U('lipstick_thickness'), name = 'lipstick_2', value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65 },
    { label = _U('lipstick_color_1'), name = 'lipstick_3', value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65 },
    { label = _U('lipstick_color_2'), name = 'lipstick_4', value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65 },
    { label = _U('ear_accessories'), name = 'ears_1', value = -1, min = -1, zoomOffset = 0.4, camOffset = 0.65, componentId = 2 },
    { label = _U('ear_accessories_color'), name = 'ears_2', value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65, textureof = 'ears_1' },
    { label = _U('chest_hair'), name = 'chest_1', value = 0, min = 0, zoomOffset = 0.75, camOffset = 0.15 },
    { label = _U('chest_hair_1'), name = 'chest_2', value = 0, min = 0, zoomOffset = 0.75, camOffset = 0.15 },
    { label = _U('chest_color'), name = 'chest_3', value = 0, min = 0, zoomOffset = 0.75, camOffset = 0.15 },
    { label = _U('bodyb'), name = 'bodyb_1', value = 0, min = 0, zoomOffset = 0.75, camOffset = 0.15 },
    { label = _U('bodyb_size'), name = 'bodyb_2', value = 0, min = 0, zoomOffset = 0.75, camOffset = 0.15 },
    { label = _U('wrinkles'), name = 'age_1', value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65 },
    { label = _U('wrinkle_thickness'), name = 'age_2', value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65 },
    { label = _U('blemishes'), name = 'blemishes_1', value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65 },
    { label = _U('blemishes_size'), name = 'blemishes_2', value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65 },
    { label = _U('blush'), name = 'blush_1', value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65 },
    { label = _U('blush_1'), name = 'blush_2', value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65 },
    { label = _U('blush_color'), name = 'blush_3', value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65 },
    { label = _U('complexion'), name = 'complexion_1', value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65 },
    { label = _U('complexion_1'), name = 'complexion_2', value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65 },
    { label = _U('sun'), name = 'sun_1', value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65 },
    { label = _U('sun_1'), name = 'sun_2', value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65 },
    { label = _U('freckles'), name = 'moles_1', value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65 },
    { label = _U('freckles_1'), name = 'moles_2', value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65 },
    { label = _U('beard_type'), name = 'beard_1', value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65 },
    { label = _U('beard_size'), name = 'beard_2', value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65 },
    { label = _U('beard_color_1'), name = 'beard_3', value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65 },
    { label = _U('beard_color_2'), name = 'beard_4', value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65 }
}

for i = 1, #Components, 1 do
    NarcosClient_SkinManager.Character[Components[i].name] = Components[i].value
end

NarcosClient_SkinManager.getMaxVals = function()
    local playerPed = PlayerPedId()

    local data = {
        ["face"] = 45,
        ["skin"] = 45,
        ["age_1"] = GetNumHeadOverlayValues(3) - 1,
        ["age_2"] = 10,
        ["beard_1"] = GetNumHeadOverlayValues(1) - 1,
        ["beard_2"] = 10,
        ["beard_3"] = GetNumHairColors() - 1,
        ["beard_4"] = GetNumHairColors() - 1,
        ["hair_1"] = GetNumberOfPedDrawableVariations(playerPed, 2) - 1,
        ["hair_2"] = GetNumberOfPedTextureVariations(playerPed, 2, NarcosClient_SkinManager.Character['hair_1']) - 1,
        ["hair_color_1"] = GetNumHairColors() - 1,
        ["hair_color_2"] = GetNumHairColors() - 1,
        ["eye_color"] = 31,
        ["eyebrows_1"] = GetNumHeadOverlayValues(2) - 1,
        ["eyebrows_2"] = 10,
        ["eyebrows_3"] = GetNumHairColors() - 1,
        ["eyebrows_4"] = GetNumHairColors() - 1,
        ["makeup_1"] = GetNumHeadOverlayValues(4) - 1,
        ["makeup_2"] = 10,
        ["makeup_3"] = GetNumHairColors() - 1,
        ["makeup_4"] = GetNumHairColors() - 1,
        ["lipstick_1"] = GetNumHeadOverlayValues(8) - 1,
        ["lipstick_2"] = 10,
        ["lipstick_3"] = GetNumHairColors() - 1,
        ["lipstick_4"] = GetNumHairColors() - 1,
        ["blemishes_1"] = GetNumHeadOverlayValues(0) - 1,
        ["blemishes_2"] = 10,
        ["blush_1"] = GetNumHeadOverlayValues(5) - 1,
        ["blush_2"] = 10,
        ["blush_3"] = GetNumHairColors() - 1,
        ["complexion_1"] = GetNumHeadOverlayValues(6) - 1,
        ["complexion_2"] = 10,
        ["sun_1"] = GetNumHeadOverlayValues(7) - 1,
        ["sun_2"] = 10,
        ["moles_1"] = GetNumHeadOverlayValues(9) - 1,
        ["moles_2"] = 10,
        ["chest_1"] = GetNumHeadOverlayValues(10) - 1,
        ["chest_2"] = 10,
        ["chest_3"] = GetNumHairColors() - 1,
        ["bodyb_1"] = GetNumHeadOverlayValues(11) - 1,
        ["bodyb_2"] = 10,
        ["ears_1"] = GetNumberOfPedPropDrawableVariations(playerPed, 2) - 1,
        ["ears_2"] = GetNumberOfPedPropTextureVariations(playerPed, 2, NarcosClient_SkinManager.Character['ears_1'] - 1),
        ["tshirt_1"] = GetNumberOfPedDrawableVariations(playerPed, 8) - 1,
        ["tshirt_2"] = GetNumberOfPedTextureVariations(playerPed, 8, NarcosClient_SkinManager.Character['tshirt_1']) - 1,
        ["torso_1"] = GetNumberOfPedDrawableVariations(playerPed, 11) - 1,
        ["torso_2"] = GetNumberOfPedTextureVariations(playerPed, 11, NarcosClient_SkinManager.Character['torso_1']) - 1,
        ["decals_1"] = GetNumberOfPedDrawableVariations(playerPed, 10) - 1,
        ["decals_2"] = GetNumberOfPedTextureVariations(playerPed, 10, NarcosClient_SkinManager.Character['decals_1']) - 1,
        ["arms"] = GetNumberOfPedDrawableVariations(playerPed, 3) - 1,
        ["arms_2"] = 10,
        ["pants_1"] = GetNumberOfPedDrawableVariations(playerPed, 4) - 1,
        ["pants_2"] = GetNumberOfPedTextureVariations(playerPed, 4, NarcosClient_SkinManager.Character['pants_1']) - 1,
        ["shoes_1"] = GetNumberOfPedDrawableVariations(playerPed, 6) - 1,
        ["shoes_2"] = GetNumberOfPedTextureVariations(playerPed, 6, NarcosClient_SkinManager.Character['shoes_1']) - 1,
        ["mask_1"] = GetNumberOfPedDrawableVariations(playerPed, 1) - 1,
        ["mask_2"] = GetNumberOfPedTextureVariations(playerPed, 1, NarcosClient_SkinManager.Character['mask_1']) - 1,
        ["bproof_1"] = GetNumberOfPedDrawableVariations(playerPed, 9) - 1,
        ["bproof_2"] = GetNumberOfPedTextureVariations(playerPed, 9, NarcosClient_SkinManager.Character['bproof_1']) - 1,
        ["chain_1"] = GetNumberOfPedDrawableVariations(playerPed, 7) - 1,
        ["chain_2"] = GetNumberOfPedTextureVariations(playerPed, 7, NarcosClient_SkinManager.Character['chain_1']) - 1,
        ["bags_1"] = GetNumberOfPedDrawableVariations(playerPed, 5) - 1,
        ["bags_2"] = GetNumberOfPedTextureVariations(playerPed, 5, NarcosClient_SkinManager.Character['bags_1']) - 1,
        ["helmet_1"] = GetNumberOfPedPropDrawableVariations(playerPed, 0) - 1,
        ["helmet_2"] = GetNumberOfPedPropTextureVariations(playerPed, 0, NarcosClient_SkinManager.Character['helmet_1']) - 1,
        ["glasses_1"] = GetNumberOfPedPropDrawableVariations(playerPed, 1) - 1,
        ["glasses_2"] = GetNumberOfPedPropTextureVariations(playerPed, 1, NarcosClient_SkinManager.Character['glasses_1'] - 1),
        ["watches_1"] = GetNumberOfPedPropDrawableVariations(playerPed, 6) - 1,
        ["watches_2"] = GetNumberOfPedPropTextureVariations(playerPed, 6, NarcosClient_SkinManager.Character['watches_1']) - 1,
        ["bracelets_1"] = GetNumberOfPedPropDrawableVariations(playerPed, 7) - 1,
        ["bracelets_2"] = GetNumberOfPedPropTextureVariations(playerPed, 7, NarcosClient_SkinManager.Character['bracelets_1'] - 1)
    }

    return data
end

local function ApplySkin(skin, clothes)
    local playerPed = PlayerPedId()

    for k, v in pairs(skin) do
        NarcosClient_SkinManager.Character[k] = v
    end

    if clothes ~= nil then
        for k, v in pairs(clothes) do
            if
            k ~= 'sex' and
                    k ~= 'face' and
                    k ~= 'skin' and
                    k ~= 'age_1' and
                    k ~= 'age_2' and
                    k ~= 'eye_color' and
                    k ~= 'beard_1' and
                    k ~= 'beard_2' and
                    k ~= 'beard_3' and
                    k ~= 'beard_4' and
                    k ~= 'hair_1' and
                    k ~= 'hair_2' and
                    k ~= 'hair_color_1' and
                    k ~= 'hair_color_2' and
                    k ~= 'eyebrows_1' and
                    k ~= 'eyebrows_2' and
                    k ~= 'eyebrows_3' and
                    k ~= 'eyebrows_4' and
                    k ~= 'makeup_1' and
                    k ~= 'makeup_2' and
                    k ~= 'makeup_3' and
                    k ~= 'makeup_4' and
                    k ~= 'lipstick_1' and
                    k ~= 'lipstick_2' and
                    k ~= 'lipstick_3' and
                    k ~= 'lipstick_4' and
                    k ~= 'blemishes_1' and
                    k ~= 'blemishes_2' and
                    k ~= 'blush_1' and
                    k ~= 'blush_2' and
                    k ~= 'blush_3' and
                    k ~= 'complexion_1' and
                    k ~= 'complexion_2' and
                    k ~= 'sun_1' and
                    k ~= 'sun_2' and
                    k ~= 'moles_1' and
                    k ~= 'moles_2' and
                    k ~= 'chest_1' and
                    k ~= 'chest_2' and
                    k ~= 'chest_3' and
                    k ~= 'bodyb_1' and
                    k ~= 'bodyb_2'
            then
                NarcosClient_SkinManager.Character[k] = v
            end
        end
    end

    SetPedHeadBlendData(playerPed, NarcosClient_SkinManager.Character['face'], NarcosClient_SkinManager.Character['face'], NarcosClient_SkinManager.Character['face'], NarcosClient_SkinManager.Character['skin'], NarcosClient_SkinManager.Character['skin'], NarcosClient_SkinManager.Character['skin'], 1.0, 1.0, 1.0, true)

    SetPedHairColor(playerPed, NarcosClient_SkinManager.Character['hair_color_1'], NarcosClient_SkinManager.Character['hair_color_2'])                    -- Hair Color
    SetPedHeadOverlay(playerPed, 3, NarcosClient_SkinManager.Character['age_1'], (NarcosClient_SkinManager.Character['age_2'] / 10) + 0.0)            -- Age + opacity
    SetPedHeadOverlay(playerPed, 0, NarcosClient_SkinManager.Character['blemishes_1'], (NarcosClient_SkinManager.Character['blemishes_2'] / 10) + 0.0)        -- Blemishes + opacity
    SetPedHeadOverlay(playerPed, 1, NarcosClient_SkinManager.Character['beard_1'], (NarcosClient_SkinManager.Character['beard_2'] / 10) + 0.0)            -- Beard + opacity
    SetPedEyeColor(playerPed, NarcosClient_SkinManager.Character['eye_color'], 0, 1)                                                -- Eyes color
    SetPedHeadOverlay(playerPed, 2, NarcosClient_SkinManager.Character['eyebrows_1'], (NarcosClient_SkinManager.Character['eyebrows_2'] / 10) + 0.0)        -- Eyebrows + opacity
    SetPedHeadOverlay(playerPed, 4, NarcosClient_SkinManager.Character['makeup_1'], (NarcosClient_SkinManager.Character['makeup_2'] / 10) + 0.0)            -- Makeup + opacity
    SetPedHeadOverlay(playerPed, 8, NarcosClient_SkinManager.Character['lipstick_1'], (NarcosClient_SkinManager.Character['lipstick_2'] / 10) + 0.0)        -- Lipstick + opacity
    SetPedComponentVariation(playerPed, 2, NarcosClient_SkinManager.Character['hair_1'], NarcosClient_SkinManager.Character['hair_2'], 2)                        -- Hair
    SetPedHeadOverlayColor(playerPed, 1, 1, NarcosClient_SkinManager.Character['beard_3'], NarcosClient_SkinManager.Character['beard_4'])                        -- Beard Color
    SetPedHeadOverlayColor(playerPed, 2, 1, NarcosClient_SkinManager.Character['eyebrows_3'], NarcosClient_SkinManager.Character['eyebrows_4'])                    -- Eyebrows Color
    SetPedHeadOverlayColor(playerPed, 4, 1, NarcosClient_SkinManager.Character['makeup_3'], NarcosClient_SkinManager.Character['makeup_4'])                        -- Makeup Color
    SetPedHeadOverlayColor(playerPed, 8, 1, NarcosClient_SkinManager.Character['lipstick_3'], NarcosClient_SkinManager.Character['lipstick_4'])                    -- Lipstick Color
    SetPedHeadOverlay(playerPed, 5, NarcosClient_SkinManager.Character['blush_1'], (NarcosClient_SkinManager.Character['blush_2'] / 10) + 0.0)            -- Blush + opacity
    SetPedHeadOverlayColor(playerPed, 5, 2, NarcosClient_SkinManager.Character['blush_3'])                                                        -- Blush Color
    SetPedHeadOverlay(playerPed, 6, NarcosClient_SkinManager.Character['complexion_1'], (NarcosClient_SkinManager.Character['complexion_2'] / 10) + 0.0)        -- Complexion + opacity
    SetPedHeadOverlay(playerPed, 7, NarcosClient_SkinManager.Character['sun_1'], (NarcosClient_SkinManager.Character['sun_2'] / 10) + 0.0)            -- Sun Damage + opacity
    SetPedHeadOverlay(playerPed, 9, NarcosClient_SkinManager.Character['moles_1'], (NarcosClient_SkinManager.Character['moles_2'] / 10) + 0.0)            -- Moles/Freckles + opacity
    SetPedHeadOverlay(playerPed, 10, NarcosClient_SkinManager.Character['chest_1'], (NarcosClient_SkinManager.Character['chest_2'] / 10) + 0.0)            -- Chest Hair + opacity
    SetPedHeadOverlayColor(playerPed, 10, 1, NarcosClient_SkinManager.Character['chest_3'])                                                        -- Torso Color
    SetPedHeadOverlay(playerPed, 11, NarcosClient_SkinManager.Character['bodyb_1'], (NarcosClient_SkinManager.Character['bodyb_2'] / 10) + 0.0)            -- Body Blemishes + opacity

    if NarcosClient_SkinManager.Character['ears_1'] == -1 then
        ClearPedProp(playerPed, 2)
    else
        SetPedPropIndex(playerPed, 2, NarcosClient_SkinManager.Character['ears_1'], NarcosClient_SkinManager.Character['ears_2'], 2)                        -- Ears Accessories
    end

    SetPedComponentVariation(playerPed, 8, NarcosClient_SkinManager.Character['tshirt_1'], NarcosClient_SkinManager.Character['tshirt_2'], 2)                    -- Tshirt
    SetPedComponentVariation(playerPed, 11, NarcosClient_SkinManager.Character['torso_1'], NarcosClient_SkinManager.Character['torso_2'], 2)                    -- torso parts
    SetPedComponentVariation(playerPed, 3, NarcosClient_SkinManager.Character['arms'], NarcosClient_SkinManager.Character['arms_2'], 2)                        -- Amrs
    SetPedComponentVariation(playerPed, 10, NarcosClient_SkinManager.Character['decals_1'], NarcosClient_SkinManager.Character['decals_2'], 2)                    -- decals
    SetPedComponentVariation(playerPed, 4, NarcosClient_SkinManager.Character['pants_1'], NarcosClient_SkinManager.Character['pants_2'], 2)                    -- pants
    SetPedComponentVariation(playerPed, 6, NarcosClient_SkinManager.Character['shoes_1'], NarcosClient_SkinManager.Character['shoes_2'], 2)                    -- shoes
    SetPedComponentVariation(playerPed, 1, NarcosClient_SkinManager.Character['mask_1'], NarcosClient_SkinManager.Character['mask_2'], 2)                        -- mask
    SetPedComponentVariation(playerPed, 9, NarcosClient_SkinManager.Character['bproof_1'], NarcosClient_SkinManager.Character['bproof_2'], 2)                    -- bulletproof
    SetPedComponentVariation(playerPed, 7, NarcosClient_SkinManager.Character['chain_1'], NarcosClient_SkinManager.Character['chain_2'], 2)                    -- chain
    SetPedComponentVariation(playerPed, 5, NarcosClient_SkinManager.Character['bags_1'], NarcosClient_SkinManager.Character['bags_2'], 2)                        -- Bag

    if NarcosClient_SkinManager.Character['helmet_1'] == -1 then
        ClearPedProp(playerPed, 0)
    else
        SetPedPropIndex(playerPed, 0, NarcosClient_SkinManager.Character['helmet_1'], NarcosClient_SkinManager.Character['helmet_2'], 2)                    -- Helmet
    end

    if NarcosClient_SkinManager.Character['glasses_1'] == -1 then
        ClearPedProp(playerPed, 1)
    else
        SetPedPropIndex(playerPed, 1, NarcosClient_SkinManager.Character['glasses_1'], NarcosClient_SkinManager.Character['glasses_2'], 2)                    -- Glasses
    end

    if NarcosClient_SkinManager.Character['watches_1'] == -1 then
        ClearPedProp(playerPed, 6)
    else
        SetPedPropIndex(playerPed, 6, NarcosClient_SkinManager.Character['watches_1'], NarcosClient_SkinManager.Character['watches_2'], 2)                    -- Watches
    end

    if NarcosClient_SkinManager.Character['bracelets_1'] == -1 then
        ClearPedProp(playerPed, 7)
    else
        SetPedPropIndex(playerPed, 7, NarcosClient_SkinManager.Character['bracelets_1'], NarcosClient_SkinManager.Character['bracelets_2'], 2)                -- Bracelets
    end
end


NarcosClient_SkinManager.getData = function()
    local components = json.decode(json.encode(Components))

    for k, v in pairs(NarcosClient_SkinManager.Character) do
        for i = 1, #components, 1 do
            if k == components[i].name then
                components[i].value = v
                --components[i].zoomOffset = Components[i].zoomOffset
                --components[i].camOffset = Components[i].camOffset
            end
        end
    end
    return components
end

NarcosClient_SkinManager.change = function(key, val)
    NarcosClient_SkinManager.Character[key] = val
    ApplySkin(NarcosClient_SkinManager.Character)
    ClearAllPedProps(PlayerPedId())
end

NarcosClient_SkinManager.getSkin = function()
    return NarcosClient_SkinManager.Character
end

NarcosClient_SkinManager.loadSkin = function(skin)
    ApplySkin(skin)
end

