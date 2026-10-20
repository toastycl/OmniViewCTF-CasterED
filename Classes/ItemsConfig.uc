class ItemsConfig expands UWindowPageWindow;

var UMenuLabelControl ItemsLabel;
var UWindowCheckbox ShowShield;
var UWindowCheckbox ShowAmp;
var UWindowCheckbox ShowKeg;
var UWindowCheckbox ShowArmor;
var UWindowCheckbox ShowPads;
var UWindowCheckbox ShowBoots;
var UWindowCheckbox ShowInvis;

function Created()
{
  local int CurY;

  Super.Created();
  SetAcceptsFocus();

  CurY = 20;

  ItemsLabel = UMenuLabelControl(CreateControl(Class'UMenuLabelControl', 0.0, CurY, 240.0, 1.0));
  ItemsLabel.SetText("Timer Settings");
  ItemsLabel.Align = TA_Center;
  ItemsLabel.SetFont(F_Bold);
  CurY = CurY + 30;

  // Shield Belt checkbox //
  ShowShield = UWindowCheckbox(CreateControl(class'UWindowCheckbox', 10.0, CurY, 225.0, 1.0));
  ShowShield.SetText("Show Shield Belt timer");
  ShowShield.SetHelpText("Enable/disable Shield Belt respawn timer display");
  ShowShield.SetFont(F_Normal);
  ShowShield.bChecked = class'OverlaySettings'.default.bShowShield;
  CurY = CurY + 20;

  // Amp checkbox //
  ShowAmp = UWindowCheckbox(CreateControl(class'UWindowCheckbox', 10.0, CurY, 225.0, 1.0));
  ShowAmp.SetText("Show Amp timer");
  ShowAmp.SetHelpText("Enable/disable UDamage respawn timer display");
  ShowAmp.SetFont(F_Normal);
  ShowAmp.bChecked = class'OverlaySettings'.default.bShowAmp;
  CurY = CurY + 20;

  // Keg checkbox //
  ShowKeg = UWindowCheckbox(CreateControl(class'UWindowCheckbox', 10.0, CurY, 225.0, 1.0));
  ShowKeg.SetText("Show Keg timer");
  ShowKeg.SetHelpText("Enable/disable HealthPack respawn timer display");
  ShowKeg.SetFont(F_Normal);
  ShowKeg.bChecked = class'OverlaySettings'.default.bShowKeg;
  CurY = CurY + 20;

  // Armor checkbox //
  ShowArmor = UWindowCheckbox(CreateControl(class'UWindowCheckbox', 10.0, CurY, 225.0, 1.0));
  ShowArmor.SetText("Show Armor timer");
  ShowArmor.SetHelpText("Enable/disable Armor2 respawn timer display");
  ShowArmor.SetFont(F_Normal);
  ShowArmor.bChecked = class'OverlaySettings'.default.bShowArmor;
  CurY = CurY + 20;

  // Pads checkbox //
  ShowPads = UWindowCheckbox(CreateControl(class'UWindowCheckbox', 10.0, CurY, 225.0, 1.0));
  ShowPads.SetText("Show Pads timer");
  ShowPads.SetHelpText("Enable/disable ThighPads respawn timer display");
  ShowPads.SetFont(F_Normal);
  ShowPads.bChecked = class'OverlaySettings'.default.bShowPads;
  CurY = CurY + 20;

  // Boots checkbox //
  ShowBoots = UWindowCheckbox(CreateControl(class'UWindowCheckbox', 10.0, CurY, 225.0, 1.0));
  ShowBoots.SetText("Show Boots timer");
  ShowBoots.SetHelpText("Enable/disable Jumpboots respawn timer display");
  ShowBoots.SetFont(F_Normal);
  ShowBoots.bChecked = class'OverlaySettings'.default.bShowBoots;
  CurY = CurY + 20;

  // Invis checkbox //
  ShowInvis = UWindowCheckbox(CreateControl(class'UWindowCheckbox', 10.0, CurY, 225.0, 1.0));
  ShowInvis.SetText("Show Invis timer");
  ShowInvis.SetHelpText("Enable/disable Invisibility respawn timer display");
  ShowInvis.SetFont(F_Normal);
  ShowInvis.bChecked = class'OverlaySettings'.default.bShowInvis;
  CurY = CurY + 20;
}

function Notify(UWindowDialogControl C, byte E)
{
  switch(E)
  {
    case DE_Change:
      switch(C)
      {
        case ShowShield:
          class'OverlaySettings'.default.bShowShield = ShowShield.bChecked;
          break;
        case ShowAmp:
          class'OverlaySettings'.default.bShowAmp = ShowAmp.bChecked;
          break;
        case ShowKeg:
          class'OverlaySettings'.default.bShowKeg = ShowKeg.bChecked;
          break;
        case ShowArmor:
          class'OverlaySettings'.default.bShowArmor = ShowArmor.bChecked;
          break;
        case ShowPads:
          class'OverlaySettings'.default.bShowPads = ShowPads.bChecked;
          break;
        case ShowBoots:
          class'OverlaySettings'.default.bShowBoots = ShowBoots.bChecked;
          break;
        case ShowInvis:
          class'OverlaySettings'.default.bShowInvis = ShowInvis.bChecked;
          break;
      }
      break;
  }
}

defaultproperties
{
}
