#!/usr/bin/perl -w
#** ------------------------------------------------------------------
# nam: Yi qi - Template generator for CargoNet project 
# vsn: 0.0.1
# dsc: This is a devtool  
# crt: Ср апр 18 17:36:10 MSK 2018
# upd: 
# ath: Michael DARIN, Moscow, Russia, (c) 2018
# lic: gnu>=2, "AS-IS", "NO WARRENTY"
# cnt: darin.m@tvzavr.ru
# 
##
use warnings;
#use strict;
use File::Basename qw(basename dirname);
use File::Spec;
use Getopt::Long;
use autodie;


my $usage = "yiqi [options]\n\n";

# получить аргументы командной строки
my %options;
GetOptions("module=s" => \$options{"module"},
			"topics=s" => \$options{"topics"},
			"cargo-root=s" => \$options{"cargo-root"},
			"log=s" => \$options{"log"},
			"help" => \$options{"help"},
			"usage" => \$options{"usage"},
			"version" => \$options{"version"},
			"silent" => \$options{"silent"},
			"verbose" => \$options{"verbose"},
) or die("$usage");

#print $options{"module"} . "\n";
#print $options{"topics"} . "\n";

my $module = $options{"module"};
my @topics = split ",",$options{"topics"};
# каталог с шаблонами
my $templates_dir = File::Spec->catfile(dirname($0), "templates");
my $t_module_dir = File::Spec->catfile($templates_dir, "t_module");
my $module_suite_dir = File::Spec->catfile($templates_dir, "module_SUITE");
my $module_dir = File::Spec->catfile($templates_dir, "module");

print "module: $module\n";

foreach my $topic (@topics) {
	print "topic: $topic\n";
}
print "templates: $templates_dir\n";
print "t_module: $t_module_dir\n";
print "module_SUITE: $module_suite_dir\n";
print "module: $module_dir\n";
#print basename "move/to" . "\n";


# получить список обработчиков
# Файл модуля тестирования
#	CARGOROOT/test/<module>_SUITE.erl
# Алгоритм:
# открыть файл
# вывести зоголовок
&generate_suite_mod_head (stdout, $module, $topic);
# сгенерировать инициализацию перечня групп и тестов
&generate_suite_mod_groups (stdout, $module,\@topics);
# сгенерировать инициализацию для всего модуля теста
&generate_suite_mod_init_suite (stdout, $module, $topic);
# сгенерировать окончание для всего модуля теста
&generate_suite_mod_end_suite (stdout, $module, $topic);
# сгенерировать инициализации для групп
&generate_suite_mod_init_group (stdout, $module, $topic);
&generate_suite_mod_last_init_group (stdout, $module, $topic);
# сгенерировать окончания для групп
&generate_suite_mod_end_group (stdout, $module, $topic);
&generate_suite_mod_last_end_group (stdout, $module, $topic);
foreach my $topic (@topics) { 
	# сгенерировать инициализации для тестов для каждой группы
	&generate_suite_mod_init_testcase (stdout, $module, $topic);
	# сгенерировать окончания для тестов для каждой группы
	&generate_suite_mod_end_testcase (stdout, $module, $topic);
}
&generate_suite_mod_last_init_testcase (stdout, $module, $topic);
&generate_suite_mod_last_end_testcase (stdout, $module, $topic);
foreach my $topic (@topics) {
	# сгенеровароть заготовки тестов
	&generate_suite_mod_fun_clause (stdout, $module, basename $topic);
}
# закрыть файл

# Файл модуля API функций для тестов
#	CARGOROOT/lib/t_<module>.erl
# Алгоритм
#	открыть файл
# вывести заголовок
&generate_t_mod_head(stdout, $module);
foreach my $topic (@topics) {
	#	сгенеировать функци API к тестируемому модулoю
	&generate_t_mod_fun_clause(stdout, $module, $topic);
}
# зкрыть файл


