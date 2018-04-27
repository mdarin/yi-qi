%%---------------------------------------------------------------
%% << : /<Cid>/${module}/${topic}
%% description: [[Description]]
message(SessionID, <<"${topic}">> = Topic, Payload) ->

	lager:info("~p:message ::topic -> ~p~n", [?MODULE, Topic]),
	lager:info("~p:message ::payload -> ~p~n", [?MODULE, Payload]),

	% получить параметры запроса
	Phone = common:to_e164_format(proplists:get_value(phone, Payload)),

	% првоерить валидность данных

	% проверка номера и не зарегистрирован ли(защита)
	ValidPhone = case common:valid_phone(Phone) of
		{true, _} ->
		% если телефон удалось отформатировать
			% проверить не занят ли аккаунт уже
			FindUser = boss_db:find(users, [{phone, 'equals', Phone}]),
			case FindUser of
				{error, _} ->
				% если пользователь не нашёлся
					lager:info("~p:message *Unknown~n", [?MODULE]),
					{invalid, unknown};
				[] ->
					lager:info("~p:message *Unknown~n", [?MODULE]),
					{invalid, unknown};
				[U] ->
				% если пользователь нашёлся
					lager:info("~p:message *Engaged~n", [?MODULE]),
					{valid, U};
				U -> %FIXME(darin-m): таких не должно быть, это надо пофиксить!
					lager:info("~p:message *Engaged[*]~n", [?MODULE]),
					{valid, U};
				 _ ->
				% что-то совсем не так пошло
					{invalid,undefined}
			end;
		_ ->
		% если не удалось отформатировать
			{invalid,malformed}
	end,
	% проверить валидность агента, если номер валидный
	ValidAgent = case {boss_db:find(agents,[phone,equals,Phone]), ValidPhone} of 
		{[A],{valid,_}} -> lager:info(" ===AG===> ~p ~p~n", [A:id(), A:phone()]), {valid,A};
		{[],{invalid,_}} -> lager:info(" ===AG===> [NONE]~n",[]), {invalid,unknown}
	end,	
	% сформировать паттерн для решиющих правил формирования ответа
	Pattern = {ValidPhone, ValidAgent},
	lager:info("~p:message ::pattern -> ~p~n", [?MODULE, Pattern]),
	% получить ответ
	Reply = case Pattern of
		{{valid,_ph}, {valid,Agent}} ->
		% если всё хорошо, отве внести запись в таблицу регионов и ответить 
			lager:info("~p:message *Handle refferer...~n", [?MODULE]),	
			%TODO(darin-m):Получить
			% QR-код
			% реферальный код
			% текст сообщения
			% картинку приложение к сообщению
			% Состояние таблицы программы Приведи друга(см.доку)
 
			%% формируем проплист как ответ
			% ------------------------------
			% < ответ на запрос доступных регионов
			% -------------------------------
			common:ok() ++ [{phone, Phone}];
		{{invalid,_ph}, _ag} ->
		% если номер не валидный
			%% формируем проплист как ответ
			% ------------------------------
			% < ответ на запрос доступных регионов
			% -------------------------------
			common:error(?BADPHONE) ++ [{phone, Phone}];
		{_ph, {invalid,_ag}} ->
		% если пользоветель не валидный
			%% формируем проплист как ответ
			% ------------------------------
			% < ответ на запрос доступных регионов
			% -------------------------------
			common:error(?UNKNOWNUSER) ++ [{phone, Phone}];
		_->
		% если что-то пошло не так ну прям нетак нетак
			%% формируем проплист как ответ
			% ------------------------------
			% < ответ на запрос доступных регионов
			% -------------------------------
			common:error() ++ [{phone, Phone}]
	end,
	% ответить 
	Reply;

	
