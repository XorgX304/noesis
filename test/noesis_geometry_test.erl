% Copyright (c) 2014-2015, Daniel Kempkens <daniel@kempkens.io>
%
% Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
% provided that the above copyright notice and this permission notice appear in all copies.
%
% THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED
% WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL
% DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT,
% NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

-module(noesis_geometry_test).

-include_lib("eunit/include/eunit.hrl").

lat_test() ->
  ?assertEqual(1, noesis_geometry:lat({9001, 1})).

lng_test() ->
  ?assertEqual(1, noesis_geometry:lng({1, 9001})).

north_east_test() ->
  ?assertEqual({9001, 1}, noesis_geometry:north_east({{9001, 1}, {0, 0}})).

south_west_test() ->
  ?assertEqual({0, 0}, noesis_geometry:south_west({{9001, 1}, {0, 0}})).

center_test() ->
  ?assertEqual({15.0, 15.0}, noesis_geometry:center({{20, 20}, {10, 10}})),
  ?assertEqual({90.0, 90.0}, noesis_geometry:center({{180, 180}, {0, 0}})),
  ?assertEqual({81.0, 69.5}, noesis_geometry:center({{150, 130}, {12, 9}})),
  ?assertEqual({-165.0, 15.0}, noesis_geometry:center({{10, 10}, {20, 20}})),
  ?assertEqual({-99.0, 69.5}, noesis_geometry:center({{12, 9}, {150, 130}})),
  ?assertEqual({11.5, 69.5}, noesis_geometry:center({{12, 9}, {11, 130}})).

contains_point_test() ->
  ?assertEqual(true, noesis_geometry:contains_point({{20.0, 20.0}, {10.0, 10.0}}, {15.0, 15.0})),
  ?assertEqual(true, noesis_geometry:contains_point({{180, 180}, {0, 0}}, {90.0, 90.0})),
  ?assertEqual(false, noesis_geometry:contains_point({{10, 10}, {20, 20}}, {-165.0, 15.0})),
  ?assertEqual(false, noesis_geometry:contains_point({{12, 9}, {11, 130}}, {11.5, 69.5})).

extend_test() ->
  ?assertEqual({{20.0, 20.0}, {10.0, 10.0}}, noesis_geometry:extend({{20.0, 20.0}, {10.0, 10.0}}, {15.0, 15.0})),
  ?assertEqual({{30.0, 30.0}, {10.0, 10.0}}, noesis_geometry:extend({{20.0, 20.0}, {10.0, 10.0}}, {30.0, 30.0})),
  ?assertEqual({{30.0, 20.0}, {10.0, 5.0}}, noesis_geometry:extend({{20.0, 20.0}, {10.0, 10.0}}, {30.0, 5.0})).

crosses_antimeridian_test() ->
  ?assertEqual(false, noesis_geometry:crosses_antimeridian({{5, 0}, {1, 0}})),
  ?assertEqual(true, noesis_geometry:crosses_antimeridian({{5, 0}, {10, 0}})).

distance_test() ->
  ?assertEqual(2887.2599506071106, noesis_geometry:distance({-86.67, 36.12}, {-118.40, 33.94})),
  ?assertEqual(170.3043950254226, noesis_geometry:distance({-1.8494, 53.1472}, {0.1406, 52.2044})).

rhumb_distance_test() ->
  ?assertEqual(240, trunc(noesis_geometry:rhumb_distance({1.3380600000000065, 48.96572992335743}, {1.3380600000000065, 51.12556}))),
  ?assertEqual(15000, round(noesis_geometry:rhumb_distance({1.33806, 51.12556}, {1.3380600000000318, -83.73457882378777}))).

rhumb_destination_point_test() ->
  ?assertEqual({4.399965478328626, 50.178752812432656}, noesis_geometry:rhumb_destination_point({1.33806, 51.12556}, 116, 240.23)),
  ?assertEqual({1.338059999999981, 48.96572992335743}, noesis_geometry:rhumb_destination_point({1.33806, 51.12556}, 180, 240.23)),
  ?assertEqual({1.338059999999981, 51.12556}, noesis_geometry:rhumb_destination_point({1.3380600000000065, 48.96572992335743}, 360, 240.23)),
  ?assertEqual({1.338059999999981, 51.12556}, noesis_geometry:rhumb_destination_point({1.3380600000000065, 48.96572992335743}, 0, 240.23)),
  ?assertEqual({1.338059999999981, -83.73457882378777}, noesis_geometry:rhumb_destination_point({1.33806, 51.12556}, 180, 15000)).

rhumb_bearing_to_test() ->
  ?assertEqual(0.0, noesis_geometry:rhumb_bearing_to({1.3380600000000065, 48.96572992335743}, {1.3380600000000065, 51.12556})),
  ?assertEqual(180.0, noesis_geometry:rhumb_bearing_to({1.33806, 51.12556}, {1.3380600000000318, -83.73457882378777})),
  ?assertEqual(116, trunc(noesis_geometry:rhumb_bearing_to({1.33806, 51.12556}, {4.399965478328651, 50.178752812432656}))).

deg2rad_test() ->
  ?assertEqual(0.017453292519943295, noesis_geometry:deg2rad(1)),
  ?assertEqual(1.0, noesis_geometry:deg2rad(57.29577951308232)),
  ?assertEqual({0.017453292519943295, 1.0}, noesis_geometry:deg2rad({1, 57.29577951308232})).

rad2deg_test() ->
  ?assertEqual(57.29577951308232, noesis_geometry:rad2deg(1)),
  ?assertEqual(1.0, noesis_geometry:rad2deg(0.017453292519943295)),
  ?assertEqual({1.0, 57.29577951308232}, noesis_geometry:rad2deg({0.017453292519943295, 1})).

normalize_lat_test() ->
  ?assertEqual(90.0, noesis_geometry:normalize_lat(91)),
  ?assertEqual(-90.0, noesis_geometry:normalize_lat(-91)),
  ?assertEqual(10.0, noesis_geometry:normalize_lat(10)).

normalize_lng_test() ->
  ?assertEqual(180.0, noesis_geometry:normalize_lng(180)),
  ?assertEqual(179.0, noesis_geometry:normalize_lng(-181)),
  ?assertEqual(-179.0, noesis_geometry:normalize_lng(181)),
  ?assertEqual(10.0, noesis_geometry:normalize_lng(10)).

normalize_bearing_test() ->
  ?assertEqual(1.0, noesis_geometry:normalize_bearing(361)),
  ?assertEqual(359.0, noesis_geometry:normalize_bearing(-361)).
