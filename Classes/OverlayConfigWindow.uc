class OverlayConfigWindow expands UWindowFramedWindow;

function BeginPlay()
{
  Super.BeginPlay();
  WindowTitle = "OmniViewCTF - Caster Edition (Unreal Arena)";
  ClientClass = class'OverlayConfigTab';
  bSizable = false;
  bStatusBar = true;
  StatusBarText = ":)";
  bLeaveOnscreen = true;
}

function Created()
{
  Super.Created();
  SetSize(250, 572);
  WinLeft = (Root.WinWidth - WinWidth) / 2;
  WinTop = (Root.WinHeight - WinHeight) / 2;
}

function Close (optional bool bByParent)
{
  Super.Close(bByParent);
  WindowConsole(GetPlayerOwner().Player.Console).CloseUWindow();
}

defaultproperties
{
}
