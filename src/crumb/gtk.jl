function text_gtk(html)
	label = GtkLabel("")
    Gtk4.markup(label, html)
    Gtk4.justify(label, Gtk4.Justification_CENTER)
end
