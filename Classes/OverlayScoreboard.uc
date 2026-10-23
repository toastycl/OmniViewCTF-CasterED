class OverlayScoreboard extends Info;

var int redPlayerCount, bluePlayerCount;
var int SavedScreen;

var bool UTS_installed;

struct PlayerStats
{
  var int PlayerNumber;
  var string PlayerName;
    var int Caps;
    var int Grabs;
    var int FCKills;
    var int Covers;
    var int Seals;
    var int Frags;
    var int Efficiency;
    var int Score;
    var bool gotAmp;
    var PlayerReplicationInfo PRI;
    var Pawn PlayerOwner;
};

var PlayerStats RedPlayer[16];
var PlayerStats BluePlayer[16];
var OverlayHUD OH;
var Canvas CanvasX;
var Font Font469_16, Font469_16b, Font469_18b;

//////////////
// LET'S GO //
//////////////

function UpdateAndSort()
{
  local ReplicationInfo RI;
  local ENetRole oldrole;
  local int cID;
  redPlayerCount=0;
  bluePlayerCount=0;

// update arrays //
  foreach Level.AllActors (class 'ReplicationInfo', RI)
  {
    if (OH.Contains(string(RI.Class),"UTSReplicationInfo") && !UTS_Installed)
    UTS_installed = True;

    if (InStr(""$ri.class, "SmartCTFPlayerReplicationInfo") == -1)
    continue;

    oldrole = RI.Role;
    RI.Role = ROLE_Authority;

    if (RI.Owner != none && !PlayerReplicationInfo(RI.Owner).bIsSpectator && PlayerReplicationInfo(RI.Owner).Team != 255 && PlayerReplicationInfo(RI.Owner) != none )
    {
      UpdatePlayerStats(PlayerReplicationInfo(RI.Owner).Team, RI, PlayerReplicationInfo(RI.Owner), cid);
      cid++;
    }
    RI.ROLE = oldrole;
  }

  SortScores(redPlayerCount,0);
  SortScores(bluePlayerCount,1);
}

// sort by player score //
function SortScores(int N,byte Team)
{
  local int i,j,Max;
  local PlayerStats TempStats;
  local PlayerStats Ordered[16];

  for (i = 0; i < N; i++)
  {
    if (Team==0)
    Ordered[i] = redPlayer[i];
    else
    Ordered[i] = bluePlayer[i];
  }

  for (i=0; i<N; i++)
  {
    Max = i;
    for (j=i+1; j<N; j++)
    {
      if (Ordered[j].Score > Ordered[Max].Score)
      Max=j;
    }

    TempStats = Ordered[Max];
    Ordered[Max] = Ordered[i];
    Ordered[i] = TempStats;

    if (Team==0)
    redPlayer[i] = Ordered[i];
    else
    bluePlayer[i] = Ordered[i];
  }
}

// create usable player IDs //

function int GetUATeamPlayerCount(byte Team)
{
  if (Team == 0)
    return redPlayerCount;
  return bluePlayerCount;
}

function PlayerReplicationInfo GetUAPlayerPRI(byte Team, int Index)
{
  if (Index < 0 || Index >= 16)
    return None;

  if (Team == 0)
    return RedPlayer[Index].PRI;

  return BluePlayer[Index].PRI;
}

function int GetUAPlayerCaps(byte Team, int Index)
{
  if (Index < 0 || Index >= 16)
    return 0;

  if (Team == 0)
    return RedPlayer[Index].Caps;

  return BluePlayer[Index].Caps;
}

// v1.5.2: lightweight accessors for the live Unreal Arena MVP indicator.
// Keep PlayerStats inside this class to avoid UT99's 255-byte cross-class limit.
function string GetUAPlayerName(byte Team, int Index)
{
  if (Index < 0 || Index >= 16)
    return "";

  if (Team == 0)
    return RedPlayer[Index].PlayerName;

  return BluePlayer[Index].PlayerName;
}

