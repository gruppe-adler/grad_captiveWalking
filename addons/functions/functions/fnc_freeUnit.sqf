#include "script_component.hpp"
/*
 * Author: Salbei
 * Free's unit.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [bob] call grad_captiveWalking_functions_fnc_freeUnit
 *
 * Public: No
 */
 
params ["_unit"];

private _strengthLeft = _unit getVariable [QGVAR(handCuffStrength), 100];

if (_strengthLeft < 0) exitWith {
    addCamShake [60, 1.2, 4]; 
    playSound3D [QUOTE(PATHTO_R(sounds\snap.ogg)), objNull, false, (getPosASL _unit), 1, 1, 10];
    _unit setVariable [QGVAR(handCuffStrength), 100];

    [_unit, false] call FUNC(setHandcuffed);
};

_unit setVariable [QGVAR(fleeing), true];

private _time = if ((vehicle ACE_player) isEqualTo ACE_player) then {
    GVAR(freeingTime)
} else {
    GVAR(freeingTimeInVehicle)
};

// Create progress bar
private _fnc_onFinish = {
    params ["_unit"];
    
    addCamShake [60, 1.2, 4]; 
    playSound3D [QUOTE(PATHTO_R(sounds\snap.ogg)), objNull, false, (getPosASL _unit), 5, 1, 25];
    _unit setVariable [QGVAR(handCuffStrength), 100];

    [_unit, false] call FUNC(setHandcuffed);
    _unit setVariable [QGVAR(fleeing), false];
};

private _fnc_onFailure = {
    params ["_unit", "_elapsedTime", "_totalTime"];

    private _strengthLeft = _unit getVariable [QGVAR(handCuffStrength), 100];
    _strengthLeft = _strengthLeft - (_strengthLeft/_totalTime)*_elapsedTime;
    _unit setVariable [QGVAR(handCuffStrength), _strengthLeft];

    _unit setVariable [QGVAR(fleeing), false];
};

private _fnc_condition = {
    params ["_unit"];

    if !(_unit getVariable [QGVAR(fleeing), false]) exitWith { false };
    if !(_unit getVariable ["ace_captives_isHandcuffed", false]) exitWith { false };
     
    true
};

[((_time/100) * _strengthLeft), _unit, _fnc_onFinish, _fnc_onFailure, localize LSTRING(freeing), _fnc_condition] call ace_common_fnc_progressBar;

//PFH for effects and sounds
[{
    params ["_args", "_handle"];
    _args params ["_unit"];

    if !(_unit getVariable [QGVAR(fleeing), false]) exitWith {
        [_handle] call CBA_fnc_removePerFrameHandler;
    };

    private _sound = selectRandom [
        QUOTE(PATHTO_R(sounds\rub1.ogg)),
        QUOTE(PATHTO_R(sounds\rub2.ogg)),
        QUOTE(PATHTO_R(sounds\rub3.ogg))
    ];
    playSound3D [_sound, objNull, false, (getPosASL _unit), 5, 1, 25];

    addCamShake [1, 0.8, random 25];
}, 1, [_unit]] call CBA_fnc_addPerFrameHandler;
