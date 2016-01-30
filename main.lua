Game = {
  -- Screen configuration
  Screen = {
    -- Coordinate system size
    width = 1920,
    height = 1080,
    -- Scale and offset to fit window
    scale = 1,
    offset_x = 0,
    offset_y = 0,
  },

  -- Debug mode (options are ignored unless "debug" argument is given on command line)
  Debug = {
    draw_actions = true,
    draw_bounding_boxes = true,
  },

  -- Sprites
  Sprites = {
    Pigeon = love.graphics.newImage('assets/pigeon.png')
  },

  -- All pigeons
  Pigeons = {},
  LevelGrid = {},
  Objects = {
      default_constructors = {
          P = PigeonFactory,
      }
  }

}

PigeonFactory = require("src/pigeon")
--blah = require("src/arena")

function love.load(args)
  -- Look for args
  local fullscreen = false
  local debug = false
  for _, arg in ipairs(args) do
    if arg == "fullscreen" then
      fullscreen = true
    elseif arg == "debug" then
      debug = true
    end
  end

  -- Set window size
  local flags = {
    minwidth = 640,
    minheight = 360,
    fullscreen = arg.fullscreen or false,
    vsync = true,
    resizable = true,
  }
  if fullscreen then
    flags.fullscreen = true
    flags.fullscreentype = "desktop"
  end
  love.window.setMode(1280, 720, flags)

  -- Set debug mode
  if not debug then
    Game.Debug = {}
  end

  local level = load_level_file(
  -- Default background color
  love.graphics.setBackgroundColor(255, 255, 255)

    -- initialise pigeons
    local pigeons = Game.Pigeons
    for i = 1, 5 do
      pigeons[#pigeons + 1] = PigeonFactory(i * 50, i * 50)
    end
end

function love.update(dt)
  -- Update the screen scale to match the window
  Game.Screen.scale = love.graphics.getWidth() / Game.Screen.width
  Game.Screen.offset_x = (love.graphics.getWidth() - (Game.Screen.width * Game.Screen.scale)) / 2
  Game.Screen.offset_y = (love.graphics.getHeight() - (Game.Screen.height * Game.Screen.scale)) / 2

    -- update pigeons
    for i, pigeon in ipairs(Game.Pigeons) do
      pigeon:update(Game, dt)
    end
end

function love.draw(dt)
  love.graphics.push()
  love.graphics.translate(Game.Screen.offset_x, Game.Screen.offset_y)
  love.graphics.scale(Game.Screen.scale, Game.Screen.scale)

    -- draw pigeons
    for i, pigeon in ipairs(Game.Pigeons) do
      pigeon:draw(Game, dt)
    end
    --love.graphics.draw(blah)

  love.graphics.pop()
end

function love.keypressed(key, isrepeat)
  if key == 'escape' then
    love.event.quit()
  end
end

function love.mousepressed(x, y, button, istouch)
  -- Convert coordinates into game space
    local mouseX = x / Game.Screen.scale
    local mouseY = y / Game.Screen.scale

    local pigeonWidth = Game.Sprites.Pigeon:getWidth()
    local pigeonHeight = Game.Sprites.Pigeon:getHeight()

    -- check each pigeon's position relative to the mouse
    for i, pigeon in ipairs(Game.Pigeons) do

        local pigeonLeft = pigeon.x
        local pigeonTop = pigeon.y
        local pigeonRight = pigeon.x + pigeonWidth
        local pigeonBottom = pigeon.y + pigeonHeight
        local pigeonCentreX = pigeon.x + (pigeonWidth / 2)
        local pigeonCentreY = pigeon.y + (pigeonHeight / 2)
        
        if pigeonFeedByRadius then
        
            -- check if the pigeon is within the feed range
            local distanceFromMouse = ((mouseX-pigeonCentreX)^2+(mouseY-pigeonCentreY)^2)^0.5
            print(distanceFromMouse)
                
            if distanceFromMouse <= pigeonFeedRadius then
            
                -- feed the pigeon
                pigeon:feed()
            
            end
        
        else
        
            if (mouseX > pigeonLeft) and (mouseX < pigeonRight) and
                (mouseY > pigeonTop) and (mouseX < pigeonBottom) then
               
                -- feed the pigeon under the cursor
                pigeon:feed()
               
            end
        
        end

    end

  -- Spawn a new pigeon there
  -- local pigeons = Game.Pigeons
  -- pigeons[#pigeons + 1] = PigeonFactory(
  --   x - pigeonWidth / 2,
  --  y - Game.Sprites.Pigeon:getHeight() / 2)
end



function math.dist(x1,y1, x2,y2) return ((x2-x1)^2+(y2-y1)^2)^0.5 end
