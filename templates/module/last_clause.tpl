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
	
	%TODO: првоерить валидность данных
	% EXAMPLE: how to creaete validation rules
	% сфомировать набор данных для валидации	
	%Data = #{
	% ...declare your data as key/value pairs
	%},
	% применить правила валидации		
	%Validation = pipe:bind(Data, [fun validate_email/1, fun validate_user/1]),
	% сформировать ответ	
	%Reply = case Validation of
	%   {ok,_} ->
	%     ...
	%   {error, malformed} ->
	%   % если формат адреса почты не соответствует требуемому
	%     {json,common:error(?BADEMAIL) ++ [{email, Email}]};
	%   {error, unknown} ->
	%   % если запись с пользователем не нашлась
	%     {json,common:error(?UNKNOWNUSER) ++ [{email, Email}]};
	%   _ -> 
	%   % если позникала какя-ть неопределённость
	%     {json,common:error()}
	% end,
	% функция валидации должна виглядить примерно так:
	%validate_email(Data) -> 
	% ...validation steps
	% {ok, Data} | {error, Reason}

	%TODO: сформировать ответ

	% ответить 
	Reply = common:ok().
	%% ^^^^^^^^ завершающий обработчик ^^^^^^^^^
	
	
%%
%% Internals 
%
	
	
