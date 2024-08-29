-- main.lua
local bot = require("bot")
local ui = require("ui")
local json = require("cjson") -- Certifique-se de que lua-cjson está instalado

-- Inicialização do LÖVE
function love.load()
    love.graphics.setFont(love.graphics.newFont(20))
    ui.init()
end

-- Atualiza a cor do botão conforme o mouse está sobre ele
function love.mousemoved(x, y)
    ui.mousemoved(x, y)
end

-- Função para lidar com cliques do mouse
function love.mousepressed(x, y, button)
    if button == 1 then
        local action = ui.mousepressed(x, y, button)
        if action == "start" then
            bot_running = true
        elseif action == "stop" then
            bot_running = false
        elseif action == "save" then
            bot.salvar_estado()
        elseif action == "load" then
            bot.carregar_estado()
        end
    end
end

-- Atualiza o estado do bot a cada quadro
function love.update(dt)
    bot.atualizar_estado()
end

-- Desenha a interface gráfica
function love.draw()
    ui.draw()
end


