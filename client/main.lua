
Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}
ESX = nil

--instructionals
local form = nil
local data = {}

local entries = {}


----------------

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end
	ESX.PlayerData = ESX.GetPlayerData()
end)

function KeyboardInput(TextEntry, ExampleText, MaxStringLength)
	AddTextEntry('FMMC_KEY_TIP1', TextEntry .. ':')
	DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLength)
	blockinput = true 
	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
		Citizen.Wait(0)
	end
	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult()
		Citizen.Wait(500)
		blockinput = false
		return result
	else
		Citizen.Wait(500) 
		blockinput = false
		return nil
	end
end


RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

AddEventHandler("exitedmarker", function(markerlabel,MarkerObject)
	if MarkerObject.resource == GetCurrentResourceName() then
		TriggerEvent('esx_inventoryhud:canGiveItem',true)
        if markerlabel == "BuyMysteryBoxes" then
			ESX.UI.Menu.Close('default', GetCurrentResourceName(), 'buy_mysterybox')
        end
    end
end)

AddEventHandler("pressedmarker", function(markerlabel,MarkerObject)
	if MarkerObject.resource == GetCurrentResourceName() then
		if markerlabel == "BuyMysteryBoxes" then
			ESX.UI.Menu.CloseAll()

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'buy_mysterybox',
			{
				title    = 'Buy Mystery Boxes',
				align    = 'bottom-right',
				elements = {
					{label = "Cash For 1 Mystery Box: " .. ConfigCL.MysteryBoxCashPrice .. "$ - Black Money: " .. ConfigCL.MysteryBoxBMPrice .. '$',	value = ''},
					{label = "Yes",	value = 'yes'},
					{label = "No",	value = 'no'},
					
				}
			}, function(data, menu)
		
				if data.current.value == 'yes' then
					
					
					menu.close()
					ESX.UI.Menu.Open(
					'dialog', GetCurrentResourceName(), 'mdialog',
					{
						title = "Enter Amount"
					},
					function(data, menu)
						local count = data.value
						
						if count ~= nil and tonumber(count) > 0 then
							menu.close()
							count = tonumber(count)
							TriggerServerEvent("esx_CreateMafia:buyMysteryBox",count)
						else
							ESX.ShowNotification("Λάθος αριθμός")
						end


						
					end,
					function(data, menu)
						menu.close()
					end)
				elseif data.current.value == 'no' then
					menu.close()
				end
			end,function(data,menu)
				menu.close()
			end)
		end

	end
end)

Citizen.CreateThread(function()
	Citizen.Wait(5000)
	while true do
		Citizen.Wait(0)
		local coords = GetEntityCoords(GetPlayerPed(-1))
		local x = -889.33
		local y = -853.25
		local z = 19.57
		local distance = 2
		if GetDistanceBetweenCoords(coords, x,y,z, true) < 100.0 then
			DrawMarker(1, -889.33,-853.25,19.57, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 1.0, 0, 0, 200, 155, false, false, 2, false, false, false, false)
			if GetDistanceBetweenCoords(coords, x,y,z, true) < distance then
				DisplayHelpText("Press ~INPUT_CONTEXT~ to open the create job menu")
			end
			if IsControlJustPressed(0, Keys["E"]) and GetDistanceBetweenCoords(coords, x,y,z, true) < distance then
				OpenMafiaMenu()
			end
		end
	end
end)

