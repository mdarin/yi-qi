% end 
% this finisthing procedure is for clean up related test after end
end_per_testcase(${testcase}_ok, Config) ->
	process_flag(trap_exit, true),
	ct:log("${module}_ok:${testcase}_ok[~p]~n",  [self()]),
	ct:pal("::config -> ~p~n", [Config]),
	Config;


