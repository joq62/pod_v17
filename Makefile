all:
	rm -rf  *~ */*~ src/*.beam test/*.beam erl_cra*;
	rm -rf  logs *.pod_dir rebar.lock;
	rm -rf _build test_ebin ebin *_info_specs;
	mkdir ebin;		
	rebar3 compile;
	cp /home/joq62/erlang/infra_2/db/ebin/* ebin;
	cp _build/default/lib/*/ebin/* ebin;
	rm -rf _build test_ebin logs log;
	git add -f *;
	git commit -m $(m);
	git push;
	echo Ok there you go!
start:
	erl -pa ebin -pa test_ebin\
	    -sname pod -setcookie cookie_test
eunit:
	rm -rf  *~ */*~ src/*.beam test/*.beam test_ebin erl_cra*;
	rm -rf _build logs log;
	rm -rf ebin;
	mkdir test_ebin;
	mkdir ebin;
	rebar3 compile;
	cp _build/default/lib/*/ebin/* ebin;
	erlc -I include -o test_ebin test/*.erl;
	erl -pa ebin -pa test_ebin\
	    -pa /home/joq62/erlang/infra_2/test_lib/ebin\
	    -sname pod_test -run $(m) start -setcookie cookie_test
