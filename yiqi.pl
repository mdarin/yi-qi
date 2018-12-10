#!/usr/bin/perl -w
#** ------------------------------------------------------------------
# nam: Yi qi - Pattern generator for CargoNet project 
# vsn: 0.5.11
# dsc: This is a devtool  
# crt: Ср апр 18 17:36:10 MSK 2018
# upd: Пт дек  7 07:52:00 MSK 2018
# ath: Michael DARIN, Moscow, Russia, (c) 2018
# lic: Apache License Version 2.0, "AS-IS", "NO WARRENTY"
# cnt: darin.m@tvzavr.ru
# 
##
use warnings;
use strict;
use File::Basename qw(basename dirname);
use File::Spec;
use Getopt::Long;
use autodie;

##
## HOT FIXME: надо временную %h вмотаживать в $topics_funs чтоб всё работало едиобразно  
##
#TODO:наверное нужно добавить более гибкую настройку генерации тестов да и вообще 
# более гибкую настрйоку :) Генератор Всего или Generator Father
# надо поравить чтобы префикс не только в именах файлов был но и в директиве -module(<MODULE>)
#

my $usage = q(yiqi {option[=param]}
);
my $help = q(yiqi 0.0.1 (amd64)
Использование: yiqi {опция[=значение]}

yiqi — паттерн генератор из шаблонов файлов описывающих подсистемы проекта.
Основаная цель - минимизация ручнойго копирования и правок при создании
новых модулей проекта CargoNet. 

Например:
yiqi --module=yiqitest --topics=top1,top2/subtop,top3/subtop3/ssubtop3
сгенерирует модули и разместит их в корневом каталоге генератора

Основные параметры и команды:
  no-suite - не создавать common test suite 
  no-test - не создавать API для тестов
  no-handler - не создавать обработчик канала 
	prefix - добавить к имени файла префикс
  help - показать это справочное сообщение
  verbose - максимально информативный вывод
  silent - без лишних коментариев
  version - показать версию 
  usage - показать краткую справку по использованию
  log=Logfile - задать файл журнала регистрации хода работы
  cargo-root=Relativpath - задать относительнй каталог проекта HOME/cargo-root 
		

Дополнительную информацию о доступных командах смотрите в wiki.
Параметры настройки и синтаксис описаны в wiki.
Информацию о том, как настроить источники, можно найти в wiki.
Выбор пакетов и версий описывается через ?.
В Yi qi есть кротость сестры милосердия и необратимая мощь ревущего поезда.
);
# получить аргументы командной строки
my %options;
GetOptions("module=s" => \$options{"module"},
			"topics=s" => \$options{"topics"},
			"cargo-root=s" => \$options{"cargo-root"},
			#"empty-tests=s", => \$options{"standalone-tests"},
			"standalone-testcases=s", => \$options{"standalone-testcases"},
			"log=s" => \$options{"log"},
			"prefix=s" => \$options{"prefix"},
			"no-handler" => \$options{"no-handler"},
			"no-test" => \$options{"no-test"},
			"no-suite" => \$options{"no-suite"},
			"help" => \$options{"help"},
			"usage" => \$options{"usage"},
			"version" => \$options{"version"},
			"silent" => \$options{"silent"},
			"verbose" => \$options{"verbose"},
) or die "$usage";

die $usage
	if $options{"usage"};

die $help
	if $options{"help"};

die $usage 
	unless defined($options{"module"}) && defined($options{"topics"});


##
## сущности и грамматика их появление описывающая
#
#TODO: надо уже генератор пересматривать...
# $module <- mod_name
# $topic <- @topics
# $fun <- @funs
# $standalone_tcase <- @standalone_tcases
# $standalone_test <- @standalone_tests

# @t_test <- [$t_name,@t_parts]
# @suite <- [$suite_name,@suite_parts]
# @handler <- [$mod_name, @handler_parts]

# @t_parts <- [@template/t_module,module,@topics,@funs,@standalone_tests,@subst_spec]
# @suite_parts <- [@temlate/module_SUITE,module,@topics,@funs,@standalone_tcases,@subst_spec]
# @handler_parts <- [@template/module,module,@topics,@subst_spec]



my $module = $options{"module"};
my @topics = split ",",$options{"topics"};
my @standalone_testcases;
if (defined ($options{"standalone-testcases"})) {
	@standalone_testcases = split ",", $options{"standalone-testcases"} || undef;
}
my @standalone_tests = @standalone_testcases;

