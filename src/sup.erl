%%%-------------------------------------------------------------------
%% @doc wsapp top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(sup).

-behaviour(supervisor).

-export([start_link/0]).

-export([init/1]).

-define(SERVER, ?MODULE).

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%% sup_flags() = #{strategy => strategy(),         % optional
%%                 intensity => non_neg_integer(), % optional
%%                 period => pos_integer()}        % optional
%% child_spec() = #{id => child_id(),       % mandatory
%%                  start => mfargs(),      % mandatory
%%                  restart => restart(),   % optional
%%                  shutdown => shutdown(), % optional
%%                  type => worker(),       % optional
%%                  modules => modules()}   % optional
init([]) ->
    ListenSocket=gen_tcp:listen(8300),
    SupFlags = #{
        strategy=>one_for_all,
        intensity=>5,
        period=>5000
        },
    ChildSpec=[
            #{
                id=>wsup,
                start=>{wsup,start,[ListenSocket]},
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
