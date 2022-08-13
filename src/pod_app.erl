%%%-------------------------------------------------------------------
%% @doc pod public API
%% @end
%%%-------------------------------------------------------------------

-module(pod_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    application:start(common),
    application:start(sd),
    application:start(nodelog),
    % Use nodename
    {VmId,_HostName}=node_to_id:start(node()),
    LogDir=VmId++".log_dir",
    []=os:cmd("rm -rf "++LogDir),
    ok=file:make_dir(LogDir),
    LogFile=filename:join(LogDir,"log"),
    nodelog:create(LogFile),
    pod_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