# каталог с шаблонами
my $templates_dir = File::Spec->catfile(dirname($0), "templates");
my $t_module_dir = File::Spec->catfile($templates_dir, "t_module");
my $module_suite_dir = File::Spec->catfile($templates_dir, "module_SUITE");
my $module_dir = File::Spec->catfile($templates_dir, "module");
my $module_doc_dir = File::Spec->catfile($templates_dir, "module_doc"); 

print "module: $module\n";

my @funs;
my $singular = ({});
my %topics_funs;
# получить список обработчиков
foreach my $topic (@topics) {
	print "topic: $topic\n";
	# пропустить, если задана директива не генерировать тест
	next if ($topic =~ /^[\^].+/);
	my $fun = basename $topic;
	print "fun: $fun\n";
		
	unless (exists $singular->{$fun}) {
		$topics_funs{$topic} = $singular->{$fun} = $fun;
		push @funs, $fun;
	} else {
		my $rest = dirname $topic;
		my $new_fun = &get_prev($rest) . "_" . $fun;
		print "new fun: $new_fun\n";
		push @funs, $new_fun; 	
		$topics_funs{$topic} = $singular->{$new_fun} = $new_fun;
	}
}

sub get_prev {
	my $topic = shift @_;
	my $prev = basename $topic;
	my $fun = "";
	unless ($prev =~ m/[.]+/g) {
		$fun = $prev;
	} else {
		# голобалное имя модуля
		$fun = $module;
	}
	$fun;
}

# показать таблицу соответствия каналов и функций
while (my ($topic,$func) = each(%topics_funs)) {
	print "## topic => " . $topic . " => " . $func . "\n"; 
}


# показать все параметры
foreach my $topic (@topics) {
	print " ~> topic: $topic\n";
}

#foreach my $etest (@empty_tests) {
#	print " ~> etest: $etest\n";
#}

foreach my $standalone_test (@standalone_tests) {
	print " ~> standalone_testcase: $standalone_test\n";
}

my $prefix = ""; 
if (defined $options{"prefix"}) {
	$prefix = $options{"prefix"} . "_";
}
print "prefix: $prefix\n"
	if ($prefix ne "");
print "templates: $templates_dir\n";
print "t_module: $t_module_dir\n";
print "module_SUITE: $module_suite_dir\n";
print "module: $module_dir\n";
print "module_doc: $module_doc_dir\n";




# получить корень проекта карго, если путь не задать, генерировать себе в корень
my $cargo_root = File::Spec->catfile($ENV{'HOME'},$options{"cargo-root"})
	if defined($options{"cargo-root"});
my $cargo_root_absolute =  $cargo_root || dirname $0;
print "cargo-root: " . $cargo_root_absolute . "\n";
my $srclib_dir = $cargo_root_absolute;
my $test_dir = $cargo_root_absolute;
my $doc_dir = $cargo_root_absolute;
if (defined($cargo_root)) {
	$srclib_dir =  File::Spec->catfile($cargo_root_absolute,"src/lib"); 
			#File::Spec->catfile("src", "lib")); муторно слишком..
	$test_dir = File::Spec->catfile($cargo_root_absolute, "test");
	$doc_dir = File::Spec->catfile($cargo_root_absolute, "doc");
}
print "lib: " . $srclib_dir . "\n";
print "test: " . $test_dir . "\n";
print "doc: " . $doc_dir . "\n";





