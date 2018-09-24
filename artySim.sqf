
if (!isServer) exitWith {};

_theTrigger = param [0];
_theTriggerPos = getPos _theTrigger;
_theTriggerRadius = (triggerArea _theTrigger) select 0;
_shellCount = param [1, 1, []];
_safeDistance = param [2, 62, [0]];
_shellType = param [3, "Sh_82mm_AMOS", [""]];

for "_index" from 1 to _shellCount do {
	_posToFireAt = [];
	while {(count _posToFireAt) == 0} do {
		_posToFireAt = _theTriggerPos getPos [(random _theTriggerRadius), (random 360)];
		{
			if ((_x distance _posToFireAt) < _safeDistance) exitWith {_posToFireAt = [];};
		} forEach allUnits;
	};
	
	_posToFireAt set [2, 800];
	_shell = _shellType createVehicle _posToFireAt;
	_shell setPos _posToFireAt;
	_shell setVelocity [0,0,-200];

	if ((_index % 4) == 3) then {
		sleep (2 + (random 1) / 4);
	} else {
		sleep random 0.1;
	};
};