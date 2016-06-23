#include <sourcemod>
#include <sdktools>

#define PREFIX "[STB]"

ArrayList conClients;
bool isMapRunning;
bool isBalancing;

enum
{
	TEAM_UNASSIGNED = 0,
	TEAM_SPECTATORS = 1,
	TEAM_1 = 2,
	TEAM_2 = 3
}

public Plugin myInfo =
{
	name = "[STB] Smart team balance",
	author = "Zerovv",
	description = "Automaticly balances teams when they become unbalanced, moves last joined players to the other team.",
	version = "1.0",
	url = "dev-hq.me"
};

public void OnPluginStart()
{
	conClients = new ArrayList(MAXPLAYERS+1);
	CreateTimer(5.0, Update, _, TIMER_REPEAT)
	PrintToServer("Smart team balance started...");
}

public void OnMapStart()
{
	isMapRunning = true;
}

public void OnMapEnd()
{
	isMapRunning = false;
}

public Action Update(Handle timer)
{
	int teamIndex = NeedsTeamBalance();
	if (teamIndex != 0)
		BalanceTeam(teamIndex);
			
	return Plugin_Continue;
}

int NeedsTeamBalance()
{
	if (!isMapRunning) return 0;
	
	int playerCountT1 = GetTeamClientCount(TEAM_1);
	int playerCountT2 = GetTeamClientCount(TEAM_2);
	
	int ratio;
	
	if (playerCountT1 > playerCountT2)
		ratio = playerCountT1 - playerCountT2;
	else
		ratio = playerCountT2 - playerCountT1;
		
	if (ratio > 4) // config value
		return playerCountT1 > playerCountT2 ? TEAM_1 : TEAM_2; 
		
	return 0;
}

void BalanceTeam(int teamIndex)
{
	if (!isMapRunning) return;
	if (!isBalancing)
	{
		isBalancing = true;
		PrintToChatAll("\x03 [STB]\x01 Teams are unbalanced, engaging auto-team balance.");
	}
	
	
	
}

public void OnClientConnected(int client)
{
	conClients.Push(client);
}

public void OnClientDisconnect(int client)
{
	int clientIndex = conClients.FindValue(client);
	conClients.Erase(clientIndex);
}