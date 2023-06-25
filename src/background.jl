function init_mainmenu_gtk()
    global application = GtkApplication()
    global window = GtkWindow("FoamWorld", 576, 512, false) # unresizable
    global topbox = GtkBox(:v)
    push!(application, window)
    push!(window, topbox)
    init_menu_gtk()
    present(window, 0)
end

function init_menu_gtk()
    global topbox
    # Text
    label = GtkLabel("Foam World")
    # Gtk4.markup(label, """<span size="x-large">Foam World</span>""")
    Gtk4.justify(label, Gtk4.Justification_CENTER)
    # Button
    but_create = GtkButton("创建新世界")
    signal_connect(but_create, "clicked") do _
        init_creategame_gtk()
    end
    # ;
    push!(topbox, label)
    push!(topbox, GtkSeparator(:h))
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
    global window
    global topbox
    global canvas = GtkCanvas(576, 512)
    empty!(topbox)
    @guarded draw(canvas) do widget
        context = getgc(widget)
        game_draw(context)
    end
    # Game Logic
    initialize_game()
    ch = Channel{Bool}(0)
    timer = Timer(0; interval=1) do _
        put!(ch, true)
    end
    event_esc = GtkEventControllerKey(window)
    signal_connect(event_esc, "key-pressed") do controller, keyval, keycode, state
        println(keyval)
        if keyval == 65307 # esc
            put!(ch, false)
        end
    end
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
