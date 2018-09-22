//Grass cutting script by [Keko] Grille
if (!isServer) exitwith {};

{
	if(
		markerShape _x == "RECTANGLE" &&
		toLower _x find "grasscutter" == 0
	) then {
		markerSize _x params ["_markerWidth", "_markerHeight"];
		markerPos _x params ["_markerPosX", "_markerPosY"];
		_sin = sin markerDir _x;
		_cos = cos markerDir _x;
		for "_itWidth" from -_markerWidth to _markerWidth step 7 do {
			for "_itHeight" from -_markerHeight to _markerHeight step 7 do {
				createVehicle ["Land_ClutterCutter_large_F", [_markerPosX + _cos * _itWidth + _sin * _itHeight, _markerPosY + -_sin * _itWidth + _cos * _itHeight, 0], [], 0, "CAN_COLLIDE"];
			};
		};
		deleteMarkerLocal _x;
	};
} forEach allMapMarkers;