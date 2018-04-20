% declare your tests groups
all() -> [
	%{group, ${module}\_error}, 
	{group, ${module}_ok}
].


% and what tests every group consist of
groups() -> [
	%{${module}\_error, [], []},
	{${module}_ok, [sequence], [
		${tescases}
	]}
].


