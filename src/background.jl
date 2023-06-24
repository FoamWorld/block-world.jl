function init_mainmenu_gtk()
    global window = GtkWindow("FoamWorld", 576, 512, false) # unresizable
    global topbox = GtkBox(:v)
    push!(window, topbox)
    init_menu_gtk()
    present(window)
end

function init_menu_gtk()
    global topbox
    # Button
    but_create = GtkButton("创建新世界")
    signal_connect(but_create, "clicked") do _
        init_creategame_gtk()
    end
    # ;
    push!(topbox, but_create)
end

function init_creategame_gtk()
    global topbox
    empty!(topbox)
    # Button
    but = GtkButton("创建")
    signal_connect(but, "clicked") do _
        init_game_gtk()
    end
    # ;
    push!(topbox, but)
end

function init_game_gtk()
    global topbox
    global canvas = GtkCanvas(576, 512)
    empty!(topbox)
    draw(canvas) do widget
        context = getgc(widget)
        game_draw(context)
    end
    # Game Logic
    initialize_game()
    ch = Channel{Bool}(0)
    timer = Timer(0; interval=0.05) do _
        put!(ch, true)
    end
    event_esc = GtkEventControllerKey(topbox)
    set_gtk_property!(event_esc, :key_pressed, Ref(function (key)
        println(get_gtk_property(key, :keycode))
    end))
    task = @task begin
        while true
            take!(ch) || break
            propel_game()
        end
    end
    schedule(task)
    # ;
    push!(topbox, canvas)
end
