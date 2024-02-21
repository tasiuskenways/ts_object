-- Example QBX
--[[
exports.qbx_core:CreateUseableItem('weed_brick', function(source, item)
    local src = source
    TriggerClientEvent('uus_object:client:placeObject', src, 'prop_mb_cargo_03a', 'weed_brick')
end)
]]
