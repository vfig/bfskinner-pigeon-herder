--
-- Level loader for "B.F. Skinner, Pigeon Herder"
-- Sat 30 Jan 05:25:33 GMT 2016

--[[
--This details the level map format

   A map is a simple ASCII grid, layed out as follows

   ^-------------
   |#############
   |#############
   |######S######
   |###B#########
   |#P###########
   --------------

For each square on the grid in the map, The given ASCII character is looked up in the engine's `map_items` module, and indexed for the given character.
If the given character's key exists in the table its value (any callable) is called with the tuple (x, y, existing_constructors).
The called function is expected to return a new Game object which is the placed on a new grid at the same coordinate

The following items are predefined and can be overriden:

    | or -: Wall. It's a wall.
    Pen: Spawns Pigeons.
    O: Pit. Probably bottomless. Fuck you.
    $: Powerup. A steaming hot babe with huge money.
    *: Whirling blades of death. Fuck you again.
]]

local function parse_map(lines)
    -- given a map string `map_s` parse as a multidimensional array
    -- with the origin (top-left) as the single caret character
    -- leading whitespace is stripped
    local rows = {}
    local columns = {}
    local size = 0
    for line in lines do
        local row = {}
        rows[#rows + 1] = row
        print("LINE", line)
        for char in line:gmatch(".") do
            print(#rows+1, char)
            row[#row + 1] = char
            size = size + 1
        end
    end
    
    return rows, size
end


local function load_level_file(level_name)
    -- load a level file and return a level object which contains the raw
    -- lua chunk
    local fs = love.filesystem
    return pcall(parse_map, fs.lines(level_name))
    --local predefined = predefined or {}
    --local success, chunk = pcall(fs.load, level_name)
    --print(success, chunk, level_name)

    --if not success then return success, chunk end

    --return pcall(chunk(game_ctx))
end


local function construct_level(level_cfg, map_grid, size, default_constructors)
    --level_cfg.constructors = level_cfg.map_items or function() end
    local level = {}
    
    --[[-- for x, row in ipairs(map_grid) do
        level[x] = {}
        for y, char in ipairs(row) do
            local success, obj = pcall(level_cfg.constructors, x, y, default_constructors)
            level[x][y] = success and obj or level_cfg.objects.default
        end
    end --]]--
    level.map_grid = level_cfg
    level.size = size
    return level
end


return function(game_ctx, level_name)
    local success, level_cfg, size = load_level_file(level_name)
    print(success, level_cfg)
    return construct_level(level_cfg, map_grid, size, game_ctx.objects.default_constructors)
end