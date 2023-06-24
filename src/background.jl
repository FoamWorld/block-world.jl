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
    println(stderr, "flag")
    #= destroy(topbox)
    topbox = GtkCanvas(576, 512)
    draw(cvs) do widget
        _
        ctx = getgc(widget)
    end =#
end
