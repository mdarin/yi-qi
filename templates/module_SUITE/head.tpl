
sub generate_suite_mod_head {
	my($fout, $module) = @_;
	print $fout "%%%%----------------------------------------------\n";
	print $fout "%%% Module: $module test suite \n";
	print $fout "%%% Description:\n";
	print $fout "%%% Author:\n";
	print $fout "%%% Autogen: Yi qi\n";
	print $fout "%%% wiki page -> [link to wiki or page name]\n";
	print $fout "%%%%----------------------------------------------\n";
	print $fout "% NOTE:\n";
	print $fout "% module name must conitain _SUITE postfix\n";
	print $fout "% your_module_name_SUITE.erl\n";
	print $fout "-module($module\_SUITE).\n";
	print $fout "% this header is required\n";
	print $fout "-include_lib(\"common_test/include/ct.hrl\").\n";
	print $fout "\n";
	print $fout "-export([all/0]).\n";
	print $fout "-compile([export_all]).\n";
	print $fout "\n";
	print $fout "\n";
	print $fout "% можно заменить на:\n";
	print $fout "% SavedConfig = ?LOAD,\n";
	print $fout "% ?SAVE(SavedConfig)\n";
	print $fout "\n";
	print $fout "\n";
}
