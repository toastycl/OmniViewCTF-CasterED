class OverlayConfigTab expands UWindowPageWindow;

function Created()
{
  local UMenuPageControl Pages;
  local OverlayConfig UserWindow;

  Pages = UMenuPageControl ( CreateWindow(class'UMenuPageControl', 0, 0, 245, 540));
  UserWindow = OverlayConfig(Pages.AddPage("General", class'OverlayConfig').Page);
  Pages.AddPage ("Timers", class'ItemsConfig');
  Pages.AddPage ("Advanced", class'OverlayAdvConfig');
  Pages.AddPage ("About", class'OverlayAboutWindow');
  Pages.SetMultiLine(True);
}

defaultproperties
{
}
