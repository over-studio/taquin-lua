require("constants")
require("Case")

local largeur = love.graphics.getWidth()
local hauteur = love.graphics.getHeight()
local pieceSize = 120 -- taille des pièces
local L = hauteur / pieceSize -- nombre de lignes de la grille
local C = largeur / pieceSize -- nombre de colonnes de la grille
local stockPieces = {}
local piecesImage
local quads = {}

function love.load()
    piecesImage = love.graphics.newImage("images/spritesheet.png")

    initPieces()
end

function love.update(dt)
end

function love.draw()
    for i=1, #quads do
        --love.graphics.draw(piecesImage, quads[i], ((i-1) % NB_CASES) * 200, math.floor((i-1) / NB_CASES) * 200)
        quads[i]:draw()
    end
end

function initPieces()
    local newQuad
    for i=1, NB_CASES * NB_CASES - 1 do
        local newCase = case:new("case_" .. i, 
                                ((i-1) % (NB_CASES+1)) * SIZE_PIECE,
                                math.floor((i-1) / (NB_CASES+1)) * SIZE_PIECE, 
                                false, 
                                piecesImage)
        
        --newCase:draw()
        --newQuad = love.graphics.newQuad(((i-1) % (NB_CASES+1)) * SIZE_PIECE, math.floor((i-1) / (NB_CASES+1)) * SIZE_PIECE, SIZE_PIECE, SIZE_PIECE, piecesImage:getDimensions())
        table.insert(quads, newCase)
    end

    --[[local newQuad1 = love.graphics.newQuad(0, 0, 200, 200, piecesImage:getDimensions())
    table.insert(quads, newQuad1)

    local newQuad2 = love.graphics.newQuad(200, 0, 200, 200, piecesImage:getDimensions())
    table.insert(quads, newQuad2)

    local newQuad3 = love.graphics.newQuad(400, 0, 200, 200, piecesImage:getDimensions())
    table.insert(quads, newQuad3)

    local newQuad4 = love.graphics.newQuad(600, 0, 200, 200, piecesImage:getDimensions())
    table.insert(quads, newQuad4)

    local newQuad5 = love.graphics.newQuad(0, 200, 200, 200, piecesImage:getDimensions())
    table.insert(quads, newQuad5)

    local newQuad6 = love.graphics.newQuad(200, 200, 200, 200, piecesImage:getDimensions())
    table.insert(quads, newQuad6)

    local newQuad7 = love.graphics.newQuad(400, 200, 200, 200, piecesImage:getDimensions())
    table.insert(quads, newQuad7)

    local newQuad8 = love.graphics.newQuad(600, 200, 200, 200, piecesImage:getDimensions())
    table.insert(quads, newQuad8)

    local newQuad9 = love.graphics.newQuad(0, 400, 200, 200, piecesImage:getDimensions())
    table.insert(quads, newQuad9)

    local newQuad10 = love.graphics.newQuad(200, 400, 200, 200, piecesImage:getDimensions())
    table.insert(quads, newQuad10)

    local newQuad11 = love.graphics.newQuad(400, 400, 200, 200, piecesImage:getDimensions())
    table.insert(quads, newQuad11)
    --]]

    -- case vide
    table.insert(quads, nil)
end