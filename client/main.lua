local objpl = require 'modules.objectplacer'
local allobj = {}

RegisterNetEvent('uus_object:client:placeObject', function(model, item)
    local input = lib.inputDialog('TS-OBJECT', {
        { type = 'checkbox', label = 'Place Object On Ground Propperly?' },
    })
    if not input then return end
    local newData = {}
    objpl.placeObject({
        model = model,
        onGround = input[1],
        onFinish = function(data)
            newData[#newData + 1] = {
                obj = model,
                coords = data.pos,
                rot = data.rot,
                onGround = input[1],
                user = lib.callback.await('uus_object:server:getUserIdentifier', false),
                item = item
            }
            TriggerServerEvent('uus_object:server:saveObject', newData)
        end
    })
end)

local function removeObject(data)
    DeleteEntity(data.obj)
    TriggerServerEvent('uus_object:server:removeObject', data.pos, data.item)
end

local function refreshObject()
    local placedObj = {}
    for pos, v in ipairs(UUS.ObjectList) do
        local model = type(v.obj) == 'string' and joaat(v.obj) or v.obj
        lib.requestModel(model)
        placedObj = CreateObject(model, v.coords.x, v.coords.y, v.coords.z, true, true, false)
        SetEntityHeading(placedObj, v.rot)
        SetEntityCollision(placedObj, true, true)
        FreezeEntityPosition(placedObj, true)
        if v.onGround then
            PlaceObjectOnGroundProperly(placedObj)
        end

        allobj[#allobj + 1] = {
            obj = placedObj
        }

        if lib.callback.await('ox_lib:checkPlayerAce', false, 'admin') or lib.callback.await('uus_object:server:getUserIdentifier', false) == v.user then
            exports.ox_target:addLocalEntity(placedObj, {
                {
                    icon = 'fab fa-x-mark',
                    label = 'Remove Object',
                    distance = 1.6,
                    onSelect = function()
                        removeObject({ obj = placedObj, pos = pos, item = v.item })
                    end
                }
            })
        end
    end
end

AddEventHandler('onResourceStart', function(resource)
    if resource ~= cache.resource then return end
    refreshObject()
end)

AddEventHandler('onResourceStop', function(resource)
    for i = 1, #allobj do
        DeleteEntity(allobj[i].obj)
    end
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    refreshObject()
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    for i = 1, #allobj do
        DeleteEntity(allobj[i].obj)
    end
end)

AddStateBagChangeHandler('uus_object_save_object', 'global', function(bagname, key, value)
    if value then
        UUS.ObjectList = value
        for i = 1, #allobj do
            DeleteEntity(allobj[i].obj)
        end
        refreshObject()
    end
end)
