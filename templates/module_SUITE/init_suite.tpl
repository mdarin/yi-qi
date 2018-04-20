
sub generate_suite_mod_init_suite {
	my($fout, $module) = @_;
	print $fout "% this init procedure is for whole module\n";
	print $fout "init_per_suite(Config) ->\n";
	print $fout "	process_flag(trap_exit, true),\n";
	print $fout "	SV = tst:mqtt(),\n";
	print $fout "	[{supervisor, SV}|Config].\n";
	print $fout "\n";
	print $fout "\n";
}
