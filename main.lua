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

math.randomseed( os.time() )

function love.load()
    piecesImage = love.graphics.newImage(PATH_SPRITESHEET)
    wImg, hImg = piecesImage:getDimensions()
    
    createPieces()
    placerPieces()
    --inversePieces(2,16)
    --pieces[2].id = 15
    --pieces[15].id = 2
    --print("--------")
    --placerPieces()

    
    --inversePieces(8,10)
    --inversePieces(2,11)
    --inversePieces(11,5)
    --inversePieces(5,7)

    --melanger()

    directionCaseVide()
    melangerCases()
end

function love.update(dt)
    --melanger()
    placerPieces()
end

function love.draw()
    drawPieces()

    
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

function createPieces()
    local case
    for i=1, NB_CASES * NB_CASES do
        case = {}
        case.correct = i
        case.id = i
        case.x = ((i-1) % NB_CASES) * SIZE_PIECE
        case.y = math.floor((i-1) / NB_CASES) * SIZE_PIECE
        case.xTex = ((i-1) % NB_CASES) * SIZE_PIECE
        case.yTex = math.floor((i-1) / NB_CASES) * SIZE_PIECE
        case.size = SIZE_PIECE
        case.depart = false
        case.image = piecesImage
        case.alpha = 1
        table.insert(pieces, case)
    end

    --vide.I = #pieces

    -- définir la dernière case comme case vide
    local caseVide = pieces[#pieces]
    caseVide.alpha = 0
    caseVide.depart = true
    
    -- ajouter une case vide
    --table.insert(pieces, nil)
end

function placerPieces()
    for i=1, NB_CASES * NB_CASES do
        pieces[i].x = ((i-1) % NB_CASES) * SIZE_PIECE
        pieces[i].y = math.floor((i-1) / NB_CASES) * SIZE_PIECE
        -- print(pieces[i].id, pieces[i].x, pieces[i].y)

        if pieces[i].alpha == 0 then idVide = i end
    end
    directionCaseVide()
end

function drawPieces()
    local c, posX, posY
    for i=1, #pieces do
        c = pieces[i]
        
        posX = ((i-1) % NB_CASES) * SIZE_PIECE
        posY = math.floor((i-1) / NB_CASES) * SIZE_PIECE
        
        local quad = love.graphics.newQuad(c.xTex, c.yTex, c.size, c.size, wImg, hImg)
        love.graphics.draw(c.image, quad, c.x, c.y)
        
        --love.graphics.setColor(255, 255, 255, 50)
        --love.graphics.print("(" .. c.id .. "," .. tostring(c.depart) .. ", " .. c.x .."," .. c.y .. ")", c.x+10, c.y+10)
        love.graphics.print(i .. " | id=" .. c.id .. " (" .. c.x .."," .. c.y .. "), " .. tostring(c.alpha), c.x+10, c.y+10)
        if i == idVide then
            love.graphics.print("ID = " .. tostring(idVide), c.x+10, c.y+30)
            love.graphics.print("H = " .. tostring(H), c.x+10, c.y+50)
            love.graphics.print("B = " .. tostring(B), c.x+10, c.y+70)
            love.graphics.print("G = " .. tostring(G), c.x+10, c.y+90)
            love.graphics.print("D = " .. tostring(D), c.x+10, c.y+110)
        end
    end
end

function melanger()
    local vide = {}
    local P
    local X 
    local Y
    local E
    local i
    local S = false

    for i=1, #pieces do
        if pieces[i].alpha == 0 then
            vide.P = pieces[i]
            vide.E = pieces[i].id
            vide.X = pieces[i].x / SIZE_PIECE + 1
            vide.Y = pieces[i].y / SIZE_PIECE + 1
            --print(P,E,X,Y)
            break
        end
    end

    for i=1, #pieces do
        if pieces[i].depart == false then
            --return
        end
    end

    print("ID", "D", "X-1", "Y-1", "E")
    print("-------------------------------------")
    for i=1, #pieces do
        if pieces[i] ~= vide.P and pieces[i].depart == false then
            local rand = math.random() * 4 + 1
            vide.D = rand - rand % 1
            print(pieces[i].id, vide.D, vide.X-1, vide.Y-1, vide.E)
            if (vide.D==1 and vide.X-1>=0) then deplacer(pieces[vide.E-1]) end
			if (vide.D==2 and vide.X+1<=NB_CASES) then deplacer(pieces[vide.E+1]) end
			if (vide.D==3 and vide.Y+1<=NB_CASES) then deplacer(pieces[vide.E+NB_CASES]) end
			if (vide.D==4 and vide.Y-1>=0) then deplacer(pieces[vide.E-NB_CASES]) end
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
    if key == "up" and B ~= nil then inversePieces(idVide, B) end
    if key == "down" and H ~= nil then inversePieces(idVide, H) end
    if key == "left" and D ~= nil then inversePieces(idVide, D) end
    if key == "right" and G ~= nil then inversePieces(idVide, G) end

    if key == "m" then
        local rand
        local c

        -- choisir un nombre alétoire entre 1 et 4
        rand = math.random(1,4)
        --rand = rand - rand % 1
        
        if rand == 1 then c = B end
        if rand == 2 then c = H end
        if rand == 3 then c = D end
        if rand == 4 then c = G end

        --print(rand, idVide, c)
        if c ~= nil then inversePieces(idVide, c) end
    end
end

function inversePieces(p1, p2)
    --if pieces[p1].alpha == 0 then idVide = p2 end
    --if pieces[p2].alpha == 0 then idVide = p1 end

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
    for i=1, 500 do
        c = nil
        -- choisir un nombre alétoire entre 1 et 4
        while c == nil do
            rand = math.random(1,4)
            --rand = rand - rand % 1
            --print(H, B, G, D)
            if rand == 1 then c = H end
            if rand == 2 then c = B end
            if rand == 3 then c = G end
            if rand == 4 then c = D end

            if c ~= nil then print("tour "..i.."\t\t", rand, idVide, c); inversePieces(idVide, c) end
            placerPieces()
        end
        
    end
end