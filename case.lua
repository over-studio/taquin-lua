case = {}

case.new = function(self, id, x, y, size, isEmpty, img)
    local self = self or {}

    self.id = id
    self.x = x
    self.y = y
    self.size = size
    self.image = img
    self.empty = isEmpty
    
    -- mem,der functions
    self.draw = function()
        local quad = love.graphics.newQuad(self.x, self.y, self.size, self.size, self.image:getDimensions())
        love.graphics.draw(self.image, quad, self.x, self.y)
    end

    return self
end