function int GetUAPlayerStat(byte Team, int Index, int StatID)
{
  if (Index < 0 || Index >= 16)
    return 0;

  if (Team == 0)
  {
    if (StatID == 0) return RedPlayer[Index].Caps;
    if (StatID == 1) return RedPlayer[Index].Grabs;
    if (StatID == 2) return RedPlayer[Index].FCKills;
    if (StatID == 3) return RedPlayer[Index].Covers;
    if (StatID == 4) return RedPlayer[Index].Seals;
    if (StatID == 5) return RedPlayer[Index].Frags;
    if (StatID == 6) return RedPlayer[Index].Efficiency;
    return 0;
  }

  if (StatID == 0) return BluePlayer[Index].Caps;
  if (StatID == 1) return BluePlayer[Index].Grabs;
  if (StatID == 2) return BluePlayer[Index].FCKills;
  if (StatID == 3) return BluePlayer[Index].Covers;
  if (StatID == 4) return BluePlayer[Index].Seals;
  if (StatID == 5) return BluePlayer[Index].Frags;
  if (StatID == 6) return BluePlayer[Index].Efficiency;
  return 0;
}

function INT realPlayerID(int ID)
{
  local int j;

  for (j = 0; j < 16; j++)
    if (ID == redPlayer[j].PlayerNumber)
    return redPlayer[j].PRI.PlayerID;

  for (j = 0; j < 16; j++)
    if (ID == bluePlayer[j].PlayerNumber)
    return bluePlayer[j].PRI.PlayerID;

  return -1;
}

function PlayerStats findStatByPRI(PlayerReplicationInfo PRI)
{
  local int j;
  local PlayerStats empty;

  if (PRI.Team == 0 )
  {
  for (j = 0; j < 16; j++)
    if (PRI == redPlayer[j].PRI)
    return redPlayer[j];
  }
  else
  {
  for (j = 0; j < 16; j++)
    if (PRI == bluePlayer[j].PRI)
    return bluePlayer[j];
  }

  return empty;
}

function UpdatePlayerStats(byte Team, ReplicationInfo RI, PlayerReplicationInfo PRI, int cID)
{
  if (Team == 0)
  {
    if (redPlayerCount >= 16)
      return;
    RedPlayer[redPlayerCount] = getPlayerData(RI,PRI,cID);
    redPlayerCount++;
  }
  else
  {
    if (bluePlayerCount >= 16)
      return;
    BluePlayer[bluePlayerCount] = getPlayerData(RI,PRI,cID);
    bluePlayerCount++;
  }
}

function int GetSmartCTFStat(ReplicationInfo RI, string PrimaryName, optional string AltName1, optional string AltName2, optional string AltName3)
{
  local string StatText;

  StatText = RI.GetPropertyText(PrimaryName);
  if (StatText != "")
  return int(StatText);

  if (AltName1 != "")
  {
    StatText = RI.GetPropertyText(AltName1);
    if (StatText != "")
    return int(StatText);
  }

  if (AltName2 != "")
  {
    StatText = RI.GetPropertyText(AltName2);
    if (StatText != "")
    return int(StatText);
  }

  if (AltName3 != "")
  {
    StatText = RI.GetPropertyText(AltName3);
    if (StatText != "")
    return int(StatText);
  }

  return 0;
}

function PlayerStats GetPlayerData(ReplicationInfo RI, PlayerReplicationInfo PRI,int cID)
{
  local PlayerStats TempStats;
  local PlayerStats wowStats;
  wowStats = findStatByPRI(PRI);


  if (Pawn(PRI.Owner).Weapon != none)
  {
    TempStats.gotAMP = (Pawn(PRI.Owner).Weapon.Texture == FireTexture'UnrealShare.Belt_fx.UDamageFX');

    if (TempStats.gotAMP && PRI.TimeAcc == -1 )
    PRI.TimeAcc = 30;
  }

  if (Pawn(PRI.Owner).Health <= 0 )
  PRI.TimeAcc = -1;

  TempStats.PlayerNumber = cID;
  TempStats.PlayerName = PRI.PlayerName;
  TempStats.Caps =  int(RI.GetPropertyText("Captures"));
  TempStats.Grabs =  int(RI.GetPropertyText("Grabs"));
  TempStats.FCKills =  int(RI.GetPropertyText("FlagKills"));
  TempStats.Covers =  int(RI.GetPropertyText("Covers"));
  // SmartCTF builds use slightly different names for this stat.
  // Keep fallbacks so the Unreal Arena build remains compatible across variants.
  TempStats.Seals = GetSmartCTFStat(RI, "Seals", "Seal", "SealKills", "FlagSeals");
  TempStats.Frags =  int(RI.GetPropertyText("Frags"));

  if (TempStats.Frags + PRI.Deaths == 0)
  TempStats.Efficiency =  0;
  else
  TempStats.Efficiency = int((float(TempStats.Frags)/(pri.Deaths+float(TempStats.Frags)))*100);

  TempStats.Score = PRI.Score;
  TempStats.PRI = PRI;
  TempStats.PlayerOwner = Pawn(PRI.Owner);

  return TempStats;
}

