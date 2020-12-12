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
        intensity=>5,
        period=>5000
        },
    ChildSpec=[
            #{
                id=>wsup,
                start=>{wsup,start,[]},
                restart=>permanent,
                shutdown=>brutal_shutdown,
                type=>supervisor,
                modules=>[]
            } ,
            #{id =>server,
                start=>{server,start,[]},
                restart=>permanent,
                shutdown=>brutal_shutdown,
                type=>worker,
                modules=>[]
            } 
        ],
        {ok,{SupFlags,ChildSpec}}.

%% internal functions
