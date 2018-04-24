% other
init_per_testcase(_, Config) ->
	ct:log("group empty init per testcase pid ~p~n",  [self()]),
	Config.

