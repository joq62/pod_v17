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
-module(basic).   
 
-export([start/0]).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
%-define(HostNames,["c100","c200","c202"]).
-define(HostNames,["c100"]).


%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
start()->
    ok=setup(),
   
    init:stop(),
    timer:sleep(2000),
    ok.

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
  
    ok=pod:appl_start([]),
    pong=common:ping(),
    pong=sd:ping(),
    pong=nodelog:ping(),
    
    rpc:cast(node(),nodelog,log,[notice,?MODULE_STRING,?LINE,
				  {"OK,SUB-TEST    ",?MODULE,?FUNCTION_NAME,node()}]), 
 %   io:format("SUB-TEST OK  ~p~n",[{?MODULE,?FUNCTION_NAME,?LINE}]), 
    ok.
