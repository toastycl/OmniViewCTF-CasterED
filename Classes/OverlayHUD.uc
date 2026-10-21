class OverlayHUD extends ChallengeCTFHUD;

#exec TEXTURE IMPORT FILE=Textures\white_1x1.pcx NAME=white_1x1 MIPS=Off
#exec TEXTURE IMPORT FILE=Textures\UnrealArenaLogo.pcx NAME=UnrealArenaLogo MIPS=Off FLAGS=2
#exec TEXTURE IMPORT FILE=Textures\amp_icon.pcx NAME=amp_icon MIPS=Off FLAGS=2
#exec TEXTURE IMPORT FILE=Textures\armor_icon.bmp NAME=armor_icon MIPS=Off FLAGS=2
#exec TEXTURE IMPORT FILE=Textures\belt_icon.pcx mp NAME=belt_icon MIPS=Off FLAGS=2
#exec TEXTURE IMPORT FILE=Textures\pads_icon.pcx NAME=pads_icon MIPS=Off FLAGS=2
#exec TEXTURE IMPORT FILE=Textures\health_icon.pcx NAME=health_icon MIPS=Off FLAGS=2
#exec TEXTURE IMPORT FILE=Textures\boots_icon.pcx NAME=boots_icon MIPS=Off FLAGS=2
#exec TEXTURE IMPORT FILE=Textures\invis_icon.pcx NAME=invis_icon MIPS=Off FLAGS=2
#exec TEXTURE IMPORT FILE=Textures\timer_checkmark_icon.pcx NAME=timer_checkmark_icon MIPS=Off FLAGS=2
#exec TEXTURE IMPORT FILE=TEXTURES\NumZero.pcx GROUP="Icons" NAME=NumZero MIPS=OFF FLAGS=2
#exec TEXTURE IMPORT FILE=TEXTURES\NumOne.PCX GROUP="Icons" NAME=NumOne MIPS=OFF FLAGS=2
#exec TEXTURE IMPORT FILE=TEXTURES\NumTwo.PCX GROUP="Icons" NAME=NumTwo MIPS=OFF FLAGS=2
#exec TEXTURE IMPORT FILE=TEXTURES\NumThree.PCX GROUP="Icons" NAME=NumThree MIPS=OFF FLAGS=2
#exec TEXTURE IMPORT FILE=TEXTURES\NumFour.PCX GROUP="Icons" NAME=NumFour MIPS=OFF FLAGS=2
#exec TEXTURE IMPORT FILE=TEXTURES\NumFive.PCX GROUP="Icons" NAME=NumFive MIPS=OFF FLAGS=2
#exec TEXTURE IMPORT FILE=TEXTURES\NumSix.PCX GROUP="Icons" NAME=NumSix MIPS=OFF FLAGS=2
#exec TEXTURE IMPORT FILE=TEXTURES\NumSeven.PCX GROUP="Icons" NAME=NumSeven MIPS=OFF FLAGS=2
#exec TEXTURE IMPORT FILE=TEXTURES\NumEight.PCX GROUP="Icons" NAME=NumEight MIPS=OFF FLAGS=2
#exec TEXTURE IMPORT FILE=TEXTURES\NumNine.PCX GROUP="Icons" NAME=NumNine MIPS=OFF FLAGS=2
#exec TEXTURE IMPORT FILE=TEXTURES\NumDash.PCX GROUP="Icons" NAME=NumDash MIPS=OFF FLAGS=2
#exec TEXTURE IMPORT FILE=TEXTURES\NumSimc.PCX GROUP="Icons" NAME=NumSimc MIPS=OFF FLAGS=2

var texture BigNums[10];

var int StartTime, Overtime;
var int AmpCount, BeltCount;
var int savedArmor;
var int IdentifiedID;
var int SavedPitch, LockTimer, AutoAdjustCamDelay;
var int MaxDist;

var float gametime, lasttime;
var float HealthBlink;

var float RedBlink, BlueBlink;
var bool b3rdPersonRotationLock;
var bool bHadWarmup;
var bool HealthBlinkUp;

var vector RedBase,BlueBase;

const KILLFEED_LINES = 8;
const KILLFEED_EXTRA_LIFETIME = 4;
const IDENTIFY_FADE_SECONDS = 2;

struct TPowerupTime
{
  var float timeleft;
  var bool inited;
};

var TPowerupTime ptimes[10];
var UDamage AMP;
var UT_Shieldbelt BELT;
var OverlayScoreboard OS;
var HUDLocalizedMessage KillMessageQueue[KILLFEED_LINES];
var HUDLocalizedMessage ChatMessageQueue[4];
var Canvas CanvasX;
var Font Font469_16, Font469_16b, Font469_18, Font469_18b, Font469_20, Font469_24b, Font469_32;
var int SavedScreen;

// Unreal Arena v1.5 smart powerup tracking.
var string UAAmpOwnerName, UABeltOwnerName;
var string UAPickupNotice;
var float UAPickupNoticeUntil;
var bool bUAPowerupStateReady;

// Unreal Arena v1.5.1 match score history.
struct UACapSnapshot
{
  var PlayerReplicationInfo PRI;
  var int Caps;
};

var UACapSnapshot UACapPlayers[16];
var int UACapPlayerCount;
var int UALastRedScore, UALastBlueScore;
var string UAScoreHistory[5];
var int UAScoreHistoryCount;
var string UALastCapturePlayer;
var byte UALastCaptureTeam;
var float UALastCaptureAt;

// Retry window for SmartCTF cap replication. Team score and player Captures
// can arrive on different ticks, so do not publish "Unknown" immediately.
var bool bUAPendingCaptureResolve;
var byte UAPendingCaptureTeam;
var float UAPendingCaptureUntil;

// Unreal Arena v1.5.2 live MVP prediction (last minute only).
var string UALiveMVPName;
var byte UALiveMVPTeam;
var int UALiveMVPScore;
var int UALiveMVPIndex;
var bool bUAMatchHistoryReady;

// Unreal Arena v1.5.3 player compare.
var bool bUACompareActive, bUACompareClosing;
var float UACompareAlpha;
var PlayerReplicationInfo UACompareAnchorPRI;

// Unreal Arena v1.5.4 manual MVP Focus panel.
var bool bUAMVPFocusActive, bUAMVPFocusClosing;
var float UAMVPFocusAlpha;

// Unreal Arena v2.0 EXPERIMENTAL Player Cam.
// Locks a secondary first-person portal view to the player being spectated
// when the configured key is pressed.
var bool bUAPlayerCamActive, bUAPlayerCamClosing;
var float UAPlayerCamAlpha;
var PlayerReplicationInfo UAPlayerCamPRI;

//////////////
// LET'S GO //
//////////////

// Unreal Arena macOS font compatibility helpers.
// Canvas.CreateFont() is unreliable on some macOS 469 builds, so the Mac-fix
// uses the stock BotPack FontInfo fonts provided by ChallengeHUD.
function Font UAFont16(Canvas C)
{
  if (MyFonts != None)
    return MyFonts.GetSmallestFont(C.ClipX);
  return C.Font;
}

function Font UAFont18(Canvas C)
{
  if (MyFonts != None)
    return MyFonts.GetSmallFont(C.ClipX);
  return C.Font;
}

function Font UAFont20(Canvas C)
{
  if (MyFonts != None)
    return MyFonts.GetMediumFont(C.ClipX);
  return C.Font;
}

function Font UAFont24(Canvas C)
{
  if (MyFonts != None)
    return MyFonts.GetBigFont(C.ClipX);
  return C.Font;
}

function Font UAFont32(Canvas C)
{
  if (MyFonts != None)
    return MyFonts.GetHugeFont(C.ClipX);
  return C.Font;
}

function Destroyed()
{
  class'OverlayAdvConfig'.static.ResetToDefaultDeathMsg();
  Super.Destroyed();
}

simulated function PostNetBeginPlay()
{
  showovo();
}

function ReportNewFlagCarrier(int ID, int CTFSwitch, PlayerReplicationInfo RelatedPRI)
{
  local PlayerReplicationInfo PRI;
  local PlayerReplicationinfo RedHolder,BlueHolder;
  local int switchID;

  if ( !class'OverlaySettings'.default.bAutoViewFC || PlayerOwner == None ||IsInWarmup() )
  return;

  if (CTFSwitch == 4 || CTFSwitch == 6  )
  {
    if (PawnOwner != none && ID == PawnOwner.PlayerReplicationInfo.PlayerID )
    return;

    if (PawnOwner.PlayerReplicationInfo.HasFlag != none )
    return;
  }

  foreach Level.AllActors(class'PlayerReplicationInfo', PRI)
  {
    if (PRI.HasFlag != none )
    {
      if (PRI.Team == 0 )
      redHolder = PRI;

      if (PRI.Team == 1 )
      blueHolder = PRI;
    }
  }

  switch(CTFSwitch)
  {
  case 6: // pickup from base
    Spectator(owner).ViewPlayerNum(ID);
    IdentifiedID = ID+1;
  break;

  case 4: // pickup from ground
    Spectator(owner).ViewPlayerNum(ID);
    IdentifiedID = ID+1;
  break;
  case 0:
  case 2:
  case 1:
  case 3:
    if (blueHolder != none)
    switchID = blueHolder.PlayerID;

    if (redHolder != none)
    switchID = redHolder.PlayerID;

    if (blueholder == none && redholder == none )
    switchID = -1;

    if (SwitchID != -1 && SwitchID != PawnOwner.PlayerReplicationInfo.PlayerID )
    {
      Spectator(owner).ViewPlayerNum(switchID);
      IdentifiedID = switchID+1;
    }
  break;
  }
}

exec function ViewPlayerNum(int ID)
{
  local int realID;

  realID = OS.realPlayerID(ID);
  Spectator(PlayerOwner).ViewPlayerNum(RealID);
}

exec function Fire()
{
  if ( class'OverlaySettings'.default.bEasySwitch && PlayerOwner == PawnOwner && IdentifyTarget != none && Spectator(Owner) != none && TraceIdentifyX() )
  {
    Spectator(owner).ViewPlayerNum(IdentifyTarget.PlayerID);
    IdentifiedID = IdentifyTarget.PlayerID+1;
  }
  else
  playerpawn(owner).Fire();
}

exec function uacompare()
{
  local PlayerReplicationInfo P;

  if (bUACompareActive || bUACompareClosing)
  {
    bUACompareActive = false;
    bUACompareClosing = true;
    return;
  }

  // Prefer the player currently being followed as Player A.
  if (PawnOwner != None && PawnOwner != PlayerOwner && PawnOwner.PlayerReplicationInfo != None && !PawnOwner.PlayerReplicationInfo.bIsSpectator)
    UACompareAnchorPRI = PawnOwner.PlayerReplicationInfo;
  else
  {
    UACompareAnchorPRI = None;
    foreach Level.AllActors(class'PlayerReplicationInfo', P)
    {
      if (!P.bIsSpectator && P.Team != 255)
      {
        UACompareAnchorPRI = P;
        break;
      }
    }
  }

  if (UACompareAnchorPRI == None)
    return;

  // Keep temporary broadcast panels mutually exclusive.
  bUAMVPFocusActive = false;
  bUAMVPFocusClosing = true;

  UACompareAlpha = 0.0;
  bUACompareClosing = false;
  bUACompareActive = true;
}

exec function uamvpfocus()
{
  if (bUAMVPFocusActive || bUAMVPFocusClosing)
  {
    bUAMVPFocusActive = false;
    bUAMVPFocusClosing = true;
    return;
  }

  UpdateUALiveMVP();
  if (UALiveMVPName == "" || UALiveMVPIndex < 0)
    return;

  // MVP Focus and Player Compare share the same broadcast space.
  bUACompareActive = false;
  bUACompareClosing = true;

  UAMVPFocusAlpha = 0.0;
  bUAMVPFocusClosing = false;
  bUAMVPFocusActive = true;
}

exec function uaplayercam()
{
  // Same key toggles Player Cam on/off.
  if (bUAPlayerCamActive || bUAPlayerCamClosing)
  {
    bUAPlayerCamActive = false;
    bUAPlayerCamClosing = true;
    return;
  }

  // Experimental v2.0 behavior: lock to the player currently being followed.
  // In Free Spect there is no first-person player target, so do nothing.
  if (PawnOwner == None || PawnOwner == PlayerOwner || PawnOwner.PlayerReplicationInfo == None
      || PawnOwner.PlayerReplicationInfo.bIsSpectator)
    return;

  UAPlayerCamPRI = PawnOwner.PlayerReplicationInfo;
  UAPlayerCamAlpha = 0.0;
  bUAPlayerCamClosing = false;
  bUAPlayerCamActive = true;
}

exec function showovo()
{
  local OverlayConfig OC;
  WindowConsole(PlayerPawn(Owner).Player.Console).bQuickKeyEnable = True;
  WindowConsole(PlayerPawn(Owner).Player.Console).LaunchUWindow();
  OC = OverlayConfig(WindowConsole(PlayerPawn(Owner).Player.Console).Root.CreateWindow(class'OverlayConfigWindow',10,10,150,100));
  OC.ShowWindow();
}

event Tick (float delta)
{
  Super.Tick (delta);

  // Short fade for the temporary compare panel.
  if (bUACompareActive)
  {
    UACompareAlpha += delta * 5.0;
    if (UACompareAlpha > 1.0)
      UACompareAlpha = 1.0;
  }
  else if (bUACompareClosing)
  {
    UACompareAlpha -= delta * 6.0;
    if (UACompareAlpha <= 0.0)
    {
      UACompareAlpha = 0.0;
      bUACompareClosing = false;
      UACompareAnchorPRI = None;
    }
  }

  // Same short broadcast transition used by Player Compare.
  if (bUAMVPFocusActive)
  {
    UAMVPFocusAlpha += delta * 5.0;
    if (UAMVPFocusAlpha > 1.0)
      UAMVPFocusAlpha = 1.0;
  }
  else if (bUAMVPFocusClosing)
  {
    UAMVPFocusAlpha -= delta * 6.0;
    if (UAMVPFocusAlpha <= 0.0)
    {
      UAMVPFocusAlpha = 0.0;
      bUAMVPFocusClosing = false;
    }
  }

  // Experimental Player Cam transition. DrawPortal itself cannot be alpha-faded
  // reliably in UE1, so the whole camera card uses a short vertical slide.
  if (bUAPlayerCamActive)
  {
    UAPlayerCamAlpha += delta * 5.0;
    if (UAPlayerCamAlpha > 1.0)
      UAPlayerCamAlpha = 1.0;
  }
  else if (bUAPlayerCamClosing)
  {
    UAPlayerCamAlpha -= delta * 6.0;
    if (UAPlayerCamAlpha <= 0.0)
    {
      UAPlayerCamAlpha = 0.0;
      bUAPlayerCamClosing = false;
      UAPlayerCamPRI = None;
    }
  }

  if (HealthBlink <= 0.0)
  HealthBlinkUp = true;
  if (HealthBlink >= 0.5)
  HealthBlinkUp = false;

  if (HealthBlinkUp)
  HealthBlink += delta;
  else if (!HealthBlinkUp)
  HealthBlink -= delta;

  if (Owner.Level.Pauser == "")
  gametime += delta;

  if (PlayerOwner != PawnOwner  )
  {
    if (IdentifiedID != 0 && PawnOwner.PlayerReplicationInfo.PlayerID != IdentifiedID-1 )
    {
      Spectator(owner).ViewPlayerNum(IdentifiedID-1);
      IdentifiedID = 0;
    }

    if (SavedPitch != PlayerPawn(Owner).ViewRotation.Pitch)
    {
      LockTimer = 0;
      SavedPitch = PlayerPawn(Owner).ViewRotation.Pitch;
    }

    if ( class'OverlaySettings'.default.bAutoAdjustCam )
    {
      if ( class'OverlaySettings'.default.iAutoAdjustCamDelay == 0)
      AutoAdjustCamDelay = 1;
      else if ( class'OverlaySettings'.default.iAutoAdjustCamDelay == 1)
      AutoAdjustCamDelay = 3;
      else if ( class'OverlaySettings'.default.iAutoAdjustCamDelay == 2)
      AutoAdjustCamDelay = 5;

      if (LockTimer > AutoAdjustCamDelay )
      Spectator(owner).ViewRotation.Yaw = Spectator(owner).TargetViewRotation.Yaw;
    }
  }

  if (PlayerPawn(Owner).GameReplicationInfo != none )
  {
    if (PlayerPawn(Owner).GameReplicationInfo.RemainingTime != 0 )
    PlayerPawn(Owner).GameReplicationInfo.ElapsedTime = 0;
  }
}

function Spawned()
{
  OS = Owner.Level.Spawn(class'OverlayScoreboard');
  OS.OH = self;
  OS.SetTimer(1, true);

  foreach Level.allactors (class 'UDamage', AMP)
  {
    AmpCount++;
  }

  foreach Level.allactors (class 'UT_Shieldbelt', BELT)
  {
    BeltCount++;
  }

  StartTime = PlayerPawn(Owner).GameReplicationInfo.RemainingTime;

  Super.Spawned();
}

// testing stuff for renderer //
exec function highdetail()
{
level.bHighDetailMode = true;
}

exec function lowdetail()
{
level.bHighDetailMode = false;
}
// /testing stuff for renderer //

function bool Contains(string str, string check)
{
  if (InStr(Caps(str), Caps(check)) > -1)
  return true;
  else
  return false;
}

function bool IsInWarmup()
{
  if ( PlayerPawn(Owner).GameReplicationInfo != none && StartTime == PlayerPawn(Owner).GameReplicationInfo.RemainingTime && !bHadWarmUp)
  {
  return true;
  }
  else
  {
  bHadWarmup = true;
  return false;
  }
}

function bool gotShieldBelt(Pawn InputPlayer)
{
  local UT_ShieldBeltEffect BELT;
  local bool foundBeltOwner;

  if (InputPlayer == none)
  return false;

  if (!Level.bHighDetailMode)
  {
    if (Contains(string(InputPlayer.Texture),"BELT_FX.SHIELDBELT") )
    return true;
    else
    return false;
  }
  else
  {
    foreach Level.allactors (class 'UT_ShieldbeltEffect', BELT)
    {
      if (BELT.Owner == InputPlayer)
      {
        foundBeltOwner = true;
        break;
      }
    }
  return foundBeltOwner;
  }
}

