require("constants")
require("Case")

local stockPieces = {}
local piecesImage -- image utilisée
local pieces = {} -- tableau dans lequel on va stocker toutes les cases
local wImg -- largeur de l'image
local hImg -- hauteur de l'image

local vide = {}
vide.I = nil -- id de la case vide courante
vide.H = nil -- id de la case qui se trouve en haut de la case vide si elle existe
vide.B = nil -- id de la case qui se trouve en bas de la case vide si elle existe
vide.G = nil -- id de la case qui se trouve à gauche de la case vide si elle existe
vide.D = nil -- id de la case qui se trouve à droite de la case vide si elle existe

function love.load()
    piecesImage = love.graphics.newImage(PATH_SPRITESHEET)
    wImg, hImg = piecesImage:getDimensions()
    
    createPieces()
    placerPieces()
    pieces[6].id = 15
    pieces[15].id = 6
    print("--------")
    placerPieces()
    --melanger()
end

function love.update(dt)
    --placerPieces()
end

function love.draw()
    drawPieces()

    --[[
    local sDebug = ""
    local c, posX, posY
    for i=1, #pieces do
        c = pieces[i]
        posX = ((c.id-1) % NB_CASES) * SIZE_PIECE
        posY = math.floor((c.id-1) / NB_CASES) * SIZE_PIECE
        sDebug = sDebug .. c.id .. " (" .. posX .."," .. posY .. ")", c.x+10, c.y+10
    end
    love.graphics.print(sDebug, 620, 20)
    --]]
end

function createPieces()
    local case
    for i=1, NB_CASES * NB_CASES do
        case = {}
        case.correct = i
        case.id = i
        --case.x = ((i-1) % NB_CASES) * SIZE_PIECE
        --case.y = math.floor((i-1) / NB_CASES) * SIZE_PIECE
        case.size = SIZE_PIECE
        --case.depart = false
        case.image = piecesImage
        --case.alpha = 1
        table.insert(pieces, case)
    end

    vide.I = #pieces

    -- définir la dernière case comme case vide
    --pieces[#pieces].alpha = 0
    --pieces[#pieces].depart = true
    
    -- ajouter une case vide
    --table.insert(pieces, nil)
end

function placerPieces()
    for i=1, NB_CASES * NB_CASES do
        pieces[pieces[i].id].x = ((pieces[i].id-1) % NB_CASES) * SIZE_PIECE
        pieces[pieces[i].id].y = math.floor((pieces[i].id-1) / NB_CASES) * SIZE_PIECE
        -- print(pieces[i].id, pieces[i].x, pieces[i].y)
    end
end

function drawPieces()
    local c, posX, posY
    for i=1, #pieces do
        c = pieces[i]
        
        posX = ((c.id-1) % NB_CASES) * SIZE_PIECE
        posY = math.floor((c.id-1) / NB_CASES) * SIZE_PIECE
        
        local quad = love.graphics.newQuad(posX, posY, c.size, c.size, wImg, hImg)
        love.graphics.draw(c.image, quad, posX, posY)
        
        --love.graphics.setColor(255, 255, 255, 50)
        --love.graphics.print("(" .. c.id .. "," .. tostring(c.depart) .. ", " .. c.x .."," .. c.y .. ")", c.x+10, c.y+10)
        love.graphics.print(c.id .. " (" .. posX .."," .. posY .. ")", c.x+10, c.y+10)
    end
end

function melanger()
    local P
    local X 
    local Y
    local E
    local i
    local S = false

    for i=1, #pieces do
        if pieces[i].alpha == 0 then
            P = pieces[i]
            E = pieces[i].id
            X = pieces[i].x / SIZE_PIECE + 1
            Y = pieces[i].y / SIZE_PIECE + 1
            --print(P,E,X,Y)
            break
        end
    end

    for i=1, #pieces do
        if pieces[i].depart == false then
            return
        end
    end

    print("ID", "D", "X-1", "Y-1", "E")
    print("-------------------------------------")
    for i=1, #pieces do
        if pieces[i] ~= P and pieces[i].depart == false then
            local rand = math.random() * 4 + 1
            D = rand - rand % 1
            print(pieces[i].id, D, X-1, Y-1, E)
            if (D==1 and X-1>=0) then deplacer(pieces[E-1]) end
			if (D==2 and X+1<=NB_CASES) then deplacer(pieces[E+1]) end
			if (D==3 and Y+1<=NB_CASES) then deplacer(pieces[E+NB_CASES]) end
			if (D==4 and Y-1>=0) then deplacer(pieces[E-NB_CASES]) end
        end
    end
end

function deplacer(P)
    -- recherche le clip invisible
	local I = 0;
	local V;
	for i=1, #pieces do
		if(pieces[i].alpha == 0) then
			I = pieces[i].id
            V = pieces[i]
            --print(I, V)
        end
    end
	-- vérifie si la tuile est à coté et inverse les index
	local D = P.id;
	--if((math.floor(V.x/SIZE_PIECE)==NB_CASES-1 and D==I+1)) then return end
	--if((math.floor(V.x/SIZE_PIECE)==0 and D==I-1)) then return end
    if(D==I+1 or D==I+NB_CASES or D==I-NB_CASES or D==I-1) then
        --print("ok")
		pieces[D] = pieces[I]
		pieces[I] = P
		if (not pieces[I].depart) then pieces[I].depart=true end
		placerPieces()
		--sonBloc.play();
    end
    --print("déplacé")
end

function love.keypressed(key)
    pieces[6].id = 15
    pieces[15].id = 6
end
