-- Configuration
function love.conf(t)
    t.title = [[B.F. Skinner: Pigeon Herder (LEGITIMATE PIGEON SIMULATOR)]]
    t.version = "0.10.0"
    -- This is just the initial window size; it is readjusted in main.lua
    t.window = {
        width = 640,
        height = 480,
   }
    -- For Windows debugging
    t.console = true
end
