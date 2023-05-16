local LUABACKEND_OFFSET = 0x56454E
local CURRENT_LOCATION_ADDRESS = 0x0714DB8
local ATLANTICA_WORLD_ID = 0x0B
local HUNDRED_ACRE_WORLD_ID = 0x09

local canExecute = false

function _OnInit()
    if GAME_ID == 0x431219CC and ENGINE_TYPE == 'BACKEND' then --PC
        if ENGINE_VERSION < 5.0 then
            ConsolePrint('LuaBackend is outdated. Things might not work properly', 2)
        end

        canExecute = true
    end
end

local function read(address)
    return ReadByte(address - LUABACKEND_OFFSET)
end

local function write(address, value, isLargeInt)
    if isLargeInt then
        return WriteInt(address - LUABACKEND_OFFSET, value)
    end

    return WriteByte(address - LUABACKEND_OFFSET, value)
end

function _OnFrame()
    local world = read(CURRENT_LOCATION_ADDRESS + 0x00)
    if canExecute and world == ATLANTICA_WORLD_ID then
        local finnyFunScore = 0xB63584 -- counts down from 5 to 0, anything below 5 passes
        local excellentChainScore = 0xB63578 -- maximum number of excellents in a row, reset each song
        local atlanticaPoints = 0xB63574 -- used by the tutorial and 5th song

        local NOTES_MAX = 0
        local CHAIN_MAX = 99
        local POINTS_MAX = 999999

        write(finnyFunScore, NOTES_MAX)
        write(excellentChainScore, CHAIN_MAX)
        write(atlanticaPoints, POINTS_MAX, true)
    end
    if canExecute and world == HUNDRED_ACRE_WORLD_ID then
        local pointsAddress = 0x2A0D148 -- used by hunny slider HP
        local hunnyPointsMax = 99

        write(pointsAddress, hunnyPointsMax)
    end
end