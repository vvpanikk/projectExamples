set WildcardFilter [lsearch -not -all -inline $WildcardFilter Memory]
add log -r  sim:/*
run -all
exit
