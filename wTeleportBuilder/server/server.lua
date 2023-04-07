ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('wTeleportBuilder:TonGroupe', function(source, cb)
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    local group = xPlayer.getGroup()
    cb(group)
end)


ESX.RegisterServerCallback('wTeleportBuilder:GetPoints', function(source, cb)
	local allPoints = {}
	MySQL.Async.fetchAll("SELECT * FROM teleportbuilder", {}, function(data)
        for _,v in pairs(data) do
			table.insert(allPoints, {
                id = v.id,
				entrer = v.entrer,
				sortie = v.sortie,
				textentrer = v.textentrer,
                textsortie = v.textsortie,
			})
        end
        cb(allPoints)
    end)
end)

RegisterServerEvent('wTeleportBuilder:createMarker')
AddEventHandler('wTeleportBuilder:createMarker', function(infoMarker)
    local _src = source
    MySQL.Async.execute("INSERT INTO teleportbuilder (entrer, sortie, textentrer, textsortie) VALUES (@entrer, @sortie, @textentrer, @textsortie)", {
        ['@entrer'] = json.encode(infoMarker.entrer),
        ['@sortie'] = json.encode(infoMarker.sortie),
        ['@textentrer'] = infoMarker.textentrer,
        ['@textsortie'] = infoMarker.textsortie,
    }, function(rowsChanged)
        TriggerClientEvent('esx:showNotification', _src, "Vous avez créé un téléporteur.")
    end)
end)


RegisterServerEvent('wTeleportBuilder:deleteMarker')
AddEventHandler('wTeleportBuilder:deleteMarker', function(id)
    local _src = source
    MySQL.Async.execute("DELETE FROM teleportbuilder WHERE id = @id", {
        ['@id'] = id
    }, function(rowsChanged)
        TriggerClientEvent('esx:showNotification', _src, "Vous avez supprimé un téléporteur.")
    end)
end)