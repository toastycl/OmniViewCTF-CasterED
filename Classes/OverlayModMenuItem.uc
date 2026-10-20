class OverlayModMenuItem expands UMenuModMenuItem;

function Execute()
{
  MenuItem.Owner.Root.CreateWindow(class'OverlayConfigWindow',10,10,150,100);
}

defaultproperties
{
	MenuCaption="&OmniViewCTF - Caster Edition"
	MenuHelp=""
}
