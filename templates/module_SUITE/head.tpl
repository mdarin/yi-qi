%%%%----------------------------------------------
%%% Module: ${module} test suite 
%%% Description:
%%% Author:
%%% Autogen: Yi qi
%%% wiki page -> [link to wiki or page name]
%%%%----------------------------------------------
% NOTE:
% module name must conitain _SUITE postfix
% your_module_name_SUITE.erl
-module(${module}_SUITE).
% this header is required
-include_lib("common_test/include/ct.hrl").

-export([all/0]).
-compile([export_all]).


% можно заменить на:
% SavedConfig = ?LOAD,
% ?SAVE(SavedConfig)


