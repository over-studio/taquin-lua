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
local wImg
local hImg

function love.load()
    piecesImage = love.graphics.newImage(PATH_SPRITESHEET)
    wImg, hImg = piecesImage:getDimensions()
    createPieces()
end

function love.update(dt)
end

function love.draw()
    drawPieces()
end

function createPieces()
    local i = 1
    local factory
    local newCase
    factory = createPiece()
    for i=1, NB_CASES * NB_CASES do
        newCase = factory()
        table.insert(quads, newCase)
    end

    -- case vide
    table.insert(quads, nil)
end

function createPiece(num)
    local num = 1
    return function()
        local newCase = case:new( num, 
                                ((num-1) % NB_CASES) * SIZE_PIECE, 
                                math.floor((num-1) / NB_CASES) * SIZE_PIECE, 
                                SIZE_PIECE, 
                                false, 
                                piecesImage)
        num = num + 1
        print(newCase.id, newCase.x, newCase.y)

        return newCase
    end
end

function drawPieces()
    for i=1, #quads do
        quads[i]:draw()
    end
end

function love.keypressed(key)
    for i=1, #quads do
        print(quads[i].id)
    end
end