# Файл модуля обработчика каналов, реализующего функционал подсистемы
#	CARGOROOT/lib/<module>.erl
#	Алгоритм
#	открыть файл
#	вывести заголовок
&generate_handler_mod_head(stdout, $module); 
#	сгенеировать функци API к тестируемому модулю
my $last_topic = pop @topics;
foreach my $topic (@topics) {
	&generate_handler_mod_fun_clause(stdout, $module, $topic);
}
&generate_handler_mod_last_fun_clause(stdout, $module, $last_topic);
# вернуть обратно последний топик
push @topics, $last_topic;
#	зкрыть файл



##
## subroutines for generating CARGOROOT/test/<module>_SUITE.erl
#

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

sub generate_suite_mod_groups {
	my($fout, $module, $topics) = @_;
	print $fout "% declare your tests groups\n";
	print $fout "all() -> [\n";
	print $fout "	%{group, $module\_error},\n"; 
	print $fout "	{group, $module\_ok}\n";
	print $fout "].\n";
	print $fout "\n";
	print $fout "\n";
	print $fout "% and what tests every group consist of\n";
	print $fout "groups() -> [\n";
	print $fout "	%{$module\_error, [], []},\n";
	print $fout "	{$module\_ok, [sequence], [\n";
	# перечислить тесты в группе	
	my $last_topic = pop @$topics;
	foreach my $topic (@$topics) {
		print $fout "		" . basename $topic . "\_ok,\n";
	}
	print $fout "		" . basename $last_topic . "\_ok\n";
	push @$topics, $last_topic;
	print $fout "	]}\n";
	print $fout "].\n";
	print $fout "\n";
	print $fout "\n";
}

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

sub generate_suite_mod_init_group {
	my($fout, $module) = @_;
	print $fout "% this init procedure is for every groups one by one\n";
	print $fout "init_per_group(${module}_ok, Config) ->\n";
	print $fout "	process_flag(trap_exit, true),\n";
	print $fout "	Supervisor = ?config(supervisor, Config),\n";
	print $fout "	%TODO(darin-m): it's better to register a new user and delete them after the test has end\n";
	print $fout "	[{cid, Cid}, {phone, Phone}, {mqtt_password, MQTTPassword}, {id, Id}] = t_auth:login(<<\"89615244722\">>, <<\"123\">>),\n";
	print $fout "	Mqtt = tst:new_connection(admin, Phone, MQTTPassword, Cid),\n";
	print $fout "	%FIXME(darin-m): temporary for debug only!\n";
	print $fout "	tst:sub(Mqtt, <<\"res/#\">>),\n";
	print $fout "	{save_config, [{cid, Cid}, {mqtt, Mqtt}|Config]};\n";
	print $fout "\n";
	print $fout "\n";
}

sub generate_suite_mod_last_init_group {
	my($fout, $module) = @_;
	print $fout "% othor\n";
	print $fout "init_per_group(_, Config) ->\n";
	print $fout "	process_flag(trap_exit, true),\n";
	print $fout "	Config.\n";
	print $fout "\n";
	print $fout "\n";
}

sub generate_suite_mod_init_testcase {
	my($fout, $module, $topic) = @_;
	print $fout "% init\n";
	print $fout "% and this init procedure is for appropriate test and prepare a place for it\n";
	print $fout "init_per_testcase($topic\_ok, Config) ->\n";
	print $fout "	process_flag(trap_exit, true),\n";
	print $fout "	ct:log(\"$module\_ok:$topic\_ok[~p]~n\",  [self()]),\n";
	print $fout "	ct:pal(\"::config -> ~p~n\", [Config]),\n";
	print $fout "	Config;\n";
	print $fout "\n";
	print $fout "\n";
}

