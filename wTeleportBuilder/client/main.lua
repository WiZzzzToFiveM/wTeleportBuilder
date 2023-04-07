ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)
------------------------------

OpenMenu = false
local allMarkersInServer = {}
local infoMarker = {}
local idlol = {}

------------------------------
local mainMenu = RageUI.CreateMenu("TeleportBuilder", "INTERACTIONS")
local teleportMenu = RageUI.CreateSubMenu(mainMenu, "TeleportBuilder", "INTERACTIONS")
local gestionMenu = RageUI.CreateSubMenu(mainMenu, "Gestions", "INTERACTIONS")
local teleporteurGestion = RageUI.CreateSubMenu(gestionMenu, "Gestions", "INTERACTIONS")
------------------------------
mainMenu.Closed = function()
    OpenMenu = false
end

function wTeleportBuilderMENU()
    if OpenMenu then
        OpenMenu = false
        RageUI.Visible(mainMenu, false)
        return
    else
        OpenMenu = true
        RageUI.Visible(mainMenu, true)


        CreateThread(function()
            while OpenMenu do
                Wait(1)

                RageUI.IsVisible(mainMenu, function()

                    RageUI.Button("~r~→~s~ Créer un téléporteur", nil, {}, true, {}, teleportMenu)

                    RageUI.Line()

                    RageUI.Button("~o~→~s~ Gestion des téléporteurs", nil, {}, true, {
                        onSelected = function()
                            getAllMarkers()
                        end
                    }, gestionMenu)

                end)

                RageUI.IsVisible(teleportMenu, function()

                    RageUI.Button("~g~→~s~ Position de l\'entrée", nil, {RightLabel = ""}, true, {
                        onSelected = function()
                            infoMarker.entrer = GetEntityCoords(GetPlayerPed(-1))
                            ESX.ShowNotification("Position ~g~ajustée")
                        end
                    })
        
                    RageUI.Button("~b~→~s~ Texte de l\'entrée", "Le texte commence par Appuyez sur [E]", {RightLabel = ""}, true, {
                        onSelected = function()
                            local result = KeyboardText("Entrez le texte", "", 50)
                            if result ~= nil then
                                infoMarker.textentrer = result
                                ESX.ShowNotification("Texte ~g~ajouté")
                            else
                                ESX.ShowNotification("Vous avez mis un texte invalide !")
                            end
                        end
                    })
        
                    RageUI.Button("~g~→~s~ Position de la sortie", nil, {RightLabel = ""}, true, {
                        onSelected = function()
                            infoMarker.sortie = GetEntityCoords(GetPlayerPed(-1))
                            ESX.ShowNotification("Position ~g~ajustée")
                        end
                    })
        
                    RageUI.Button("~b~→~s~ Texte de la sortie", "Appuyez sur ~y~[E]~s~ ", {RightLabel = ""}, true, {
                        onSelected = function()
                            local result = KeyboardText("Entrez le texte", "", 50)
                            if result ~= nil then
                                infoMarker.textsortie = result
                                ESX.ShowNotification("Texte ~g~ajouté")
                            else
                                ESX.ShowNotification("Vous avez mis un texte invalide !")
                            end
                        end
                    })
                    
                    
                    RageUI.Button("~g~Créer le télépoteur", nil, {RightLabel = "VALIDER"}, true, {
                        onSelected = function()
                            if infoMarker.entrer == nil then
                                ESX.ShowNotification("Vous avez laissé les coordonnées de l\'entrée vide.")
                            elseif infoMarker.textentrer == nil then
                                ESX.ShowNotification("Vous avez laissé le texte de l\'entrée vide.")
                            elseif infoMarker.sortie == nil then
                                ESX.ShowNotification("Vous avez laissé les coordonnées de la sortie vide.")
                            elseif infoMarker.textsortie == nil then
                                ESX.ShowNotification("Vous avez laissé le texte de la sortie vide.")
                            else
                                TriggerServerEvent("wTeleportBuilder:createMarker", infoMarker)
                                refreshTable()
                            end
                        end
                    })
        
                    RageUI.Button("~r~Annuler", nil, {RightLabel = "→→→"}, true, {
                        onSelected = function()
                            RageUI.CloseAll()
                            refreshTable()
                        end
                    })

                end)

                RageUI.IsVisible(gestionMenu, function()

                    RageUI.Separator("~b~Gestion des téléporteurs")

                    for k,v in pairs(allMarkersInServer) do
                        RageUI.Button("Téléporteur : "..v.id, "Texte entrée : "..v.textentrer.."\nTexte sortie : "..v.textsortie, {}, true, {}, teleporteurGestion)
                        idlol.idformarker = v.id
                    end

                end)

                RageUI.IsVisible(teleporteurGestion, function()

                    RageUI.Button("~r~SUPPRIMEZ LE TÉLÉPORTEUR~s~", nil, {}, true, {
                        onSelected = function()
                            TriggerServerEvent("wTeleportBuilder:deleteMarker", idlol.idformarker)
                            RageUI.CloseAll()
                        end
                    })

                    RageUI.Button("~g~Annulez~s~", nil, {}, true, {
                        onSelected = function()
                            RageUI.GoBack()
                        end
                    })

                end)

            end
        end)
    end
