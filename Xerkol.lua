--[[
    UI para Delta inspirada en la librería que compartiste.
    Diseño oscuro, pestañas izquierda, secciones y controles a la derecha.
    Requiere: Delta executor con Drawing library.
]]

local Drawing = Drawing or (getrenv and getrenv().Drawing)
if not Drawing then return end

local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")

-- ================== COLORES (extraídos de la librería) ==================
local C = {
    mainBg      = Color3.fromRGB(31, 25, 44),
    tabFrameBg  = Color3.fromRGB(18, 15, 24),
    topBarBg    = Color3.fromRGB(18, 15, 24),
    btnBg       = Color3.fromRGB(53, 50, 74),
    accent      = Color3.fromRGB(228, 197, 255),   -- lila claro
    text        = Color3.fromRGB(227, 227, 227),
    textDim     = Color3.fromRGB(140, 140, 140),
    toggleOn    = Color3.fromRGB(130, 200, 130),
    toggleOff   = Color3.fromRGB(100, 80, 100),
    closeBtn    = Color3.fromRGB(255, 100, 100),
    shadow      = Color3.fromRGB(0, 0, 0),
}

-- ================== CONFIGURACIÓN DE VENTANA ==================
local WIN_W, WIN_H = 454, 333          -- igual que la librería
local X, Y = 200, 150                  -- posición inicial
local TITLE_H = 45
local TAB_W = 134
local PADDING = 6
local RADIUS = 7                       -- radio de esquinas

-- ================== ALMACENAMIENTO ==================
local allDraws = {}    -- dibujos permanentes
local connections = {} -- eventos
local tempDraws = {}   -- dibujos de la pestaña activa
local tempConns = {}   -- eventos de la pestaña activa

local function addPerm(d)
    table.insert(allDraws, d)
    return d
end
local function addTemp(d)
    table.insert(tempDraws, d)
    return d
end
local function addConn(c)
    table.insert(connections, c)
    return c
end
local function addTempConn(c)
    table.insert(tempConns, c)
    return c
end

-- Limpia el contenido dinámico al cambiar de pestaña
local function clearTemp()
    for _, d in ipairs(tempDraws) do
        if d.Remove then d:Remove() end
    end
    for _, c in ipairs(tempConns) do
        c:Disconnect()
    end
    tempDraws = {}
    tempConns = {}
end

-- ================== RECTÁNGULO REDONDEADO ==================
local function roundedRect(x, y, w, h, color, radius)
    local group = {}
    -- Rectángulos planos
    local rect = Drawing.new("Square")
    rect.Size = Vector2.new(w - radius*2, h)
    rect.Position = Vector2.new(x + radius, y)
    rect.Color = color
    rect.Filled = true
    rect.Visible = true
    table.insert(group, rect)

    local top = Drawing.new("Square")
    top.Size = Vector2.new(w - radius*2, radius)
    top.Position = Vector2.new(x + radius, y)
    top.Color = color
    top.Filled = true
    top.Visible = true
    table.insert(group, top)

    local bottom = Drawing.new("Square")
    bottom.Size = Vector2.new(w - radius*2, radius)
    bottom.Position = Vector2.new(x + radius, y + h - radius)
    bottom.Color = color
    bottom.Filled = true
    bottom.Visible = true
    table.insert(group, bottom)

    -- Círculos esquina
    local corners = {
        {x + radius, y + radius},
        {x + w - radius, y + radius},
        {x + radius, y + h - radius},
        {x + w - radius, y + h - radius},
    }
    for _, pos in ipairs(corners) do
        local c = Drawing.new("Circle")
        c.Radius = radius
        c.Position = Vector2.new(pos[1], pos[2])
        c.Color = color
        c.Filled = true
        c.Visible = true
        table.insert(group, c)
    end
    return group
end

-- ================== CREAR VENTANA BASE ==================
-- Sombra (opcional)
local shadowGroup = roundedRect(X+2, Y+2, WIN_W, WIN_H, C.shadow, RADIUS)
for _, d in ipairs(shadowGroup) do addPerm(d) end

