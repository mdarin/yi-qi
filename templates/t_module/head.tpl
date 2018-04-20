
sub generate_t_mod_head {
	my($fout, $module) = @_;
	print $fout "%%%%----------------------------------------------\n";
	print $fout "%%% Module: API $module module for test suite\n";
	print $fout "%%% Desc: \n";
	print $fout "%%% Author:\n";
	print $fout "%%% Autogen: Yi qi\n";
	print $fout "%%% wiki page -> [link to wiki or page name]\n";
	print $fout "%%%%----------------------------------------------\n";
	print $fout "-module(t_$module).\n";
	print $fout "-compile([export_all]).\n";
	print $fout "\n";
	print $fout "% Команды управления подсистемой Добавьте название\n";
	print $fout "\n";
}