simulated function bool TraceIdentifyX()
{
  local actor Other;
  local vector HitLocation, HitNormal, StartTrace, EndTrace;

  StartTrace = PawnOwner.Location;
  StartTrace.Z += PawnOwner.BaseEyeHeight;
  EndTrace = StartTrace + vector(PawnOwner.ViewRotation) * 1500.0;
  Other = Trace(HitLocation, HitNormal, EndTrace, StartTrace, true);

  if ( Pawn(Other) != None )
  {
    if ( Pawn(Other).bIsPlayer && !Other.bHidden )
    {
      IdentifyTarget = Pawn(Other).PlayerReplicationInfo;
      IdentifyFadeTime = IDENTIFY_FADE_SECONDS;
    }
  }

  if ( (IdentifyFadeTime == 0.0) || (IdentifyTarget == None) || IdentifyTarget.bFeigningDeath )
  return false;

  return true;
}

simulated function SetIDColor( Canvas Canvas, int type )
{
  if ( type == 0 )
  Canvas.DrawColor = AltTeamColor[IdentifyTarget.Team] * 0.333 * IdentifyFadeTime;
  else
  Canvas.DrawColor = TeamColor[IdentifyTarget.Team] * 0.333 * IdentifyFadeTime;
}

simulated function bool DrawIdentifyInfo(canvas Canvas)
{
  if ( !TraceIdentifyX())
  return false;

  if( IdentifyTarget.PlayerName != "" )
  {
    Canvas.Font = MyFonts.GetBigFont(Canvas.ClipX);
    DrawTwoColorID(Canvas,IdentifyName, IdentifyTarget.PlayerName, Canvas.ClipY - 256 * Scale);
  }
  return true;
}

simulated function DrawTwoColorID( canvas Canvas, string TitleString, string ValueString, int YStart )
{
  local float XL, YL, XOffset;

  Canvas.Style = Style;
  Canvas.StrLen(ValueString, XL, YL);
  XOffset = Canvas.ClipX/2 - (XL)/2;
  Canvas.SetPos(XOffset, YStart);
  SetIDColor(Canvas,1);
  Canvas.DrawText(ValueString);
  Canvas.DrawColor = WhiteColor;
  Canvas.Font = MyFonts.GetSmallFont( Canvas.ClipX );
}


// Unreal Arena additions:
// - visible player name tags for spectators/broadcasts
// - discreet Unreal Arena branded watermark
// UE1/UT99 Canvas has no Project() method.  Project a world position manually
// from the spectator's actual camera so this also works in chase/third-person view.
simulated function bool UAWorldToScreen(Canvas Canvas, vector WorldLoc, out float ScreenX, out float ScreenY)
{
  local actor ViewActor;
  local vector CameraLocation, XAxis, YAxis, ZAxis, Delta;
  local rotator CameraRotation;
  local float Depth, FocalLength, HalfFOVRadians;

  if (PlayerOwner == None)
    return false;

  PlayerOwner.PlayerCalcView(ViewActor, CameraLocation, CameraRotation);
  GetAxes(CameraRotation, XAxis, YAxis, ZAxis);

  Delta = WorldLoc - CameraLocation;
  Depth = Delta dot XAxis;
  if (Depth <= 1.0)
    return false;

  HalfFOVRadians = PlayerOwner.FOVAngle * 0.008726646; // PI / 360
  FocalLength = (Canvas.ClipX * 0.5) / Tan(HalfFOVRadians);

  ScreenX = Canvas.ClipX * 0.5 + ((Delta dot YAxis) * FocalLength / Depth);
  ScreenY = Canvas.ClipY * 0.5 - ((Delta dot ZAxis) * FocalLength / Depth);

  // Return true as long as the point is in front of the camera.
  // The caller decides how to clamp the label to the viewport. This prevents
  // close players from losing their name just because their head projects
  // slightly outside the top edge of the screen.
  return true;
}

simulated function bool UAVisibleFromCamera(Pawn P, vector CameraLocation)
{
  local actor HitActor;
  local vector HitLocation, HitNormal, TestLoc;

  if (P == None)
    return false;

  // Trace only against world geometry.  This is important while following a
  // player: the spectator camera can be inside/behind the viewed pawn, so
  // PlayerOwner.LineOfSightTo() or an actor trace can incorrectly report that
  // every other player is hidden.
  TestLoc = P.Location;
  TestLoc.Z += P.CollisionHeight * 0.45;
  HitActor = Trace(HitLocation, HitNormal, TestLoc, CameraLocation, false);
  if (HitActor == None)
    return true;

  // Try a second point near the head so a low wall/ledge does not hide a
  // player whose upper body is actually visible to the broadcast camera.
  TestLoc = P.Location;
  TestLoc.Z += P.CollisionHeight * 0.90;
  HitActor = Trace(HitLocation, HitNormal, TestLoc, CameraLocation, false);
  return (HitActor == None);
}

simulated function DrawUAPlayerNames(Canvas Canvas)
{
  local Pawn P;
  local actor ViewActor;
  local vector CameraLocation;
  local rotator CameraRotation;
  local vector HeadLoc, TorsoLoc, FeetLoc;
  local float ScreenX, ScreenY, TorsoX, TorsoY, FeetX, FeetY;
  local float DrawX, DrawY;
  local float XL, YL, Dist, MaxDistUA, DistRatio, MaxNameW;
  local string PName, RawPName;
  local int NameChars;
  local color SavedColor;
  local byte SavedStyle;
  local bool bHasFlag, bHasAmp;
  local float MarkerY, MarkerW;

  if (!class'OverlaySettings'.default.bShowPlayerNames || PlayerOwner == None)
    return;

  // Always use the actual render camera.  PlayerOwner.Location remains the
  // spectator pawn position when following another player and is therefore
  // not a reliable origin for distance/visibility checks.
  PlayerOwner.PlayerCalcView(ViewActor, CameraLocation, CameraRotation);

  MaxDistUA = float(class'OverlaySettings'.default.iPlayerNameDistance);
  if (MaxDistUA <= 0)
    MaxDistUA = 3500.0;

  SavedColor = Canvas.DrawColor;
  SavedStyle = Canvas.Style;
  Canvas.Font = MyFonts.GetSmallFont(Canvas.ClipX);

  foreach Level.AllActors(class'Pawn', P)
  {
    if (P == None || P == PawnOwner || P.PlayerReplicationInfo == None)
      continue;

    if (P.PlayerReplicationInfo.bIsSpectator || P.PlayerReplicationInfo.Team > 1 || P.Health <= 0)
      continue;

    Dist = VSize(P.Location - CameraLocation);
    if (Dist > MaxDistUA)
      continue;

    // Do not reveal players through walls, using the actual broadcast camera
    // as the visibility origin in both free-cam and player-follow modes.
    if (!UAVisibleFromCamera(P, CameraLocation))
      continue;

    // Require at least part of the player's body to be inside the viewport.
    // We use torso/feet for this check because, at very short distance, the
    // head can legitimately project above the screen while the player is
    // still clearly visible.
    TorsoLoc = P.Location;
    TorsoLoc.Z += P.CollisionHeight * 0.25;
    FeetLoc = P.Location;
    FeetLoc.Z -= P.CollisionHeight * 0.75;

    if (!UAWorldToScreen(Canvas, TorsoLoc, TorsoX, TorsoY))
      continue;

    if (TorsoX < 0 || TorsoX > Canvas.ClipX || TorsoY < 0 || TorsoY > Canvas.ClipY)
    {
      if (!UAWorldToScreen(Canvas, FeetLoc, FeetX, FeetY))
        continue;
      if (FeetX < 0 || FeetX > Canvas.ClipX || FeetY < 0 || FeetY > Canvas.ClipY)
        continue;
    }

    HeadLoc = P.Location;
    HeadLoc.Z += P.CollisionHeight + 18.0;

    if (!UAWorldToScreen(Canvas, HeadLoc, ScreenX, ScreenY))
      continue;

    RawPName = P.PlayerReplicationInfo.PlayerName;
    if (RawPName == "")
      continue;

    // Distance-responsive world tags.  Near players keep the complete name;
    // medium/far players progressively use a tighter pixel budget so a busy
    // spectator view stays readable instead of filling the screen with text.
    DistRatio = Dist / MaxDistUA;
    if (DistRatio >= 0.70)
    {
      Canvas.Font = MyFonts.GetSmallestFont(Canvas.ClipX);
      MaxNameW = 92.0;
    }
    else if (DistRatio >= 0.35)
    {
      Canvas.Font = MyFonts.GetSmallFont(Canvas.ClipX);
      MaxNameW = 130.0;
    }
    else
    {
      Canvas.Font = MyFonts.GetSmallFont(Canvas.ClipX);
      MaxNameW = 180.0;
    }

    PName = RawPName;
    Canvas.StrLen(PName, XL, YL);
    NameChars = Len(RawPName);
    while (XL > MaxNameW && NameChars > 4)
    {
      NameChars--;
      PName = Left(RawPName, NameChars) $ "..";
      Canvas.StrLen(PName, XL, YL);
    }

    DrawX = ScreenX - XL * 0.5;
    DrawY = ScreenY - YL - 7;

    // Keep the tag visible when a player is very close to the camera.
    // The world anchor can move outside the top edge, but the tag stays
    // clamped to the nearest safe point on screen.
    if (DrawX < 4)
      DrawX = 4;
    if (DrawX > Canvas.ClipX - XL - 4)
      DrawX = Canvas.ClipX - XL - 4;
    if (DrawY < 4)
      DrawY = 4;
    if (DrawY > Canvas.ClipY - YL - 4)
      DrawY = Canvas.ClipY - YL - 4;

    // Strong black outline/shadow to keep names readable over bright maps.
    Canvas.Style = ERenderStyle.STY_Normal;
    Canvas.DrawColor = SetColor(0, 0, 0);
    Canvas.SetPos(DrawX + 1, DrawY + 1);
    Canvas.DrawText(PName, False);

    Canvas.SetPos(DrawX - 1, DrawY - 1);
    Canvas.DrawText(PName, False);

    // Team color remains the primary name cue, but distant tags are slightly
    // muted so they do not compete with nearby action. FC/AMP markers stay vivid.
    if (P.PlayerReplicationInfo.Team == 0)
    {
      if (DistRatio >= 0.70)
        Canvas.DrawColor = SetColor(190, 65, 65);
      else if (DistRatio >= 0.35)
        Canvas.DrawColor = SetColor(225, 68, 68);
      else
        Canvas.DrawColor = SetColor(255, 70, 70);
    }
    else
    {
      if (DistRatio >= 0.70)
        Canvas.DrawColor = SetColor(70, 100, 195);
      else if (DistRatio >= 0.35)
        Canvas.DrawColor = SetColor(75, 115, 225);
      else
        Canvas.DrawColor = SetColor(80, 125, 255);
    }

    Canvas.SetPos(DrawX, DrawY);
    Canvas.DrawText(PName, False);

    // Broadcast state markers: small enough to keep the world view clean.
    // FC gets an enemy-flag underline; AMP gets a short purple cap above the name.
    bHasFlag = (class'OverlaySettings'.default.bFC_Info && P.PlayerReplicationInfo.HasFlag != None && !IsInWarmup());
    bHasAmp = (class'OverlaySettings'.default.iAmpEffects != 0 && P.PlayerReplicationInfo.TimeAcc != -1);

    Canvas.Style = ERenderStyle.STY_Normal;
    if (bHasFlag)
    {
      if (P.PlayerReplicationInfo.Team == 0)
        Canvas.DrawColor = SetColor(55, 120, 255);
      else
        Canvas.DrawColor = SetColor(235, 55, 55);

      MarkerY = DrawY + YL + 2;
      Canvas.SetPos(DrawX, MarkerY);
      Canvas.DrawRect(Texture'white_1x1', XL, 2);
    }

    if (bHasAmp)
    {
      Canvas.DrawColor = SetColor(165, 85, 215);
      MarkerY = DrawY - 3;
      if (MarkerY < 2)
        MarkerY = 2;
      MarkerW = XL;
      if (MarkerW > 14)
        MarkerW = 14;
      Canvas.SetPos(DrawX, MarkerY);
      Canvas.DrawRect(Texture'white_1x1', MarkerW, 2);
    }
  }

  Canvas.DrawColor = SavedColor;
  Canvas.Style = SavedStyle;
}

simulated function DrawUnrealArenaBrand(Canvas Canvas)
{
  local float LogoSize, X, Y;
  local color SavedColor;
  local byte SavedStyle;

  if (!class'OverlaySettings'.default.bShowUnrealArenaLogo)
    return;

  // 0 = small, 1 = normal, 2 = large
  if (class'OverlaySettings'.default.iUnrealArenaLogoSize <= 0)
    LogoSize = 75.0 * Scale;
  else if (class'OverlaySettings'.default.iUnrealArenaLogoSize == 1)
    LogoSize = 100.0 * Scale;
  else
    LogoSize = 125.0 * Scale;

  SavedColor = Canvas.DrawColor;
  SavedStyle = Canvas.Style;

  X = Canvas.ClipX - LogoSize - (18.0 * Scale);
  Y = Canvas.ClipY - LogoSize - (18.0 * Scale);

  Canvas.Style = ERenderStyle.STY_Translucent;
  Canvas.DrawColor = SetColor(255,255,255);
  Canvas.SetPos(X, Y);
  Canvas.DrawTile(Texture'UnrealArenaLogo', LogoSize, LogoSize, 0, 0, 256, 256);

  Canvas.DrawColor = SavedColor;
  Canvas.Style = SavedStyle;
}


function vector returnFlagCarrierLoc(int TeamID)
{
  local playerpawn pp;

  foreach PlayerOwner.Level.AllActors(class'PlayerPawn', PP)
  {
    if (PP.PlayerReplicationInfo.HasFlag != none && PP.PlayerReplicationInfo.Team == TeamID )
    {
    return PP.Location;
    }
  }

  return vect(0,0,0);
}

