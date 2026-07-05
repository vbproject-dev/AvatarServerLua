local SessionManager = {}
SessionManager.sessions = {}

function SessionManager.register(session)
    SessionManager.sessions[session:id()] = session

    print("Session " .. session:getIpAddress() .. " connected")
end

function SessionManager.unregister(session)
    if session:getPlayer() then
        local player = session:getPlayer()
        if player.map then
            player.map:leave(player)
        end
    end

    SessionManager.sessions[session:id()] = nil

    print("Session " .. session:getIpAddress() .. " disconnected")
end

function SessionManager.broadcast(msg)
    for _, session in pairs(SessionManager.sessions) do
        session:send(msg.command, msg:getData(), msg:size())
    end
end

function SessionManager.clear()
    for _, session in pairs(SessionManager.sessions) do
        session:close()
    end

    SessionManager.sessions = {}
end

return SessionManager
