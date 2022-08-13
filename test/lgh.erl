%%% -------------------------------------------------------------------
%%% @author  : Joq Erlang
%%% @doc: : 
%%% Created :
%%% Node end point  
%%% Creates and deletes Pods
%%% 
%%% API-kube: Interface 
%%% Pod consits beams from all services, app and app and sup erl.
%%% The setup of envs is
%%% -------------------------------------------------------------------
-module(lgh).   
 
-export([start/0]).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-define(HostNames,["c200","c201"]).
%-define(HostNames,["c100"]).
-define(C1,[
             {"c1_node1","c1_node1.dir","c1"},
	     {"c1_node2","c1_node2.dir","c1"},
	     {"c1_node3","c1_node3.dir","c1"},
	     {"c1_node4","c1_node4.dir","c1"}]).

-define(C2,[
             {"c2_node1","c2_node1.dir","c2"},
	     {"c2_node2","c2_node2.dir","c2"},
	     {"c2_node3","c2_node3.dir","c2"},
	     {"c2_node4","c2_node4.dir","c2"}]).

-define(C3,[
             {"c3_node1","c3_node1.dir","c3"},
	     {"c3_node2","c3_node2.dir","c3"},
	     {"c3_node3","c3_node3.dir","c3"},
	     {"c3_node4","c3_node4.dir","c3"}]).

-define(DbCallBacks,[db_application_spec,
		     db_deployment_info,
		     db_deployments,
		     db_host_spec]).


%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
start()->
    ok=setup(),
    case oam_db:create_cluster("c1",2,?HostNames,"c1_cookie") of
	[]->
	    io:format("DBG: error ~p~n",[{"eexist",?MODULE,?FUNCTION_NAME,?LINE}]);
	_->
	    NodesC200=[c1_c200_1@c200|rpc:call(c1_c200_1@c200,erlang,nodes,[])],
	    
	    io:format("NoticeC200 ~p~n",[[{Node,rpc:call(Node,nodelog,read,[notice])}||Node<-NodesC200]]),
	    io:format("WarningC200 ~p~n",[[{Node,rpc:call(Node,nodelog,read,[warning])}||Node<-NodesC200]]),
	    io:format("AlertC200 ~p~n",[[{Node,rpc:call(Node,nodelog,read,[alert])}||Node<-NodesC200]]),
	    init:stop()
	    
	end,
    case oam_db:create_cluster("c2",3,?HostNames,"c2_cookie") of
	[]->
	    io:format("DBG: error ~p~n",[{"eexist",?MODULE,?FUNCTION_NAME,?LINE}]);
	_->
	    ok
	end,
    DeleteC1Dirs=oam_db:delete_cluster("c1",2,?HostNames,"c1_cookie"), 
    io:format("DBG: DeleteC1Dirs ~p~n",[{DeleteC1Dirs,?MODULE,?FUNCTION_NAME,?LINE}]),
    DeleteC2Dirs=oam_db:delete_cluster("c2",3,?HostNames,"c2_cookie"),
    io:format("DBG: DeleteC2Dirs ~p~n",[{DeleteC2Dirs,?MODULE,?FUNCTION_NAME,?LINE}]),
    io:format("TEST Ok, there you go! ~p~n",[{?MODULE,?FUNCTION_NAME,?LINE}]),
    ok.

%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
start_cluster(ClusterName,NumNodesPerHost,Hosts,Cookie)->
    % Create start info 
    % NodeName=ClusterName++"_"++HostName++"_"++integer_to_list(N),
    % NodeDir= =filename:join(ClusterName,NodeName++".dir"),

    NodeHostNameNodeNameNodeDirCookieList=lists:append([oam_db:create_cluster_node_info(NumNodesPerHost,ClusterName,HostName,Cookie)||HostName<-Hosts]),
    io:format("DBG: NodeHostNameNodeNameNodeDirCookieList ~p~n",[{NodeHostNameNodeNameNodeDirCookieList,?MODULE,?FUNCTION_NAME,?LINE}]),
						   
   %% Create ClusterDir => ClusterName++".dir" at each host
    CreateClusterDir=[oam_db:create_dir(HostName,ClusterName++".dir")||HostName<-Hosts],
    io:format("DBG: CreateClusterDir ~p~n",[{CreateClusterDir,?MODULE,?FUNCTION_NAME,?LINE}]),
    %% Creat NodeDirs
    CreateNodeDirs=[{HostName,NodeDir,oam_db:create_dir(HostName,NodeDir)}||{_Node,HostName,_NodeName,NodeDir,_Cookie}<-NodeHostNameNodeNameNodeDirCookieList],
    io:format("DBG: CreateNodeDirs ~p~n",[{CreateNodeDirs,?MODULE,?FUNCTION_NAME,?LINE}]),
    
    
 