unless ($options{"no-suite"}) {
	# Файл модуля тестирования
	# CARGOROOT/test/<module>_SUITE.erl
	# Алгоритм:
	# открыть файл
	my $suite_fname = File::Spec->catfile($test_dir, "$prefix$module\_SUITE.erl");
	print "suite file: $suite_fname\n";
	my $suite_fout;
	open $suite_fout, ">$suite_fname"
		or die "Can't open $suite_fname file:$!";
	# вывести зоголовок
	&generate_suite_mod_head ($suite_fout, "$prefix$module", \%topics_funs);
	# сгенерировать инициализацию перечня групп и тестов %FIXME: @funs надобы заменить...
	&generate_suite_mod_groups ($suite_fout, "$prefix$module", \@funs, \@standalone_testcases);
	# сгенерировать инициализацию для всего модуля теста
	&generate_suite_mod_init_suite ($suite_fout, $module);
	# сгенерировать инициализации для групп
	&generate_suite_mod_init_group ($suite_fout, $module);
	&generate_suite_mod_last_init_group ($suite_fout, $module);
	# сгенерировать окончания для групп
	&generate_suite_mod_end_group ($suite_fout, $module);
	&generate_suite_mod_last_end_group ($suite_fout, $module);

	foreach my $topic (@topics) { 
		unless ($topic =~ m/^[\^]/) {
			# сгенерировать инициализации для тестов для каждой группы
			&generate_suite_mod_init_testcase ($suite_fout, $module, $topic, \%topics_funs);
		}
	}

	foreach my $topic (@standalone_tests) { 
		# сгенерировать инициализации для тестов для самостоятельных команд
		my %h = ($topic => basename $topic);
		&generate_suite_mod_init_testcase ($suite_fout, $module, $topic, \%h);
	}
	&generate_suite_mod_last_init_testcase ($suite_fout, $module);

	foreach my $topic (@topics) { 
		unless ($topic =~ m/^[\^]/) {
			# сгенерировать окончания для тестов для каждой группы
			&generate_suite_mod_end_testcase ($suite_fout, $module, $topic, \%topics_funs);
		}
	}

	foreach my $topic (@standalone_tests) { 
		# сгенерировать окончания для тестов самостоятельных команд
		my %h = ($topic => basename $topic);
		&generate_suite_mod_end_testcase ($suite_fout, "$prefix$module", $topic, \%h);
	}
	&generate_suite_mod_last_end_testcase ($suite_fout, $module);

	# сгенерировать окончание для всего модуля теста
	&generate_suite_mod_end_suite ($suite_fout, $module);
	foreach my $topic (@topics) {
		unless ($topic =~ m/^[\^]/) {
			# сгенеровароть заготовки тестов
			&generate_suite_mod_fun_clause ($suite_fout, "$prefix$module", $topic, "case_clause.tpl", \%topics_funs);
		}
	}
	foreach my $topic (@standalone_testcases) {
		# сгенеровароть заготовки тестов
		my %h = ($topic => basename $topic);
		&generate_suite_mod_fun_clause ($suite_fout, "$prefix$module", $topic, "standalone_case_clause.tpl", \%h);
	}
	# закрыть файл
	close $suite_fout
		or die "Can't close $suite_fname file:$!";
}

unless ($options{"no-test"}) {
	# Файл модуля API функций для тестов
	# CARGOROOT/lib/t_<module>.erl
	# Алгоритм
	# открыть файл
	my $test_fname = File::Spec->catfile($srclib_dir, "t\_$prefix$module.erl");
	print "test file: $test_fname\n";
	my $test_fout;
	open $test_fout, ">$test_fname"
		or die "Can't open $test_fname file:$!";
	# вывести заголовок
	&generate_t_mod_head($test_fout, "$prefix$module");
	foreach my $topic (@topics) {
		unless ($topic =~ m/^[\^]/) {
			# сгенеировать функци API к тестируемому модулoю
			&generate_t_mod_fun_clause($test_fout, "$prefix$module", $topic, "clause.tpl", \%topics_funs);
		}
	}
	# вывести самостоятельные команды(не mqtt)
	foreach my $topic (@standalone_testcases) {
		my %h = ($topic => basename $topic);
		&generate_t_mod_fun_clause($test_fout, "$prefix$module", $topic, "standalone_clause.tpl", \%h);
	}
	# зкрыть файл
	close $test_fout
		or die "Can't open $test_fname file:$!";
}

unless ($options{"no-handler"}) {
	# Файл модуля обработчика каналов, реализующего функционал подсистемы
	# CARGOROOT/lib/<module>.erl
	# Алгоритм
	# открыть файл
	my $handler_fname = File::Spec->catfile($srclib_dir, "$prefix$module.erl");
	print "handler file: $handler_fname\n";
	my $handler_fout;
	open $handler_fout, ">$handler_fname"
		or die "Can't open $handler_fname file:$!";
	# вывести заголовок
	&generate_handler_mod_head($handler_fout, "$prefix$module"); 
	# сгенеировать функци обработчки каналов
	my $last_topic = pop @topics;
	foreach my $topic (@topics) {
		&generate_handler_mod_fun_clause($handler_fout, $module, $topic);
	}
	&generate_handler_mod_last_fun_clause($handler_fout, $module, $last_topic);
	# вернуть обратно последний топик
	push @topics, $last_topic;
	# зкрыть файл
	close $handler_fout
		or die "Can't close $handler_fname file:$!";
}