-- Fondo principal
local mainGroup = roundedRect(X, Y, WIN_W, WIN_H, C.mainBg, RADIUS)
for _, d in ipairs(mainGroup) do addPerm(d) end

-- Barra de título
local titleGroup = roundedRect(X, Y, WIN_W, TITLE_H, C.topBarBg, RADIUS)
for _, d in ipairs(titleGroup) do addPerm(d) end

-- Texto del título
local titleText = addPerm(Drawing.new("Text"))
titleText.Text = "IIGOS"
titleText.Size = 18
titleText.Position = Vector2.new(X + 15, Y + 8)
titleText.Color = C.text
titleText.Visible = true

local versionText = addPerm(Drawing.new("Text"))
versionText.Text = "V0.01"
versionText.Size = 11
versionText.Position = Vector2.new(X + WIN_W - 45, Y + 28)
versionText.Color = C.textDim
versionText.Visible = true

-- Botón minimizar [–]
local minBtn = addPerm(Drawing.new("Square"))
minBtn.Size = Vector2.new(20, 20)
minBtn.Position = Vector2.new(X + WIN_W - 50, Y + 12)
minBtn.Color = C.btnBg
minBtn.Filled = true
minBtn.Visible = true

local minLabel = addPerm(Drawing.new("Text"))
minLabel.Text = "–"
minLabel.Size = 16
minLabel.Position = Vector2.new(X + WIN_W - 40, Y + 10)
minLabel.Color = C.text
minLabel.Center = true
minLabel.Visible = true

-- Botón cerrar [×]
local closeBtn = addPerm(Drawing.new("Square"))
closeBtn.Size = Vector2.new(20, 20)
closeBtn.Position = Vector2.new(X + WIN_W - 24, Y + 12)
closeBtn.Color = C.closeBtn
closeBtn.Filled = true
closeBtn.Visible = true

local closeLabel = addPerm(Drawing.new("Text"))
closeLabel.Text = "×"
closeLabel.Size = 16
closeLabel.Position = Vector2.new(X + WIN_W - 14, Y + 10)
closeLabel.Color = C.text
closeLabel.Center = true
closeLabel.Visible = true

-- ================== SIDEBAR (PESTAÑAS) ==================
local sidebarX = X + 9
local sidebarY = Y + TITLE_H + 6
local sidebarW = TAB_W - 2
local sidebarH = WIN_H - TITLE_H - 12

-- Fondo de la sidebar
local sidebarBg = roundedRect(sidebarX, sidebarY, sidebarW, sidebarH, C.tabFrameBg, RADIUS)
for _, d in ipairs(sidebarBg) do addPerm(d) end

-- Pestañas
local tabs = {"Combat", "Visuals", "Misc", "Info"}
local tabBtns = {}
local activeTab = 1

-- Área de contenido
local contentX = X + TAB_W + 15
local contentY = sidebarY
local contentW = WIN_W - TAB_W - 24
local contentH = sidebarH

for i, name in ipairs(tabs) do
    local btnY = sidebarY + 12 + (i-1) * 44
    local btnW = sidebarW - 24
    local btnH = 25

    local bg = addPerm(Drawing.new("Square"))
    bg.Size = Vector2.new(btnW, btnH)
    bg.Position = Vector2.new(sidebarX + 12, btnY)
    bg.Color = (i == activeTab) and C.btnBg or C.tabFrameBg
    bg.Filled = true
    bg.Visible = true

    local label = addPerm(Drawing.new("Text"))
    label.Text = name
    label.Size = 13
    label.Position = Vector2.new(sidebarX + 12 + btnW/2, btnY + 4)
    label.Color = C.text
    label.Center = true
    label.Visible = true

    tabBtns[i] = {bg = bg, label = label}
end