%{Node,HostName,NodeName,NodeDir,Cookie}
    StartedNodes=[{Node,oam_db:load_start_node_w_basic_appls(HostName,NodeName,NodeDir,Cookie)}||
		     {Node,HostName,NodeName,NodeDir,_Cookie}<-NodeHostNameNodeNameNodeDirCookieList],
    io:format("DBG: StartedNodes ~p~n",[{StartedNodes,?MODULE,?FUNCTION_NAME,?LINE}]),
%    SortedStartedNodes=lists:sort([{Node,Cookie}||{ok,Node,Cookie}<-StartedNodes]),
%						%{ok,Node,Cookie}
 %   io:format("DBG: SortedStartedNodes ~p~n",[{SortedStartedNodes,?MODULE,?FUNCTION_NAME,?LINE}]),
  %  ErrorStartedNodes=[{error,Reason}||{error,Reason}<-StartedNodes],
  %  []=ErrorStartedNodes,
    io:format("SUB-TEST OK  ~p~n",[{?MODULE,?FUNCTION_NAME,?LINE}]),
   % {ok,SortedStartedNodes}.
    {ok,glurk}.

%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
start_cluster_1(ClusterName,NumNodesPerHost,Hosts,Cookie)->
    % Create start info 
    % NodeName=ClusterName++"_"++HostName++"_"++integer_to_list(N),
    % NodeDir= =filename:join(ClusterName,NodeName++".dir"),

    NodeHostNameNodeNameNodeDirCookieList=lists:append([oam_db:create_cluster_node_info(NumNodesPerHost,ClusterName,HostName,Cookie)||HostName<-Hosts]),
    io:format("DBG: NodeHostNameNodeNameNodeDirCookieList ~p~n",[{NodeHostNameNodeNameNodeDirCookieList,?MODULE,?FUNCTION_NAME,?LINE}]),
						   
   %% Create ClusterDir => ClusterName++".dir" at each host
    CreateClusterDir=[oam_db:create_dir(HostName,ClusterName++".dir")||HostName<-Hosts],
    io:format("DBG: CreateClusterDir ~p~n",[{CreateClusterDir,?MODULE,?FUNCTION_NAME,?LINE}]),
    %% Creat NodeDirs
    CreateNodeDirs=[{HostName,NodeDir,oam_db:create_dir(HostName,NodeDir)}||{_Node,HostName,_NodeName,NodeDir,_Cookie}<-NodeHostNameNodeNameNodeDirCookieList],
    io:format("DBG: CreateNodeDirs ~p~n",[{CreateNodeDirs,?MODULE,?FUNCTION_NAME,?LINE}]),
    
    
 
%{Node,HostName,NodeName,NodeDir,Cookie}
    StartedNodes=[{Node,oam_db:load_start_node_w_basic_appls(HostName,NodeName,NodeDir,Cookie)}||
		     {Node,HostName,NodeName,NodeDir,_Cookie}<-NodeHostNameNodeNameNodeDirCookieList],
    io:format("DBG: StartedNodes ~p~n",[{StartedNodes,?MODULE,?FUNCTION_NAME,?LINE}]),
%    SortedStartedNodes=lists:sort([{Node,Cookie}||{ok,Node,Cookie}<-StartedNodes]),
%						%{ok,Node,Cookie}
 %   io:format("DBG: SortedStartedNodes ~p~n",[{SortedStartedNodes,?MODULE,?FUNCTION_NAME,?LINE}]),
  %  ErrorStartedNodes=[{error,Reason}||{error,Reason}<-StartedNodes],
  %  []=ErrorStartedNodes,
    io:format("SUB-TEST OK  ~p~n",[{?MODULE,?FUNCTION_NAME,?LINE}]),
   % {ok,SortedStartedNodes}.
    {ok,glurk}.

%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
single_test_tabort()->
    HostName="c100",
    NodeName="oam_test_1",
    NodeDir=NodeName++".dir",
    Cookie=NodeName,
    Node=list_to_atom(NodeName++"@"++HostName),
    LoadStartBasic=test_lib:load_start_basic({HostName,NodeName,NodeDir,Cookie}),
       io:format("DBG: LoadStartBasic ~p~n",[{LoadStartBasic,?MODULE,?FUNCTION_NAME,?LINE}]),
    
    vm:delete(Node,NodeDir),
    io:format("SUB-TEST OK  ~p~n",[{?MODULE,?FUNCTION_NAME,?LINE}]),
    ok.
%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
setup()->
    ok=application:start(common),
    ok=application:start(sd),
    
    ok=application:start(nodelog),
    OamTestLogsDir="test_logs",
    []=os:cmd("rm -rf "++OamTestLogsDir),
    ok=file:make_dir(OamTestLogsDir),
    LogFile=filename:join(OamTestLogsDir,"log"),
    nodelog:create(LogFile),
    
    ok=application:start(config),
    HostName="c202",
    "192.168.1.202"=config:host_local_ip(HostName),
    
   % ok=application:start(test_lib),
   
    ok=application:start(oam_db),
    io:format("SUB-TEST OK  ~p~n",[{?MODULE,?FUNCTION_NAME,?LINE}]), 
    ok.
