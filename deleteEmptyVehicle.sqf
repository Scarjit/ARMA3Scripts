if (!isServer) exitWith {};

_veh = param [0];
if({alive _x} count crew _veh == 0) then {
	deleteVehicle _veh;
}