#unless ($options{"no-handler"}) {
	# Файл спецификации интерфейса модуля обработчика каналов, 
	# реализующего функционал подсистемы
	# CARGOROOT/doc/<module>.MD
	# Алгоритм
	# открыть файл
	my $doc_fname = File::Spec->catfile($doc_dir, "$prefix$module.MD");
	print "doc spec file: $doc_fname\n";
	my $doc_fout;
	open $doc_fout, ">$doc_fname"
		or die "Can't open $doc_fname file:$!";
	# вывести заголовок
	&generate_doc_mod_head($doc_fout, "$prefix$module"); 
	# сгенеировать функци обработчки каналов
	foreach my $topic (@topics) {
		&generate_doc_mod_fun_clause($doc_fout, $module, $topic);
	}
	# зкрыть файл
	close $doc_fout
		or die "Can't close $doc_fname file:$!";
#}






##
## subroutines for generating CARGOROOT/test/<module>_SUITE.erl
#

sub generate_suite_mod_head {
	my($fout, $module) = @_;
	my $head_fname = File::Spec->catfile($module_suite_dir, "head.tpl");
	my $fin;
	open $fin, "<$head_fname"
		or die "Can't open $head_fname file:$!";
	map { chomp; 
		s/\$\{module\}/$module/;
		print $fout "$_\n";	
	} <$fin>;
	close $fin
		or die "Can't closse $head_fname file:$!";
}

sub generate_suite_mod_groups {
	my($fout, $module, $topics, $standalone_funs) = @_;
	my $groups_fname = File::Spec->catfile($module_suite_dir, "groups.tpl");
	my $fin;
	open $fin, "<$groups_fname"
		or die "Can't open $groups_fname file:$!";
	map { chomp; 
		s/\$\{module\}/$module/;
		if (m/\$\{tescases\}/) {
			# вывести функции для всех топиков и всех самостоятельных команд
			&generate_suite_mod_group_testcases($fout, $topics, $standalone_funs);
		} else {
			print $fout "$_\n";
		}	
	} <$fin>;
	close $fin
		or die "Can't closse $groups_fname file:$!";
}


sub generate_suite_mod_group_testcases {
	my($fout, $topics, $standalone_funs) = @_;	
	# перечислить самостоятельные команды
	foreach my $standalone_fun (@$standalone_funs) {
		print $fout "		" . $standalone_fun . "\_ok,\n";
	}
	# перечислить тесты в группе
	# тут есть особый случай, завершающий элемент	
	my $last_topic = pop @$topics;
	foreach my $topic (@$topics) {
		print $fout "		" . basename $topic . "\_ok,\n";
	}
	print $fout "		" . basename $last_topic . "\_ok\n";
	push @$topics, $last_topic;
}

sub generate_suite_mod_init_suite {
	my($fout, $module) = @_;
	my $init_fname = File::Spec->catfile($module_suite_dir, "init_suite.tpl");
	my $fin;
	open $fin, "<$init_fname"
		or die "Can't open $init_fname file:$!";
	map { chomp; 
		#TODO: хэш и цикл
		s/\$\{module\}/$module/;
		print $fout "$_\n";	
	} <$fin>;
	close $fin
		or die "Can't closse $init_fname file:$!";
}

sub generate_suite_mod_init_group {
	my($fout, $module) = @_;
	my $init_fname = File::Spec->catfile($module_suite_dir, "init_group.tpl");
	my $fin;
	open $fin, "<$init_fname"
		or die "Can't open $init_fname file:$!";
	map { chomp; 
		#TODO: хэш и цикл
		s/\$\{module\}/$module/;
		print $fout "$_\n";	
	} <$fin>;
	close $fin
		or die "Can't closse $init_fname file:$!";
}

sub generate_suite_mod_last_init_group {
	my($fout, $module) = @_;
	my $init_fname = File::Spec->catfile($module_suite_dir, "last_init_group.tpl");
	my $fin;
	open $fin, "<$init_fname"
		or die "Can't open $init_fname file:$!";
	map { chomp; 
		#TODO: хэш и цикл
		s/\$\{module\}/$module/;
		print $fout "$_\n";	
	} <$fin>;
	close $fin
		or die "Can't closse $init_fname file:$!";
}