// draw overlay //
simulated function PostRender( canvas Canvas )
{
  local int i;
  local PlayerReplicationInfo PRI;
  local CTFFlag Flag;
  local Texture TempTex;
  local float TempScale, TempValue, TempX,TempY;
  local int xo;
  local int Offsets[8];
  local float CalcDist, CalcSpeed;
  local float blinkblink;
  local float ResScale, OBSOffset;
  local vector FlagPos;
  Offsets[0] = 1;
  Offsets[1] = 0;
  Offsets[2] = -1;
  Offsets[3] = 0;
  Offsets[4] = 0;
  Offsets[5] = 1;
  Offsets[6] = 0;
  Offsets[7] = -1;

  if ( class'OverlaySettings'.default.iOBSOffset == 0 )
    OBSOffset = 0;
  else if ( class'OverlaySettings'.default.iOBSOffset == 1 )
    OBSOffset = 25;
  else if ( class'OverlaySettings'.default.iOBSOffset == 2 )
    OBSOffset = 50;
      else if ( class'OverlaySettings'.default.iOBSOffset == 3 )
    OBSOffset = 75;

  Super(HUD).PostRender( Canvas );

  HUDSetup(canvas);

// make sure player exists //
  if ( (PawnOwner == None) || (PlayerOwner.PlayerReplicationInfo == None) )
  return;

  if ( (PlayerOwner == None) || (PawnOwner == None) || (PlayerOwner.GameReplicationInfo == None)
  || (PawnOwner.PlayerReplicationInfo == None)
  || ((PlayerOwner.bShowMenu || PlayerOwner.bShowScores) && (Canvas.ClipX < 640)) )
  return;

  if (OS != none && !PlayerOwner.bShowScores)
  OS.PostRender(Canvas);

  // Track score transitions after the scoreboard has refreshed SmartCTF stats.
  UpdateUAMatchHistory();

// set fonts //
  if ( (Canvas.ClipX < 2250 && Canvas.ClipX >= 1750) || (Canvas.ClipY < 1150 && Canvas.ClipY >= 900) )
  {
  ResScale=0.75;
  }
  else if ( Canvas.ClipX < 1750 || Canvas.ClipY < 900 )
  {
  ResScale=0.5;
  }
  else
  {
  ResScale=1.00;
  }

  if (SavedScreen != Canvas.ClipX+Canvas.ClipY)
  {
    Font469_16 = none;
    Font469_16b = none;
    Font469_18 = none;
    Font469_18b = none;
    Font469_20 = none;
    Font469_24b = none;
    Font469_32 = none;
    SavedScreen = Canvas.ClipX+Canvas.ClipY;
  }

  // macOS 469 compatibility: avoid Canvas.CreateFont() entirely.
  // These stock FontInfo fonts render consistently on Windows and macOS.
  if (Font469_16 == none)
    Font469_16 = UAFont16(Canvas);
  if (Font469_16b == none)
    Font469_16b = UAFont16(Canvas);
  if (Font469_18 == none)
    Font469_18 = UAFont18(Canvas);
  if (Font469_18b == none)
    Font469_18b = UAFont18(Canvas);
  if (Font469_20 == none)
    Font469_20 = UAFont20(Canvas);
  if (Font469_24b == none)
    Font469_24b = UAFont24(Canvas);
  if (Font469_32 == none)
    Font469_32 = UAFont32(Canvas);

// draw chat text input //
  if ( PlayerOwner.Player.Console.bTyping )
  DrawTypingPrompt(Canvas, PlayerOwner.Player.Console);

// draw chat and kill feed //
  if (!bUAPlayerCamActive && !bUAPlayerCamClosing)
    DrawChat(Canvas);
  DrawKillFeed(Canvas);

// draw centered messages (you killed.. returned the flag..) //
  DrawCenterMessages(Canvas);

// F1 scoreboard //
  if ( PlayerOwner.bShowScores || bForceScores )
  {
    if ( (PlayerOwner.Scoring == None) && (PlayerOwner.ScoringType != None) )
    PlayerOwner.Scoring = Spawn(PlayerOwner.ScoringType, PlayerOwner);
	  if ( PlayerOwner.Scoring != None )
	  {
    	PlayerOwner.Scoring.OwnerHUD = self;
    	PlayerOwner.Scoring.ShowScores(Canvas);
    	if ( PlayerOwner.Player.Console.bTyping )
    	  DrawTypingPrompt(Canvas, PlayerOwner.Player.Console);
    	  return;
      }
  }

  if ( (PlayerOwner.ProgressTimeOut > Level.TimeSeconds) && !bHideCenterMessages )
  DisplayProgressMessage(Canvas); //

// Display Identification Info
  if ( PawnOwner == PlayerOwner )
  DrawIdentifyInfo(Canvas);

// crosshair and weapons postrender //
  if ( !PlayerOwner.bBehindView && (PawnOwner.Weapon != None) && (Level.LevelAction == LEVACT_None) )
  {
  Canvas.DrawColor = WhiteColor;
  PawnOwner.Weapon.PostRender(Canvas);
  if ( !PawnOwner.Weapon.bOwnsCrossHair )
  DrawCrossHair(Canvas, 0,0 );
  }

// draw back ground for scores, time, HP and armor //
  Canvas.DrawColor = SetColor(4, 4, 4);
  Canvas.Style = ERenderStyle.STY_Translucent;

// top center left (time)
  Canvas.SetPos(Canvas.ClipX * 0.5 - 108 * Scale, (24 + OBSOffset * ResScale) * Scale);
  Canvas.DrawRect(Texture'white_1x1', 4 * Scale, 76 * Scale);

// top center (time)
  Canvas.SetPos(Canvas.ClipX * 0.5 - 100 * Scale, (24 + OBSOffset * ResScale) * Scale);
  Canvas.DrawRect(Texture'white_1x1', 200 * Scale, 76 * Scale);

// top center right (time)
  Canvas.SetPos(Canvas.ClipX * 0.5 + 104 * Scale, (24 + OBSOffset * ResScale) * Scale);
  Canvas.DrawRect(Texture'white_1x1', 4 * Scale, 76 * Scale);

  if ( class'OverlaySettings'.default.bShowHealthArmor && !PlayerOwner.PlayerReplicationInfo.bIsSpectator )
  {
// bottom center left
    Canvas.SetPos(Canvas.ClipX * 0.5 - 250 * Scale, Canvas.ClipY * 1 - 112 * Scale);
    if ( !PawnOwner.PlayerReplicationInfo.bIsSpectator && PawnOwner.Health >= 50 )
    Canvas.DrawRect(Texture'white_1x1', 240 * Scale, 100 * Scale);
    else if ( !PawnOwner.PlayerReplicationInfo.bIsSpectator && PawnOwner.Health < 50 )
    {
    Canvas.DrawColor = SetColor(4 + 60*HealthBlink, 4 + 60*HealthBlink, 4 + 60*HealthBlink);
    Canvas.DrawRect(Texture'white_1x1', 240 * Scale, 100 * Scale);
    Canvas.DrawColor = SetColor(4, 4, 4);
    }

// bottom center
    Canvas.SetPos(Canvas.ClipX * 0.5 - 2 * Scale, Canvas.ClipY * 1 - 112 * Scale);
    if ( !PawnOwner.PlayerReplicationInfo.bIsSpectator )
    Canvas.DrawRect(Texture'white_1x1', 4 * Scale, 100 * Scale);

// bottom center right
    Canvas.SetPos(Canvas.ClipX * 0.5 + 10 * Scale, Canvas.ClipY * 1 - 112 * Scale);
    if ( !PawnOwner.PlayerReplicationInfo.bIsSpectator )
    Canvas.DrawRect(Texture'white_1x1', 240 * Scale, 100 * Scale);
  }

// scores top left and right plus accent colors and blinking
  for ( i=0; i<2; i++ )
  {
    Flag = CTFReplicationInfo(PlayerPawn(Owner).GameReplicationInfo).FlagList[i];

    if ( RedBase != vect(0,0,0) && BlueBase != vect(0,0,0) && class'OverlaySettings'.default.iFlagEffects == 2 )
    MaxDist = VSize(RedBase - BlueBase);
    else if ( class'OverlaySettings'.default.iFlagEffects == 1 )
    MaxDist = -1;
    else if ( class'OverlaySettings'.default.iFlagEffects == 0 )
    MaxDist = -2;

    Canvas.DrawColor = SetColor(4, 4, 4);
    Canvas.Style = ERenderStyle.STY_Translucent;

    if (Flag.bHome)
    {
      if (i == 0 )
      {
        // top center left
        Canvas.SetPos(Canvas.ClipX * 0.5 - 262  * Scale, (12 + OBSOffset * ResScale) * Scale);
  	    Canvas.DrawRect(Texture'white_1x1', 150 * Scale, 100 * Scale);

        Canvas.DrawColor = SetColor(128, 0, 0);

        if (RedBase == vect(0,0,0) && Flag.Location != vect(0,0,0) )
        RedBase = Flag.Location;
      }
      else
      {
        // top center right
        Canvas.SetPos(Canvas.ClipX * 0.5 + 112 * Scale, (12 + OBSOffset * ResScale) * Scale);
        Canvas.DrawRect(Texture'white_1x1', 150 * Scale, 100 * Scale);

        Canvas.DrawColor = SetColor(0, 0, 168);

        if (BlueBase == vect(0,0,0) && Flag.Location != vect(0,0,0) )
        BlueBase = Flag.Location;
      }
      blinkblink = 0;
    }
    else if (MaxDist != 0 )
    {
      if (i == 0 )
      FlagPos = returnFlagCarrierLoc(1);
      else
      FlagPos = returnFlagCarrierLoc(0);

      if (MaxDist == -1 || FlagPos == vect(0,0,0) )
      {
        calcSpeed = 0.5;
      }
      else if ( MaxDist == -2 )
      {
        calcSpeed = 0.0;
      }
      else
      {
        if (i == 0)
	    calcDist = VSize(FlagPos - RedBase);
        else
	    calcDist = VSize(FlagPos - BlueBase);

        calcDist = FClamp(calcDist, 600, MaxDist-600);
        calcSpeed = calcDist/MaxDist;
      }

      if (i == 0 )
      {
        if ( MaxDist == -2 )
        RedBlink = 0.0;
        else
        RedBlink += 12*calcspeed;

        if (RedBlink >= 1000)
        RedBlink = 0.0;

        if (RedBlink > 500 )
        {
          Canvas.DrawColor = SetColor(25, 10, 10);
  	      Canvas.SetPos(Canvas.ClipX * 0.5 - 262  * Scale, (12 + OBSOffset * ResScale) * Scale);
          Canvas.DrawRect(Texture'white_1x1', 150 * Scale, 100 * Scale);

          Canvas.Style = ERenderStyle.STY_Normal;
          Canvas.DrawColor = SetColor(128, 0, 0);
          Canvas.SetPos(Canvas.ClipX * 0.5 - 262 * Scale, (12 + OBSOffset * ResScale) * Scale);
 		  Canvas.DrawRect(Texture'white_1x1', 150 * Scale, 1);
 		  Canvas.SetPos(Canvas.ClipX * 0.5 - 113 * Scale, (12 + OBSOffset * ResScale) * Scale);
          Canvas.DrawRect(Texture'white_1x1', 1 , 100 * Scale);
 		  Canvas.SetPos(Canvas.ClipX * 0.5 - 262 * Scale, (111 + OBSOffset * ResScale)* Scale);
 		  Canvas.DrawRect(Texture'white_1x1', 150 * Scale, 1);
 		  Canvas.Style = ERenderStyle.STY_Translucent;

          blinkblink = 6;
          Canvas.DrawColor = SetColor(255, 0, 0);
        }
        else
        {
          Canvas.SetPos(Canvas.ClipX * 0.5 - 262  * Scale, (12 + OBSOffset * ResScale) * Scale);
          Canvas.DrawRect(Texture'white_1x1', 150 * Scale, 100 * Scale);
          Canvas.DrawColor = SetColor(128, 0, 0);
        }
      }
      else
      {
        if ( MaxDist == -2 )
        BlueBlink = 0.0;
        else
        BlueBlink += 12*calcspeed;

        if (BlueBlink >= 1000)
        BlueBlink = 0.0;

        if (BlueBlink > 500 )
        {
          Canvas.DrawColor = SetColor(10, 10, 35);
  		  Canvas.SetPos(Canvas.ClipX * 0.5 + 112 * Scale, (12 + OBSOffset * ResScale) * Scale);
 		  Canvas.DrawRect(Texture'white_1x1', 150 * Scale, 100 * Scale);

          Canvas.Style = ERenderStyle.STY_Normal;
          Canvas.DrawColor = SetColor(0, 0, 168);
          Canvas.SetPos(Canvas.ClipX * 0.5 + 112 * Scale, (12 + OBSOffset * ResScale) * Scale);
 		  Canvas.DrawRect(Texture'white_1x1', 150 * Scale, 1 );
 		  Canvas.SetPos(Canvas.ClipX * 0.5 + 112 * Scale, (12 + OBSOffset * ResScale) * Scale);
          Canvas.DrawRect(Texture'white_1x1', 1 , 100 * Scale);
 		  Canvas.SetPos(Canvas.ClipX * 0.5 + 112 * Scale, (111 + OBSOffset * ResScale) * Scale);
 		  Canvas.DrawRect(Texture'white_1x1', 150 * Scale, 1 );
 		  Canvas.Style = ERenderStyle.STY_Translucent;

          blinkblink = 6;
          Canvas.DrawColor = SetColor(0, 0, 255);
        }
        else
        {
          Canvas.SetPos(Canvas.ClipX * 0.5 + 112 * Scale, (12 + OBSOffset * ResScale) * Scale);
  		  Canvas.DrawRect(Texture'white_1x1', 150 * Scale, 100 * Scale);
          Canvas.DrawColor = SetColor(0, 0, 168);
        }
      }
    }

// score accents
    if ( i == 0 )
    {
      Canvas.Style = ERenderStyle.STY_Normal;
      Canvas.SetPos(Canvas.ClipX * 0.5 - 262 * Scale, (12 + OBSOffset * ResScale) * Scale);
      Canvas.DrawRect(Texture'white_1x1', (12+blinkblink) * Scale, 100 * Scale);
    }
    else
    {
      Canvas.Style = ERenderStyle.STY_Normal;
      Canvas.SetPos(Canvas.ClipX * 0.5 + (250-blinkblink)  * Scale, (12 + OBSOffset * ResScale) * Scale);
      Canvas.DrawRect(Texture'white_1x1', (12+blinkblink) * Scale, 100 * Scale);
    }
  }

  if ( class'OverlaySettings'.default.bShowHealthArmor && !PlayerOwner.PlayerReplicationInfo.bIsSpectator && !PawnOwner.PlayerReplicationInfo.bIsSpectator )
  {
//green accent bottom center left
    Canvas.DrawColor = SetColor(0, 45, 0);
    Canvas.Style = ERenderStyle.STY_Normal;

    Canvas.SetPos(Canvas.ClipX * 0.5 - 262  * Scale, Canvas.ClipY * 1 - 112 * Scale);
    Canvas.DrawRect(Texture'white_1x1', 12 * Scale, 100 * Scale);

// yellow accent bottom center right
    Canvas.DrawColor = SetColor(255, 200, 0);
    Canvas.Style = ERenderStyle.STY_Normal;

    Canvas.SetPos(Canvas.ClipX * 0.5 + 250  * Scale, Canvas.ClipY * 1 - 112 * Scale);
    Canvas.DrawRect(Texture'white_1x1', 12 * Scale, 100 * Scale);

// icon for HP //
    Canvas.Style = ERenderStyle.STY_Normal;

    TempTex = Texture'health_icon';
    TempScale = 0.35 * Scale;
    TempValue = 1-(FClamp(PawnOwner.Health,0,100) / 100);
    TempX = Canvas.ClipX * 0.5 - ((100 - 128 * 0.35) * 0.5 + 128 * 0.35) * Scale;
    TempY = Canvas.ClipY * 1 - (112 - (100 - 128 * 0.35) * 0.5) * Scale;

    Canvas.DrawColor = SetColor(255, 255, 255);
    Canvas.SetPos(TempX,TempY);
    Canvas.DrawIcon(TempTex, TempScale);

    Canvas.DrawColor = SetColor(100, 100, 100);
    Canvas.SetPos(TempX,TempY);
    Canvas.DrawTile(TempTex, 128 * TempScale, TempValue * TempScale * 128, 0, 0, 128, 128 * TempValue );

// icon for armor //
    TempTex = Texture'armor_icon';
    TempScale = 0.35 * Scale;
    TempValue = 1-(FClamp(savedArmor,0,100) / 100);
    TempX = Canvas.ClipX * 0.5 + (100 - 128 * 0.35) * 0.5 * Scale;
    TempY = Canvas.ClipY * 1 - (112 - (100 - 128 * 0.35) * 0.5) * Scale;

    Canvas.DrawColor = SetColor(255, 255, 255);
    Canvas.SetPos(TempX,TempY);
    Canvas.DrawIcon(TempTex, TempScale);

    Canvas.DrawColor = SetColor(100, 100, 100);
    Canvas.SetPos(TempX,TempY);
    Canvas.DrawTile(TempTex, 128 * TempScale, TempValue * TempScale * 128, 0, 0, 128, 128 * TempValue );
  }

// display score on top center left and right //
  Canvas.Style = ERenderStyle.STY_Normal;
  Canvas.DrawColor = SetColor(128, 0, 0);
  DrawBigNum(Canvas, int(CTFReplicationInfo(PlayerOwner.GameReplicationInfo).Teams[0].Score), Canvas.ClipX * 0.5 - 252 * Scale, (32 + OBSOffset * ResScale) * Scale, 1.75);
  Canvas.DrawColor = SetColor(0, 0, 168);
  DrawBigNum(Canvas, int(CTFReplicationInfo(PlayerOwner.GameReplicationInfo).Teams[1].Score), Canvas.ClipX * 0.5 + 112 * Scale, (32 + OBSOffset * ResScale) * Scale, 1.75);

// draw game time on top center //
  i = PlayerOwner.GameReplicationInfo.RemainingTime;
  if (i == 0)
  {
    i = PlayerOwner.GameReplicationInfo.ElapsedTime;
    if (OverTime < 0)
    OverTime = i;
    if (OverTime > 0)
    i = OverTime - i;
  }
  else
  OverTime = -1;

  Canvas.DrawColor = SetColor(255, 255, 255);
  Canvas.Style = ERenderStyle.STY_Normal;

  if (overTime == 1 )
  DrawTime(Canvas, Canvas.ClipX * 0.5 - 128 * 0.5 * Scale, (32 + OBSOffset * ResScale) * Scale, PlayerPawn(Owner).GameReplicationInfo.ElapsedTime, 1.75 * Scale);
  else
  DrawTime(Canvas, Canvas.ClipX * 0.5 - 128 * 0.5 * Scale, (32 + OBSOffset * ResScale) * Scale, i, 1.75 * Scale);

  // Compact match context: only the most recent capture scorer.
  DrawUALastCapture(Canvas);

  // Temporary player-vs-player comparison overlay.
  DrawUAPlayerCompare(Canvas);

  // UA 2.0 retains the manual MVP Focus behavior. The small last-minute MVP text remains automatic,
  // but this detailed breakdown only appears when the configured key is pressed.
  DrawUAMVPFocus(Canvas);

// display HP and armor amount //
  if ( !PlayerOwner.PlayerReplicationInfo.bIsSpectator && !PawnOwner.PlayerReplicationInfo.bIsSpectator && class'OverlaySettings'.default.bShowHealthArmor )
  {
    DrawBigNum(Canvas, Max(0, PawnOwner.Health), Canvas.ClipX * 0.5 - 236 * Scale, Canvas.ClipY * 1 - 94 * Scale, 1.75);
    DrawArmor(Canvas);
  }

  // UA smart powerup ownership. Keep the compact ownership line only;
  // pickup pop-up notifications were intentionally removed for a cleaner broadcast HUD.
  UpdateUAPowerupOwnership();

  // UA spectator status bar: Free Spect vs following a player.
  if ( PlayerOwner.PlayerReplicationInfo.bIsSpectator )
  DrawUASpectatorStatus(Canvas);

  // Experimental v2.0 first-person picture-in-picture camera.
  DrawUAPlayerCam(Canvas);

// draw timer for power ups //
  if ( class'OverlaySettings'.default.bShowItemTimer )
  {
    DrawUAPowerupOwners(Canvas);
    DrawItemTimer(canvas);
  }

// draw name of flag holder on top //
  if ( class'OverlaySettings'.default.bFC_Info && !IsInWarmup() )
  {
    for ( i=0; i<2; i++ )
    {
      Flag = CTFReplicationInfo(PlayerOwner.GameReplicationInfo).FlagList[i];
   	  foreach Level.AllActors(class'PlayerReplicationInfo', PRI)
      {
        if (PRI.HasFlag != none && PRI.Team != Flag.Team)
        {
    	Canvas.Style = 1;

          if (PRI.Team == 0 )
          Canvas.DrawColor = SetColor(128, 0, 0);
          else
          Canvas.DrawColor = SetColor(0, 0, 168);

          Canvas.Font = Font469_24b;

          if (PRI.Team == 0)
          {
            for( xo = 0 ; xo < 4 ; xo++ )
              DrawTextRight(canvas, shortenName(PRI.PlayerName, 20), Canvas.ClipX * 0.5 - 274 * Scale+Offsets[xo*2], (45 + OBSOffset * ResScale) * Scale + Offsets[(xo*2)+1]);

              Canvas.DrawColor = SetColor(255, 255, 255);
              DrawTextRight(canvas, shortenName(PRI.PlayerName, 20), Canvas.ClipX * 0.5 - 274 * Scale, (45 + OBSOffset * ResScale) * Scale);
          }
          else
          {
   		    for( xo = 0 ; xo < 4 ; xo++ )
            DrawTextLeft(canvas, shortenName(PRI.PlayerName, 20), Canvas.ClipX * 0.5 + 274  * Scale+Offsets[xo*2], (45 + OBSOffset * ResScale) * Scale + Offsets[(xo*2)+1], false, false);

            Canvas.DrawColor = SetColor(255, 255, 255);
            DrawTextLeft(canvas, shortenName(PRI.PlayerName, 20), Canvas.ClipX * 0.5 + 274  * Scale, (45 + OBSOffset * ResScale) * Scale, false, false);
          }
        }
      }
    }
  }

  // Unreal Arena broadcast additions. The original OmniView layout remains untouched.
  DrawUAPlayerNames(Canvas);
  DrawUnrealArenaBrand(Canvas);
}

// function to draw game time //
function DrawTime(Canvas Canvas, float X, float Y, int Seconds, float ExtraSize)
{
  local int Min, Sec,TimeStepX;
  local float FullSize;
  local float TimeScaleX;

  Min = Seconds / 60;
  Sec = Seconds % 60;
  X += ExtraSize * Scale;

  FullSize = 25 * Scale * 4 + 16 * Scale;

  Canvas.SetPos( X + 52 * Scale, Y + 10 * Scale);
  Canvas.CurX -= (FullSize / 2);

  TimeScaleX = 1.1 * Scale;
  TimeStepX = 6;

  Canvas.DrawColor = SetColor(255,255,255,1);

  DrawTimeDigit(Canvas, ((Min/10)%10), TimeStepX, TimeScaleX);
  Canvas.CurX -= TimeStepX * Scale;
  DrawTimeDigit(Canvas, (Min%10), TimeStepX, TimeScaleX);
  Canvas.CurX -= TimeStepX * Scale;
  DrawTimeDigit(Canvas, 0, TimeStepX, TimeScaleX, true );

  Canvas.CurX -= TimeStepX * Scale;

  if ( ((Sec/10)%10) == 1 )
  Canvas.CurX -= 15 * Scale;

  DrawTimeDigit(Canvas, ((Sec/10)%10), TimeStepX, TimeScaleX);
  Canvas.CurX -= TimeStepX * Scale;
  DrawTimeDigit(Canvas, (Sec%10), TimeStepX, TimeScaleX);
}

