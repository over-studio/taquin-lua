require("constants")
require("Case")

local piecesImage -- image utilisée
local pieces = {} -- tableau dans lequel on va stocker toutes les cases
local wImg -- largeur de l'image
local hImg -- hauteur de l'image

local idVide -- ID de la case vide
local H -- id de la case qui se trouve en haut de la case vide si elle existe
local B -- id de la case qui se trouve en bas de la case vide si elle existe
local G -- id de la case qui se trouve à gauche de la case vide si elle existe
local D -- id de la case qui se trouve à droite de la case vide si elle existe

local partieGagne = false -- définie à TRUE si le joueur arrive à remettre en place toutes les cases

local mainSound = love.audio.newSource(MAIN_SOUND, "static")

math.randomseed( os.time() )

function love.load()
    mainSound:play()
    mainFont = love.graphics.newFont(PATH_MAIN_FONT, 30)
    -- spritesheet
    if DEBUG then
        piecesImage = love.graphics.newImage(PATH_SPRITESHEET_DEBUG)
    else
        piecesImage = love.graphics.newImage(PATH_SPRITESHEET)
    end
    -- dimensions de spritesheet
    wImg, hImg = piecesImage:getDimensions()
    -- créer les cases
    createPieces()
    -- placer toutes les cases sur le stage
    placerPieces()
    -- définir les directions possibles pour la case vide
    directionCaseVide()
    -- melanger les cases
    melangerCases()
end

function love.update(dt)
    placerPieces()
end

function love.draw()
    drawPieces()
    if DEBUG then drawDebug() end
end

function createPieces()
    local case
    for i=1, NB_CASES * NB_CASES do
        case = {}
        case.correct = i
        case.id = i
        case.xTex = ((i-1) % NB_CASES) * SIZE_PIECE
        case.yTex = math.floor((i-1) / NB_CASES) * SIZE_PIECE
        case.image = piecesImage
        case.alpha = 1
        table.insert(pieces, case)
    end

    -- définir la dernière case comme case vide
    local caseVide = pieces[#pieces]
    caseVide.alpha = 0
end

function placerPieces()
    for i=1, NB_CASES * NB_CASES do
        pieces[i].x = ((i-1) % NB_CASES) * SIZE_PIECE
        pieces[i].y = math.floor((i-1) / NB_CASES) * SIZE_PIECE

        if pieces[i].alpha == 0 then idVide = i end
    end

    -- redéfinir les directions possibles à partir de la case vide
    directionCaseVide()
end

function drawPieces()
    if not partieGagne then
        local c, posX, posY
        for i=1, #pieces do
            c = pieces[i]
            
            posX = ((i-1) % NB_CASES) * SIZE_PIECE
            posY = math.floor((i-1) / NB_CASES) * SIZE_PIECE
            
            if c.id ~= #pieces then
                local quad = love.graphics.newQuad(c.xTex, c.yTex, SIZE_PIECE-4, SIZE_PIECE-4, wImg, hImg)
                love.graphics.draw(c.image, quad, c.x+2, c.y+2)
            end
            
            -- Debug
            if DEBUG then 
                --love.graphics.print(i .. " | id=" .. c.id .. " (" .. c.x .."," .. c.y .. "), " .. tostring(c.alpha), c.x+10, c.y+10)
                love.graphics.print(i .. " | id=" .. c.id .. " | " .. tostring(c.alpha), c.x+10, c.y+10)
                if i == idVide then
                    --love.graphics.print("ID = " .. tostring(idVide), c.x+10, c.y+30)
                    love.graphics.print("H = " .. tostring(H), c.x+50, c.y+50)
                    love.graphics.print("B = " .. tostring(B), c.x+50, c.y+120)
                    love.graphics.print("G = " .. tostring(G), c.x+10, c.y+80)
                    love.graphics.print("D = " .. tostring(D), c.x+95, c.y+80)
                end
            end 
        end
    else
        love.graphics.setFont(mainFont)
        love.graphics.print("Brabo!\nPartie gangee", 120, HAUTEUR/2-50)
    end
end

function love.keypressed(key)
    if key == "up" and B ~= nil then inversePieces(idVide, B) end
    if key == "down" and H ~= nil then inversePieces(idVide, H) end
    if key == "left" and D ~= nil then inversePieces(idVide, D) end
    if key == "right" and G ~= nil then inversePieces(idVide, G) end
    -- tester si la partie est terminée
    gagne()
end

function inversePieces(p1, p2)
    local temp = pieces[p1]
    pieces[p1] = pieces[p2]
    pieces[p2] = temp
end

-- définir les directions possibles pour la case vide
function directionCaseVide()
    local L = pieces[idVide].y / SIZE_PIECE + 1
    local C = pieces[idVide].x / SIZE_PIECE + 1

    -- Bas
    if L > 1 then
        H = idVide - NB_CASES
    else
        H = nil
    end

    -- Haut
    if L < NB_CASES then
        B = idVide + NB_CASES
    else
        B = nil
    end

    -- Droite
    if C > 1 then
        G = idVide - 1
    else
        G = nil
    end

    -- Gauche
    if C < NB_CASES then
        D = idVide + 1
    else
        D = nil
    end
end

function melangerCases()
    local rand
    local c
    for i=1, NB_MELANGE do
        c = nil
        -- choisir un nombre alétoire entre 1 et 4
        while c == nil do
            rand = math.random(1,4)

            if rand == 1 then c = H end
            if rand == 2 then c = B end
            if rand == 3 then c = G end
            if rand == 4 then c = D end

            if c ~= nil then 
                print("tour "..i.."\t\t", rand, idVide, c)
                inversePieces(idVide, c)
            end
            placerPieces()
        end
        
    end
end

function drawDebug()
    local sDebug = ""
    sDebug = sDebug .. "ID" .. "\t\t\t" .. "POS" .. "\t\t\t" .. "Vide" .. "\n"
    sDebug = sDebug .. "----------------------------\n"
    local c, posX, posY
    for i=1, #pieces do
        c = pieces[i]
        posX = ((i-1) % NB_CASES) * SIZE_PIECE
        posY = math.floor((i-1) / NB_CASES) * SIZE_PIECE
        if c.id < 10 then idd = "0" .. c.id; else idd = c.id end
        sDebug = sDebug .. idd .. "\t\t" .. " (" .. posX .."," .. posY .. ")" .. "\t\t\t" .. c.alpha .. "\n"
    end
    love.graphics.print(sDebug, 620, 20)
end

function gagne()
    local counter = 0
    for i=1, #pieces do
        if i == pieces[i].id then
            counter = counter + 1
        end
    end

    if counter == #pieces then
        partieGagne = true
        print("Bravo! Partie gagnée!")
    end
end