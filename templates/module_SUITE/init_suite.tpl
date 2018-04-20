% this init procedure is for whole module
init_per_suite(Config) ->
	process_flag(trap_exit, true),
	SV = tst:mqtt(),
	[{supervisor, SV}|Config].


