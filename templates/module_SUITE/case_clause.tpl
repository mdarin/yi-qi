${topic}_ok(Config) ->
	ct:pal("::config -> ~p~n", [Config]),
	{Saver,SavedConfig} = ?config(saved_config, Config),
	Mqtt = ?config(mqtt, SavedConfig),
	Res = t_${module}:${function}(Mqtt),
	ct:log("::res -> ~p~n", [Res]),
	SaveConfig = SavedConfig,
	{save_config, SaveConfig}.


