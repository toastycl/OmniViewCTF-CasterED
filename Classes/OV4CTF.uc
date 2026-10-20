class OV4CTF expands Mutator;

var bool init;
var PlayerPawn PlayerOwner;

simulated function Tick(float DeltaTime) {
    if (Level.NetMode != NM_DedicatedServer) {
        if (!bHUDMutator) RegisterHUDMutator();
    }
}

function SetupOverlayHUD(canvas C)
{
  local OverlayHUD OHUD;

  if (PlayerOwner.myHUD != none)
  PlayerOwner.myHUD.Destroy();

  OHUD = PlayerOwner.Level.Spawn(class'OverlayHUD', PlayerOwner);

  PlayerOwner.myHUD = OHUD;

  init = true;
}

function PostRender(canvas C)
{
  Super.PostRender(C);

  PlayerOwner = C.Viewport.Actor;

  if (PlayerOwner != none && !init )
  SetupOverlayHUD(C);
}

defaultproperties
{
}
