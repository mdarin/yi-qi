%TODO: Добавьте реализацию теста
% заготовка для теста
${function}() -> % добавьте свои агрументы 
	% переменная payload строго обязатеьная!
	% всё что отправляется на сервер помещяется в неё
	Payload = [
		%TODO:insert your data here as a proplilst {key, Value} pairs for instance
	],
	% Переменная reply строго обязательна!
	% Она должно содержать ответ в термах Erlang
	% M = какой-либо модуль(скорей всего это будет модуль tst
	% F = какая-либо функция(скорей это будет либо pubr либо post)
	%FIXME: >> Reply = M:F(Payload),
	% например сформировать post запрос
	%Url = "/account/admin_activate_eamil",
	%Head = [{<<"content-type">>, <<"application/x-www-form-urlencoded">>}],
	%Path = <<"token=",Token/binary,
	%        "&state=admin-activation-stage-1">>,
	%Reply = tst:post(Url, Head, Path),
	Reply = ok,
	% тест должен возращать какой-то ответ в термах Erlang
	% строка является обязательной!
	%TODO: желательно бы ещё сделать ct:fail()
	ct:log("::reply -> ~p~n", [Reply]),
	Reply.
	
	
