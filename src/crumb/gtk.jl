function text_view(text)
	text_buffer = GtkTextBuffer()
    set_gtk_property!(text_buffer, :text, text)
    text_view = GtkTextView(; editable=false, buffer=text_buffer)
end
