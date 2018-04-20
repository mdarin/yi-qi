
sub generate_suite_mod_end_suite {
	my($fout, $module) = @_;
	print $fout "% and this procedure do same for whole module\n";
	print $fout "end_per_suite(Config) ->\n";
	print $fout "	ct:log(\"end per suite:$module [~p]~n\",  [self()]),\n";
	print $fout "	Config.\n";
	print $fout "\n";
	print $fout "\n";
	print $fout "\n";
	print $fout "% \n";
	print $fout "% here you can see testcase fucntions\n";
	print $fout "%\n";
	print $fout "% Module:Testcase(Config) -> term() \n";
	print $fout "%			| {skip,Reason} \n";
	print $fout "%			| {comment,Comment} \n";
	print $fout "%			| {save_config,SaveConfig} \n";
	print $fout "%			| {skip_and_save,Reason,SaveConfig} \n";
	print $fout "%			| exit()\n";
	print $fout "% Types\n";
	print $fout "%	Config = SaveConfig = [{Key,Value}]\n";
	print $fout "%	Key = atom()\n";
	print $fout "%	Value = term()\n";
	print $fout "%	Reason = term()\n";
	print $fout "%	Comment = string()\n";
	print $fout "% MANDATORY\n";
	print $fout "%	The implementation of a test case. Call the functions to test and check the result. \n";
	print $fout "%	If something fails, ensure the function causes a runtime error or call ct:fail/1,2 \n";
	print $fout "%	(which also causes the test case process to terminate).\n";
	print $fout "\n";
	print $fout "\n";
}
