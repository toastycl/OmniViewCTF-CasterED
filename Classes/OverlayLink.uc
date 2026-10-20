class OverlayLink extends UMenuLabelControl;

var string URL;

function Created()
{
  Cursor = Root.HandCursor;
}

function Paint(Canvas C, float X, float Y)
{
  if(Text != "")
  {
    if (bMouseDown )
    {
	C.DrawColor.R = 255;
	C.DrawColor.G = 255;
	C.DrawColor.B = 255;
    }
    else
    {
	C.DrawColor.R = 0;
	C.DrawColor.G = 0;
	C.DrawColor.B = 168;
                }
    C.Font = Root.Fonts[Font];
	ClipText(C, TextX, TextY, Text);

    Cursor = Root.HandCursor;

    C.DrawColor.R = 0;
	C.DrawColor.G = 0;
	C.DrawColor.B = 0;
  }
}

function Click(float X, float Y)
{
  Root.Console.ViewPort.Actor.ConsoleCommand("start "$URL);
}

defaultproperties
{
}
