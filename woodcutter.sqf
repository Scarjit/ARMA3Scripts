//Tree & Brushes cutting script by [Keko] Grille
if (!isServer) exitwith {};

hideTObjs = [];
{
	if(
		markerShape _x == "ELLIPSE" &&
		toLower _x find "treecutter" == 0
	) then {
		_pos = markerPos( _x );
		_size = markerSize( _x ) select 0;
				
		{
			hideTObjs pushBack _x
		} foreach (nearestTerrainObjects [_pos, ["TREE", "SMALL TREE", "BUSH"], _size]);
		
		{
			if (
				(str(_x) find "fallen" >= 0) || 
				(str(_x) find "stump" >= 0) || 
				(str(_x) find "stone" >= 0)
			) then {
				hideTObjs pushBack _x
			};
		} foreach (nearestTerrainObjects [_pos, [], _size]);
			
		deleteMarkerLocal _x;
	};
} forEach allMapMarkers;

{
	_x hideObjectGlobal true
} foreach hideTObjs;