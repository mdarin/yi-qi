%%---------------------------------------------------------------
%% << : /<Cid>/${module}/${topic}
%% description: [[Description]]
message(SessionID, <<"${topic}">> = Topic, Payload) ->

	lager:info("~p:message ::topic -> ~p~n", [?MODULE, Topic]),
	lager:info("~p:message ::payload -> ~p~n", [?MODULE, Payload]),
  % получить учётные данные
  ShortId = boss_session:get_session_data(SessionID, short_id),
  FullId = boss_session:get_session_data(SessionID, id),
  CidSession = boss_session:get_session_data(SessionID, cid),
  ParentId = boss_session:get_session_data(SessionID, parent_id),

	%TODO: получить параметры запроса
	
	%TODO: сформировать ответ

	% првоерить валидность данных

	% ответить 
	Reply = common:ok().
	%% ^^^^^^^^ завершающий обработчик ^^^^^^^^^
	
	
%%
%% Internals 
%
	
	
