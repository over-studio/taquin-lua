function love.conf(t)
    t.window.title = " Taquin"
    t.console = true
    if DEBUG then
        t.window.width = 1000
    else
        t.window.width = 600
    end
    t.window.height = 600
end