function string shortenName(string PlayerName, int NoChars,optional float MaxPixel)
{
  local float XL,YL;

  if (MaxPixel != 0)
  {
    do
    {
    CanvasX.StrLen(Left(PlayerName,NoChars), XL, YL);
    NoChars--;
    }
    until(XL < MaxPixel);
  }

  if (Len(PlayerName) > NoChars)
  return Left(PlayerName,NoChars)$"..";
  else
  return PlayerName;
}

simulated function Timer()
{
  local int j;

  for (j = 0; j < 16; j++)
  {
    if (bluePlayer[j].PRI != none )
    {
      if (bluePlayer[j].PRI.TimeAcc > 0 )
      bluePlayer[j].PRI.TimeAcc--;
      else
      bluePlayer[j].PRI.TimeAcc = -1;
    }

    if (redPlayer[j].PRI != none )
    {
      if (redPlayer[j].PRI.TimeAcc > 0 )
      redPlayer[j].PRI.TimeAcc--;
      else
      redPlayer[j].PRI.TimeAcc = -1;
    }
  }
}

function PostRender(canvas canvas)
{
  local float ResScale;
  local float PanelWidth;

  if (canvasx == none)
  canvasx = canvas;

  updateAndSort();

  if ( (Canvas.ClipX < 2250 && Canvas.ClipX >= 1750) || (Canvas.ClipY < 1150 && Canvas.ClipY >= 900) )
  ResScale=0.75;
  else if ( Canvas.ClipX < 1750 || Canvas.ClipY < 900 )
  ResScale=0.5;
  else
  ResScale=1.00;

  if (SavedScreen != Canvas.ClipX+Canvas.ClipY)
  {
    Font469_16 = none;
    Font469_16b = none;
    Font469_18b = none;
    SavedScreen = Canvas.ClipX+Canvas.ClipY;
  }

  // macOS 469 compatibility: keep using the HUD's stock FontInfo fonts.
  if (Font469_16 == none && OH != none)
  Font469_16 = OH.UAFont16(Canvas);
  if (Font469_16b == none && OH != none)
  Font469_16b = OH.UAFont16(Canvas);
  if (Font469_18b == none && OH != none)
  Font469_18b = OH.UAFont18(Canvas);

  if ( !class'OverlaySettings'.default.bScoreBoardState )
  return;

  // Keep the scoreboard out of the action: one compact panel in each top corner.
  PanelWidth = 570 * ResScale;
  DrawTeamPanel(Canvas, 0, 6 * ResScale, 6 * ResScale, ResScale);
  DrawTeamPanel(Canvas, 1, Canvas.ClipX - PanelWidth - (6 * ResScale), 6 * ResScale, ResScale);
}

