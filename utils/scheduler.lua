local scheduler = {}

scheduler.queue = {}

function scheduler.run()

end

function scheduler.add()

end

function scheduler.remove()

end

function scheduler.queue()
    for player_index, _ in pairs(global.marking_players) do
        local _, pdata = Player.get(player_index)
        local wt = pdata.scheduled_markers and pdata.scheduled_markers[1]
        if wt and next(wt) then
            local next_belt = table.remove(wt, 1)
            if next_belt[1].valid then
                highlight_belts(next_belt[1], player_index, next_belt[2] == 'forward' and true or false, next_belt[2] == 'backward' and true or false, next_belt[3])
            end
            break
        elseif pdata.scheduled_markers and not next(pdata.scheduled_markers[1]) and pdata.scheduled_markers[2] and next(pdata.scheduled_markers[2]) then
            table.remove(pdata.scheduled_markers, 1)
        else
            pdata.scheduled_markers = nil
            global.marking_players[player_index] = nil
        end
    end
    if not next(global.marking_players) then
        global.marking = false
    end
    if global.marking and global.belts_marked_this_tick < max_belts then
        return highlight_scheduler()
    end
end

local function max_belts_handler()
    if global.marking then
        global.belts_marked_this_tick = 0
        highlight_scheduler()
    end
end
