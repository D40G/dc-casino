local Slot
local SlotCoords
local ClosestSlot
local ClosestSlotCoord = vector3(0, 0, 0)
local NearbySlot
local EnteredSlot
local SlotObject1
local SlotObject2
local SlotObject3
local Slots = {
    2362925439,
    2775323096,
    3863977906,
    654385216,
    161343630,
    1096374064,
    207578973,
    3807744938
}
local RandomEnter = {
    'enter_left',
    'enter_right',
    'enter_left_short',
    'enter_right_short'
}
local RandomLeave = {
    'exit_left',
    'exit_right'
}
local RandomIdle = {
    'base_idle_a',
    'base_idle_b',
    'base_idle_c',
    'base_idle_d',
    'base_idle_e',
    'base_idle_f'
}
local RandomSpin = {
    'press_spin_a',
    'press_spin_b',
    'pull_spin_a_SLOTMACHINE'
}

local function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

local function SetupSlotMachine()
    RequestModel(3104582536)
    while not HasModelLoaded(3104582536) do Wait(0) end

    local SlotLocation1 = GetObjectOffsetFromCoords(ClosestSlotCoord, GetEntityHeading(ClosestSlot), -0.115, 0.047, 0.906)
    local SlotLocation2 = GetObjectOffsetFromCoords(ClosestSlotCoord, GetEntityHeading(ClosestSlot), 0.005, 0.047, 0.906)
    local SlotLocation3 = GetObjectOffsetFromCoords(ClosestSlotCoord, GetEntityHeading(ClosestSlot), 0.125, 0.047, 0.906)

    SlotObject1 = CreateObject(3104582536, SlotLocation1, false, false, true)
    SlotObject2 = CreateObject(3104582536, SlotLocation2, false, false, true)
    SlotObject3 = CreateObject(3104582536, SlotLocation3, false, false, true)

    FreezeEntityPosition(SlotObject1, true)
    FreezeEntityPosition(SlotObject2, true)
    FreezeEntityPosition(SlotObject3, true)

    SetEntityCollision(SlotObject1, false, false)
    SetEntityCollision(SlotObject2, false, false)
    SetEntityCollision(SlotObject3, false, false)

    SetEntityRotation(SlotObject1, 0.0, 0.0, GetEntityHeading(ClosestSlot), 2, 1)
    SetEntityRotation(SlotObject2, 0.0, 0.0, GetEntityHeading(ClosestSlot), 2, 1)
    SetEntityRotation(SlotObject3, 0.0, 0.0, GetEntityHeading(ClosestSlot), 2, 1)

    SetModelAsNoLongerNeeded(3104582536)
end

