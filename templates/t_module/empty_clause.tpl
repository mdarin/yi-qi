%TODO: Добавьте реализацию теста
% заготовка для теста
${function}() -> % добавьте свои агрументы 
	% переменная payload строго обязатеьная!
	% всё что отправляется на сервер помещяется в неё
	Payload = [
		%TODO:insert your data here as a proplilst {key, Value} pairs
	],
	Reply = tst:pubr(Mqtt, Outgoing, Payload),
	% тест должне возращать какой-то ответ
	% строка является обязательной!
	% желательно бы ещё сделать ct:fail()
	ct:log("::reply -> ~p~n", [Reply]),
	Reply.
	
	
