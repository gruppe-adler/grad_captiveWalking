#include "script_component.hpp"
/*
 * Author: Jonpas, Salbei
 * Called when a unit dies.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [bob] call grad_captiveWalking_functions_fnc_handleKilled
 *
 * Public: No
 */

params ["_unit"];
TRACE_1("handleKilled",_unit);

// Remove handcuffs on a dead unit, removing them after unit goes into ragdoll causes a stand-up twitch and restarts the ragdoll
if (_unit getVariable ["ace_captives_isHandcuffed", false]) then {
    [_unit, false] call FUNC(setHandcuffed);
};