sub generate_suite_mod_last_init_testcase {
	my($fout, $module) = @_;
	print $fout "% other\n";
	print $fout "init_per_testcase(_, Config) ->\n";
	print $fout "	ct:log(\"group empty init per testcase pid ~p~n\",  [self()]),\n";
	print $fout "	Config.\n";
	print $fout "\n";
	print $fout "\n";
}

sub generate_suite_mod_end_testcase {
	my($fout, $module, $topic) = @_;
	print $fout "% end \n";
	print $fout "% this finisthing procedure is for clean up related test after end\n";
	print $fout "end_per_testcase($topic\_ok, Config) ->\n";
	print $fout "	process_flag(trap_exit, true),\n";
	print $fout "	ct:log(\"$module\_ok:$topic\_ok[~p]~n\",  [self()]),\n";
	print $fout "	ct:pal(\"::config -> ~p~n\", [Config]),\n";
	print $fout "	Config;\n";
	print $fout "\n";
	print $fout "\n";
}

sub generate_suite_mod_last_end_testcase {
	my($fout, $module) = @_;
	print $fout "% othor\n";
	print $fout "end_per_testcase(_, Config) ->\n";
	print $fout "	ct:log(\"$module\_ok: _ [~p]~n\",  [self()]),\n";
	print $fout "	Config.\n";
	print $fout "\n";
	print $fout "\n";
}


sub generate_suite_mod_end_group {
	my($fout, $module) = @_;
	print $fout "% this poroceduer cleaning up related group\n";
	print $fout "end_per_group($module\_ok, Config) ->\n";
	print $fout "	ct:log(\"end per group $module\_ok[~p]~n\",  [self()]),\n";
	print $fout "	Mqtt = ?config(mqtt, Config),\n";
	print $fout "	%FIXME(darin-m): падает тут t_auth:logout(Mqtt, admin),\n";
	print $fout "	Config;\n";
	print $fout "\n";
	print $fout "\n";
}

sub generate_suite_mod_last_end_group {
	my($fout, $module) = @_;
	print $fout "% othor\n";
	print $fout "end_per_group(_, Config) ->\n";
	print $fout "	ct:log(\"end per group _ [~p]~n\",  [self()]),\n";
	print $fout "	Config.\n";
	print $fout "\n";
	print $fout "\n";
}

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

sub generate_suite_mod_fun_clause {
	my($fout, $module, $topic) = @_;
	my $function = basename $topic;
	print $fout "$topic\_ok(Config) ->\n";
	print $fout "	ct:pal(\"::config -> ~p~n\", [Config]),\n";
	print $fout "	{Saver,SavedConfig} = ?config(saved_config, Config),\n";
	print $fout "	Mqtt = ?config(mqtt, SavedConfig),\n";
	print $fout "	Res = t_$module:$function(Mqtt),\n";
	print $fout "	ct:log(\"::res -> ~p~n\", [Res]),\n";
	print $fout "	SaveConfig = SavedConfig,\n";
	print $fout "	{save_config, SaveConfig}.\n";
	print $fout "\n";
	print $fout "\n";
}


##
## subroutines for generating CARGOROOT/lib/t_<module>.elr
#

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

sub generate_t_mod_fun_clause {
	my($fout, $module, $topic) = @_;
	my $function = basename $topic;
	print $fout "% MQTT pub:  /<CID>/$module/$topic\n";
	print $fout "% MQTT sub:  /<CID>/$module/res/$topic\n";
	print $fout "$function(Mqtt) -> %TODO: Довьте требуетмые аргументы фукнции\n";
	print $fout "	Outgoing = <<\"$module/$topic\">>,\n";
	print $fout "	Incomeing = <<\"$module/res/$topic\">>,\n";
	print $fout "	tst:sub(Mqtt, Incomeing),\n";
	print $fout "	Payload = [\n";
	print $fout "		%TODO:insert your data here as a proplilst {key, Value} pairs\n";
	print $fout "	],\n";
	print $fout "	Reply = tst:pubr(Mqtt, Outgoing, Payload),\n";
	print $fout "	ct:log(\"::reply -> ~p~n\", [Reply]),\n";
	print $fout "	Reply.\n";
	print $fout "\n";
	print $fout "\n";
}