sub generate_suite_mod_init_testcase {
	my($fout, $module, $topic) = @_;
	my $testcase = basename $topic;
	my $init_fname = File::Spec->catfile($module_suite_dir, "init_testcase.tpl");
	my $fin;
	open $fin, "<$init_fname"
		or die "Can't open $init_fname file:$!";
	map { chomp; 
		#TODO: хэш и цикл
		s/\$\{module\}/$module/;
		s/\$\{testcase\}/$testcase/;
		print $fout "$_\n";	
	} <$fin>;
	close $fin
		or die "Can't closse $init_fname file:$!";
}

sub generate_suite_mod_last_init_testcase {
	my($fout, $module) = @_;
	my $init_fname = File::Spec->catfile($module_suite_dir, "last_init_testcase.tpl");
	my $fin;
	open $fin, "<$init_fname"
		or die "Can't open $init_fname file:$!";
	map { chomp; 
		#TODO: хэш и цикл
		s/\$\{module\}/$module/;
		print $fout "$_\n";	
	} <$fin>;
	close $fin
		or die "Can't closse $init_fname file:$!";
}

sub generate_suite_mod_end_testcase {
	my($fout, $module, $topic, $topics_funs) = @_;
	my $testcase = $topics_funs->{$topic};
	my $end_fname = File::Spec->catfile($module_suite_dir, "end_testcase.tpl");
	my $fin;
	open $fin, "<$end_fname"
		or die "Can't open $end_fname file:$!";
	map { chomp; 
		#TODO: хэш и цикл
		s/\$\{module\}/$module/;
		s/\$\{testcase\}/$testcase/;
		print $fout "$_\n";	
	} <$fin>;
	close $fin
		or die "Can't closse $end_fname file:$!";
}

sub generate_suite_mod_last_end_testcase {
	my($fout, $module) = @_;
	my $end_fname = File::Spec->catfile($module_suite_dir, "last_end_testcase.tpl");
	my $fin;
	open $fin, "<$end_fname"
		or die "Can't open $end_fname file:$!";
	map { chomp; 
		#TODO: хэш и цикл
		s/\$\{module\}/$module/;
		print $fout "$_\n";	
	} <$fin>;
	close $fin
		or die "Can't closse $end_fname file:$!";
}


sub generate_suite_mod_end_group {
	my($fout, $module) = @_;
	my $end_fname = File::Spec->catfile($module_suite_dir, "end_group.tpl");
	my $fin;
	open $fin, "<$end_fname"
		or die "Can't open $end_fname file:$!";
	map { chomp; 
		#TODO: хэш и цикл
		s/\$\{module\}/$module/;
		print $fout "$_\n";	
	} <$fin>;
	close $fin
		or die "Can't closse $end_fname file:$!";
}

sub generate_suite_mod_last_end_group {
	my($fout, $module) = @_;
	my $end_fname = File::Spec->catfile($module_suite_dir, "last_end_group.tpl");
	my $fin;
	open $fin, "<$end_fname"
		or die "Can't open $end_fname file:$!";
	map { chomp; 
		#TODO: хэш и цикл
		s/\$\{module\}/$module/;
		print $fout "$_\n";	
	} <$fin>;
	close $fin
		or die "Can't closse $end_fname file:$!";
}

sub generate_suite_mod_end_suite {
	my($fout, $module) = @_;
	my $end_fname = File::Spec->catfile($module_suite_dir, "end_suite.tpl");
	my $fin;
	open $fin, "<$end_fname"
		or die "Can't open $end_fname file:$!";
	map { chomp; 
		#TODO: хэш и цикл
		s/\$\{module\}/$module/;
		print $fout "$_\n";	
	} <$fin>;
	close $fin
		or die "Can't closse $end_fname file:$!";
}

sub generate_suite_mod_fun_clause {
	my ($fout, $module, $topic, $template_fname, $topics_funs) = @_;
	my $function = $topics_funs->{$topic};
	my $testcase = $function;
	my $caseclause_fname = File::Spec->catfile($module_suite_dir, $template_fname);
	my $fin;
	open $fin, "<$caseclause_fname"
		or die "Can't open $caseclause_fname file:$!";
	map { chomp; 
		#TODO: хэш и цикл
		s/\$\{module\}/$module/;
		s/\S\{testcase\}/$testcase/;
		s/\S\{function\}/$function/;
		print $fout "$_\n";	
	} <$fin>;
	close $fin
		or die "Can't closse $caseclause_fname file:$!";
}