simulated function DrawTimeDigit(Canvas Canvas, int d, int Step, float UpScale, optional bool Semi )
{
  Canvas.Style = ERenderStyle.STY_Translucent;

  if (Semi)
  {
  	Canvas.CurX -= 0.5 * UpScale;
  	Canvas.DrawIcon(Texture'NumSimc', UpScale);
    return;
  }

  if ( d == 1 )
  Canvas.CurX -= 0.5*UpScale;

  Canvas.DrawIcon(BigNums[d], UpScale);
}

function Timer()
{
  local int i,j;
  Super.Timer();


  LockTimer++;
// Age the chat message queue original) //
  for (i=0; i<4; i++)
  {
    // Purge expired messages.
    if ( (ChatMessageQueue[i].Message != None) && (Level.TimeSeconds >= ChatMessageQueue[i].EndOfLife) )
    ClearMessage(ChatMessageQueue[i]);
  }

// Clean empty slots //
  for (i=0; i<3; i++)
  {
    if ( ChatMessageQueue[i].Message == None )
    {
      for (j=i; j<4; j++)
      {
        if ( ChatMessageQueue[j].Message != None )
        {
          CopyMessage(ChatMessageQueue[i],ChatMessageQueue[j]);
          ClearMessage(ChatMessageQueue[j]);
          break;
        }
      }
    }
  }
// Age the kill message queue //
  for (i=0; i<KILLFEED_LINES; i++)
  {
// Purge expired messages.
    if ( (KillMessageQueue[i].Message != None) && (Level.TimeSeconds >= KillMessageQueue[i].EndOfLife) )
    ClearMessage(KillMessageQueue[i]);
  }

// Clean empty slots //
  for (i=0; i<KILLFEED_LINES-1; i++)
  {
    if ( KillMessageQueue[i].Message == None )
    {
      for (j=i; j<KILLFEED_LINES; j++)
      {
        if ( KillMessageQueue[j].Message != None )
        {
          CopyMessage(KillMessageQueue[i],KillMessageQueue[j]);
          ClearMessage(KillMessageQueue[j]);
          break;
        }
      }
    }
  }
}

// function to corretly display custom death messages //
function string returnDeathMessage(Object Weapon)
{
  local string WeaponName;

  WeaponName = GetItemName(String(Weapon));

  if (Contains(WeaponName,"ImpactHammer") )
    return class'impacthammer'.default.DeathMessage;
  else if (Contains(WeaponName,"Translocator") )
    return class'Translocator'.default.DeathMessage;
  else if (Contains(WeaponName,"Enforcer") )
    return class'Enforcer'.default.DeathMessage;
  else if (Contains(WeaponName,"BioRifle") )
    return class'UT_BioRifle'.default.DeathMessage;
  else if (Contains(WeaponName,"SuperShockRifle") )
    return class'SuperShockRifle'.default.DeathMessage;
  else if (Contains(WeaponName,"ShockRifle") )
    return class'ShockRifle'.default.DeathMessage;
  else if (Contains(WeaponName,"PulseGun") )
    return class'PulseGun'.default.DeathMessage;
  else if (Contains(WeaponName,"Ripper") )
    return class'Ripper'.default.DeathMessage;
  else if (Contains(WeaponName,"Minigun") )
    return class'Minigun2'.default.DeathMessage;
  else if (Contains(WeaponName,"FlakCannon") )
    return class'UT_FlakCannon'.default.DeathMessage;
  else if (Contains(WeaponName,"Eightball") )
    return class'UT_EightBall'.default.DeathMessage;
  else if (Contains(WeaponName,"SniperRifle") )
    return class'SniperRifle'.default.DeathMessage;
  else
    return "UNKNOWN WEAPON: "$string(Weapon);
}