-- ================== FUNCIONES DE CADA PESTAÑA ==================
local function createToggle(x, y, w, text, initial, callback)
    local group = {}
    local toggleW = 36
    local toggleH = 18
    local toggleX = x + w - toggleW - 5
    local toggleY = y + 3

    -- Track
    local track = Drawing.new("Square")
    track.Size = Vector2.new(toggleW, toggleH)
    track.Position = Vector2.new(toggleX, toggleY)
    track.Color = initial and C.toggleOn or C.toggleOff
    track.Filled = true
    track.Visible = true
    addTemp(track)
    table.insert(group, track)

    -- Knob
    local knobR = 7
    local knob = Drawing.new("Circle")
    knob.Radius = knobR
    knob.Position = Vector2.new(toggleX + (initial and (toggleW - knobR*2 - 2) or 3) + knobR, toggleY + toggleH/2)
    knob.Color = Color3.fromRGB(255, 255, 255)
    knob.Filled = true
    knob.Visible = true
    addTemp(knob)
    table.insert(group, knob)

    -- Etiqueta
    local label = Drawing.new("Text")
    label.Text = text
    label.Size = 13
    label.Position = Vector2.new(x, y)
    label.Color = C.text
    label.Visible = true
    addTemp(label)
    table.insert(group, label)

    -- Estado
    local state = {on = initial}

    -- Evento
    local conn = addTempConn(UIS.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local mp = UIS:GetMouseLocation()
            if mp.X >= toggleX and mp.X <= toggleX + toggleW
               and mp.Y >= toggleY and mp.Y <= toggleY + toggleH then
                if track.Visible then
                    state.on = not state.on
                    track.Color = state.on and C.toggleOn or C.toggleOff
                    knob.Position = Vector2.new(toggleX + (state.on and (toggleW - knobR*2 - 2) or 3) + knobR, toggleY + toggleH/2)
                    if callback then callback(state.on) end
                end
            end
        end
    end))

    return group
end

local function createButton(x, y, w, text, callback)
    local h = 26
    local bg = Drawing.new("Square")
    bg.Size = Vector2.new(w, h)
    bg.Position = Vector2.new(x, y)
    bg.Color = C.btnBg
    bg.Filled = true
    bg.Visible = true
    addTemp(bg)

    local label = Drawing.new("Text")
    label.Text = text
    label.Size = 13
    label.Position = Vector2.new(x + 5, y + 4)
    label.Color = C.text
    label.Visible = true
    addTemp(label)

    local conn = addTempConn(UIS.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local mp = UIS:GetMouseLocation()
            if mp.X >= x and mp.X <= x + w and mp.Y >= y and mp.Y <= y + h then
                if bg.Visible and callback then callback() end
            end
        end
    end))

    return {bg, label}
end

local function createSectionTitle(x, y, title)
    local txt = Drawing.new("Text")
    txt.Text = title
    txt.Size = 12
    txt.Position = Vector2.new(x, y)
    txt.Color = C.accent
    txt.Font = 2  -- negrita
    txt.Visible = true
    addTemp(txt)
    return txt
end

-- ================== DEFINICIÓN DE CONTENIDO POR PESTAÑA ==================
local contentByTab = {
    Combat = function()
        local y = contentY + 10
        createSectionTitle(contentX, y, "GUN GRAB")
        y += 18
        createToggle(contentX, y, contentW, "Auto Grab Gun", false)
        y += 35
        createButton(contentX, y, contentW, "Grab gun", function() print("Grab gun") end)
        y += 35

        y += 10
        createSectionTitle(contentX, y, "EXPERIMENTAL")
        y += 18
        createToggle(contentX, y, contentW, "BombJump", false)
        y += 35
        createToggle(contentX, y, contentW, "Sans (second chance)", false)
    end,
    Visuals = function()
        local y = contentY + 10
        createSectionTitle(contentX, y, "PLAYER ESP")
        y += 18
        createToggle(contentX, y, contentW, "Box ESP", true)
        y += 35
        createToggle(contentX, y, contentW, "Name ESP", false)
        y += 35
        createToggle(contentX, y, contentW, "Health Bar", true)
    end,
    Misc = function()
        local y = contentY + 10
        createSectionTitle(contentX, y, "MOVEMENT")
        y += 18
        createToggle(contentX, y, contentW, "Speed Boost", false)
        y += 35
        createToggle(contentX, y, contentW, "Fly Mode", false)
    end,
    Info = function()
        local y = contentY + 10
        local txt = Drawing.new("Text")
        txt.Text = "IIGOS - v1.0\n\nPresiona [–] para minimizar.\nArrastra desde el título."
        txt.Size = 13
        txt.Position = Vector2.new(contentX, y)
        txt.Color = C.textDim
        txt.Visible = true
        addTemp(txt)
    end
}

