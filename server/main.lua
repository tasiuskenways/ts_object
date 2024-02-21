lib.versionCheck('tasiuskenways/ts_object')

lib.addCommand('placeobject', {
    help = 'Place an object (Admin Only)',
    restricted = 'admin',
    params = {
        { name = 'model', help = 'Object model', type = 'string' },
    }
}, function(src, args, raw)
    TriggerClientEvent('uus_object:client:placeObject', src, args.model)
end)

RegisterNetEvent('uus_object:server:removeObject', function(pos, item)
    exports.ox_inventory:AddItem(source, item, 1)
    table.remove(UUS.ObjectList, pos)
    local Model = [[
        {
            obj = `%s`,
            coords = %s,
            rot = %s,
            onGround = %s,
            user = '%s',
            item = '%s'
        },
    ]]

    local formatted = {}

    for _, v in ipairs(UUS.ObjectList) do
        formatted[#formatted + 1] = Model:format(v.obj, v.coords, v.rot, v.onGround, v.user, v.item)
    end
    local ret = ('return { \n%s}'):format(table.concat(formatted, '\n'))

    GlobalState.uus_object_save_object = UUS.ObjectList

    SaveResourceFile(cache.resource, 'data/objectlist.lua', ret, -1)
end)

RegisterNetEvent('uus_object:server:saveObject', function(data)
    local mergedData = {}
    for _, v in ipairs(UUS.ObjectList) do
        mergedData[#mergedData + 1] = {
            obj = v.obj,
            coords = v.coords,
            rot = v.rot,
            onGround = v.onGround or false,
            user = v.user,
            item = v.item
        }
    end

    for _, v in ipairs(data) do
        mergedData[#mergedData + 1] = {
            obj = v.obj,
            coords = v.coords,
            rot = v.rot,
            onGround = v.onGround or false,
            user = v.user,
            item = v.item
        }
        exports.ox_inventory:RemoveItem(source, v.item, 1)
    end

    local Model = [[
        {
            obj = `%s`,
            coords = %s,
            rot = %s,
            onGround = %s,
            user = '%s',
            item = '%s'
        },
    ]]

    local formatted = {}

    for _, v in ipairs(mergedData) do
        formatted[#formatted + 1] = Model:format(v.obj, v.coords, v.rot, v.onGround, v.user, v.item)
    end
    local ret = ('return { \n%s}'):format(table.concat(formatted, '\n'))

    UUS.ObjectList = mergedData
    GlobalState.uus_object_save_object = mergedData

    SaveResourceFile(cache.resource, 'data/objectlist.lua', ret, -1)
end)

lib.callback.register('uus_object:server:getUserIdentifier', function(source)
    return GetPlayerIdentifierByType(source, 'steam')
end)
