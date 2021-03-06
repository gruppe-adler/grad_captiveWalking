#include "script_component.hpp"
/*
 * Author: commy2, PabstMirror, Salbei
 * Handles the "ace_unconscious" event
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 0: Is Unconsisisiouses <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [bob, true] call grad_captiveWalking_functions_fnc_handleOnUnconscious
 *
 * Public: No
 */

params ["_unit", "_isUnconc"];

if (!local _unit) exitWith {};

if (_isUnconc) then {
    //Knocked out: If surrendering, stop
    if (_unit getVariable ["ace_captives_fnc_isSurrendering", false]) then {
        [_unit, false] call FUNC(setSurrendered);
    };
} else {
    //Woke up: if handcuffed, goto animation
    if (_unit getVariable ["ace_captives_isHandcuffed", false] && {vehicle _unit == _unit}) then {
        [_unit] call ace_common_fnc_fixLoweredRifleAnimation;
        [_unit] call  FUNC(handleCaptivAnim);
    };
};