-- ================== CAMBIAR PESTAÑA ==================
local function loadTab(index)
    clearTemp()
    for i, btn in ipairs(tabBtns) do
        btn.bg.Color = (i == index) and C.btnBg or C.tabFrameBg
    end
    if contentByTab[tabs[index]] then
        contentByTab[tabs[index]]()
    end
    activeTab = index
end

-- Conectar clic en pestañas
for i, btnData in ipairs(tabBtns) do
    local bg = btnData.bg
    addConn(UIS.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local mp = UIS:GetMouseLocation()
            if mp.X >= bg.Position.X and mp.X <= bg.Position.X + bg.Size.X
               and mp.Y >= bg.Position.Y and mp.Y <= bg.Position.Y + bg.Size.Y then
                if activeTab ~= i then
                    loadTab(i)
                end
            end
        end
    end))
end

-- ================== ARRASTRE ==================
local drag = false
local startMouse, startWin

local function moveAll(dx, dy)
    X += dx
    Y += dy
    -- Recalculamos contentX etc. pero mejor movemos todos los dibujos
    local all = {}
    for _, d in ipairs(allDraws) do table.insert(all, d) end
    for _, d in ipairs(tempDraws) do table.insert(all, d) end
    for _, d in ipairs(all) do
        if d.Position then
            d.Position = Vector2.new(d.Position.X + dx, d.Position.Y + dy)
        end
        if d.From then
            d.From = Vector2.new(d.From.X + dx, d.From.Y + dy)
            d.To = Vector2.new(d.To.X + dx, d.To.Y + dy)
        end
    end
end

addConn(UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local mp = UIS:GetMouseLocation()
        -- Cerrar
        if mp.X >= closeBtn.Position.X and mp.X <= closeBtn.Position.X + closeBtn.Size.X
           and mp.Y >= closeBtn.Position.Y and mp.Y <= closeBtn.Position.Y + closeBtn.Size.Y then
            for _, d in ipairs(allDraws) do if d.Remove then d:Remove() end end
            for _, d in ipairs(tempDraws) do if d.Remove then d:Remove() end end
            for _, c in ipairs(connections) do c:Disconnect() end
            for _, c in ipairs(tempConns) do c:Disconnect() end
            return
        end
        -- Minimizar
        if mp.X >= minBtn.Position.X and mp.X <= minBtn.Position.X + minBtn.Size.X
           and mp.Y >= minBtn.Position.Y and mp.Y <= minBtn.Position.Y + minBtn.Size.Y then
            local vis = not tempDraws[1] or not tempDraws[1].Visible
            for _, d in ipairs(tempDraws) do d.Visible = vis end
            for _, d in ipairs(allDraws) do
                -- ocultar todo menos título y botones
                if d ~= titleText and d ~= versionText and d ~= minBtn and d ~= minLabel
                   and d ~= closeBtn and d ~= closeLabel then
                    -- simplificación: ocultamos el fondo principal y sidebar también
                    d.Visible = vis
                end
            end
            return
        end
        -- Arrastre
        if mp.X >= X and mp.X <= X + WIN_W and mp.Y >= Y and mp.Y <= Y + TITLE_H then
            drag = true
            startMouse = Vector2.new(mp.X, mp.Y)
            startWin = Vector2.new(X, Y)
        end
    end
end))

addConn(UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        drag = false
    end
end))

addConn(RS.RenderStepped:Connect(function()
    if drag then
        local mousePos = UIS:GetMouseLocation()
        local dx = mousePos.X - startMouse.X
        local dy = mousePos.Y - startMouse.Y
        if dx ~= 0 or dy ~= 0 then
            moveAll(dx, dy)
            startMouse = Vector2.new(mousePos.X, mousePos.Y)
        end
    end
end))

-- Cargar primera pestaña
loadTab(1)

print("✅ UI IIGOS cargada para Delta")
