function init_window_gtk(app)
    global window = GtkApplicationWindow(app, "FoamWorld")
    set_gtk_property!(window, :resizable, false)
    set_gtk_property!(window, :width_request, 576)
    set_gtk_property!(window, :height_request, 512)
    global topbox = GtkBox(:v)
    push!(window, topbox)
    present(window, 0)
    init_menu_gtk()
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
    # Game Logic
    initialize_game()
    ch = Channel{Bool}(0)
    timer = Timer(0; interval=1) do _
        isempty(ch) || put!(ch, true)
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
        close(timer)
        init_gamestop_gtk()
    end
    schedule(task)
    # ;
    @guarded draw(canvas) do widget
        context = getgc(widget)
        game_draw(context)
    end
    push!(topbox, canvas)
end

function init_gamestop_gtk()
    global topbox
    empty!(topbox)
    but_resume = GtkButton("恢复")
    but_menu = GtkButton("保存并退出")
    but_quit = GtkButton("保存并关闭")
    push!(topbox, but_resume)
    push!(topbox, but_menu)
    push!(topbox, but_quit)
    signal_connect(but_menu, "clicked") do _
        destroy_game()
        init_menu_gtk()
    end
end
