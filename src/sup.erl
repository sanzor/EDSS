%%%-------------------------------------------------------------------
%% @doc wsapp top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(sup).

-behaviour(supervisor).

-export([start_link/0,init/1]).




start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
    SupFlags = #{
        strategy=>one_for_all,
        intensity=>0,
        period=>2
        },
    ChildSpec=[
            #{
              id=>wsup,
              start=>{wsup,start_link,[]},
              restart=>permanent,
              shutdown=>brutal_kill,
              modules=>[wsup],
              type=>supervisor
            } ,
            #{id =>server,
                start=>{server,start,[]},
                restart=>permanent,
                shutdown=>brutal_kill,
                type=>worker,
                modules=>[server]
            } 
        ],
        {ok,{SupFlags,ChildSpec}}.

%% internal functions
