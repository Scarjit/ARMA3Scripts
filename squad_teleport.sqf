/*
	Original Script:
		https://forums.bohemia.net/forums/topic/135262-insurgency-style-respawn/
		
	Modified to work with ACE by [Keko] Grille
	
	
	_actionId = this addAction ["<t color='#FF0000' size='2'>Teleport to squad</t>", "squad_teleport.sqf"];
*/


_unit = _this select 1;
//-------------------Night Vision-----------------------------//
if (currentVisionMode player == 1) then
{
	camUseNVG true;
}else{
	camUseNVG false;
};
////////////////////////////////////////////////////////////////
//------------------------------------------------------------//
if (_unit == player) then {
	waituntil {alive player};
	player setPos getPos glbase;

	_squad = group player;
	lck_livingmates = [];
	{
		if (alive _x and _x!=player and !([_x] call ace_medical_fnc_getUnconsciousCondition)) then {lck_livingmates = lck_livingmates + [_x];};
	} foreach units _squad;

	
	//Check if no living squadmates
	lvng_mates = count lck_livingmates;
	if(lvng_mates > 0) then {
		lck_actualmate = 0;
		keyout = 0;

		openMap false;
		0 fadesound 0;
		disableserialization;
		keyspressed = compile preprocessFile "scripts\lib\keydown.sqf";
		_displayID = (findDisplay 46) displayAddEventHandler  ["KeyDown","_this call keyspressed"];

		_cam = "camera" camcreate [0,0,0];
		_cam cameraeffect ["internal", "back"] ;
		showCinemaBorder true;
		_cam camsettarget (lck_livingmates select lck_actualmate);
		_cam camsetrelpos [0,-5,2.5];
		_cam camcommit 0;
		
		_ido=0;
		while {_ido<=25000} do {

			if (_ido mod 500 == 0) then {
				TitleText["\n \n \nRight Arrow = next squadmate\nLeft Arrow = previous squadmate\nEnter = respawn","PLAIN",10];
			};
			

			if (keyout > 0) exitwith {};

			_currentmate = lck_livingmates select lck_actualmate;
			_tempcnt=0;
			
			if (_ido mod 50 == 0) then {
				cutText[["<t color='#00ff00' size='2'>",name _currentmate,"</t>"] joinString " ", "PLAIN",0, false, true];
			};
			
			lck_livingmates = [];
			{
				if (alive _x and _x != player and !([_x] call ace_medical_fnc_getUnconsciousCondition)) then {
				lck_livingmates = lck_livingmates + [_x];
				if (_x ==_currentmate) then {
					lck_actualmate = _tempcnt;
				};
				_tempcnt = _tempcnt + 1;
			};
			} foreach units _squad;

			if (count lck_livingmates == 0) exitwith {};

			_cam camsettarget (lck_livingmates select lck_actualmate);
			_cam camsetrelpos [0,-5,2.5];
			_cam camcommit 0;    

			waituntil{camCommitted _cam};
			_ido = _ido + 1; 
			sleep 0.02;
		};

		(findDisplay 46) displayRemoveEventHandler ["keyDown",_displayID];

		_ido=0;
		while {_ido<=90} do {
			_cam camsettarget (lck_livingmates select lck_actualmate);
			_cam camsetrelpos [0,-5,2.5];
			_cam camcommit 0;    
			TitleText["","PLAIN DOWN"];
			waituntil{camCommitted _cam};
			_ido = _ido + 1; 
			sleep 0.02;
		};

		_newpos = getPos glbase;

		if (keyout > 0) then {
			_newpos = getPos (lck_livingmates select lck_actualmate);
			if ((_newpos select 0)>50 and (_newpos select 1)>50) then {
				//?
			} else {
				_newpos = getPos glbase;
			};
		} else {
			_newpos = getPos glbase;
		};
		
		
		//-----------------Vehicle Spawn-----------------------------//
		if (vehicle (lck_livingmates select lck_actualmate) != (lck_livingmates select lck_actualmate)) then 
		{
			if ((vehicle (lck_livingmates select lck_actualmate)) emptyPositions "cargo"==0) then 
			{
				null = ['dummy',player] execVM "scripts\teleport.sqf"; //No space in vehicle
			}else{
				player moveincargo vehicle (lck_livingmates select lck_actualmate);
				camdestroy _cam;
				player cameraEffect ["terminate","back"];
				0 fadesound 1;
			};

		} else {
			//////////////////////////////////////////////////////////////////
			//------------------Set Unit Stance-----------------------------//
			_return = stance (lck_livingmates select lck_actualmate);

			if (_return == "stand") then {_return = "amovpknlmstpsraswrfldnon";};
				sleep 0.02;
			if (_return == "crouch") then {_return = "amovpknlmstpsraswrfldnon";};
				sleep 0.02;
			if (_return == "prone") then {_return = "AmovPpneMstpSrasWrflDnon";};
				player switchMove _return;
				
			//////////////////////////////////////////////////////////////////
			player cameraEffect ["terminate","back"];
			camdestroy _cam;
			0 fadesound 1;

			//------------------Show spawning screen-----------------------------//
			titleText [format ["Spawning on %1", lck_livingmates select lck_actualmate], "BLACK FADED"];sleep 2;
			titleText [format ["Spawning on %1", lck_livingmates select lck_actualmate], "BLACK in",2];
			///////////////////////////////////////////////////////////////////////
			player setPos _newpos;

		};//if vehicle
		cutText["", "PLAIN",-1, false, true];
		
		
	}else{
		hint "No teammate alive";
	};
};