function DrawTeamPanel(Canvas Canvas, byte Team, float StartX, float StartY, float ResScale)
{
  local int j, PlayerCount;
  local float CurY, RowHeight, PanelWidth;
  local float NameX, CapsX, GrabsX, FCKillsX, CoversX, SealsX, FragsX, EffX;
  local float TextW, TextH, HeaderTextY, RowTextY;
  local PlayerStats CurrentPlayer;
  local bool bSpectated;

  PanelWidth = 570 * ResScale;

  // FIX8: UT fonts do not scale continuously with our geometry.
  // Measure the actual font and never allow a row to become shorter than the glyphs.
  Canvas.Font = Font469_16b;
  Canvas.StrLen("Ag", TextW, TextH);
  RowHeight = 19 * ResScale;
  if (RowHeight < TextH + 4)
  RowHeight = TextH + 4;

  CurY = StartY;

  NameX = StartX + 32 * ResScale;
  CapsX = StartX + 220 * ResScale;
  GrabsX = StartX + 270 * ResScale;
  FCKillsX = StartX + 325 * ResScale;
  CoversX = StartX + 385 * ResScale;
  SealsX = StartX + 435 * ResScale;
  FragsX = StartX + 490 * ResScale;
  EffX = StartX + 558 * ResScale;

  if (Team == 0)
  PlayerCount = redPlayerCount;
  else
  PlayerCount = bluePlayerCount;

  // UA 2.0: charcoal broadcast header with a team-color rail and restrained gold separator.
  // The geometry remains identical to FIX2 so chat/killfeed placement is unaffected.
  Canvas.Style = ERenderStyle.STY_Translucent;
  if (class'OverlaySettings'.default.bHighContrastMode)
  Canvas.DrawColor = SetColor(10,12,15);
  else
  Canvas.DrawColor = SetColor(9,11,15);

  Canvas.SetPos(StartX, CurY);
  Canvas.DrawRect(Texture'white_1x1', PanelWidth, RowHeight);

  // Thin top accent identifies the team without filling the whole header.
  Canvas.Style = ERenderStyle.STY_Normal;
  if (Team == 0)
  Canvas.DrawColor = SetColor(214,42,46);
  else
  Canvas.DrawColor = SetColor(48,112,232);
  Canvas.SetPos(StartX, CurY);
  Canvas.DrawRect(Texture'white_1x1', PanelWidth, 3 * ResScale);

  Canvas.Style = ERenderStyle.STY_Normal;
  Canvas.DrawColor = SetColor(218,222,228);
  Canvas.Font = Font469_16;
  Canvas.StrLen("Ag", TextW, TextH);
  HeaderTextY = CurY + (RowHeight - TextH) * 0.5;

  if (class'OverlaySettings'.default.bPlayerNumbers)
  DrawTextLeft(Canvas, "#", StartX + 7 * ResScale, HeaderTextY, false, true);

  // Team label gets the team accent; column labels stay neutral for readability.
  if (Team == 0)
  Canvas.DrawColor = SetColor(238,82,84);
  else
  Canvas.DrawColor = SetColor(102,166,255);

  if (Team == 0)
  DrawTextLeft(Canvas, "RED (" $ string(PlayerCount) $ ")", NameX, HeaderTextY, false, true);
  else
  DrawTextLeft(Canvas, "BLUE (" $ string(PlayerCount) $ ")", NameX, HeaderTextY, false, true);

  Canvas.DrawColor = SetColor(176,182,190);
  DrawTextRight(Canvas, "CAP", CapsX, HeaderTextY, false, true);
  DrawTextRight(Canvas, "GRB", GrabsX, HeaderTextY, false, true);
  DrawTextRight(Canvas, "FK", FCKillsX, HeaderTextY, false, true);
  DrawTextRight(Canvas, "COV", CoversX, HeaderTextY, false, true);
  DrawTextRight(Canvas, "SEA", SealsX, HeaderTextY, false, true);
  DrawTextRight(Canvas, "FRG", FragsX, HeaderTextY, false, true);
  DrawTextRight(Canvas, "EFF", EffX, HeaderTextY, false, true);

  // Quiet separator: helps distinguish labels from live rows without adding height.
  Canvas.Style = ERenderStyle.STY_Normal;
  Canvas.DrawColor = SetColor(218,174,70);
  Canvas.SetPos(StartX, CurY + RowHeight - 1 * ResScale);
  Canvas.DrawRect(Texture'white_1x1', PanelWidth, 1 * ResScale);

  CurY += RowHeight;

  for (j = 0; j < PlayerCount; j++)
  {
    if (Team == 0)
    CurrentPlayer = redPlayer[j];
    else
    CurrentPlayer = bluePlayer[j];

    bSpectated = false;
    if (OH.PawnOwner != none && OH.PlayerOwner != none && OH.PawnOwner != OH.PlayerOwner &&
        OH.PawnOwner.PlayerReplicationInfo != none &&
        CurrentPlayer.PlayerName == OH.PawnOwner.PlayerReplicationInfo.PlayerName)
    bSpectated = true;

    // Mostly neutral rows: much less screen tint, while keeping subtle zebra separation.
    Canvas.Style = ERenderStyle.STY_Translucent;
    if (class'OverlaySettings'.default.bHighContrastMode)
    {
      if (j % 2 == 0)
      Canvas.DrawColor = SetColor(14,14,14);
      else
      Canvas.DrawColor = SetColor(8,8,8);
    }
    else
    {
      if (j % 2 == 0)
      Canvas.DrawColor = SetColor(13,15,19);
      else
      Canvas.DrawColor = SetColor(8,10,13);
    }

    if (bSpectated)
    Canvas.DrawColor = SetColor(28,31,38);

    Canvas.SetPos(StartX, CurY);
    Canvas.DrawRect(Texture'white_1x1', PanelWidth, RowHeight);

    // A subtle team edge keeps rows visually associated with RED/BLUE.
    Canvas.Style = ERenderStyle.STY_Normal;
    if (Team == 0)
    Canvas.DrawColor = SetColor(150,30,34);
    else
    Canvas.DrawColor = SetColor(30,74,170);
    Canvas.SetPos(StartX, CurY);
    Canvas.DrawRect(Texture'white_1x1', 2 * ResScale, RowHeight);

    // Spectated player: bright neutral/gold marker, readable without a large filled row.
    if (bSpectated)
    {
      Canvas.DrawColor = SetColor(218,174,70);
      Canvas.SetPos(StartX, CurY);
      Canvas.DrawRect(Texture'white_1x1', 4 * ResScale, RowHeight);
    }

    // Preserve AMP countdown bar, but make it subtler than the row background.
    if (class'OverlaySettings'.default.iAmpEffects == 2 && CurrentPlayer.PRI != none && CurrentPlayer.PRI.TimeAcc != -1)
    {
      Canvas.DrawColor = SetColor(44,20,62);
      Canvas.Style = ERenderStyle.STY_Translucent;
      Canvas.SetPos(StartX + (4 * ResScale), CurY);
      Canvas.DrawRect(Texture'white_1x1', ((PanelWidth - (4 * ResScale)) / 30.0) * CurrentPlayer.PRI.TimeAcc, RowHeight);
    }

    // UA 2.0 row frame: a single muted baseline keeps dense stats aligned
    // without adding another bright decorative rail.
    Canvas.Style = ERenderStyle.STY_Normal;
    Canvas.DrawColor = SetColor(28,31,37);
    Canvas.SetPos(StartX + (4 * ResScale), CurY + RowHeight - 1);
    Canvas.DrawRect(Texture'white_1x1', PanelWidth - (4 * ResScale), 1);

    Canvas.Style = ERenderStyle.STY_Normal;
    Canvas.DrawColor = SetColor(235,235,235);
    Canvas.Font = Font469_16b;
    Canvas.StrLen("Ag", TextW, TextH);
    RowTextY = CurY + (RowHeight - TextH) * 0.5;

    Canvas.Font = Font469_16;
    if (class'OverlaySettings'.default.bPlayerNumbers)
    DrawTextLeft(Canvas, string(CurrentPlayer.PlayerNumber), StartX + 7 * ResScale, RowTextY, false, true);

    // Player name remains the visual priority. The currently followed player gets a warm highlight.
    Canvas.Font = Font469_16b;
    if (bSpectated)
    Canvas.DrawColor = SetColor(236,198,104);
    else
    Canvas.DrawColor = SetColor(232,235,240);
    DrawTextLeft(Canvas, shortenName(CurrentPlayer.PlayerName, 24, 176 * ResScale), NameX, RowTextY, false, true);

    // Compact state badges get their own lane between player number and name.
    // FC uses the enemy flag color and AMP uses purple, with enough breathing room to stay distinct from the nick.
    if (CurrentPlayer.PRI != none && CurrentPlayer.PRI.HasFlag != none && !OH.IsInWarmup())
    {
      if (Team == 0)
      Canvas.DrawColor = SetColor(55,120,255);
      else
      Canvas.DrawColor = SetColor(235,55,55);
      Canvas.Style = ERenderStyle.STY_Normal;
      Canvas.SetPos(NameX - (10 * ResScale), CurY + (RowHeight - 10 * ResScale) * 0.5);
      Canvas.DrawRect(Texture'white_1x1', 6 * ResScale, 10 * ResScale);
    }

    if (class'OverlaySettings'.default.iAmpEffects == 1 && CurrentPlayer.PRI != none && CurrentPlayer.PRI.TimeAcc != -1)
    {
      Canvas.DrawColor = SetColor(165,85,215);
      Canvas.Style = ERenderStyle.STY_Normal;
      Canvas.SetPos(NameX - (10 * ResScale), CurY + (RowHeight - 3 * ResScale) * 0.5);
      Canvas.DrawRect(Texture'white_1x1', 6 * ResScale, 3 * ResScale);
    }

    Canvas.Font = Font469_16b;
    Canvas.DrawColor = SetColor(220,220,220);
    DrawTextRight(Canvas, string(CurrentPlayer.Caps), CapsX, RowTextY, true, true);
    DrawTextRight(Canvas, string(CurrentPlayer.Grabs), GrabsX, RowTextY, true, true);
    DrawTextRight(Canvas, string(CurrentPlayer.FCKills), FCKillsX, RowTextY, true, true);
    DrawTextRight(Canvas, string(CurrentPlayer.Covers), CoversX, RowTextY, true, true);

    // Seals get a soft violet tone so the new stat is easy to scan without dominating.
    Canvas.DrawColor = SetColor(190,150,224);
    DrawTextRight(Canvas, string(CurrentPlayer.Seals), SealsX, RowTextY, true, true);

    Canvas.DrawColor = SetColor(218,222,228);
    DrawTextRight(Canvas, string(CurrentPlayer.Frags), FragsX, RowTextY, false, true);

    // Efficiency is the only metric with semantic color coding.
    if (CurrentPlayer.Efficiency >= 60)
    Canvas.DrawColor = SetColor(128,216,156);
    else if (CurrentPlayer.Efficiency >= 40)
    Canvas.DrawColor = SetColor(224,190,92);
    else
    Canvas.DrawColor = SetColor(224,116,120);
    DrawTextRight(Canvas, string(CurrentPlayer.Efficiency)$"%", EffX, RowTextY, false, true);

    CurY += RowHeight;
  }
}