##
## subroutines for generating CARGOROOT/lib/t_<module>.elr
#

sub generate_t_mod_head {
	my ($fout, $module) = @_;
	my $head_fname = File::Spec->catfile($t_module_dir, "head.tpl");
	my $fin;
	open $fin, "<$head_fname"
		or die "Can't open $head_fname file:$!";
	map { chomp; 
		s/\$\{module\}/$module/;
		print $fout "$_\n";	
	} <$fin>;
	close $fin
		or die "Can't closse $head_fname file:$!";
}

sub generate_t_mod_fun_clause {
	my ($fout, $module, $topic, $template_fname, $topics_funs) = @_;
	# удаилить директиву Не генерировать тест
	$topic =~ s/^[\^]//;
	my $function = $topics_funs->{$topic};
	my $clause_fname = File::Spec->catfile($t_module_dir, $template_fname);
	my $fin;
	open $fin, "<$clause_fname"
		or die "Can't open $clause_fname file:$!";
	map { chomp; 
		#TODO: хэш и цикл
		s/\$\{module\}/$module/;
		s/\S\{topic\}/$topic/;
		s/\S\{function\}/$function/;
		print $fout "$_\n";	
	} <$fin>;
	close $fin
		or die "Can't closse $clause_fname file:$!";
}


##
## subroutines for generating CARGOROOT/lib/<module>.erl
#

sub generate_handler_mod_head {
	my ($fout,$module) = @_;
	my $head_fname = File::Spec->catfile($module_dir, "head.tpl");
	my $fin;
	open $fin, "<$head_fname"
		or die "Can't open $head_fname file:$!";
	map { chomp; 
		s/\$\{module\}/$module/;
		print $fout "$_\n";	
	} <$fin>;
	close $fin
		or die "Can't closse $head_fname file:$!";
}

sub generate_handler_mod_fun_clause {
	my ($fout,$module,$topic) = @_;
	# удаилить директиву Не генерировать тест
	$topic =~ s/^[\^]//;
	my $clause_fname = File::Spec->catfile($module_dir, "clause.tpl");
	my $fin;
	open $fin, "<$clause_fname"
		or die "Can't open $clause_fname file:$!";
	map { chomp; 
		#TODO: хэш и цикл
		s/\$\{module\}/$module/;
		s/\S\{topic\}/$topic/;
		print $fout "$_\n";	
	} <$fin>;
	close $fin
		or die "Can't closse $clause_fname file:$!";
}

sub generate_handler_mod_last_fun_clause {
	my ($fout,$module,$topic) = @_;
	# удаилить директиву Не генерировать тест
	$topic =~ s/^[\^]//;
	my $clause_fname = File::Spec->catfile($module_dir, "last_clause.tpl");
	my $fin;
	open $fin, "<$clause_fname"
		or die "Can't open $clause_fname file:$!";
	map { chomp; 
		#TODO: хэш и цикл
		s/\$\{module\}/$module/;
		s/\S\{topic\}/$topic/;
		print $fout "$_\n";	
	} <$fin>;
	close $fin
		or die "Can't closse $clause_fname file:$!";
}


##
## subroutines for generating CARGOROOT/doc/<module>.MD
#

sub generate_doc_mod_head {
	my ($fout,$module) = @_;
	my $head_fname = File::Spec->catfile($module_doc_dir, "head.tpl");
	my $fin;
	open $fin, "<$head_fname"
		or die "Can't open $head_fname file:$!";
	map { chomp; 
		s/\$\{module\}/$module/;
		print $fout "$_\n";	
	} <$fin>;
	close $fin
		or die "Can't closse $head_fname file:$!";
}

sub generate_doc_mod_fun_clause {
	my ($fout,$module,$topic) = @_;
	# удаилить директиву Не генерировать тест
	$topic =~ s/^[\^]//;
	my $clause_fname = File::Spec->catfile($module_doc_dir, "clause.tpl");
	my $fin;
	open $fin, "<$clause_fname"
		or die "Can't open $clause_fname file:$!";
	map { chomp; 
		#TODO: хэш и цикл
		s/\$\{module\}/$module/;
		s/\S\{topic\}/$topic/;
		print $fout "$_\n";	
	} <$fin>;
	close $fin
		or die "Can't closse $clause_fname file:$!";
}
