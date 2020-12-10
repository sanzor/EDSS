%%% @author Bercovici Adrian Simon    
%%% worker module responsible for handling
%%% socket connections
-module(worker).
-behaviour(gen_server).
%-include("state.hrl").
-export([start/1,init/1,handle_cast/2,handle_call/3,handle_info/2]).

-record(state,{
    socket,
    messages=[],
    incr=0
    }).



%% Api
start(ListenSock)->
    gen_server:start_link(?MODULE,ListenSock,[]).

init(LSock)->
    gen_server:cast(self(),'accept'),
    {ok,#state{socket=LSock}}.



% Callbacks


handle_call(Message,From,State)->
    {reply,State,State}.

handle_cast('accept',state=#state{socket=S})->
    {ok,Socket}=gen_tcp:accept(S),
    {noreply,state#state{socket=Socket}}.

handle_info({tcp,_,Message},State=#state{messages=Ms,socket=S,incr=I})->
    F=fun(Data)->erlang:term_to_binary(Msg),
    Nm=[Message|Ms],
    St=case Message of
        state  -> gen_tcp:send(S,erlang:term_to_binary(State)),
                  State#state{messages=Nm};
        incr   -> State#state{messages=Nm,incr=I+1};
        decr   -> State#state{messages=Nm,incr=I-1};
        _      -> gen_tcp:send(S,erlang:term_to_binary("Unknwon message"++Message)),
                  State#state{messages=Nm}
    end,
    {noreply,St}.