function DrawTextRight(Canvas Canvas,string text, int X, int Y,optional bool hidezeros,optional bool dropshadow)
{
  local float w,h;
  local color oldcolor;
  local int oldstyle;

  oldcolor = canvas.drawcolor;
  oldstyle = canvas.style;
  Canvas.StrLen(text, w, h);

  if (dropshadow)
  {
    Canvas.Style = 1;
	Canvas.DrawColor = SetColor(0,0,0);
	Canvas.SetPos(X-w-1,Y-1);

    if (hidezeros)
    {
      if (Text != "0" && Text != "0%")
      Canvas.DrawText(Text);
    }
    else
    Canvas.DrawText(text);

    Canvas.DrawColor = oldcolor;
    Canvas.Style = oldstyle;
   }

  Canvas.SetPos(X-w, Y);

  if (hidezeros)
  {
    if (Text != "0" && Text != "0%")
    Canvas.DrawText(Text);
  }
  else
  Canvas.DrawText(text);
}

function DrawTextLeft(Canvas Canvas,string text, int X, int Y,optional bool hidezeros,optional bool dropshadow)
{
  local color oldcolor;
  local int oldstyle;

  oldcolor = canvas.drawcolor;
  oldstyle = canvas.style;

  if (dropshadow)
  {
    Canvas.Style = 1;
	Canvas.DrawColor = SetColor(0,0,0);
	Canvas.SetPos(X-1,Y-1);

    if (hidezeros)
    {
      if (Text != "0" && Text != "0%")
      Canvas.DrawText(Text);
    }
    else
    Canvas.DrawText(text);
    Canvas.DrawColor = oldcolor;
    Canvas.Style = oldstyle;
  }

  Canvas.SetPos(X, Y);

  if (hidezeros)
  {
    if (Text != "0" && Text != "0%")
    Canvas.DrawText(Text);
  }
  else
  Canvas.DrawText(text);
}