// Deal with a localized messages //
simulated function LocalizedMessage( class<LocalMessage> Message, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject, optional String CriticalString )
{
  local int i;

  if ( ClassIsChildOf( Message, class'PickupMessagePlus' ) )
  PickupTime = Level.TimeSeconds;


  if (ClassIsChildOf(Message, class'CTFMessage') )
    ReportNewFlagCarrier(RelatedPRI_1.PlayerID,Switch,RelatedPRI_1);

  if ( !Message.Default.bIsSpecial )
  {
    if (!ClassIsChildOf(Message, class'DeathMessagePlus')  && !ClassIsChildOf(Message, class'MultiKillMessage') && !Contains(String(Message),"IGPlus_DeathMessagePlus")  )
    {
      if ( ClassIsChildOf(Message, class'SayMessagePlus') ||
      ClassIsChildOf(Message, class'TeamSayMessagePlus') )
      {
        FaceTexture = RelatedPRI_1.TalkTexture;

        if ( FaceTexture != None )
        FaceTime = Level.TimeSeconds + 3;
      }
// Find an empty slot  //
      for (i=0; i<4; i++)
      {
        if ( ChatMessageQueue[i].Message == None )
        {
          ChatMessageQueue[i].Message = Message;
          ChatMessageQueue[i].Switch = Switch;
          ChatMessageQueue[i].RelatedPRI = RelatedPRI_1;
          ChatMessageQueue[i].OptionalObject = OptionalObject;
          ChatMessageQueue[i].EndOfLife = Message.Default.Lifetime + Level.TimeSeconds;
          if ( Message.Default.bComplexString )
          ChatMessageQueue[i].StringMessage = CriticalString;
          else
          ChatMessageQueue[i].StringMessage = Message.Static.GetString(Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
          return;
        }
      }
// No empty slots.  Force a message out //
      for (i=0; i<3; i++)
      CopyMessage(ChatMessageQueue[i], ChatMessageQueue[i+1]);

      ChatMessageQueue[3].Message = Message;
      ChatMessageQueue[3].Switch = Switch;
      ChatMessageQueue[3].RelatedPRI = RelatedPRI_1;
      ChatMessageQueue[3].OptionalObject = OptionalObject;
      ChatMessageQueue[3].EndOfLife = Message.Default.Lifetime + Level.TimeSeconds;

      if ( Message.Default.bComplexString )
      ChatMessageQueue[3].StringMessage = CriticalString;
      else
      ChatMessageQueue[3].StringMessage = Message.Static.GetString(Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
      return;
    }

  else
  {
    if ( ClassIsChildOf(Message, class'SayMessagePlus') || ClassIsChildOf(Message, class'TeamSayMessagePlus') )
    {
      FaceTexture = RelatedPRI_1.TalkTexture;

      if ( FaceTexture != None )
      FaceTime = Level.TimeSeconds + 3;
    }

    if ( class'OverlaySettings'.default.bMsgLengthKF)
    class'OverlayAdvConfig'.static.SetCustomDeathMsg();

// Find an empty slot //
    for (i=0; i<KILLFEED_LINES; i++)
    {
      if ( KillMessageQueue[i].Message == None )
      {
        KillMessageQueue[i].Message = Message;
        KillMessageQueue[i].Switch = Switch;
        KillMessageQueue[i].RelatedPRI = RelatedPRI_1;
        KillMessageQueue[i].OptionalObject = OptionalObject;
        KillMessageQueue[i].EndOfLife = Message.Default.Lifetime + Level.TimeSeconds + KILLFEED_EXTRA_LIFETIME;

        if ( Message.Default.bComplexString )
        KillMessageQueue[i].StringMessage = CriticalString;

        else
        {
          if (RelatedPRI_1 != none && RelatedPRI_2 != none && OptionalObject != none )
          {
            Class<Weapon>(OptionalObject).Default.DeathMessage=returnDeathMessage(OptionalObject);
            KillMessageQueue[i].StringMessage = Message.Static.GetString(Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
          }
          else
          KillMessageQueue[i].StringMessage = Message.Static.GetString(Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
        }
        return;
      }
    }
// No empty slots.  Force a message out //
    for (i=0; i<KILLFEED_LINES-1; i++)
      CopyMessage(KillMessageQueue[i], KillMessageQueue[i+1]);
      KillMessageQueue[KILLFEED_LINES-1].Message = Message;
	  KillMessageQueue[KILLFEED_LINES-1].Switch = Switch;
	  KillMessageQueue[KILLFEED_LINES-1].RelatedPRI = RelatedPRI_1;
	  KillMessageQueue[KILLFEED_LINES-1].OptionalObject = OptionalObject;
	  KillMessageQueue[KILLFEED_LINES-1].EndOfLife = Message.Default.Lifetime + Level.TimeSeconds+ KILLFEED_EXTRA_LIFETIME;

      if ( Message.Default.bComplexString )
      KillMessageQueue[i].StringMessage = CriticalString;

      else
      {
        if (RelatedPRI_1 != none && RelatedPRI_2 != none && OptionalObject != none )
        {
          Class<Weapon>(OptionalObject).Default.DeathMessage=returnDeathMessage(OptionalObject);
          KillMessageQueue[i].StringMessage = Message.Static.GetString(Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
        }
        else
        KillMessageQueue[i].StringMessage = Message.Static.GetString(Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
      }
      return;
    }
  }

  else
  {
    if ( CriticalString == "" )
    CriticalString = Message.Static.GetString(Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);

    if ( Message.Default.bIsUnique )
    {
      for (i=0; i<10; i++)
      {
        if (LocalMessages[i].Message != None)
        {
          if ((LocalMessages[i].Message == Message) || (LocalMessages[i].Message.Static.GetOffset(LocalMessages[i].Switch, 24, 640) == Message.Static.GetOffset(Switch, 24, 640)) )
          {
            LocalMessages[i].Message = Message;
            LocalMessages[i].Switch = Switch;
            LocalMessages[i].RelatedPRI = RelatedPRI_1;
            LocalMessages[i].OptionalObject = OptionalObject;
            LocalMessages[i].LifeTime = Message.Default.Lifetime;
            LocalMessages[i].EndOfLife = Message.Default.Lifetime + Level.TimeSeconds;
            LocalMessages[i].StringMessage = CriticalString;
            LocalMessages[i].DrawColor = Message.Static.GetColor(Switch, RelatedPRI_1, RelatedPRI_2);
            LocalMessages[i].XL = 0;
            return;
          }
        }
      }
    }

    for (i=0; i<10; i++)
    {
      if (LocalMessages[i].Message == None)
      {
        LocalMessages[i].Message = Message;
        LocalMessages[i].Switch = Switch;
        LocalMessages[i].RelatedPRI = RelatedPRI_1;
	    LocalMessages[i].OptionalObject = OptionalObject;
        LocalMessages[i].EndOfLife = Message.Default.Lifetime + Level.TimeSeconds;
        LocalMessages[i].StringMessage = CriticalString;
        LocalMessages[i].DrawColor = Message.Static.GetColor(Switch, RelatedPRI_1, RelatedPRI_2);
        LocalMessages[i].LifeTime = Message.Default.Lifetime;
        LocalMessages[i].XL = 0;
        return;
      }
    }
// No empty slots.  Force a message out //
    for (i=0; i<9; i++)
      CopyMessage(LocalMessages[i],LocalMessages[i+1]);
      LocalMessages[9].Message = Message;
      LocalMessages[9].Switch = Switch;
      LocalMessages[9].RelatedPRI = RelatedPRI_1;
      LocalMessages[9].OptionalObject = OptionalObject;
      LocalMessages[9].EndOfLife = Message.Default.Lifetime + Level.TimeSeconds;
      LocalMessages[9].StringMessage = CriticalString;
	  LocalMessages[9].DrawColor = Message.Static.GetColor(Switch, RelatedPRI_1, RelatedPRI_2);
	  LocalMessages[9].LifeTime = Message.Default.Lifetime;
	  LocalMessages[9].XL = 0;
	  return;
  }
}

// Entry point for string messages //
simulated function Message( PlayerReplicationInfo PRI, coerce string Msg, name MsgType )
{
  local int i;
  local Class<LocalMessage> MessageClass;

  switch (MsgType)
  {
    case 'Say':
      MessageClass = class'SayMessagePlus';
    break;

    case 'TeamSay':
      MessageClass = class'TeamSayMessagePlus';
    break;

    case 'CriticalEvent':
      MessageClass = class'CriticalStringPlus';
      LocalizedMessage( MessageClass, 0, None, None, None, Msg );
    return;

	default:
	  MessageClass= class'StringMessagePlus';
	break;
  }

  if ( ClassIsChildOf(MessageClass, class'SayMessagePlus') || ClassIsChildOf(MessageClass, class'TeamSayMessagePlus') )
  {
    FaceTexture = PRI.TalkTexture;
	FaceTeam = TeamColor[PRI.Team];

    if ( FaceTexture != None )
	FaceTime = Level.TimeSeconds + 3;

    if ( Msg == "" )
	return;
  }

  if (!ClassIsChildOf(MessageClass, class'DeathMessagePlus') && MsgType != 'DeathMessage'  && !ClassIsChildOf(MessageClass, class'MultiKillMessage'))
  {
    for (i=0; i<4; i++)
	{
      if ( ChatMessageQueue[i].Message == None )
      {
// Add the message here //
        ChatMessageQueue[i].Message = MessageClass;
        ChatMessageQueue[i].Switch = 0;
		ChatMessageQueue[i].RelatedPRI = PRI;
		ChatMessageQueue[i].OptionalObject = None;
		ChatMessageQueue[i].EndOfLife = MessageClass.Default.Lifetime + Level.TimeSeconds;

        if ( MessageClass.Default.bComplexString )
		ChatMessageQueue[i].StringMessage = Msg;
		else
		ChatMessageQueue[i].StringMessage = MessageClass.Static.AssembleString(self,0,PRI,Msg);
	  return;
	  }
	}

// No empty slots.  Force a message out //
	for (i=0; i<3; i++)
	CopyMessage(ChatMessageQueue[i],ChatMessageQueue[i+1]);
    ChatMessageQueue[3].Message = MessageClass;
	ChatMessageQueue[3].Switch = 0;
	ChatMessageQueue[3].RelatedPRI = PRI;
	ChatMessageQueue[3].OptionalObject = None;
	ChatMessageQueue[3].EndOfLife = MessageClass.Default.Lifetime + Level.TimeSeconds;

    if ( MessageClass.Default.bComplexString )
	ChatMessageQueue[3].StringMessage = Msg;
	else
	ChatMessageQueue[3].StringMessage = MessageClass.Static.AssembleString(self,0,PRI,Msg);
  }
  else
  {
    for (i=0; i<KILLFEED_LINES; i++)
	{
	  if ( KillMessageQueue[i].Message == None )
        {
// Add the message here //
          KillMessageQueue[i].Message = MessageClass;
          KillMessageQueue[i].Switch = 0;
          KillMessageQueue[i].RelatedPRI = PRI;
          KillMessageQueue[i].OptionalObject = None;
          KillMessageQueue[i].EndOfLife = MessageClass.Default.Lifetime + Level.TimeSeconds+KILLFEED_EXTRA_LIFETIME;

          if ( MessageClass.Default.bComplexString )
          KillMessageQueue[i].StringMessage = Msg$MessageClass;
          else
          KillMessageQueue[i].StringMessage = MessageClass.Static.AssembleString(self,0,PRI,Msg);
        return;
		}
	}
// No empty slots.  Force a message out //
	for (i=0; i<KILLFEED_LINES-1; i++)
    CopyMessage(KillMessageQueue[i],KillMessageQueue[i+1]);
    KillMessageQueue[KILLFEED_LINES-1].Message = MessageClass;
	KillMessageQueue[KILLFEED_LINES-1].Switch = 0;
	KillMessageQueue[KILLFEED_LINES-1].RelatedPRI = PRI;
	KillMessageQueue[KILLFEED_LINES-1].OptionalObject = None;
	KillMessageQueue[KILLFEED_LINES-1].EndOfLife = MessageClass.Default.Lifetime + Level.TimeSeconds+KILLFEED_EXTRA_LIFETIME;

    if ( MessageClass.Default.bComplexString )
	KillMessageQueue[KILLFEED_LINES-1].StringMessage = Msg;
	else
	KillMessageQueue[KILLFEED_LINES-1].StringMessage = MessageClass.Static.AssembleString(self,0,PRI,Msg);
  }
}

simulated function DrawTypingPrompt(Canvas Canvas, Console TypingConsole)
{
  local string TypingPrompt;
  local float XL, YL, PromptY, ScoreRowH, ResScale;
  local float OldClipX, OldClipY, OldOrgX, OldOrgY;

  OldClipX = Canvas.ClipX;
  OldClipY = Canvas.ClipY;
  OldOrgX = Canvas.OrgX;
  OldOrgY = Canvas.OrgY;

  Canvas.DrawColor = GreenColor;
  TypingPrompt = "(>" @ TypingConsole.TypedStr $ "_";
  Canvas.Font = MyFonts.GetSmallFont(Canvas.ClipX);
  Canvas.StrLen("TEST", XL, YL);

  // Position the typing line safely below the compact team table.
  // Match the same measured row-height rules used by the scoreboard/kill feed
  // so this stays correct across UT resolutions and fixed-pixel fonts.
  if (class'OverlaySettings'.default.bScoreBoardState)
  {
    if ( (Canvas.ClipX < 2250 && Canvas.ClipX >= 1750) || (Canvas.ClipY < 1150 && Canvas.ClipY >= 900) )
      ResScale = 0.75;
    else if (Canvas.ClipX < 1750 || Canvas.ClipY < 900)
      ResScale = 0.5;
    else
      ResScale = 1.0;

    Canvas.Font = Font469_16;
    Canvas.StrLen("Ag", XL, YL);
    ScoreRowH = 19 * ResScale;
    if (ScoreRowH < YL + 4)
      ScoreRowH = YL + 4;

    // 12 = table top margin; 6 rows = header + max five players.
    PromptY = (12 * ResScale) + (ScoreRowH * 6) + 8;
  }
  else
  {
    PromptY = YL * 4 + 8;
  }

  // Restore the normal small typing font after scoreboard measurement.
  Canvas.Font = MyFonts.GetSmallFont(Canvas.ClipX);
  Canvas.SetOrigin(6, PromptY);
  Canvas.SetClip(Canvas.ClipX - 12, Canvas.ClipY - PromptY);
  Canvas.SetPos(0, 0);
  Canvas.DrawText(TypingPrompt, false);

  Canvas.SetOrigin(OldOrgX, OldOrgY);
  Canvas.SetClip(OldClipX, OldClipY);
}

function DrawKillFeed(Canvas canvas)
{
  local float XL, YL, YPos, FeedTop, ResScale, MsgY, ScoreRowH;
  local int i, j, k;

// Keep the kill feed clear of the compact team tables.
// It remains top-right, but starts immediately below the scoreboard's
// maximum five-player height. If the scoreboard is disabled, retain
// the original top-right position.
  if ( class'OverlaySettings'.default.iFontSizeKF == 2)
    Canvas.Font = Font469_20;
  else if ( class'OverlaySettings'.default.iFontSizeKF == 1)
    Canvas.Font = Font469_18;
  else
    Canvas.Font = Font469_16;

  if ( (Canvas.ClipX < 2250 && Canvas.ClipX >= 1750) || (Canvas.ClipY < 1150 && Canvas.ClipY >= 900) )
    ResScale = 0.75;
  else if ( Canvas.ClipX < 1750 || Canvas.ClipY < 900 )
    ResScale = 0.5;
  else
    ResScale = 1.0;

  if ( class'OverlaySettings'.default.bScoreBoardState )
  {
    // FIX8: mirror the scoreboard's measured minimum row height so the
    // kill feed always starts below it, even where UT's font is taller
    // than the geometry implied by ResScale.
    Canvas.Font = Font469_16;
    Canvas.StrLen("Ag", XL, YL);
    ScoreRowH = 19 * ResScale;
    if (ScoreRowH < YL + 4)
    ScoreRowH = YL + 4;
    FeedTop = (12 * ResScale) + (ScoreRowH * 6);
  }
  else
    FeedTop = 2;

  // Restore the configured kill-feed font after measuring the scoreboard.
  if ( class'OverlaySettings'.default.iFontSizeKF == 2)
    Canvas.Font = Font469_20;
  else if ( class'OverlaySettings'.default.iFontSizeKF == 1)
    Canvas.Font = Font469_18;
  else
    Canvas.Font = Font469_16;

  Canvas.StrLen("TEST", XL, YL);
  YPos = 0;

  for (i=0; i<KILLFEED_LINES-1; i++)
  {
    if ( KillMessageQueue[i].Message != None )
    {
      j++;
      if ( bResChanged || (KillMessageQueue[i].XL == 0) )
      {
        if ( KillMessageQueue[i].Message.Default.bComplexString )
          Canvas.StrLen(KillMessageQueue[i].Message.Static.AssembleString(self, KillMessageQueue[i].Switch, KillMessageQueue[i].RelatedPRI, KillMessageQueue[i].StringMessage), KillMessageQueue[i].XL, KillMessageQueue[i].YL);
        else
          Canvas.StrLen(KillMessageQueue[i].StringMessage, KillMessageQueue[i].XL, KillMessageQueue[i].YL);

        Canvas.StrLen("TEST", XL, YL);
        KillMessageQueue[i].numLines = 1;

        if ( KillMessageQueue[i].YL > YL )
        {
          KillMessageQueue[i].numLines++;
          for (k=2; k<KILLFEED_LINES-i; k++)
          {
            if (KillMessageQueue[i].YL > YL*k)
              KillMessageQueue[i].numLines++;
          }
        }
      }

      if ( YPos + KillMessageQueue[i].numLines > KILLFEED_LINES )
        break;

      MsgY = FeedTop + YL * YPos;
      YPos += KillMessageQueue[i].numLines;

      if ( KillMessageQueue[i].Message.Default.bComplexString )
      {
        Canvas.SetPos(Canvas.ClipX - KillMessageQueue[i].XL - 6, MsgY);
        KillMessageQueue[i].Message.Static.RenderComplexMessage(Canvas, KillMessageQueue[i].XL, YL, KillMessageQueue[i].StringMessage, KillMessageQueue[i].Switch, KillMessageQueue[i].RelatedPRI, None, KillMessageQueue[i].OptionalObject);
      }
      else
      {
        Canvas.DrawColor = SetColor(255,255,255);
        DrawTextRight(canvas, KillMessageQueue[i].StringMessage, Canvas.ClipX-6, MsgY);
      }
    }
  }
}

function DrawChat(Canvas Canvas)
{
  local float OldOriginX;
  local float XL, YL, YPos, ChatTop, BottomMargin, TotalLines;
  local int i, j, k;

  OldOriginX = Canvas.OrgX;

// Respect the existing font-size setting; this build defaults it to Small.
  if ( class'OverlaySettings'.default.iFontSizeChat == 2)
    Canvas.Font = Font469_20;
  else if ( class'OverlaySettings'.default.iFontSizeChat == 1)
    Canvas.Font = Font469_18;
  else
    Canvas.Font = Font469_16;

  Canvas.StrLen("TEST", XL, YL);
  Canvas.SetClip(768*Scale - 10, Canvas.ClipY);
  bDrawFaceArea = false;

// First calculate how many visible lines we need so the chat hugs the
// lower-left corner instead of reserving a permanent four-line block.
  TotalLines = 0;
  for (i=0; i<4; i++)
  {
    if ( ChatMessageQueue[i].Message != None )
    {
      if ( bResChanged || (ChatMessageQueue[i].XL == 0) )
      {
        if ( ChatMessageQueue[i].Message.Default.bComplexString )
          Canvas.StrLen(ChatMessageQueue[i].Message.Static.AssembleString(self, ChatMessageQueue[i].Switch, ChatMessageQueue[i].RelatedPRI, ChatMessageQueue[i].StringMessage), ChatMessageQueue[i].XL, ChatMessageQueue[i].YL);
        else
          Canvas.StrLen(ChatMessageQueue[i].StringMessage, ChatMessageQueue[i].XL, ChatMessageQueue[i].YL);

        Canvas.StrLen("TEST", XL, YL);
        ChatMessageQueue[i].numLines = 1;
        if ( ChatMessageQueue[i].YL > YL )
        {
          ChatMessageQueue[i].numLines++;
          for (k=2; k<4-i; k++)
          {
            if (ChatMessageQueue[i].YL > YL*k)
              ChatMessageQueue[i].numLines++;
          }
        }
      }

      TotalLines += ChatMessageQueue[i].numLines;
      if ( TotalLines >= 4 )
      {
        TotalLines = 4;
        break;
      }
    }
  }

  BottomMargin = 10;
  if ( PlayerOwner != None && PlayerOwner.Player != None && PlayerOwner.Player.Console.bTyping )
    BottomMargin = 34;

  ChatTop = Canvas.ClipY - BottomMargin - (YL * TotalLines);
  if ( ChatTop < Canvas.ClipY * 0.55 )
    ChatTop = Canvas.ClipY * 0.55;

  YPos = 0;
  for (i=0; i<4; i++)
  {
    if ( ChatMessageQueue[i].Message != None )
    {
      j++;
      if ( YPos + ChatMessageQueue[i].numLines > 4 )
        break;

      Canvas.SetPos(6, ChatTop + YL * YPos);
      YPos += ChatMessageQueue[i].numLines;

      if ( ChatMessageQueue[i].Message.Default.bComplexString )
      {
        ChatMessageQueue[i].Message.Static.RenderComplexMessage(Canvas, ChatMessageQueue[i].XL, YL, ChatMessageQueue[i].StringMessage, ChatMessageQueue[i].Switch, ChatMessageQueue[i].RelatedPRI, None, ChatMessageQueue[i].OptionalObject);
      }
      else
      {
        Canvas.DrawColor = ChatMessageQueue[i].Message.Default.DrawColor;
        Canvas.DrawText(ChatMessageQueue[i].StringMessage, False);
      }
    }
  }

  Canvas.DrawColor = WhiteColor;
  Canvas.SetClip(OldClipX, Canvas.ClipY);
  Canvas.SetOrigin(OldOriginX, Canvas.OrgY);
}

function DrawCenterMessages(Canvas Canvas)
{
  local int i, M;
  local float FadeValue, BaseY, CurrentY, StackGap, MsgY;

  if ( !bHideCenterMessages )
  {
    // Re-anchor localized center messages under the top score area so they do
    // not block the middle of the action. Messages stack downward with a small
    // gap, which also keeps spree/capture variations from overlapping.
    BaseY = Canvas.ClipY * 0.14;
    if (BaseY < 88)
      BaseY = 88;
    StackGap = 4;
    CurrentY = BaseY;

// Master localized message control loop //
    for (i=0; i<10; i++)
    {
      if (LocalMessages[i].Message != None)
      {
        if (LocalMessages[i].Message.Default.bFadeMessage && Level.bHighDetailMode)
        {
          Canvas.Style = ERenderStyle.STY_Translucent;
          FadeValue = (LocalMessages[i].EndOfLife - Level.TimeSeconds);

          if (FadeValue > 0.0)
          {
            if ( bResChanged || (LocalMessages[i].XL == 0) )
            {
              if ( LocalMessages[i].Message.Static.GetFontSize(LocalMessages[i].Switch) == 1 )
              LocalMessages[i].StringFont = MyFonts.GetBigFont( Canvas.ClipX );
              else
              LocalMessages[i].StringFont = MyFonts.GetHugeFont( Canvas.ClipX );

              Canvas.Font = LocalMessages[i].StringFont;
              Canvas.StrLen(LocalMessages[i].StringMessage, LocalMessages[i].XL, LocalMessages[i].YL);
              LocalMessages[i].YPos = LocalMessages[i].Message.Static.GetOffset(LocalMessages[i].Switch, LocalMessages[i].YL, Canvas.ClipY);
            }

            Canvas.Font = LocalMessages[i].StringFont;
            Canvas.DrawColor = LocalMessages[i].DrawColor * (FadeValue/LocalMessages[i].LifeTime);
            MsgY = CurrentY;
			Canvas.SetPos( 0.5 * (Canvas.ClipX - LocalMessages[i].XL), MsgY );
			Canvas.DrawText( LocalMessages[i].StringMessage, False );
            CurrentY += LocalMessages[i].YL + StackGap;
		  }
		}

        else
        {
          if ( bResChanged || (LocalMessages[i].XL == 0) )
          {
            if ( LocalMessages[i].Message.Static.GetFontSize(LocalMessages[i].Switch) == 1 )
            LocalMessages[i].StringFont = MyFonts.GetBigFont( Canvas.ClipX );
            else
            LocalMessages[i].StringFont = MyFonts.GetHugeFont( Canvas.ClipX );

            Canvas.Font = LocalMessages[i].StringFont;
            Canvas.StrLen(LocalMessages[i].StringMessage, LocalMessages[i].XL, LocalMessages[i].YL);
            LocalMessages[i].YPos = LocalMessages[i].Message.Static.GetOffset(LocalMessages[i].Switch, LocalMessages[i].YL, Canvas.ClipY);
          }

          Canvas.Font = LocalMessages[i].StringFont;
          Canvas.Style = ERenderStyle.STY_Normal;
          Canvas.DrawColor = LocalMessages[i].DrawColor;
          MsgY = CurrentY;
          Canvas.SetPos( 0.5 * (Canvas.ClipX - LocalMessages[i].XL), MsgY );
          Canvas.DrawText( LocalMessages[i].StringMessage, False );
          CurrentY += LocalMessages[i].YL + StackGap;
        }
      }
    }

    if ( (PlayerOwner.GameReplicationInfo != None) && (PlayerPawn(Owner).GameReplicationInfo.RemainingTime > 0) )
    {
      if ( TimeMessageClass == None )
      TimeMessageClass = class<CriticalEventPlus>(DynamicLoadObject("Botpack.TimeMessage", class'Class'));

      if ( (PlayerOwner.GameReplicationInfo.RemainingTime <= 300) && (PlayerOwner.GameReplicationInfo.RemainingTime != LastReportedTime) )
	  {
	    LastReportedTime = PlayerOwner.GameReplicationInfo.RemainingTime;

        if ( PlayerOwner.GameReplicationInfo.RemainingTime <= 30 )
        {
          bTimeValid = ( bTimeValid || (PlayerOwner.GameReplicationInfo.RemainingTime > 0) );

          if ( PlayerOwner.GameReplicationInfo.RemainingTime == 30 )
          TellTime(5);
          else if ( bTimeValid && PlayerOwner.GameReplicationInfo.RemainingTime <= 10 )
          TellTime(16 - PlayerOwner.GameReplicationInfo.RemainingTime);
        }

        else if ( PlayerOwner.GameReplicationInfo.RemainingTime % 60 == 0 )
        {
          M = PlayerOwner.GameReplicationInfo.RemainingTime/60;
          TellTime(5 - M);
        }
      }
    }
  }
  Canvas.Style = ERenderStyle.STY_Normal;
}

simulated function DrawArmor(Canvas Canvas)
{
  local int ArmorAmount, CurAbs, i, thxepic;
  local PlayerReplicationInfo PRI;
  local ENetRole oldrole;
  local inventory Inv, BestArmor;
  local bool bShieldbelt, bThighArmor, bChestArmor;
  local float ChestAmount, ThighAmount;

  thxepic = -1;

  foreach Level.AllActors (class 'PlayerReplicationInfo', PRI)
  {
    if ( InStr(CAPS(PRI.class), "BBPLAYERREPLICATIONINFO") == -1 )
    continue;

    if ( PawnOwner != PRI.Owner )
    continue;

    oldrole = PRI.Role;
    PRI.Role = ROLE_Authority;
    thxepic = int(PRI.GetPropertyText("Armor"));
    savedArmor = thxepic;
    PRI.Role = oldrole;
  }

  if (thxepic != -1 )
  {
    if ( gotShieldBelt(PawnOwner) )
    Canvas.DrawColor = SetColor(255, 200, 0);

    DrawBigNum(Canvas, Min(150, thxepic), Canvas.ClipX * 0.5 + (128 * 0.35 * 2) * Scale, Canvas.ClipY * 1 - 94 * Scale, 1.75);
  }
  else
  {
    ArmorAmount = 0;
    CurAbs = 0;
    i = 0;
    BestArmor=None;

    for( Inv=PawnOwner.Inventory; Inv!=None; Inv=Inv.Inventory )
    {
      if (Inv.bIsAnArmor)
      {
      if ( Inv.IsA('UT_Shieldbelt') )
      bShieldbelt = true;
      else if ( Inv.IsA('Thighpads') )
      {
        ThighAmount += Inv.Charge;
        bThighArmor = true;
      }
      else
      {
        bChestArmor = true;
        ChestAmount += Inv.Charge;
      }
      ArmorAmount += Inv.Charge;
      }
      else
      {
        i++;
        if ( i > 100 )
        break;
      }
    }

    if ( bShieldBelt )
    Canvas.DrawColor = SetColor(255, 200, 0);

    DrawBigNum(Canvas, Min(150,ArmorAmount), Canvas.ClipX * 0.5 + (128 * 0.35 * 2) * Scale, Canvas.ClipY * 1 - 94 * Scale, 1.75);
    savedArmor=ArmorAmount;
  }
}

function int GetUAObservedArmor()
{
  local int ArmorAmount, thxepic;
  local PlayerReplicationInfo PRI;
  local ENetRole oldrole;
  local Inventory Inv;

  thxepic = -1;

  foreach Level.AllActors (class 'PlayerReplicationInfo', PRI)
  {
    if ( InStr(CAPS(PRI.class), "BBPLAYERREPLICATIONINFO") == -1 )
      continue;

    if ( PawnOwner != PRI.Owner )
      continue;

    oldrole = PRI.Role;
    PRI.Role = ROLE_Authority;
    thxepic = int(PRI.GetPropertyText("Armor"));
    PRI.Role = oldrole;
  }

  if (thxepic != -1)
    return Min(150, thxepic);

  ArmorAmount = 0;
  for (Inv = PawnOwner.Inventory; Inv != None; Inv = Inv.Inventory)
  {
    if (Inv.bIsAnArmor)
      ArmorAmount += Inv.Charge;
  }

  return Min(150, ArmorAmount);
}

function int FindUACapSnapshot(PlayerReplicationInfo PRI)
{
  local int i;

  for (i=0; i<UACapPlayerCount; i++)
    if (UACapPlayers[i].PRI == PRI)
      return i;

  return -1;
}

function string RefreshUACaptureSnapshots(bool bDetectIncrease)
{
  local int TeamIndex, i, Idx, CurrentCaps;
  local PlayerReplicationInfo PRI;
  local string Scorer;

  if (OS == None)
    return "";

  for (TeamIndex=0; TeamIndex<2; TeamIndex++)
  {
    if (TeamIndex == 0)
    {
      for (i=0; i<OS.redPlayerCount; i++)
      {
        PRI = OS.GetUAPlayerPRI(0, i);
        CurrentCaps = OS.GetUAPlayerCaps(0, i);
        if (PRI == None)
          continue;

        Idx = FindUACapSnapshot(PRI);
        if (Idx == -1)
        {
          if (UACapPlayerCount < 16)
          {
            UACapPlayers[UACapPlayerCount].PRI = PRI;
            UACapPlayers[UACapPlayerCount].Caps = CurrentCaps;
            UACapPlayerCount++;
          }
        }
        else if (bDetectIncrease)
        {
          if (CurrentCaps > UACapPlayers[Idx].Caps)
            Scorer = PRI.PlayerName;
          UACapPlayers[Idx].Caps = CurrentCaps;
        }
      }
    }
    else
    {
      for (i=0; i<OS.bluePlayerCount; i++)
      {
        PRI = OS.GetUAPlayerPRI(1, i);
        CurrentCaps = OS.GetUAPlayerCaps(1, i);
        if (PRI == None)
          continue;

        Idx = FindUACapSnapshot(PRI);
        if (Idx == -1)
        {
          if (UACapPlayerCount < 16)
          {
            UACapPlayers[UACapPlayerCount].PRI = PRI;
            UACapPlayers[UACapPlayerCount].Caps = CurrentCaps;
            UACapPlayerCount++;
          }
        }
        else if (bDetectIncrease)
        {
          if (CurrentCaps > UACapPlayers[Idx].Caps)
            Scorer = PRI.PlayerName;
          UACapPlayers[Idx].Caps = CurrentCaps;
        }
      }
    }
  }

  return Scorer;
}

function AddUAScoreHistory(int RedScore, int BlueScore)
{
  local int i;
  local string ScoreState;

  ScoreState = string(RedScore) $ "-" $ string(BlueScore);

  if (UAScoreHistoryCount < 5)
  {
    UAScoreHistory[UAScoreHistoryCount] = ScoreState;
    UAScoreHistoryCount++;
    return;
  }

  for (i=0; i<4; i++)
    UAScoreHistory[i] = UAScoreHistory[i+1];
  UAScoreHistory[4] = ScoreState;
}

function UpdateUAMatchHistory()
{
  local CTFReplicationInfo CTFGRI;
  local int RedScore, BlueScore;
  local string Scorer;

  if (PlayerOwner == None || PlayerOwner.GameReplicationInfo == None || OS == None)
    return;

  CTFGRI = CTFReplicationInfo(PlayerOwner.GameReplicationInfo);
  if (CTFGRI == None || CTFGRI.Teams[0] == None || CTFGRI.Teams[1] == None)
    return;

  RedScore = int(CTFGRI.Teams[0].Score);
  BlueScore = int(CTFGRI.Teams[1].Score);

  if (!bUAMatchHistoryReady)
  {
    UALastRedScore = RedScore;
    UALastBlueScore = BlueScore;
    AddUAScoreHistory(RedScore, BlueScore);
    RefreshUACaptureSnapshots(false);
    bUAMatchHistoryReady = true;
    return;
  }

  if (RedScore != UALastRedScore || BlueScore != UALastBlueScore)
  {
    Scorer = RefreshUACaptureSnapshots(true);
    AddUAScoreHistory(RedScore, BlueScore);

    if (RedScore > UALastRedScore)
      UAPendingCaptureTeam = 0;
    else if (BlueScore > UALastBlueScore)
      UAPendingCaptureTeam = 1;

    if (Scorer != "")
    {
      UALastCapturePlayer = Scorer;
      UALastCaptureTeam = UAPendingCaptureTeam;
      UALastCaptureAt = Level.TimeSeconds;
      bUAPendingCaptureResolve = false;
    }
    else
    {
      // SmartCTF can replicate team score before the player's Captures value.
      // Keep the previous Last Cap visible and retry briefly instead of
      // replacing a valid name with "Unknown".
      bUAPendingCaptureResolve = true;
      UAPendingCaptureUntil = Level.TimeSeconds + 2.0;
    }

    UALastRedScore = RedScore;
    UALastBlueScore = BlueScore;
  }
  else if (bUAPendingCaptureResolve)
  {
    Scorer = RefreshUACaptureSnapshots(true);
    if (Scorer != "")
    {
      UALastCapturePlayer = Scorer;
      UALastCaptureTeam = UAPendingCaptureTeam;
      UALastCaptureAt = Level.TimeSeconds;
      bUAPendingCaptureResolve = false;
    }
    else if (Level.TimeSeconds >= UAPendingCaptureUntil)
    {
      // Give up silently: never replace a known scorer with "Unknown".
      // Refresh baselines now so a later cap can be detected normally.
      bUAPendingCaptureResolve = false;
      RefreshUACaptureSnapshots(false);
    }
  }
  else
  {
    // Add late joiners to the snapshot without consuming future cap deltas.
    RefreshUACaptureSnapshots(false);
  }
}

function string UAElapsedShort(float Seconds)
{
  local int T, M, S;

  T = Max(0, int(Seconds));
  M = T / 60;
  S = T - (M * 60);

  if (S < 10)
    return string(M) $ ":0" $ string(S);
  return string(M) $ ":" $ string(S);
}

function int CalcUALiveMVPScore(byte Team, int Index)
{
  local int CapsV, GrabsV, FCKV, CoversV, SealsV, FragsV, EffV;

  if (OS == None)
    return -999999;

  CapsV = OS.GetUAPlayerStat(Team, Index, 0);
  GrabsV = OS.GetUAPlayerStat(Team, Index, 1);
  FCKV = OS.GetUAPlayerStat(Team, Index, 2);
  CoversV = OS.GetUAPlayerStat(Team, Index, 3);
  SealsV = OS.GetUAPlayerStat(Team, Index, 4);
  FragsV = OS.GetUAPlayerStat(Team, Index, 5);
  EffV = OS.GetUAPlayerStat(Team, Index, 6);

  // CTF-first weighting: objective and defensive play matter most.
  return (CapsV * 12) + (GrabsV * 2) + (FCKV * 5) + (CoversV * 3) + (SealsV * 4) + (FragsV / 2) + (EffV / 5);
}

function UpdateUALiveMVP()
{
  local int Team, Index, CandidateScore;

  UALiveMVPName = "";
  UALiveMVPScore = -999999;
  UALiveMVPTeam = 255;
  UALiveMVPIndex = -1;

  if (OS == None)
    return;

  // Scoreboard data is already refreshed during PostRender; only read the
  // lightweight accessors here so we do not move PlayerStats across classes.
  for (Team=0; Team<2; Team++)
  {
    for (Index=0; Index<5; Index++)
    {
      if (OS.GetUAPlayerPRI(Team, Index) == None)
        continue;

      CandidateScore = CalcUALiveMVPScore(Team, Index);
      if (CandidateScore > UALiveMVPScore)
      {
        UALiveMVPScore = CandidateScore;
        UALiveMVPName = OS.GetUAPlayerName(Team, Index);
        UALiveMVPTeam = Team;
        UALiveMVPIndex = Index;
      }
    }
  }
}

function bool UAGetCompareSlot(PlayerReplicationInfo PRI, out byte Team, out int Index)
{
  local int i;

  if (PRI == None || OS == None)
    return false;

  for (i=0; i<5; i++)
  {
    if (OS.GetUAPlayerPRI(0,i) == PRI)
    {
      Team = 0;
      Index = i;
      return true;
    }
    if (OS.GetUAPlayerPRI(1,i) == PRI)
    {
      Team = 1;
      Index = i;
      return true;
    }
  }

  return false;
}

function PlayerReplicationInfo UAGetCompareOpponent()
{
  local PlayerReplicationInfo P;
  local int i;

  // Player B always follows the normal spectator target.
  if (PawnOwner != None && PawnOwner != PlayerOwner && PawnOwner.PlayerReplicationInfo != None
      && !PawnOwner.PlayerReplicationInfo.bIsSpectator && PawnOwner.PlayerReplicationInfo != UACompareAnchorPRI)
    return PawnOwner.PlayerReplicationInfo;

  // If A is still being watched (or we are in free spect), show the first
  // available opponent so the panel is immediately useful.
  if (OS != None)
  {
    for (i=0; i<5; i++)
    {
      P = OS.GetUAPlayerPRI(0,i);
      if (P != None && P != UACompareAnchorPRI)
        return P;
      P = OS.GetUAPlayerPRI(1,i);
      if (P != None && P != UACompareAnchorPRI)
        return P;
    }
  }

  return None;
}

function DrawUACompareStat(Canvas Canvas, string Label, int ValueA, int ValueB, float X, float Y, float W, float Alpha)
{
  local float XL, YL;

  Canvas.Font = Font469_16;
  Canvas.DrawColor = SetColor(162,168,176,Alpha);
  Canvas.StrLen(Label, XL, YL);
  Canvas.SetPos(X + W*0.5 - XL*0.5, Y);
  Canvas.DrawText(Label, false);

  Canvas.Font = Font469_16b;
  Canvas.DrawColor = SetColor(228,232,238,Alpha);
  Canvas.SetPos(X + 18, Y);
  Canvas.DrawText(string(ValueA), false);

  Canvas.StrLen(string(ValueB), XL, YL);
  Canvas.SetPos(X + W - 18 - XL, Y);
  Canvas.DrawText(string(ValueB), false);
}

function DrawUAPlayerCompare(Canvas Canvas)
{
  local PlayerReplicationInfo PRI_B;
  local byte TeamA, TeamB;
  local int IndexA, IndexB, i;
  local float W, H, X, Y, RowH, XL, YL, A;
  local string NameA, NameB, EffA, EffB;
  local color ColA, ColB;

  if ((!bUACompareActive && !bUACompareClosing) || UACompareAlpha <= 0.0 || OS == None || UACompareAnchorPRI == None)
    return;

  PRI_B = UAGetCompareOpponent();
  if (PRI_B == None)
    return;

  if (!UAGetCompareSlot(UACompareAnchorPRI, TeamA, IndexA) || !UAGetCompareSlot(PRI_B, TeamB, IndexB))
    return;

  A = UACompareAlpha;
  W = 410;
  H = 178;
  if (Canvas.ClipX >= 2200 || Canvas.ClipY >= 1200)
  {
    W = 480;
    H = 202;
  }
  if (W > Canvas.ClipX - 30)
    W = Canvas.ClipX - 30;

  // A tiny vertical slide accompanies the fade.
  X = Canvas.ClipX*0.5 - W*0.5;
  Y = Canvas.ClipY*0.34 + (1.0-A)*12;
  RowH = (H - 54) / 7;

  Canvas.Style = ERenderStyle.STY_Translucent;
  Canvas.DrawColor = SetColor(9,11,15,0.90*A);
  Canvas.SetPos(X,Y);
  Canvas.DrawRect(Texture'white_1x1',W,H);

  ColA = SetColor(210,55,55,A);
  if (TeamA == 1) ColA = SetColor(65,120,255,A);
  ColB = SetColor(210,55,55,A);
  if (TeamB == 1) ColB = SetColor(65,120,255,A);

  Canvas.Style = ERenderStyle.STY_Normal;
  Canvas.DrawColor = ColA;
  Canvas.SetPos(X,Y);
  Canvas.DrawRect(Texture'white_1x1',W*0.5,2);
  Canvas.DrawColor = ColB;
  Canvas.SetPos(X+W*0.5,Y);
  Canvas.DrawRect(Texture'white_1x1',W*0.5,2);

  // Shared UA panel frame: only a muted bottom edge, avoiding extra bright bars.
  Canvas.DrawColor = SetColor(42,46,54,A);
  Canvas.SetPos(X,Y+H-1);
  Canvas.DrawRect(Texture'white_1x1',W,1);

  Canvas.Font = Font469_16;
  Canvas.DrawColor = SetColor(218,174,70,A);
  Canvas.StrLen("PLAYER COMPARE",XL,YL);
  Canvas.SetPos(X+W*0.5-XL*0.5,Y+8);
  Canvas.DrawText("PLAYER COMPARE",false);

  NameA = OS.GetUAPlayerName(TeamA,IndexA);
  NameB = OS.GetUAPlayerName(TeamB,IndexB);
  if (Len(NameA)>18) NameA=Left(NameA,16)$"..";
  if (Len(NameB)>18) NameB=Left(NameB,16)$"..";

  Canvas.Font = Font469_16b;
  Canvas.DrawColor = ColA;
  Canvas.SetPos(X+16,Y+30);
  Canvas.DrawText(NameA,false);
  Canvas.DrawColor = ColB;
  Canvas.StrLen(NameB,XL,YL);
  Canvas.SetPos(X+W-16-XL,Y+30);
  Canvas.DrawText(NameB,false);

  DrawUACompareStat(Canvas,"CAPS",OS.GetUAPlayerStat(TeamA,IndexA,0),OS.GetUAPlayerStat(TeamB,IndexB,0),X,Y+52+RowH*0,W,A);
  DrawUACompareStat(Canvas,"GRABS",OS.GetUAPlayerStat(TeamA,IndexA,1),OS.GetUAPlayerStat(TeamB,IndexB,1),X,Y+52+RowH*1,W,A);
  DrawUACompareStat(Canvas,"FCKILLS",OS.GetUAPlayerStat(TeamA,IndexA,2),OS.GetUAPlayerStat(TeamB,IndexB,2),X,Y+52+RowH*2,W,A);
  DrawUACompareStat(Canvas,"COVERS",OS.GetUAPlayerStat(TeamA,IndexA,3),OS.GetUAPlayerStat(TeamB,IndexB,3),X,Y+52+RowH*3,W,A);
  DrawUACompareStat(Canvas,"SEALS",OS.GetUAPlayerStat(TeamA,IndexA,4),OS.GetUAPlayerStat(TeamB,IndexB,4),X,Y+52+RowH*4,W,A);
  DrawUACompareStat(Canvas,"FRAGS",OS.GetUAPlayerStat(TeamA,IndexA,5),OS.GetUAPlayerStat(TeamB,IndexB,5),X,Y+52+RowH*5,W,A);

  Canvas.Font = Font469_16;
  Canvas.DrawColor = SetColor(170,170,170,A);
  Canvas.StrLen("EFF",XL,YL);
  Canvas.SetPos(X+W*0.5-XL*0.5,Y+52+RowH*6);
  Canvas.DrawText("EFF",false);
  Canvas.Font = Font469_16b;
  EffA = string(OS.GetUAPlayerStat(TeamA,IndexA,6))$"%";
  EffB = string(OS.GetUAPlayerStat(TeamB,IndexB,6))$"%";
  Canvas.DrawColor = SetColor(235,235,235,A);
  Canvas.SetPos(X+18,Y+52+RowH*6);
  Canvas.DrawText(EffA,false);
  Canvas.StrLen(EffB,XL,YL);
  Canvas.SetPos(X+W-18-XL,Y+52+RowH*6);
  Canvas.DrawText(EffB,false);
}

function int GetUAMVPContribution(int StatID, int Value)
{
  if (StatID == 0) return Value * 12; // Caps
  if (StatID == 1) return Value * 2;  // Grabs
  if (StatID == 2) return Value * 5;  // FC kills
  if (StatID == 3) return Value * 3;  // Covers
  if (StatID == 4) return Value * 4;  // Seals
  if (StatID == 5) return Value / 2;  // Frags
  if (StatID == 6) return Value / 5;  // Efficiency
  return 0;
}

function DrawUAMVPStat(Canvas Canvas, string Label, int Value, int Points, float X, float Y, float W, float Alpha)
{
  local float XL, YL;
  local string PText;

  Canvas.Font = Font469_16;
  Canvas.DrawColor = SetColor(162,168,176,Alpha);
  Canvas.SetPos(X,Y);
  Canvas.DrawText(Label,false);

  Canvas.Font = Font469_16b;
  Canvas.DrawColor = SetColor(228,232,238,Alpha);
  Canvas.StrLen(string(Value),XL,YL);
  Canvas.SetPos(X + W*0.56 - XL,Y);
  Canvas.DrawText(string(Value),false);

  PText = "+" $ string(Points) $ " pts";
  Canvas.DrawColor = SetColor(218,174,70,Alpha);
  Canvas.StrLen(PText,XL,YL);
  Canvas.SetPos(X + W - XL,Y);
  Canvas.DrawText(PText,false);
}

function DrawUAMVPFocus(Canvas Canvas)
{
  local int CapsV, GrabsV, FCKV, CoversV, SealsV, FragsV, EffV;
  local int Index, Points;
  local float W, H, X, Y, A, XL, YL, RowH, PortraitSize, StatsX, StatsW;
  local string NameText, TeamText, ScoreText;
  local color Accent;
  local PlayerReplicationInfo PRI;
  local texture Portrait;

  if ((!bUAMVPFocusActive && !bUAMVPFocusClosing) || UAMVPFocusAlpha <= 0.0 || OS == None)
    return;

  UpdateUALiveMVP();
  if (UALiveMVPName == "" || UALiveMVPIndex < 0)
    return;

  Index = UALiveMVPIndex;
  PRI = OS.GetUAPlayerPRI(UALiveMVPTeam,Index);
  if (PRI == None)
    return;

  CapsV = OS.GetUAPlayerStat(UALiveMVPTeam,Index,0);
  GrabsV = OS.GetUAPlayerStat(UALiveMVPTeam,Index,1);
  FCKV = OS.GetUAPlayerStat(UALiveMVPTeam,Index,2);
  CoversV = OS.GetUAPlayerStat(UALiveMVPTeam,Index,3);
  SealsV = OS.GetUAPlayerStat(UALiveMVPTeam,Index,4);
  FragsV = OS.GetUAPlayerStat(UALiveMVPTeam,Index,5);
  EffV = OS.GetUAPlayerStat(UALiveMVPTeam,Index,6);

  A = UAMVPFocusAlpha;
  W = 450;
  H = 228;
  if (Canvas.ClipX >= 2200 || Canvas.ClipY >= 1200)
  {
    W = 520;
    H = 250;
  }
  if (W > Canvas.ClipX - 30)
    W = Canvas.ClipX - 30;

  // Same fade + subtle slide language as Player Compare.
  X = Canvas.ClipX*0.5 - W*0.5;
  Y = Canvas.ClipY*0.31 + (1.0-A)*12;
  PortraitSize = 94;
  if (H > 230) PortraitSize = 108;

  Canvas.Style = ERenderStyle.STY_Translucent;
  Canvas.DrawColor = SetColor(9,11,15,0.92*A);
  Canvas.SetPos(X,Y);
  Canvas.DrawRect(Texture'white_1x1',W,H);

  if (UALiveMVPTeam == 0)
  {
    Accent = SetColor(210,55,55,A);
    TeamText = "RED TEAM";
  }
  else
  {
    Accent = SetColor(65,120,255,A);
    TeamText = "BLUE TEAM";
  }

  Canvas.Style = ERenderStyle.STY_Normal;
  Canvas.DrawColor = Accent;
  Canvas.SetPos(X,Y);
  Canvas.DrawRect(Texture'white_1x1',W,2);

  Canvas.DrawColor = SetColor(42,46,54,A);
  Canvas.SetPos(X,Y+H-1);
  Canvas.DrawRect(Texture'white_1x1',W,1);

  Canvas.Font = Font469_16;
  Canvas.DrawColor = SetColor(218,174,70,A);
  Canvas.StrLen("MVP FOCUS",XL,YL);
  Canvas.SetPos(X+W*0.5-XL*0.5,Y+8);
  Canvas.DrawText("MVP FOCUS",false);

  // Stable portrait/skin representation: use the player's TalkTexture when
  // available. This avoids moving/rendering the live pawn and remains compatible
  // with custom skins. A true animated 3D dodge pose can be experimented later.
  Portrait = PRI.TalkTexture;
  if (Portrait != None)
  {
    Canvas.DrawColor = SetColor(255,255,255,A);
    Canvas.SetPos(X+18,Y+42);
    Canvas.DrawTile(Portrait,PortraitSize,PortraitSize,0,0,Portrait.USize,Portrait.VSize);
  }
  else
  {
    Canvas.Style = ERenderStyle.STY_Translucent;
    Canvas.DrawColor = SetColor(28,28,28,A);
    Canvas.SetPos(X+18,Y+42);
    Canvas.DrawRect(Texture'white_1x1',PortraitSize,PortraitSize);
    Canvas.Style = ERenderStyle.STY_Normal;
  }

  NameText = UALiveMVPName;
  if (Len(NameText)>22) NameText=Left(NameText,20)$"..";
  Canvas.Font = Font469_18b;
  Canvas.DrawColor = Accent;
  Canvas.SetPos(X+18,Y+42+PortraitSize+10);
  Canvas.DrawText(NameText,false);
  Canvas.Font = Font469_16;
  Canvas.DrawColor = SetColor(162,168,176,A);
  Canvas.SetPos(X+18,Y+42+PortraitSize+30);
  Canvas.DrawText(TeamText,false);

  StatsX = X + PortraitSize + 38;
  StatsW = W - (StatsX-X) - 20;
  RowH = 21;
  if (H > 230) RowH = 23;

  DrawUAMVPStat(Canvas,"CAPS",CapsV,GetUAMVPContribution(0,CapsV),StatsX,Y+42+RowH*0,StatsW,A);
  DrawUAMVPStat(Canvas,"GRABS",GrabsV,GetUAMVPContribution(1,GrabsV),StatsX,Y+42+RowH*1,StatsW,A);
  DrawUAMVPStat(Canvas,"FCKILLS",FCKV,GetUAMVPContribution(2,FCKV),StatsX,Y+42+RowH*2,StatsW,A);
  DrawUAMVPStat(Canvas,"COVERS",CoversV,GetUAMVPContribution(3,CoversV),StatsX,Y+42+RowH*3,StatsW,A);
  DrawUAMVPStat(Canvas,"SEALS",SealsV,GetUAMVPContribution(4,SealsV),StatsX,Y+42+RowH*4,StatsW,A);
  DrawUAMVPStat(Canvas,"FRAGS",FragsV,GetUAMVPContribution(5,FragsV),StatsX,Y+42+RowH*5,StatsW,A);
  DrawUAMVPStat(Canvas,"EFF %",EffV,GetUAMVPContribution(6,EffV),StatsX,Y+42+RowH*6,StatsW,A);

  ScoreText = "MVP SCORE  " $ string(UALiveMVPScore);
  Canvas.Font = Font469_16b;
  Canvas.DrawColor = SetColor(218,174,70,A);
  Canvas.StrLen(ScoreText,XL,YL);
  Canvas.SetPos(X+W-20-XL,Y+H-24);
  Canvas.DrawText(ScoreText,false);
}

function DrawUALastCapture(Canvas Canvas)
{
  local string LastLabel, LastName, MVPLabel, MVPName;
  local float XL, YL, UIScale, LogoSize, LogoLeft, SpectRight, GapLeft, GapRight, X, Y;
  local float LastLabelW, LastNameW, MVPLabelW, MVPNameW, BlockW, LineGap;
  local int Remaining;
  local bool bHasLastCap, bShowMVP;

  bHasLastCap = (bUAMatchHistoryReady && UALastCaptureAt > 0 && UALastCapturePlayer != "");
  bShowMVP = false;

  if (PlayerOwner != None && PlayerOwner.GameReplicationInfo != None)
  {
    Remaining = PlayerOwner.GameReplicationInfo.RemainingTime;
    bShowMVP = (Remaining > 0 && Remaining <= 60);
  }

  if (!bHasLastCap && !bShowMVP)
    return;

  if (Canvas.ClipX >= 2200 || Canvas.ClipY >= 1200)
    UIScale = 1.20;
  else
    UIScale = 1.00;

  Canvas.Font = Font469_16b;
  Canvas.Style = ERenderStyle.STY_Normal;

  LastLabel = "Last cap: ";
  LastName = UALastCapturePlayer;
  MVPLabel = "MVP: ";

  if (bShowMVP)
  {
    UpdateUALiveMVP();
    MVPName = UALiveMVPName;
    if (MVPName == "")
      bShowMVP = false;
  }

  BlockW = 0;
  if (bHasLastCap)
  {
    Canvas.StrLen(LastLabel, LastLabelW, YL);
    Canvas.StrLen(LastName, LastNameW, YL);
    BlockW = LastLabelW + LastNameW;
  }

  if (bShowMVP)
  {
    Canvas.StrLen(MVPLabel, MVPLabelW, YL);
    Canvas.StrLen(MVPName, MVPNameW, YL);
    if (MVPLabelW + MVPNameW > BlockW)
      BlockW = MVPLabelW + MVPNameW;
  }

  // Estimate the right edge of the central spectator information panel.
  SpectRight = Canvas.ClipX * 0.5 + Min(255 * UIScale, (Canvas.ClipX - 24 * UIScale) * 0.5);

  // Mirror the watermark size logic so these labels occupy the free lane
  // between spectator information and the Unreal Arena logo.
  if (class'OverlaySettings'.default.bShowUnrealArenaLogo)
  {
    if (class'OverlaySettings'.default.iUnrealArenaLogoSize <= 0)
      LogoSize = 75.0 * Scale;
    else if (class'OverlaySettings'.default.iUnrealArenaLogoSize == 1)
      LogoSize = 100.0 * Scale;
    else
      LogoSize = 125.0 * Scale;

    LogoLeft = Canvas.ClipX - LogoSize - (18.0 * Scale);
  }
  else
  {
    LogoLeft = Canvas.ClipX - 18 * UIScale;
  }

  GapLeft = SpectRight + 12 * UIScale;
  GapRight = LogoLeft - 12 * UIScale;

  if (GapRight - GapLeft >= BlockW + 8 * UIScale)
  {
    X = GapLeft + ((GapRight - GapLeft) - BlockW) * 0.5;
    if (bShowMVP && bHasLastCap)
      Y = Canvas.ClipY - (72 * UIScale);
    else
      Y = Canvas.ClipY - (50 * UIScale);
  }
  else
  {
    X = Canvas.ClipX - BlockW - 18 * UIScale;
    Y = Canvas.ClipY - (150 * UIScale);
    if (X < Canvas.ClipX * 0.5 + 8 * UIScale)
      X = Canvas.ClipX * 0.5 + 8 * UIScale;
  }

  LineGap = 17 * UIScale;

  if (bHasLastCap)
  {
    // Neutral label + scorer colored by team.
    Canvas.DrawColor = SetColor(165,165,165);
    Canvas.SetPos(X, Y);
    Canvas.DrawText(LastLabel, False);

    if (UALastCaptureTeam == 0)
      Canvas.DrawColor = SetColor(210,75,75);
    else
      Canvas.DrawColor = SetColor(85,135,235);
    Canvas.SetPos(X + LastLabelW, Y);
    Canvas.DrawText(LastName, False);
  }

  if (bShowMVP)
  {
    if (bHasLastCap)
      Y += LineGap;

    Canvas.DrawColor = SetColor(218,174,70);
    Canvas.SetPos(X, Y);
    Canvas.DrawText(MVPLabel, False);

    if (UALiveMVPTeam == 0)
      Canvas.DrawColor = SetColor(210,75,75);
    else
      Canvas.DrawColor = SetColor(85,135,235);
    Canvas.SetPos(X + MVPLabelW, Y);
    Canvas.DrawText(MVPName, False);
  }
}

function string FindUAAmpOwnerName()
{
  local Pawn P;
  local Inventory Inv;

  foreach Level.AllActors(class'Pawn', P)
  {
    if (P == None || !P.bIsPlayer || P.Health <= 0 || P.PlayerReplicationInfo == None)
      continue;

    // Primary check: UDamage inventory. Fallback: the purple weapon overlay
    // already used by OmniView's existing AMP indicator.
    for (Inv = P.Inventory; Inv != None; Inv = Inv.Inventory)
      if (Inv.IsA('UDamage'))
        return P.PlayerReplicationInfo.PlayerName;

    if (P.Weapon != None && P.Weapon.Texture == FireTexture'UnrealShare.Belt_fx.UDamageFX')
      return P.PlayerReplicationInfo.PlayerName;
  }

  return "";
}

function string FindUABeltOwnerName()
{
  local Pawn P;
  local Inventory Inv;

  foreach Level.AllActors(class'Pawn', P)
  {
    if (P == None || !P.bIsPlayer || P.Health <= 0 || P.PlayerReplicationInfo == None)
      continue;

    for (Inv = P.Inventory; Inv != None; Inv = Inv.Inventory)
      if (Inv.IsA('UT_ShieldBelt'))
        return P.PlayerReplicationInfo.PlayerName;

    if (gotShieldBelt(P))
      return P.PlayerReplicationInfo.PlayerName;
  }

  return "";
}

function UpdateUAPowerupOwnership()
{
  local string NewAmpOwner, NewBeltOwner;

  NewAmpOwner = FindUAAmpOwnerName();
  NewBeltOwner = FindUABeltOwnerName();

  // Do not generate a fake pickup message when OmniView first initializes
  // in the middle of an already-running match.
  if (!bUAPowerupStateReady)
  {
    UAAmpOwnerName = NewAmpOwner;
    UABeltOwnerName = NewBeltOwner;
    bUAPowerupStateReady = true;
    return;
  }

  if (NewAmpOwner != "" && NewAmpOwner != UAAmpOwnerName)
  {
    UAPickupNotice = "AMP  ->  " $ NewAmpOwner;
    UAPickupNoticeUntil = Level.TimeSeconds + 2.0;
  }
  else if (NewBeltOwner != "" && NewBeltOwner != UABeltOwnerName)
  {
    UAPickupNotice = "BELT  ->  " $ NewBeltOwner;
    UAPickupNoticeUntil = Level.TimeSeconds + 2.0;
  }

  UAAmpOwnerName = NewAmpOwner;
  UABeltOwnerName = NewBeltOwner;
}

function DrawUAPickupNotice(Canvas Canvas)
{
  local float XL, YL, BoxW, BoxH, X, Y;
  local color NoticeColor;

  if (UAPickupNotice == "" || Level.TimeSeconds >= UAPickupNoticeUntil)
    return;

  Canvas.Font = Font469_18b;
  Canvas.StrLen(UAPickupNotice, XL, YL);
  BoxW = XL + 28;
  BoxH = YL + 12;
  X = Canvas.ClipX * 0.5 - BoxW * 0.5;
  Y = Canvas.ClipY * 0.23;

  Canvas.Style = ERenderStyle.STY_Translucent;
  Canvas.DrawColor = SetColor(4,4,4);
  Canvas.SetPos(X, Y);
  Canvas.DrawRect(Texture'white_1x1', BoxW, BoxH);

  if (Left(UAPickupNotice, 3) == "AMP")
    NoticeColor = SetColor(178,96,226);
  else
    NoticeColor = SetColor(235,190,45);

  Canvas.Style = ERenderStyle.STY_Normal;
  Canvas.DrawColor = NoticeColor;
  Canvas.SetPos(X, Y);
  Canvas.DrawRect(Texture'white_1x1', BoxW, 2);

  Canvas.DrawColor = SetColor(240,240,240);
  Canvas.SetPos(X + 14, Y + 6);
  Canvas.DrawText(UAPickupNotice, False);
}

function DrawUAPowerupOwners(Canvas Canvas)
{
  local string OwnerText;
  local float XL, YL, X, Y, BoxW, BoxH;

  if (UAAmpOwnerName == "" && UABeltOwnerName == "")
    return;

  if (UAAmpOwnerName != "")
    OwnerText = "AMP: " $ UAAmpOwnerName;

  if (UABeltOwnerName != "")
  {
    if (OwnerText != "")
      OwnerText = OwnerText $ "     ";
    OwnerText = OwnerText $ "BELT: " $ UABeltOwnerName;
  }

  Canvas.Font = Font469_16;
  Canvas.StrLen(OwnerText, XL, YL);
  BoxW = XL + 20;
  BoxH = YL + 6;
  X = Canvas.ClipX * 0.5 - BoxW * 0.5;
  Y = Canvas.ClipY - 64;

  Canvas.Style = ERenderStyle.STY_Translucent;
  Canvas.DrawColor = SetColor(4,4,4);
  Canvas.SetPos(X, Y);
  Canvas.DrawRect(Texture'white_1x1', BoxW, BoxH);

  Canvas.Style = ERenderStyle.STY_Normal;
  Canvas.DrawColor = SetColor(205,205,205);
  Canvas.SetPos(X + 10, Y + 3);
  Canvas.DrawText(OwnerText, False);
}

simulated function DrawUASpectatorStatus(Canvas Canvas)
{
  local float BoxW, BoxH, BoxX, BoxY, XL, YL, UIScale, TimerReserve, IconSize;
  local float LabelX, NameX, NameMaxW, StatsX, Gap, DividerX, StateX, StateReserve;
  local string PName, RawName, TeamText, HPValue, ArmorValue, NameBlock, AmpText;
  local color Accent;
  local bool bFollowing, bObservedFC, bObservedAMP;
  local int NameChars;

  // UT99 fonts are fixed-pixel. Keep normal layouts at 1.0 and only enlarge
  // slightly on high-resolution canvases so geometry and text stay coherent.
  if (Canvas.ClipX >= 2200 || Canvas.ClipY >= 1200)
    UIScale = 1.20;
  else
    UIScale = 1.00;

  bFollowing = (PawnOwner != PlayerOwner && PawnOwner.PlayerReplicationInfo != None && !PawnOwner.PlayerReplicationInfo.bIsSpectator);

  if (class'OverlaySettings'.default.bShowItemTimer)
  {
    TimerReserve = 50 * UIScale;
    if (UAAmpOwnerName != "" || UABeltOwnerName != "")
      TimerReserve += 22 * UIScale;
  }
  else
    TimerReserve = 8 * UIScale;

  Canvas.Style = ERenderStyle.STY_Translucent;

  if (!bFollowing)
  {
    BoxW = 126 * UIScale;
    BoxH = 28 * UIScale;
    BoxX = Canvas.ClipX * 0.5 - BoxW * 0.5;
    BoxY = Canvas.ClipY - TimerReserve - BoxH - 6 * UIScale;

    Canvas.DrawColor = SetColor(9,11,15);
    Canvas.SetPos(BoxX, BoxY);
    Canvas.DrawRect(Texture'white_1x1', BoxW, BoxH);

    Canvas.Style = ERenderStyle.STY_Normal;
    Canvas.DrawColor = SetColor(42,46,54);
    Canvas.SetPos(BoxX, BoxY + BoxH - 1);
    Canvas.DrawRect(Texture'white_1x1', BoxW, 1);

    Canvas.Style = ERenderStyle.STY_Normal;
    // Unreal Arena brand signature: RED + BLUE split accent.
    Canvas.DrawColor = SetColor(214,42,46);
    Canvas.SetPos(BoxX, BoxY);
    Canvas.DrawRect(Texture'white_1x1', BoxW * 0.5, 2 * UIScale);
    Canvas.DrawColor = SetColor(48,112,232);
    Canvas.SetPos(BoxX + BoxW * 0.5, BoxY);
    Canvas.DrawRect(Texture'white_1x1', BoxW * 0.5, 2 * UIScale);

    Canvas.DrawColor = SetColor(218,174,70);
    Canvas.Font = Font469_16b;
    Canvas.StrLen("Free Spect", XL, YL);
    Canvas.SetPos(Canvas.ClipX * 0.5 - XL * 0.5, BoxY + (BoxH - YL) * 0.5 + 1 * UIScale);
    Canvas.DrawText("Free Spect", False);
    return;
  }

  RawName = PawnOwner.PlayerReplicationInfo.PlayerName;
  if (PawnOwner.PlayerReplicationInfo.Team == 0)
  {
    TeamText = "RED";
    Accent = SetColor(214,48,52);
  }
  else
  {
    TeamText = "BLUE";
    Accent = SetColor(58,124,240);
  }

  bObservedFC = (class'OverlaySettings'.default.bFC_Info && PawnOwner.PlayerReplicationInfo.HasFlag != None && !IsInWarmup());
  bObservedAMP = (class'OverlaySettings'.default.iAmpEffects != 0 && PawnOwner.PlayerReplicationInfo.TimeAcc != -1);

  // Responsive width with a safe margin on narrow 4:3 / low-res canvases.
  BoxW = 510 * UIScale;
  if (BoxW > Canvas.ClipX - 24 * UIScale)
    BoxW = Canvas.ClipX - 24 * UIScale;
  BoxH = 38 * UIScale;
  BoxX = Canvas.ClipX * 0.5 - BoxW * 0.5;
  BoxY = Canvas.ClipY - TimerReserve - BoxH - 6 * UIScale;
  IconSize = 16 * UIScale;
  Gap = 10 * UIScale;

  Canvas.DrawColor = SetColor(9,11,15);
  Canvas.SetPos(BoxX, BoxY);
  Canvas.DrawRect(Texture'white_1x1', BoxW, BoxH);

  Canvas.Style = ERenderStyle.STY_Normal;
  Canvas.DrawColor = SetColor(42,46,54);
  Canvas.SetPos(BoxX, BoxY + BoxH - 1);
  Canvas.DrawRect(Texture'white_1x1', BoxW, 1);

  Canvas.DrawColor = Accent;
  Canvas.SetPos(BoxX, BoxY);
  Canvas.DrawRect(Texture'white_1x1', BoxW, 2 * UIScale);

  // Reserve the right side for HP + Armor so long nicknames can never collide.
  // FC / AMP badges get their own conditional slot immediately before it.
  StatsX = BoxX + BoxW - (148 * UIScale);
  DividerX = StatsX - Gap;
  StateReserve = 0;
  if (bObservedFC)
    StateReserve += 30 * UIScale;
  if (bObservedAMP)
  {
    AmpText = "AMP " $ string(Max(0, PawnOwner.PlayerReplicationInfo.TimeAcc));
    StateReserve += 58 * UIScale;
  }
  StateX = DividerX - StateReserve;

  // Removed the old vertical divider here because in-game it could read as
  // an accidental extra bar next to the spectated player name.

  Canvas.Font = Font469_16;
  Canvas.DrawColor = SetColor(156,162,170);
  LabelX = BoxX + 12 * UIScale;
  Canvas.SetPos(LabelX, BoxY + 10 * UIScale);
  Canvas.DrawText("Spectating", False);
  Canvas.StrLen("Spectating", XL, YL);

  NameX = LabelX + XL + 12 * UIScale;
  NameMaxW = StateX - NameX - Gap;
  if (NameMaxW < 54 * UIScale)
    NameMaxW = 54 * UIScale;

  // Pixel-fit the nick + team tag instead of relying only on a character count.
  NameChars = Len(RawName);
  if (NameChars > 24)
    NameChars = 24;
  PName = Left(RawName, NameChars);
  if (NameChars < Len(RawName))
    PName = PName $ "..";
  NameBlock = PName $ " [" $ TeamText $ "]";

  Canvas.Font = Font469_16b;
  Canvas.StrLen(NameBlock, XL, YL);
  while (XL > NameMaxW && NameChars > 4)
  {
    NameChars--;
    PName = Left(RawName, NameChars) $ "..";
    NameBlock = PName $ " [" $ TeamText $ "]";
    Canvas.StrLen(NameBlock, XL, YL);
  }

  Canvas.DrawColor = Accent;
  Canvas.SetPos(NameX, BoxY + 10 * UIScale);
  Canvas.DrawText(NameBlock, False);

  // Compact live-state badges for the player being followed.  They only
  // consume space when active, so the normal spectator bar stays unchanged.
  if (bObservedFC)
  {
    if (PawnOwner.PlayerReplicationInfo.Team == 0)
      Canvas.DrawColor = SetColor(70,135,255);
    else
      Canvas.DrawColor = SetColor(235,65,65);
    Canvas.Font = Font469_16b;
    Canvas.SetPos(StateX + 4 * UIScale, BoxY + 10 * UIScale);
    Canvas.DrawText("FC", False);
    StateX += 30 * UIScale;
  }

  if (bObservedAMP)
  {
    Canvas.DrawColor = SetColor(178,96,226);
    Canvas.Font = Font469_16b;
    Canvas.SetPos(StateX + 4 * UIScale, BoxY + 10 * UIScale);
    Canvas.DrawText(AmpText, False);
  }

  HPValue = string(Max(0, PawnOwner.Health));
  ArmorValue = string(GetUAObservedArmor());

  // Fixed right-side stat cells with deliberate spacing between icon/value pairs.
  Canvas.DrawColor = SetColor(225,225,225);
  Canvas.SetPos(StatsX, BoxY + 10 * UIScale);
  Canvas.DrawTile(Texture'health_icon', IconSize, IconSize, 0, 0, 128, 128);

  Canvas.Font = Font469_16b;
  Canvas.DrawColor = SetColor(226,230,236);
  Canvas.SetPos(StatsX + 21 * UIScale, BoxY + 10 * UIScale);
  Canvas.DrawText(HPValue, False);

  Canvas.DrawColor = SetColor(208,174,68);
  Canvas.SetPos(StatsX + 76 * UIScale, BoxY + 10 * UIScale);
  Canvas.DrawTile(Texture'armor_icon', IconSize, IconSize, 0, 0, 128, 128);

  Canvas.Font = Font469_16b;
  Canvas.DrawColor = SetColor(226,198,118);
  Canvas.SetPos(StatsX + 97 * UIScale, BoxY + 10 * UIScale);
  Canvas.DrawText(ArmorValue, False);
}

function int GetUABeltCount()
{
  local UT_Shieldbelt B;
  local int Count;

  Count = 0;
  foreach Level.AllActors(class'UT_Shieldbelt', B)
    Count++;

  return Count;
}

function byte GetUABeltSide(Inventory P)
{
  local float RedDist, BlueDist;

  // 255 = no reliable team association yet.
  if (P == None || RedBase == vect(0,0,0) || BlueBase == vect(0,0,0))
    return 255;

  RedDist = VSize(P.Location - RedBase);
  BlueDist = VSize(P.Location - BlueBase);

  if (RedDist <= BlueDist)
    return 0;

  return 1;
}

function Pawn UAResolvePlayerCamPawn()
{
  local Pawn P;

  if (UAPlayerCamPRI == None)
    return None;

  foreach Level.AllActors(class'Pawn', P)
  {
    if (P != None && P.PlayerReplicationInfo == UAPlayerCamPRI && P.Health > 0)
      return P;
  }

  return None;
}

function DrawUAPlayerCam(Canvas Canvas)
{
  local Pawn P;
  local vector CamLocation;
  local rotator CamRotation;
  local float W, H, X, Y, HeaderH, SlideY, XL, YL;
  local color Accent;
  local string PlayerName;
  local bool bOldHidden;

  if ((!bUAPlayerCamActive && !bUAPlayerCamClosing) || UAPlayerCamAlpha <= 0.0)
    return;

  P = UAResolvePlayerCamPawn();
  if (P == None)
  {
    // Player died/disconnected. Close cleanly and restore chat.
    bUAPlayerCamActive = false;
    bUAPlayerCamClosing = true;
    return;
  }

  // Extra-large responsive 16:9 Player Cam.
  // It grows upward from the lower-left lane while preserving a safety zone
  // above the spectator bar / timers so existing HUD elements are untouched.
  W = Canvas.ClipX * 0.38;
  if (W < 340)
    W = 340;
  if (W > 600)
    W = 600;

  H = W * 0.5625;
  HeaderH = 22;

  X = 12;

  // Reserve the full lower-HUD lane used by Spectating/HP/Armor and timers.
  // Player Cam sits above that area instead of overlapping it.
  Y = Canvas.ClipY - H - 148;

  // Avoid climbing into the compact scoreboard on low resolutions.
  if (Y < 150)
    Y = 150;

  // Same subtle slide language as Compare/MVP Focus.
  SlideY = (1.0 - UAPlayerCamAlpha) * 14;
  Y += SlideY;

  // Emulate a clean BehindView 0 / first-person POV.
  // EyeHeight alone can leave DrawPortal inside the player's mesh, so move
  // a few Unreal Units forward and hide only this pawn while the portal is drawn.
  // Keep Player Cam synchronized even after the caster switches the main
  // spectator target. ViewRotation is reliable while directly following the
  // player. For a locked remote pawn, rebuild the view every frame from the
  // replicated Pawn.Rotation instead.
  if (P == PawnOwner)
  {
    CamRotation = P.ViewRotation;
  }
  else
  {
    // For a locked remote player, use Pawn.Rotation, which is available and
    // replicated safely across UT99 builds.
    CamRotation = P.Rotation;
    CamRotation.Roll = 0;
  }

  CamLocation = P.Location;
  CamLocation.Z += P.EyeHeight;
  CamLocation += Vector(CamRotation) * 8.0;

  bOldHidden = P.bHidden;
  P.bHidden = True;

  // Use the local spectator as the portal camera actor instead of the target Pawn.
  // The explicit location/rotation still follows the locked player.
  Canvas.DrawPortal(
    int(X + 2),
    int(Y + HeaderH),
    int(W - 4),
    int(H - HeaderH - 2),
    PlayerOwner,
    CamLocation,
    CamRotation,
    90,
    True
  );

  P.bHidden = bOldHidden;

  Canvas.Style = ERenderStyle.STY_Translucent;
  Canvas.DrawColor = SetColor(4,4,4);
  Canvas.SetPos(X, Y);
  Canvas.DrawRect(Texture'white_1x1', W, HeaderH);

  if (UAPlayerCamPRI.Team == 0)
    Accent = SetColor(205,45,45);
  else
    Accent = SetColor(55,115,235);

  Canvas.Style = ERenderStyle.STY_Normal;
  Canvas.DrawColor = Accent;

  // Team rail: top and left only, keeping the picture itself unobstructed.
  Canvas.SetPos(X, Y);
  Canvas.DrawRect(Texture'white_1x1', W, 2);
  Canvas.SetPos(X, Y);
  Canvas.DrawRect(Texture'white_1x1', 2, H);

  Canvas.Font = Font469_16b;
  Canvas.DrawColor = SetColor(218,190,120);
  Canvas.SetPos(X + 9, Y + 4);
  Canvas.DrawText("PLAYER CAM", False);

  PlayerName = UAPlayerCamPRI.PlayerName;
  Canvas.Font = Font469_16;
  Canvas.DrawColor = Accent;
  Canvas.StrLen(PlayerName, XL, YL);

  // Fit very long names inside the camera header.
  while (XL > W - 118 && Len(PlayerName) > 5)
  {
    PlayerName = Left(PlayerName, Len(PlayerName)-1);
    Canvas.StrLen(PlayerName$"..", XL, YL);
  }
  if (PlayerName != UAPlayerCamPRI.PlayerName)
    PlayerName = PlayerName$"..";

  Canvas.SetPos(X + W - XL - 9, Y + 4);
  Canvas.DrawText(PlayerName, False);
}

function string GetUATimerLabel(Inventory P)
{
  local byte BeltSide;

  if (P.IsA('UDamage'))
  {
    if (class'OverlaySettings'.default.bShowAmp) return "AMP";
  }
  else if (P.IsA('UT_ShieldBelt'))
  {
    if (class'OverlaySettings'.default.bShowShield)
    {
      // Maps with one Belt keep the classic label.  With multiple Belts,
      // identify the spawn by the closest CTF base so spectators can tell
      // which side is becoming available.
      if (GetUABeltCount() > 1)
      {
        BeltSide = GetUABeltSide(P);
        if (BeltSide == 0) return "BELT";
        if (BeltSide == 1) return "BELT";
      }
      return "BELT";
    }
  }
  else if (P.IsA('HealthPack'))
  {
    if (class'OverlaySettings'.default.bShowKeg) return "KEG";
  }
  else if (P.IsA('Armor2'))
  {
    if (class'OverlaySettings'.default.bShowArmor) return "ARMOR";
  }
  else if (P.IsA('ThighPads'))
  {
    if (class'OverlaySettings'.default.bShowPads) return "PADS";
  }
  else if (P.IsA('UT_Jumpboots'))
  {
    if (class'OverlaySettings'.default.bShowBoots) return "BOOTS";
  }
  else if (P.IsA('UT_Invisibility'))
  {
    if (class'OverlaySettings'.default.bShowInvis) return "INVIS";
  }

  return "";
}

function Texture GetUATimerIcon(Inventory P)
{
  if (P.IsA('UDamage')) return Texture'amp_icon';
  if (P.IsA('UT_ShieldBelt')) return Texture'belt_icon';
  if (P.IsA('HealthPack')) return Texture'health_icon';
  if (P.IsA('Armor2')) return Texture'armor_icon';
  if (P.IsA('ThighPads')) return Texture'pads_icon';
  if (P.IsA('UT_Jumpboots')) return Texture'boots_icon';
  if (P.IsA('UT_Invisibility')) return Texture'invis_icon';
  return None;
}

function color GetUATimerAccent(Inventory P)
{
  local byte BeltSide;

  if (P.IsA('UDamage')) return SetColor(115,65,155);
  if (P.IsA('UT_ShieldBelt'))
  {
    if (GetUABeltCount() > 1)
    {
      BeltSide = GetUABeltSide(P);
      if (BeltSide == 0) return SetColor(205,45,45);
      if (BeltSide == 1) return SetColor(55,115,235);
    }
    return SetColor(218,174,70);
  }
  if (P.IsA('HealthPack')) return SetColor(225,90,90);
  if (P.IsA('Armor2')) return SetColor(180,180,180);
  if (P.IsA('ThighPads')) return SetColor(150,170,210);
  if (P.IsA('UT_Jumpboots')) return SetColor(145,145,145);
  return SetColor(210,210,210);
}

function DrawItemTimer (Canvas Canvas) // UA compact responsive horizontal spectator timer strip
{
  local Inventory P;
  local string N, TimeText;
  local int i, j, ItemCount;
  local float ItemW, ItemH, TotalW, StartX, CurX, BaseY, IconSize, UIScale, TextY, XL, YL, AccentW;
  local byte Team;
  local float Distance;
  local Texture TimerIcon;
  local color Accent;

  bHidden = true;

  // Match the status bar: fixed readable geometry at normal resolutions,
  // slightly larger on high-resolution displays.
  if (Canvas.ClipX >= 2200 || Canvas.ClipY >= 1200)
    UIScale = 1.20;
  else
    UIScale = 1.00;

  ItemCount = 0;

  // Count visible timer types first so the strip stays centered.
  foreach Level.AllActors (class 'Inventory', P)
  {
    N = GetUATimerLabel(P);
    if (N != "" && !P.bHeldItem && P.Owner == None)
      ItemCount++;
  }

  if (ItemCount <= 0)
  {
    lasttime = gametime;
    return;
  }

  ItemH = 36 * UIScale;
  IconSize = 18 * UIScale;
  ItemW = 88 * UIScale;

  // Keep the strip inside the screen on narrow resolutions.
  if (ItemW * ItemCount > Canvas.ClipX - 20)
    ItemW = (Canvas.ClipX - 20) / ItemCount;

  TotalW = ItemCount * ItemW;
  StartX = Canvas.ClipX * 0.5 - TotalW * 0.5;
  BaseY = Canvas.ClipY - ItemH - 8 * UIScale;
  CurX = StartX;
  i = 0;

  foreach Level.AllActors (class 'Inventory', P)
  {
    N = GetUATimerLabel(P);
    if (N == "")
      continue;

    if (P.bHeldItem || (P.Owner != None))
      continue;

    if (P.bHidden)
    {
      if (!(ptimes[i].inited))
      {
        ptimes[i].timeleft = P.RespawnTime;
        ptimes[i].inited = true;
      }
      ptimes[i].timeleft -= (gametime - lasttime);
    }
    else
    {
      ptimes[i].inited = false;
      ptimes[i].timeleft = P.RespawnTime;
    }

    if (ptimes[i].timeleft < 0)
      ptimes[i].timeleft = P.RespawnTime;

    Accent = GetUATimerAccent(P);
    TimerIcon = GetUATimerIcon(P);

    Canvas.Style = ERenderStyle.STY_Translucent;
    Canvas.DrawColor = SetColor(9,11,15);
    Canvas.SetPos(CurX, BaseY);
    Canvas.DrawRect(Texture'white_1x1', ItemW - 2 * UIScale, ItemH);

    Canvas.Style = ERenderStyle.STY_Normal;
    Canvas.DrawColor = SetColor(40,44,52);
    Canvas.SetPos(CurX, BaseY);
    Canvas.DrawRect(Texture'white_1x1', ItemW - 2 * UIScale, 1);
    Canvas.SetPos(CurX, BaseY + ItemH - 1);
    Canvas.DrawRect(Texture'white_1x1', ItemW - 2 * UIScale, 1);

    Canvas.DrawColor = Accent;
    AccentW = 3 * UIScale;
    // Subtle pulse while the pickup is available. It changes only the thin
    // accent rail, never the size of the timer card or its text.
    if (!ptimes[i].inited && (int(Level.TimeSeconds * 4) % 2 == 0))
      AccentW = 5 * UIScale;
    Canvas.SetPos(CurX, BaseY);
    Canvas.DrawRect(Texture'white_1x1', AccentW, ItemH);

    // Keep the original team hint for duplicated AMP/Belt timers.
    if ((P.IsA('UDamage') && AmpCount > 1) || (P.IsA('UT_ShieldBelt') && BeltCount > 1))
    {
      if (!IsInWarmup())
      {
        returnClosestTeamPointAndDistance(P, Team, Distance);
        if (Team == 0)
          Canvas.DrawColor = SetColor(190,55,55);
        else
          Canvas.DrawColor = SetColor(70,115,235);
      }
    }
    else
      Canvas.DrawColor = SetColor(226,230,236);

    if (TimerIcon != None)
    {
      Canvas.SetPos(CurX + 8 * UIScale, BaseY + 9 * UIScale);
      Canvas.DrawTile(TimerIcon, IconSize, IconSize, 0, 0, 128, 128);
    }

    j = ptimes[i].timeleft / Level.TimeDilation;
    if (ptimes[i].inited)
      TimeText = string(j);
    else
      TimeText = "UP";

    // Label and value share the same nominal font size/baseline.
    Canvas.Font = Font469_16;
    Canvas.StrLen(N $ " " $ TimeText, XL, YL);
    TextY = BaseY + (ItemH - YL) * 0.5;

    Canvas.DrawColor = SetColor(176,182,190);
    Canvas.SetPos(CurX + 31 * UIScale, TextY);
    Canvas.DrawText(N, False);

    Canvas.StrLen(N, XL, YL);
    Canvas.Font = Font469_16b;
    if (!ptimes[i].inited)
      Canvas.DrawColor = SetColor(105,220,125);
    else if (j <= 5)
      Canvas.DrawColor = SetColor(245,110,100);
    else if (j <= 10)
      Canvas.DrawColor = SetColor(245,210,105);
    else
      Canvas.DrawColor = SetColor(226,230,236);

    Canvas.SetPos(CurX + 34 * UIScale + XL, TextY);
    Canvas.DrawText(TimeText, False);

    i++;
    CurX += ItemW;
  }

  lasttime = gametime;
}

function returnClosestTeamPointAndDistance(Actor A, out byte Team, out float Distance)
{
  local float distToRed,distToBlue;

  distToRed = VSize(A.Location - RedBase);
  distToBlue = VSize(A.Location - BlueBase);

  if (distToRed > distToBlue)
  {
    Team = 1;
    Distance = distToBlue;
  }
  else
  {
    Team = 0;
    Distance = distToRed;
  }
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

function DrawTextRight(Canvas Canvas,string text, int X, int Y)
{
  local float w,h;

  Canvas.StrLen(text, w, h);
  Canvas.SetPos(X-w, Y);
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

simulated function DrawDigit(Canvas Canvas, int d, int Step, float UpScale, out byte bMinus )
{
  if ( bMinus == 1 )
  {
    Canvas.CurX -= Step;
    Canvas.DrawIcon(Texture'NumDash', UpScale);
    bMinus = 0;
  }
  if ( d == 1 )
  Canvas.CurX -= 0.5 * Step;
  Canvas.DrawIcon(BigNums[d], UpScale);
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

defaultproperties
{
	BigNums(0)=Texture'OmniViewCTF_CasterED_UA.Icons.NumZero'
	BigNums(1)=Texture'OmniViewCTF_CasterED_UA.Icons.NumOne'
	BigNums(2)=Texture'OmniViewCTF_CasterED_UA.Icons.NumTwo'
	BigNums(3)=Texture'OmniViewCTF_CasterED_UA.Icons.NumThree'
	BigNums(4)=Texture'OmniViewCTF_CasterED_UA.Icons.NumFour'
	BigNums(5)=Texture'OmniViewCTF_CasterED_UA.Icons.NumFive'
	BigNums(6)=Texture'OmniViewCTF_CasterED_UA.Icons.NumSix'
	BigNums(7)=Texture'OmniViewCTF_CasterED_UA.Icons.NumSeven'
	BigNums(8)=Texture'OmniViewCTF_CasterED_UA.Icons.NumEight'
	BigNums(9)=Texture'OmniViewCTF_CasterED_UA.Icons.NumNine'
}
