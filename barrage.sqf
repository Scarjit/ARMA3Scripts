if (!isServer) exitWith {};

_blufor_vehicles = []; 
_attackers = [];
 
{
	_vehicle = _x;
	if ( 
		(side _vehicle) == blufor && (typeOf _vehicle == "rhsusf_mkvsoc")
	) then {
		_player_vehicle = False;
		{
			if(isPlayer _x) then {
				_player_vehicle = True;
			}
		} forEach crew _vehicle;
		if(!_player_vehicle) then {
			_blufor_vehicles pushBack _vehicle;
		}
	}
} forEach vehicles; 

_posToFireAt = [];
{
	_posToFireAt = _x getPos  [(random 5), (random 360)];
	_shell = "Sh_82mm_AMOS" createVehicle _posToFireAt;
	_shell setPos _posToFireAt;
	_shell setVelocity [0,0,-200];
	sleep (0.25);
	_x setDamage 1;
	sleep (10 + (random 1) / 4);
} forEach _blufor_vehicles;