function DrawTextHighlighted(Canvas Canvas,string text, int X, int Y,optional bool hidezeros,optional bool dropshadow)  //not in use atm
{
  local color oldcolor;
  local int oldstyle,xo;
  local int Offsets[8];
  Offsets[0] = 1;
  Offsets[1] = 0;
  Offsets[2] = -1;
  Offsets[3] = 0;
  Offsets[4] = 0;
  Offsets[5] = 1;
  Offsets[6] = 0;
  Offsets[7] = -1;

  oldcolor = canvas.drawcolor;
  oldstyle = canvas.style;

  Canvas.Style = 1;
  Canvas.DrawColor = SetColor(90,90,0);

  for( xo = 0 ; xo < 4 ; xo++ )
  {
    Canvas.SetPos(X+Offsets[xo*2],Y+Offsets[(xo*2)+1]);
    Canvas.DrawText(text);
  }

  Canvas.DrawColor = oldcolor;
  Canvas.Style = oldstyle;
  Canvas.SetPos(X, Y);
  Canvas.DrawText(text);
}

function color SetColor( byte Red, byte Green, byte Blue, optional float Alpha )
{
  local color MyColor;

  if (Alpha == 0.0)
  Alpha = 1;

  MyColor.R = Red * Alpha;
  MyColor.G = Green *  Alpha;
  MyColor.B = Blue * Alpha;
  MyColor.A = 0;

  Return MyColor;
}

defaultproperties
{
}