end

function getAllMarkers()
    ESX.TriggerServerCallback('wTeleportBuilder:GetPoints', function(result)
        allMarkersInServer = result
    end)
end

function KeyboardText(TextEntry, ExampleText, MaxStringLenght)
    AddTextEntry('FMMC_KEY_TIP1', TextEntry)
    blockinput = true
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do 
        Wait(0)
    end
        
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Wait(500)
        blockinput = false
        return result
    else
        Wait(500)
        blockinput = false
        return nil
    end
end

Citizen.CreateThread(function()
    ESX.TriggerServerCallback('wTeleportBuilder:GetPoints', function(result)
            while true do
                local Timer = 500
                for k,v in pairs(result) do
                local plyPos = GetEntityCoords(PlayerPedId())
                local pos = vector3(json.decode(v.entrer).x, json.decode(v.entrer).y, json.decode(v.entrer).z)
                local dist = #(plyPos-pos)
                if dist <= 10.0 then
                Timer = 0
                DrawMarker(22, pos, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.45, 0.45, 0.45, 0, 255, 0, 255, 55555, false, true, 2, false, false, false, false)
                end
                if dist <= 3.0 then
                    Timer = 0
                        RageUI.Text({ message = "Appuyez sur ~y~[E]~s~ "..v.textentrer, time_display = 1 })
                    if IsControlJustPressed(1,51) then
                        if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                            ESX.ShowNotification("Vous ne pouvez pas entrez avec un véhicule !")
                        else
                            teleportPed(json.decode(v.sortie))
                        end
                    end
                end
            end
            Citizen.Wait(Timer)
        end
    end)
end)


Citizen.CreateThread(function()
    ESX.TriggerServerCallback('wTeleportBuilder:GetPoints', function(result2)
            while true do
                local Timer = 500
                for k2,v2 in pairs(result2) do
                local plyPos = GetEntityCoords(PlayerPedId())
                local pos2 = vector3(json.decode(v2.sortie).x, json.decode(v2.sortie).y, json.decode(v2.sortie).z)
                local dist = #(plyPos-pos2)
                if dist <= 10.0 then
                Timer = 0
                DrawMarker(22, pos2, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.45, 0.45, 0.45, 255, 0, 0, 255, 55555, false, true, 2, false, false, false, false)
                end
                if dist <= 3.0 then
                    Timer = 0
                        RageUI.Text({ message = "Appuyez sur ~y~[E]~s~ "..v2.textsortie, time_display = 1 })
                    if IsControlJustPressed(1,51) then
                        if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                            ESX.ShowNotification("Vous ne pouvez pas entrez avec un véhicule !")
                        else
                            teleportPed(json.decode(v2.entrer))
                        end
                    end
                end
            end
            Citizen.Wait(Timer)
        end
    end)
end)

function teleportPed(coords)
    local playerPed = PlayerPedId()
	SetEntityCoords(playerPed, coords.x, coords.y, coords.z)
end

function refreshTable()
    infoMarker = {}
end


RegisterCommand("teleportbuilder", function()
    ESX.TriggerServerCallback('wTeleportBuilder:TonGroupe', function(result)
        if result == "admin" or result == "superadmin" then
            wTeleportBuilderMENU()
        else
            ESX.ShowNotification("Vous n'avez pas le droit d\'utiliser cette commande.")
        end
    end)
end)