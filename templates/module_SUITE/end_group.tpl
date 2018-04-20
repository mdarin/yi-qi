% this poroceduer cleaning up related group
end_per_group(${module}_ok, Config) ->
	ct:log("end per group ${module}_ok[~p]~n",  [self()]),
	Mqtt = ?config(mqtt, Config),
	%FIXME(darin-m): падает тут t_auth:logout(Mqtt, admin),
	Config;


