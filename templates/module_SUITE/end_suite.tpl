% and this procedure do same for whole module
end_per_suite(Config) ->
	ct:log("end per suite:$module [~p]~n",  [self()]),
	Config.


% here you can see testcase fucntions
%
% Module:Testcase(Config) -> term() 
%			| {skip,Reason} 
%			| {comment,Comment} 
%			| {save_config,SaveConfig} 
%			| {skip_and_save,Reason,SaveConfig} 
%			| exit()
% Types
%	Config = SaveConfig = [{Key,Value}]
%	Key = atom()
%	Value = term()
%	Reason = term()
%	Comment = string()
% MANDATORY
%	The implementation of a test case. Call the functions to test and check the result. 
%	If something fails, ensure the function causes a runtime error or call ct:fail/1,2 
%	(which also causes the test case process to terminate).


