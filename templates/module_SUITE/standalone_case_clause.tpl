${testcase}_ok(Config) ->
	ct:pal("::config -> ~p~n", [Config]),
	SavedConfig = ?LOAD,
	Res = t_${module}:${function}(), %TODO: add your arguments
	ct:log("::res -> ~p~n", [Res]),
	?SAVE(SavedConfig).


