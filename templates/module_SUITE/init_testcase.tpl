% init
% and this init procedure is for appropriate test and prepare a place for it
init_per_testcase(${testcase}_ok, Config) ->
	process_flag(trap_exit, true),
	ct:log("${module}_ok:${testcase}_ok[~p]~n",  [self()]),
	ct:pal("::config -> ~p~n", [Config]),
	Config;