Citizen.CreateThread(function()
    Wait(500)
    local pedmodel = "a_m_m_hillbilly_01"
    RequestModel(pedmodel)
    while not HasModelLoaded(pedmodel) do
        Citizen.Wait(1)
        RequestModel(pedmodel)
    end
    local ped = CreatePed("PED_TYPE_CIVMALE", pedmodel, vector3(-889.39, -853.24, 19.57), 280.75, true, false)
    SetEntityInvincible(ped, true)
    FreezeEntityPosition(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    TaskStartScenarioInPlace(ped, "WORLD_HUMAN_SMOKING", 0, true)
end)

Citizen.CreateThread(function ()
	local blip = AddBlipForCoord(-889.33,-853.25,19.57)

	SetBlipSprite (blip, 501)
	SetBlipDisplay(blip, 4)
	SetBlipScale  (blip, 0.8)
	SetBlipColour  (blip, 1)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('Create Mafia')
	EndTextCommandSetBlipName(blip)
end)

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function OpenMafiaMenu()
	SetNuiFocus(true,true)
	
	SendNUIMessage({action = "enable"})
end


RegisterNUICallback('onCloseMenu', function()
	SendNUIMessage({action = 'disable'})
	SetNuiFocus(false,false)
	
end)

RegisterNUICallback('onCreateMafia', function()
	SendNUIMessage({action = 'disable'})
	SetNuiFocus(false)
	CreateJob("mafia")
end)

RegisterNUICallback('onCreateGang', function()
	SendNUIMessage({action = 'disable'})
	SetNuiFocus(false)
	CreateJob("gang")
end)

RegisterNUICallback('onCreateCartel', function()
	SendNUIMessage({action = 'disable'})
	SetNuiFocus(false)
	CreateJob("cartel")
end)

function CreateJob(type)
	local name = KeyboardInput("~g~Enter Your Mafias Name","",100)
	local id = GetPlayerServerId(NetworkGetEntityOwner(GetPlayerPed(-1)))
	local mafiaexists
	ESX.TriggerServerCallback('esx_Mafia:checkmafiaxp', function(hasxp)
		if hasxp and not mafiaexists then
	TriggerServerEvent('esx:CreateMafiaUser', name, 1, name..'Boss')
	TriggerServerEvent('esx:CreateMafia', name, type, 0)
	Wait(500)
	ESX.TriggerServerCallback('esx_Mafia:isaboss', function(isaboss)
	print(isaboss)
	if isaboss then
	TriggerServerEvent('esx_XpSystem:removecriminalxp', id, Mitsurukis.CriminalXPNeededToCreateMafia)
	TriggerEvent("esx_pushNotification:sendNotificationSUCCES","You Have Successfully Created "..name.." Mafia")
	else 
		TriggerEvent("esx_pushNotification:sendNotificationERROR","This " ..type.. " Already Exists")
	end 
		end)
	end
	end)
end
----instructional button


local function ButtonMessage(text)
	BeginTextCommandScaleformString("STRING")
	AddTextComponentScaleform(text)
    EndTextCommandScaleformString()
end

local function Button(ControlButton)
    N_0xe83a3e3557a56640(ControlButton)
end

local function setupScaleform(scaleform, data)
    local scaleform = RequestScaleformMovie(scaleform)
    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(0)
    end
    PushScaleformMovieFunction(scaleform, "CLEAR_ALL")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_CLEAR_SPACE")
    PushScaleformMovieFunctionParameterInt(math.floor(200))
    PopScaleformMovieFunctionVoid()

    for n, btn in next, data do
        PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
        PushScaleformMovieFunctionParameterInt(math.floor(n-1))
		Button(GetControlInstructionalButton(math.floor(2), btn.control, true))
        ButtonMessage(btn.name)
        PopScaleformMovieFunctionVoid()
    end

    PushScaleformMovieFunction(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_BACKGROUND_COLOUR")
    PushScaleformMovieFunctionParameterInt(math.floor(0))
    PushScaleformMovieFunctionParameterInt(math.floor(0))
    PushScaleformMovieFunctionParameterInt(math.floor(0))
    PushScaleformMovieFunctionParameterInt(math.floor(80))
    PopScaleformMovieFunctionVoid()

    return scaleform
end


function SetInstructions()
    form = setupScaleform("instructional_buttons", entries)
end

function SetInstructionalButton(name, control, enabled)
    local found = false
    for k, entry in next, entries do
        if entry.name == name and entry.control == control then
            found = true
            if not enabled then
                table.remove(entries, k)
                SetInstructions()
            end
            break
        end
    end
    if not found then
        if enabled then
            table.insert(entries, {name = name, control = control})
            SetInstructions()
        end
    end
end

RegisterNetEvent("esx_CreateMafia:showJobNotification")
AddEventHandler("esx_CreateMafia:showJobNotification",function(msg,jobs)

    if jobs then
		for k,v in pairs(jobs) do
        	if ESX.PlayerData.job.name == v then
				ESX.ShowNotification(msg)
				break
			end
		end
    else
        ESX.ShowNotification(msg)
    end

end)