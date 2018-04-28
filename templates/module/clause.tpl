%%---------------------------------------------------------------
%% << : /<Cid>/${module}/${topic}
%% description: [[Description]]
message(SessionID, <<"${topic}">> = Topic, Payload) ->

	lager:info("~p:message ::topic -> ~p~n", [?MODULE, Topic]),
	lager:info("~p:message ::payload -> ~p~n", [?MODULE, Payload]),

	%TODO: получить параметры запроса
	
	%TODO: сформировать ответ

	% првоерить валидность данных

	% ответить 
	Reply = common:ok();

	
