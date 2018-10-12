#!/bin/bash
#
# Example how to configure pattern generator for complex modules consisting lots of handlers, 
# tests and all of this stuff obey complicated rules.
#
# This script will be working only when your pwd is directory with yiqi.pl 
#

echo "Run gernerating..."

./yiqi.pl --module=feedbacks --topics=leave,rating_total,about/every,about/every/list,^about/every/first,^about/every/next,^about/every/prev,^about/every/last,^about/every/goto,^about/every/more,^about/every/current,about/positive,about/positive/list,^about/positive/first,^about/positive/next,^about/positive/prev,^about/positive/last,^about/positive/goto,^about/positive/more,^about/positive/current,about/neutral,about/neutral/list,^about/neutral/first,^about/neutral/next,^about/neutral/prev,^about/neutral/last,^about/neutral/goto,^about/neutral/more,^about/neutral/current,about/negative,about/negative/list,^about/negative/first,^about/negative/next,^about/negative/prev,^about/negative/last,^about/negative/goto,^about/negative/more,^about/negative/current,own/every,own/every/list,^own/every/first,^own/every/next,^own/every/prev,^own/every/last,^own/every/goto,^own/every/more,^own/every/current,own/positive,own/positive/list,^own/positive/first,^own/positive/next,^own/positive/prev,^own/positive/last,^own/positive/goto,^own/positive/more,^own/positive/current,own/neutral,own/neutral/list,^own/neutral/first,^own/neutral/next,^own/neutral/prev,^own/neutral/last,^own/neutral/goto,^own/neutral/more,^own/neutral/current,own/negative,own/negative/list,^own/negative/first,^own/negative/next,^own/negative/prev,^own/negative/last,^own/negative/goto,^own/negative/more,^own/negative/current,disputes/proceeding,disputes/proceeding/list,^disputes/proceeding/first,^disputes/proceeding/next,^disputes/proceeding/prev,^disputes/proceeding/last,^disputes/proceeding/goto,^disputes/proceeding/more,^disputes/proceeding/current,disputes/resolved,disputes/resolved/list,^disputes/resolved/first,^disputes/resolved/next,^disputes/resolved/prev,^disputes/resolved/last,^disputes/resolved/goto,^disputes/resolved/more,^disputes/resolved/current,blacklist,blacklist/list,^blacklist/first,^blacklist/next,^blacklist/prev,^blacklist/last,^blacklist/goto,^blacklist/more,^blacklist/current 

echo "Generationg is done!"
