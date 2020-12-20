
%%% Worker supervisor module 
%%% Controls the workers that are assigned to incoming clients

-module(wsup).
-behaviour(supervisor).
-import(gen_tcp,[listen/1]).

-define(NAME,?MODULE).
-define(DEFAULT_PORT,8300).
%% API

-export([init/1,start_link/0,start_child/0]).



% Internals

handle_port()->
     Port=case application:get_env(port) of
        {ok,PortVal} ->PortVal;
        undefined -> ?DEFAULT_PORT
        end,
     Port.
            

%% ============================================================
%% API Functions
%% ============================================================

start_link()->
    {ok,Pid}=supervisor:start_link({local,?NAME},?NAME,[]),
    {ok,Pid}.

start_child()->
    supervisor:start_child(?NAME,[]).
%callbacks
init(Args)->
    Port=case application:get_env(port) of
        {ok,PortVal} ->PortVal;
        undefined -> ?DEFAULT_PORT
        end,
    case gen_tcp:listen(Port,[]) of
        {ok,L}->
            SupFlags=#{strategy=>simple_one_for_one,intensity=>4,period=>3600},
            ChildSpec=#{id=>worker,start=>{worker,start,[L]},restart=>temporary,shutdown=>brutal_kill,type=>worker,modules=>[worker]},
            {ok,{SupFlags,[ChildSpec]}};
        Error->exit(socket_error)
    end.

