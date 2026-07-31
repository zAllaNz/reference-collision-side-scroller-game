/// @function Esta função criará uma mensagem de debug personalizada para listas que é exibida na janela do compilador em tempo de execução.
function show_debug_message_dslist(list){
	var txt = "[";
	var len = ds_list_size(list);
	for(i = 0; i < len; i++){
		txt += string(ds_list_find_value(list, i));
	    if (i < len - 1) txt += ", ";
	}
	txt += "]";
	show_debug_message(txt);
}