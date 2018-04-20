
sub generate_suite_mod_last_init_group {
	my($fout, $module) = @_;
	print $fout "% othor\n";
	print $fout "init_per_group(_, Config) ->\n";
	print $fout "	process_flag(trap_exit, true),\n";
	print $fout "	Config.\n";
	print $fout "\n";
	print $fout "\n";
}
