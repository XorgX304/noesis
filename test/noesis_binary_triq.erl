% Copyright (c) 2014-2015, Daniel Kempkens <daniel@kempkens.io>
%
% Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
% provided that the above copyright notice and this permission notice appear in all copies.
%
% THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED
% WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL
% DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT,
% NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

-module(noesis_binary_triq).

-include_lib("triq/include/triq.hrl").

% Generators

binary_hex() -> ?LET(I, non_neg_integer(), binary:encode_unsigned(I)).

% Properties

prop_join_1() ->
  ?FORALL({A, B, Sep}, {binary(), binary(), binary()},
    <<A/binary, Sep/binary, B/binary>> =:= noesis_binary:join([A, B], Sep)).

prop_to_hex_1() ->
  ?FORALL(Bin, binary_hex(),
    begin
      Hex = noesis_binary:to_hex(Bin),
      {ok, [Num], []} = io_lib:fread("~16u", Hex),
      Bin =:= <<Num>>
    end).
