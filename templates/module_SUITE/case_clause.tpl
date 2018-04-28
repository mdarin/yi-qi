${testcase}_ok(Config) ->
	ct:pal("::config -> ~p~n", [Config]),
	SavedConfig = ?LOAD,
	Mqtt = ?config(mqtt, SavedConfig),
	Res = t_${module}:${function}(Mqtt), %TODO: add your arguments
	ct:log("::res -> ~p~n", [Res]),
	?SAVE(SavedConfig).


