% othor
init_per_group(_, Config) ->
	process_flag(trap_exit, true),
	Config.


