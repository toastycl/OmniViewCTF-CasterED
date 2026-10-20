class OverlayConfig expands UWindowScrollingDialogClient;

function Created()
{
  ClientClass = class'OverlayConfigContent';
  FixedAreaClass = None;
  Super.Created();
}

defaultproperties
{
}
