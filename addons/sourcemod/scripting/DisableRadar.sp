/*  [CS:GO] DisableRadar: Disables radar on top-right.
 *
 *  Copyright (C) 2021 Mr.Timid // timidexempt@gmail.com
 * 
 * This program is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the Free
 * Software Foundation, either version 3 of the License, or (at your option) 
 * any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT 
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS 
 * FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along with 
 * this program. If not, see http://www.gnu.org/licenses/.
 */

#include <sourcemod>
#include <sdkhooks>
#include <timid>

#define NoShow_Radar 1<<12

//Bool value
bool g_isRadarEnabled;


//ConVars
ConVar g_cvEnabledRadar;


public Plugin myinfo = 
{
    name = "Disable Radar", 
    author = PLUGIN_AUTHOR, 
    description = "Turns off Radar on spawn", 
    version = PLUGIN_VERSION, 
    url = ""
};

public void OnPluginStart()
{
    g_cvEnabledRadar = CreateConVar("sm_disableradar_enabled", "1", "Should we show radar on top-left. (0 off, 1 on)");
    g_cvEnabledRadar.AddChangeHook(OnCVarChanged);
    
    //Hook Events
    HookEvent("player_spawn", Event_PlayerSpawn);
    
    //Bool Vlaues
    g_isRadarEnabled = g_cvEnabledRadar.BoolValue;
}

public void OnCVarChanged(ConVar convar, char[] oldValue, char[] newValue)
{
    if (convar == g_cvEnabledRadar)
    {
        g_isRadarEnabled = g_cvEnabledRadar.BoolValue;
    }
}

public Action Event_PlayerSpawn(Handle event, char[] name, bool dontBroadcast)
{
    int client = GetClientOfUserId(GetEventInt(event, "userid"));
    CreateTimer(0.0, RemoveRadar, client, TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);
}

public Action RemoveRadar(Handle timer, int client)
{
    if (!IsValidClient(client))
        return Plugin_Continue;
    
    if (!g_isRadarEnabled)
        return Plugin_Continue;
    
    if (client && GetClientTeam(client) > 1 || GetClientTeam(client) < 1)
    {
        SetEntProp(client, Prop_Send, "m_iHideHUD", GetEntProp(client, Prop_Send, "m_iHideHUD") | NoShow_Radar);
    }
    return Plugin_Continue;
} 