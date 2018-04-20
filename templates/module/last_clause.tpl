
sub generate_handler_mod_last_fun_clause {
	my($fout,$module,$topic) = @_;
	print $fout "%%---------------------------------------------------------------\n";
	print $fout "%% MQTT pub : /<Cid>/${module}/${topic}\n";
	print $fout "%% description: [[Discription]]\n";
	print $fout "message(SessionID, <<\"${topic}\">> = Topic, Payload) ->\n";
	print $fout "\n";
	print $fout "	lager:info(\"~p:message ::topic -> ~p~n\", [?MODULE, Topic]),\n";
	print $fout " lager:info(\"~p:message ::payload -> ~p~n\", [?MODULE, Payload]),\n";
	print $fout "\n";
	print $fout "	% поулчить данные из запроса\n";
	print $fout "	% прверить валидность данных\n";
	print $fout "	% сформировать паттерн для решиющих правил формирования ответа\n";
	print $fout "	%% формируем ответ как проплист\n";
	print $fout "	% ------------------------------\n";
	print $fout "	% > ответ на запрос процедуры завершения регистрации\n";
	print $fout "	% -------------------------------\n";
	print $fout "	% ответить\n";
	print $fout "	common:ok().\n";
	print $fout "	%% ^^^^^^^^ завершающий обработчик ^^^^^^^^^\n";
	print $fout "\n";
	print $fout "\n";
	print $fout "%%\n";
	print $fout "%% Internals\n";
	print $fout "%\n";
	print $fout "\n";
	print $fout "\n";
}
