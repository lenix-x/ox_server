if not Framework.ESX() then return end

local client = client
local firstSpawn = false

AddEventHandler("esx_skin:resetFirstSpawn", function()
    firstSpawn = true
end)

AddEventHandler("esx_skin:playerRegistered", function()
    if(firstSpawn) then
        InitializeCharacter(Framework.GetGender(true))
    end
end)

RegisterNetEvent("skinchanger:loadSkin2", function(ped, skin)
    if not skin.model then skin.model = "mp_m_freemode_01" end
    client.setPedAppearance(ped, skin)
    Framework.CachePed()
end)

RegisterNetEvent("skinchanger:getSkin", function(cb)
    while not Framework.PlayerData do
        Wait(1000)
    end
    lib.callback("illenium-appearance:server:getAppearance", false, function(appearance)
        cb(appearance)
        Framework.CachePed()
    end)
end)

local function LoadSkin(skin, cb)
    if skin.model then
        client.setPlayerAppearance(skin)
    else -- add validation invisible when failed registration (maybe server restarted when apply skin)
        SetInitialClothes(Config.InitialPlayerClothes[Framework.GetGender(true)])
    end
    if Framework.PlayerData and Framework.PlayerData.loadout then
        TriggerEvent("esx:restoreLoadout")
    end
    Framework.CachePed()
	if cb ~= nil then
		cb()
	end
end

RegisterNetEvent("skinchanger:loadSkin", function(skin, cb)
    LoadSkin(skin, cb)
end)

local function loadClothes(_, clothes)
    local components = Framework.ConvertComponents(clothes, client.getPedComponents(cache.ped))
    local props = Framework.ConvertProps(clothes, client.getPedProps(cache.ped))

    client.setPedComponents(cache.ped, components)
    client.setPedProps(cache.ped, props)
end

RegisterNetEvent("skinchanger:loadClothes", function(_, clothes)
    loadClothes(_, clothes)
end)

RegisterNetEvent("esx_skin:openSaveableMenu", function(onSubmit, onCancel)
    InitializeCharacter(Framework.GetGender(true), onSubmit, onCancel)
end)

local function exportHandler(exportName, func)
  AddEventHandler(('__cfx_export_skinchanger_%s'):format(exportName), function(setCB)
      setCB(func)
  end)
end

exportHandler("GetSkin", function()
    while not Framework.PlayerData do
        Wait(1000)
    end

    local appearance = lib.callback.await("illenium-appearance:server:getAppearance", false)
    return appearance
end)

exportHandler("LoadSkin", function(skin)
    return LoadSkin(skin)
end)

exportHandler("LoadClothes", function(playerSkin, clothesSkin)
    return loadClothes(playerSkin, clothesSkin)
end)
