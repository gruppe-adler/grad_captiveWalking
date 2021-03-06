#include "script_component.hpp"
/*
 * Author: commy2, Salbei
 * Unit loads the target object into a vehicle. (logic same as canLoadCaptive)
 *
 * Arguments:
 * 0: Unit that wants to load a captive <OBJECT>
 * 1: A captive. objNull for the first escorted captive <OBJECT>
 * 2: Vehicle to load the captive into. objNull for the nearest vehicle <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [bob, tom, car] call grad_captiveWalking_functions_fnc_doLoadCaptive
 *
 * Public: No
 */

params ["_unit", "_target", "_vehicle"];

if (isNull _target && {_unit getVariable ["ace_captives_isEscorting", false]}) then {
    // Looking at a vehicle while escorting, get target from attached objects
    {
        if (_x getVariable ["ace_captives_isHandcuffed", false]) exitWith {
            _target = _x;
        };
    } forEach (attachedObjects _unit);
};
if (isNull _target || {(vehicle _target) != _target} || {!(_target getVariable ["ace_captives_isHandcuffed", false])}) exitWith {};

if (isNull _vehicle) then {
    // Looking at a captive unit, get nearest vehicle with valid seat:
    _vehicle = (_target call ace_common_fnc_nearestVehiclesFreeSeat) param [0, objNull];
} else {
    // We have a vehicle picked, make sure it has empty seats:
    if (_vehicle emptyPositions "cargo" == 0 && {_vehicle emptyPositions "gunner" == 0}) then {
        _vehicle = objNull;
    };
};

if (isNull _vehicle) exitWith {WARNING("Could not find vehicle to load captive");};

_unit setVariable ["ace_captives_isEscorting", false, true];
[QGVAR(moveInCaptive), [_target, _vehicle], [_target]] call CBA_fnc_targetEvent;