local function SlotMachineHandler()
    EnteredSlot = true
    IdleScene = NetworkCreateSynchronisedScene(ClosestSlotCoord, GetEntityRotation(ClosestSlot), 2, 2, 0, 1.0, 0, 1.0)
    RequestAnimDict('anim_casino_a@amb@casino@games@slots@male')
    while not HasAnimDictLoaded('anim_casino_a@amb@casino@games@slots@male') do Wait(0) end
    local RandomAnimName = RandomIdle[math.random(1, #RandomIdle)]
    NetworkAddPedToSynchronisedScene(PlayerPedId(), IdleScene, 'anim_casino_a@amb@casino@games@slots@male', RandomAnimName, 2.0, -1.5, 13, 16, 2.0, 0)
    NetworkStartSynchronisedScene(IdleScene)
    CreateThread(function()
        while true do
            if IsControlJustPressed(0, 202) then
                LeaveScene = NetworkCreateSynchronisedScene(ClosestSlotCoord, GetEntityRotation(ClosestSlot), 2, 2, 0, 1.0, 0, 1.0)
                RequestAnimDict('anim_casino_a@amb@casino@games@slots@male')
                while not HasAnimDictLoaded('anim_casino_a@amb@casino@games@slots@male') do Wait(0) end
                local RandomAnimName = RandomLeave[math.random(1, #RandomLeave)]
                NetworkAddPedToSynchronisedScene(PlayerPedId(), LeaveScene, 'anim_casino_a@amb@casino@games@slots@male', RandomAnimName, 2.0, -1.5, 13, 16, 2.0, 0)
                NetworkStartSynchronisedScene(LeaveScene)
                Wait(GetAnimDuration('anim_casino_a@amb@casino@games@slots@male', RandomAnimName) * 1000)
                DeleteObject(SlotObject1)
                DeleteObject(SlotObject2)
                DeleteObject(SlotObject3)
                NetworkStopSynchronisedScene(LeaveScene)
                EnteredSlot = false
                break
            elseif IsControlJustPressed(0, 201) then
                PullScene = NetworkCreateSynchronisedScene(ClosestSlotCoord, GetEntityRotation(ClosestSlot), 2, 2, 0, 1.0, 0, 1.0)
                RequestAnimDict('anim_casino_a@amb@casino@games@slots@male')
                while not HasAnimDictLoaded('anim_casino_a@amb@casino@games@slots@male') do Wait(0) end
                local RandomAnimName = RandomSpin[math.random(1, #RandomSpin)]
                if RandomAnimName == 'pull_spin_a_SLOTMACHINE' then
                    LeverScene = NetworkCreateSynchronisedScene(ClosestSlotCoord, GetEntityRotation(ClosestSlot), 2, 2, 0, 1.0, 0, 1.0)
                    N_0x45f35c0edc33b03b(LeverScene, GetEntityModel(ClosestSlot), ClosestSlotCoord, 'anim_casino_a@amb@casino@games@slots@male', 'pull_spin_a_SLOTMACHINE', 2.0, -1.5, 13)
                    NetworkStartSynchronisedScene(LeverScene)
                else
                    NetworkAddPedToSynchronisedScene(PlayerPedId(), PullScene, 'anim_casino_a@amb@casino@games@slots@male', RandomAnimName, 2.0, -1.5, 13, 16, 2.0, 0)
                end
                NetworkStartSynchronisedScene(PullScene)
                Wait(GetAnimDuration('anim_casino_a@amb@casino@games@slots@male', RandomAnimName) * 1000)
                print('done')
            end
            Wait(0)
        end
    end)
end

CreateThread(function()
	while true do
        local PlayerCoords = GetEntityCoords(PlayerPedId())
        for i = 1, #Slots do
            Slot = GetClosestObjectOfType(PlayerCoords, 0.9, Slots[i], true)
            if Slot ~= 0 then
                SlotCoords = GetEntityCoords(Slot)
                local CurrentDistance = #(PlayerCoords - SlotCoords)
                if CurrentDistance < 1.8 and CurrentDistance < #(PlayerCoords - ClosestSlotCoord) then
                    NearbySlot = true
                    ClosestSlot = Slot
                    ClosestSlotCoord = SlotCoords
                end
            elseif #(PlayerCoords - ClosestSlotCoord) > 1.8 then
                NearbySlot = false
            end
        end
        Wait(600)
	end
end)

CreateThread(function()
	while true do
        local WaitTime = 500
        if NearbySlot and not EnteredSlot then
            WaitTime = 0
            DrawText3D(ClosestSlotCoord.x, ClosestSlotCoord.y, ClosestSlotCoord.z + 1, "~o~E~w~ - Aight")
            if IsControlJustReleased(0, 38) then
                EnterScene = NetworkCreateSynchronisedScene(ClosestSlotCoord, GetEntityRotation(ClosestSlot), 2, 2, 0, 1.0, 0, 1.0)
                RequestAnimDict('anim_casino_a@amb@casino@games@slots@male')
                while not HasAnimDictLoaded('anim_casino_a@amb@casino@games@slots@male') do Wait(0) end
                local RandomAnimName = RandomEnter[math.random(1, #RandomEnter)]
                NetworkAddPedToSynchronisedScene(PlayerPedId(), EnterScene, 'anim_casino_a@amb@casino@games@slots@male', RandomAnimName, 2.0, -1.5, 13, 16, 2.0, 0)
                NetworkStartSynchronisedScene(EnterScene)
                Wait(GetAnimDuration('anim_casino_a@amb@casino@games@slots@male', RandomAnimName) * 1000)
                SetupSlotMachine()
                SlotMachineHandler()
            end
        end
        Wait(WaitTime)
    end
end)
