_key = _this select 1;

//right arrow
if (_key == 205) then { 
 lck_actualmate = lck_actualmate + 1; 
 if (lck_actualmate >= count lck_livingmates) then {
   lck_actualmate = 0;
 };
}; 
//left arrow
if (_key == 203) then { 
 lck_actualmate = lck_actualmate - 1; 
 if (lck_actualmate < 0) then {
   lck_actualmate = (count lck_livingmates)-1;
 };
}; 



if (_key == 76) then {
 TitleText["Right Arrow = next squadmate\nLeft Arrow = previous squadmate\nEnter = respawn","PLAIN DOWN"];
};


//Enter key
if (_key == 28) then { keyout = _key };