##
## subroutines for generating CARGOROOT/lib/<module>.er
#

sub generate_handler_mod_head {
	my($fout,$module,$topic) = @_;
	print $fout "%%%%----------------------------------------------\n";
	print $fout "%%% Module: $module \n";
	print $fout "%%% Description:\n";
	print $fout "%%% Author:\n";
	print $fout "%%% Autogen: Yi qi\n";
	print $fout "%%% wiki page -> [link to wiki or page name]\n";
	print $fout "%%%%----------------------------------------------\n";
	print $fout "-module($module).\n";
	print $fout "-compile([export_all]).\n";
	print $fout "\n";
	print $fout "-include(\"cargo_error.hrl\").\n";
	print $fout "\n";
	print $fout "% Подсистема TODO: Довьте описание реализуемой подсистемы \n";
	print $fout "% MQTT pub: /<Cid>/${module}\n";
	print $fout "% MQTT sub: /<Cid>/res/${module}\n";
	print $fout "\n";
	print $fout "\n";
}

sub generate_handler_mod_fun_clause {
	my($fout,$module,$topic) = @_;
	print $fout "%%---------------------------------------------------------------\n";
	print $fout "%% MQTT pub : /<Cid>/${module}/${topic}\n";
	print $fout "%% description: [[Discription]]\n";
	print $fout "message(SessionID, <<\"${topic}\">> = Topic, Payload) ->\n";
	print $fout "\n";
	print $fout "	lager:info(\"~p:message ::topic -> ~p~n\", [?MODULE, Topic]),\n";
	print $fout "	lager:info(\"~p:message ::payload -> ~p~n\", [?MODULE, Payload]),\n";
	print $fout "\n";
	print $fout "	% поулчить данные из запроса\n";
	print $fout "	% прверить валидность данных\n";
	print $fout "	% сформировать паттерн для решиющих правил формирования ответа\n";
	print $fout "	%% формируем ответ как проплист\n";
	print $fout "	% ------------------------------\n";
	print $fout "	% > ответ на запрос процедуры завершения регистрации\n";
	print $fout "	% -------------------------------\n";
	print $fout "	% ответить\n";
	print $fout "	common:ok();\n";
	print $fout "\n";
	print $fout "\n";
}
sub generate_handler_mod_last_fun_clause {
	my($fout,$module,$topic) = @_;
	print $fout "%%---------------------------------------------------------------\n";
	print $fout "%% MQTT pub : /<Cid>/${module}/${topic}\n";
	print $fout "%% description: [[Discription]]\n";
	print $fout "message(SessionID, <<\"${topic}\">> = Topic, Payload) ->\n";
	print $fout "\n";
	print $fout "	lager:info(\"~p:message ::topic -> ~p~n\", [?MODULE, Topic]),\n";
	print $fout " lager:info(\"~p:message ::payload -> ~p~n\", [?MODULE, Payload]),\n";
	print $fout "\n";
	print $fout "	% поулчить данные из запроса\n";
	print $fout "	% прверить валидность данных\n";
	print $fout "	% сформировать паттерн для решиющих правил формирования ответа\n";
	print $fout "	%% формируем ответ как проплист\n";
	print $fout "	% ------------------------------\n";
	print $fout "	% > ответ на запрос процедуры завершения регистрации\n";
	print $fout "	% -------------------------------\n";
	print $fout "	% ответить\n";
	print $fout "	common:ok().\n";
	print $fout "	%% ^^^^^^^^ завершающий обработчик ^^^^^^^^^\n";
	print $fout "\n";
	print $fout "\n";
	print $fout "%%\n";
	print $fout "%% Internals\n";
	print $fout "%\n";
	print $fout "\n";
	print $fout "\n";
}
