class OverlayAdvConfig expands UWindowPageWindow;

var UMenuLabelControl Settings;
var UMenuLabelControl EmptyLine;
var UMenuLabelControl OBSCompatibility;

var UWindowEditControl IH_DeathMsg;
var UWindowEditControl TL_DeathMsg;
var UWindowEditControl ENF_DeathMsg;
var UWindowEditControl BIO_DeathMsg;
var UWindowEditControl SHOCK_DeathMsg;
var UWindowEditControl PULSE_DeathMsg;
var UWindowEditControl RIPPER_DeathMsg;
var UWindowEditControl MINI_DeathMsg;
var UWindowEditControl FLAK_DeathMsg;
var UWindowEditControl RL_DeathMsg;
var UWindowEditControl SNIPER_DeathMsg;
var UWindowEditControl IG_DeathMsg;
var UWindowEditControl FALL_DeathMsg;
var UWindowEditControl DROWNED_DeathMsg;
var UWindowEditControl BURNED_DeathMsg;
var UWindowEditControl CORRODED_DeathMsg;
var UWindowEditControl MaleSuicide_DeathMsg;
var UWindowEditControl FemaleSuicide_DeathMsg;

var UWindowComboControl OBSOffset;

var UWindowSmallButton ResetButton;

var string IH_DeathMsg_Default, TL_DeathMsg_Default, ENF_DeathMsg_Default, BIO_DeathMsg_Default, SHOCK_DeathMsg_Default, PULSE_DeathMsg_Default,
RIPPER_DeathMsg_Default, MINI_DeathMsg_Default, FLAK_DeathMsg_Default, RL_DeathMsg_Default, SNIPER_DeathMsg_Default, IG_DeathMsg_Default, FALL_DeathMsg_Default,
DROWNED_DeathMsg_Default, BURNED_DeathMsg_Default, CORRODED_DeathMsg_Default, MaleSuicide_DeathMsg_Default, FemaleSuicide_DeathMsg_Default;

function SaveToConfig()
{
  class'OverlaySettings'.static.StaticSaveConfig();
}

function Created()
{
  local int CurY;
  Cury = 25;

  Super.Created();
  SetAcceptsFocus();

  Settings = UMenuLabelControl(CreateControl(Class'UMenuLabelControl', 0.0, 5.0, 240.0, 1.0));
  Settings.SetText ("Kill Feed Messages");
  Settings.Align = TA_Center;
  Settings.SetFont (F_Bold);

  // weapons //
  IH_DeathMsg = UWindowEditControl(CreateControl(class'UWindowEditControl', 10, Cury, 225, 1));
  IH_DeathMsg.editboxwidth=170;
  IH_DeathMsg.SetText("IH");
  IH_DeathMsg.SetHelpText("");
  IH_DeathMsg.SetValue(class'OverlaySettings'.default.IH_DM);
  IH_DeathMsg.SetMaxLength (125);
  IH_DeathMsg.Align = TA_Left;
  Cury = Cury + 20;

  TL_DeathMsg = UWindowEditControl(CreateControl(class'UWindowEditControl', 10, Cury, 225, 1));
  TL_DeathMsg.editboxwidth=170;
  TL_DeathMsg.SetText("TL");
  TL_DeathMsg.SetHelpText("");
  TL_DeathMsg.SetValue(class'OverlaySettings'.default.trans_DM);
  TL_DeathMsg.SetMaxLength (125);
  TL_DeathMsg.Align = TA_Left;
  Cury = Cury + 20;

  ENF_DeathMsg = UWindowEditControl(CreateControl(class'UWindowEditControl', 10, Cury, 225, 1));
  ENF_DeathMsg.editboxwidth=170;
  ENF_DeathMsg.SetText("Enforcer");
  ENF_DeathMsg.SetHelpText("");
  ENF_DeathMsg.SetValue(class'OverlaySettings'.default.enforcer_DM);
  ENF_DeathMsg.SetMaxLength (125);
  ENF_DeathMsg.Align = TA_Left;
  Cury = Cury + 20;

  BIO_DeathMsg = UWindowEditControl(CreateControl(class'UWindowEditControl', 10, Cury, 225, 1));
  BIO_DeathMsg.editboxwidth=170;
  BIO_DeathMsg.SetText("Bio");
  BIO_DeathMsg.SetHelpText("");
  BIO_DeathMsg.SetValue(class'OverlaySettings'.default.bio_DM);
  BIO_DeathMsg.SetMaxLength (125);
  BIO_DeathMsg.Align = TA_Left;
  Cury = Cury + 20;

  SHOCK_DeathMsg = UWindowEditControl(CreateControl(class'UWindowEditControl', 10, Cury, 225, 1));
  SHOCK_DeathMsg.editboxwidth=170;
  SHOCK_DeathMsg.SetText("Shock");
  SHOCK_DeathMsg.SetHelpText("");
  SHOCK_DeathMsg.SetValue(class'OverlaySettings'.default.shock_DM);
  SHOCK_DeathMsg.SetMaxLength (125);
  SHOCK_DeathMsg.Align = TA_Left;
  Cury = Cury + 20;

  PULSE_DeathMsg = UWindowEditControl(CreateControl(class'UWindowEditControl', 10, Cury, 225, 1));
  PULSE_DeathMsg.editboxwidth=170;
  PULSE_DeathMsg.SetText("Pulse");
  PULSE_DeathMsg.SetHelpText("");
  PULSE_DeathMsg.SetValue(class'OverlaySettings'.default.pulse_DM);
  PULSE_DeathMsg.SetMaxLength (125);
  PULSE_DeathMsg.Align = TA_Left;
  Cury = Cury + 20;

  RIPPER_DeathMsg = UWindowEditControl(CreateControl(class'UWindowEditControl', 10, Cury, 225, 1));
  RIPPER_DeathMsg.editboxwidth=170;
  RIPPER_DeathMsg.SetText("Ripper");
  RIPPER_DeathMsg.SetHelpText("");
  RIPPER_DeathMsg.SetValue(class'OverlaySettings'.default.ripper_DM);
  RIPPER_DeathMsg.SetMaxLength (125);
  RIPPER_DeathMsg.Align = TA_Left;
  Cury = Cury + 20;

  MINI_DeathMsg = UWindowEditControl(CreateControl(class'UWindowEditControl', 10, Cury, 225, 1));
  MINI_DeathMsg.editboxwidth=170;
  MINI_DeathMsg.SetText("Mini");
  MINI_DeathMsg.SetHelpText("");
  MINI_DeathMsg.SetValue(class'OverlaySettings'.default.mini_DM);
  MINI_DeathMsg.SetMaxLength (125);
  MINI_DeathMsg.Align = TA_Left;
  Cury = Cury + 20;

  FLAK_DeathMsg = UWindowEditControl(CreateControl(class'UWindowEditControl', 10, Cury, 225, 1));
  FLAK_DeathMsg.editboxwidth=170;
  FLAK_DeathMsg.SetText("Flak");
  FLAK_DeathMsg.SetHelpText("");
  FLAK_DeathMsg.SetValue(class'OverlaySettings'.default.flak_DM);
  FLAK_DeathMsg.SetMaxLength (125);
  FLAK_DeathMsg.Align = TA_Left;
  Cury = Cury + 20;

  RL_DeathMsg = UWindowEditControl(CreateControl(class'UWindowEditControl', 10, Cury, 225, 1));
  RL_DeathMsg.editboxwidth=170;
  RL_DeathMsg.SetText("RL");
  RL_DeathMsg.SetHelpText("");
  RL_DeathMsg.SetValue(class'OverlaySettings'.default.RL_DM);
  RL_DeathMsg.SetMaxLength (125);
  RL_DeathMsg.Align = TA_Left;
  Cury = Cury + 20;

  SNIPER_DeathMsg = UWindowEditControl(CreateControl(class'UWindowEditControl', 10, Cury, 225, 1));
  SNIPER_DeathMsg.editboxwidth=170;
  SNIPER_DeathMsg.SetText("Sniper");
  SNIPER_DeathMsg.SetHelpText("");
  SNIPER_DeathMsg.SetValue(class'OverlaySettings'.default.sniper_DM);
  SNIPER_DeathMsg.SetMaxLength (125);
  SNIPER_DeathMsg.Align = TA_Left;
  Cury = Cury + 20;

  EmptyLine = UMenuLabelControl(CreateControl(Class'UMenuLabelControl', 0.0, Cury, 240.0, 1.0));
  EmptyLine.SetText ("");
  EmptyLine.Align = TA_Center;
  EmptyLine.SetFont (F_Normal);
  Cury = Cury + 20;

  IG_DeathMsg = UWindowEditControl(CreateControl(class'UWindowEditControl', 10, Cury, 225, 1));
  IG_DeathMsg.editboxwidth=170;
  IG_DeathMsg.SetText("SuperShock");
  IG_DeathMsg.SetHelpText("");
  IG_DeathMsg.SetValue(class'OverlaySettings'.default.IG_DM);
  IG_DeathMsg.SetMaxLength (125);
  IG_DeathMsg.Align = TA_Left;
  Cury = Cury + 20;

  EmptyLine = UMenuLabelControl(CreateControl(Class'UMenuLabelControl', 0.0, Cury, 240.0, 1.0));
  EmptyLine.SetText ("");
  EmptyLine.Align = TA_Center;
  EmptyLine.SetFont (F_Normal);
  Cury = Cury + 20;

  FALL_DeathMsg = UWindowEditControl(CreateControl(class'UWindowEditControl', 10, Cury, 225, 1));
  FALL_DeathMsg.editboxwidth=170;
  FALL_DeathMsg.SetText("Fall");
  FALL_DeathMsg.SetHelpText("");
  FALL_DeathMsg.SetValue(class'OverlaySettings'.default.Fall_DM);
  FALL_DeathMsg.SetMaxLength (125);
  FALL_DeathMsg.Align = TA_Left;
  Cury = Cury + 20;

  DROWNED_DeathMsg = UWindowEditControl(CreateControl(class'UWindowEditControl', 10, Cury, 225, 1));
  DROWNED_DeathMsg.editboxwidth=170;
  DROWNED_DeathMsg.SetText("Drowned");
  DROWNED_DeathMsg.SetHelpText("");
  DROWNED_DeathMsg.SetValue(class'OverlaySettings'.default.Drowned_DM);
  DROWNED_DeathMsg.SetMaxLength (125);
  DROWNED_DeathMsg.Align = TA_Left;
  Cury = Cury + 20;

  BURNED_DeathMsg = UWindowEditControl(CreateControl(class'UWindowEditControl', 10, Cury, 225, 1));
  BURNED_DeathMsg.editboxwidth=170;
  BURNED_DeathMsg.SetText("Burned");
  BURNED_DeathMsg.SetHelpText("");
  BURNED_DeathMsg.SetValue(class'OverlaySettings'.default.Burned_DM);
  BURNED_DeathMsg.SetMaxLength (125);
  BURNED_DeathMsg.Align = TA_Left;
  Cury = Cury + 20;

  CORRODED_DeathMsg = UWindowEditControl(CreateControl(class'UWindowEditControl', 10, Cury, 225, 1));
  CORRODED_DeathMsg.editboxwidth=170;
  CORRODED_DeathMsg.SetText("Corroded");
  CORRODED_DeathMsg.SetHelpText("");
  CORRODED_DeathMsg.SetValue(class'OverlaySettings'.default.Corroded_DM);
  CORRODED_DeathMsg.SetMaxLength (125);
  CORRODED_DeathMsg.Align = TA_Left;
  Cury = Cury + 20;

  MaleSuicide_DeathMsg = UWindowEditControl(CreateControl(class'UWindowEditControl', 10, Cury, 225, 1));
  MaleSuicide_DeathMsg.editboxwidth=170;
  MaleSuicide_DeathMsg.SetText("Suicide (M)");
  MaleSuicide_DeathMsg.SetHelpText("");
  MaleSuicide_DeathMsg.SetValue(class'OverlaySettings'.default.MaleSuicide_DM);
  MaleSuicide_DeathMsg.SetMaxLength (125);
  MaleSuicide_DeathMsg.Align = TA_Left;
  Cury = Cury + 20;

  FemaleSuicide_DeathMsg = UWindowEditControl(CreateControl(class'UWindowEditControl', 10, Cury, 225, 1));
  FemaleSuicide_DeathMsg.editboxwidth=170;
  FemaleSuicide_DeathMsg.SetText("Suicide (F)");
  FemaleSuicide_DeathMsg.SetHelpText("");
  FemaleSuicide_DeathMsg.SetValue(class'OverlaySettings'.default.FemaleSuicide_DM);
  FemaleSuicide_DeathMsg.SetMaxLength (125);
  FemaleSuicide_DeathMsg.Align = TA_Left;
  Cury = Cury + 20;

  ResetButton = UWindowSmallButton(CreateWindow(class'UWindowSmallButton',35.0 , CurY, 175.0, 18.0));
  ResetButton.SetText( "Reset all to defaults" );
  ResetButton.NotifyWindow = Self;
  Cury = Cury + 30;

  OBSCompatibility = UMenuLabelControl(CreateControl(Class'UMenuLabelControl', 0.0, CurY, 240.0, 1.0));
  OBSCompatibility.SetText ("OBS Compatibility");
  OBSCompatibility.Align = TA_Center;
  OBSCompatibility.SetFont (F_Bold);
  Cury = Cury + 20;

  OBSOffset = UWindowComboControl(CreateControl(class'UWindowComboControl', 10.0, CurY, 225.0, 50.0));
  OBSOffset.SetText ("Offset for game info on top");
  OBSOffset.SetHelpText ("");
  OBSOffset.SetFont (F_Normal);
  OBSOffset.AddItem ("None");
  OBSOffset.AddItem ("Small");
  OBSOffset.AddItem ("Medium");
  OBSOffset.AddItem ("Large");
  OBSOffset.SetSelectedIndex (class'OverlaySettings'.default.iOBSOffset);
  OBSOffset.EditBoxWidth = 60;
  OBSOffset.bCanEdit = false;
  Cury = Cury + 20;
}

function Notify(UWindowDialogControl C, byte E)
{
  Super.Notify( C, E );
  if ( E == DE_Change && class'OverlaySettings'.default.bMsgLengthKF == true)
  {
  SetCustomDeathMsg();
  }

  switch(E)
  {
    case DE_Click:
      switch(C)
      {
        case ResetButton:
          ResetCustomDeathMsg();
          SaveToConfig();
        break;
      }
    break;

    case DE_Change:
	  switch(C)
      {
        case IH_DeathMsg:
          C.NotifyWindow=self;
          class'OverlaySettings'.default.IH_DM=IH_DeathMsg.GetValue();
          SaveToConfig();
        break;
        case TL_DeathMsg:
          C.NotifyWindow=self;
          class'OverlaySettings'.default.trans_DM=TL_DeathMsg.GetValue();
          SaveToConfig();
        break;
        case ENF_DeathMsg:
          C.NotifyWindow=self;
          class'OverlaySettings'.default.enforcer_DM=ENF_DeathMsg.GetValue();
          SaveToConfig();
        break;
        case BIO_DeathMsg:
          C.NotifyWindow=self;
          class'OverlaySettings'.default.bio_DM=BIO_DeathMsg.GetValue();
          SaveToConfig();
        break;
        case SHOCK_DeathMsg:
          C.NotifyWindow=self;
          class'OverlaySettings'.default.shock_DM=SHOCK_DeathMsg.GetValue();
          SaveToConfig();
        break;
        case PULSE_DeathMsg:
          C.NotifyWindow=self;
          class'OverlaySettings'.default.pulse_DM=PULSE_DeathMsg.GetValue();
          SaveToConfig();
        break;
        case RIPPER_DeathMsg:
          C.NotifyWindow=self;
          class'OverlaySettings'.default.ripper_DM=RIPPER_DeathMsg.GetValue();
          SaveToConfig();
        break;
        case MINI_DeathMsg:
          C.NotifyWindow=self;
          class'OverlaySettings'.default.mini_DM=MINI_DeathMsg.GetValue();
          SaveToConfig();
        break;
        case FLAK_DeathMsg:
          C.NotifyWindow=self;
          class'OverlaySettings'.default.flak_DM=FLAK_DeathMsg.GetValue();
          SaveToConfig();
        break;
        case RL_DeathMsg:
          C.NotifyWindow=self;
          class'OverlaySettings'.default.RL_DM=RL_DeathMsg.GetValue();
          SaveToConfig();
        break;
        case SNIPER_DeathMsg:
          C.NotifyWindow=self;
          class'OverlaySettings'.default.sniper_DM=SNIPER_DeathMsg.GetValue();
          SaveToConfig();
        break;
        case IG_DeathMsg:
          C.NotifyWindow=self;
          class'OverlaySettings'.default.IG_DM=IG_DeathMsg.GetValue();
          SaveToConfig();
        break;
        case FALL_DeathMsg:
          C.NotifyWindow=self;
          class'OverlaySettings'.default.Fall_DM=FALL_DeathMsg.GetValue();
          SaveToConfig();
        break;
        case DROWNED_DeathMsg:
          C.NotifyWindow=self;
          class'OverlaySettings'.default.Drowned_DM=DROWNED_DeathMsg.GetValue();
          SaveToConfig();
          break;
        case BURNED_DeathMsg:
          C.NotifyWindow=self;
          class'OverlaySettings'.default.Burned_DM=BURNED_DeathMsg.GetValue();
          SaveToConfig();
        break;
        case CORRODED_DeathMsg:
          C.NotifyWindow=self;
          class'OverlaySettings'.default.Corroded_DM=CORRODED_DeathMsg.GetValue();
          SaveToConfig();
        break;
        case MaleSuicide_DeathMsg:
          C.NotifyWindow=self;
          class'OverlaySettings'.default.MaleSuicide_DM=MaleSuicide_DeathMsg.GetValue();
          SaveToConfig();
        break;
        case FemaleSuicide_DeathMsg:
          C.NotifyWindow=self;
          class'OverlaySettings'.default.FemaleSuicide_DM=FemaleSuicide_DeathMsg.GetValue();
          SaveToConfig();
        break;
        case OBSOffset:
          class'OverlaySettings'.default.iOBSOffset = OBSOffset.GetSelectedIndex ();
          SaveToConfig();
        break;
      }
  }
}

static final function SetCustomDeathMsg ()
{
  class'impacthammer'.default.DeathMessage = class'OverlaySettings'.default.IH_DM;
  class'translocator'.default.DeathMessage = class'OverlaySettings'.default.trans_DM;
  class'enforcer'.default.DeathMessage = class'OverlaySettings'.default.enforcer_DM;
  class'ut_biorifle'.default.DeathMessage = class'OverlaySettings'.default.bio_DM;
  class'shockrifle'.default.DeathMessage = class'OverlaySettings'.default.shock_DM;
  class'pulsegun'.default.DeathMessage = class'OverlaySettings'.default.pulse_DM;
  class'ripper'.default.DeathMessage = class'OverlaySettings'.default.ripper_DM;
  class'minigun2'.default.DeathMessage = class'OverlaySettings'.default.mini_DM;
  class'ut_flakcannon'.default.DeathMessage = class'OverlaySettings'.default.flak_DM;
  class'ut_eightball'.default.DeathMessage = class'OverlaySettings'.default.RL_DM;
  class'sniperrifle'.default.DeathMessage = class'OverlaySettings'.default.sniper_DM;
  class'SuperShockRifle'.default.DeathMessage = class'OverlaySettings'.default.IG_DM;
  class'TournamentGameInfo'.default.FallMessage= class'OverlaySettings'.default.Fall_DM;
  class'TournamentGameInfo'.default.DrownedMessage= class'OverlaySettings'.default.Drowned_DM;
  class'TournamentGameInfo'.default.BurnedMessage= class'OverlaySettings'.default.Burned_DM;
  class'TournamentGameInfo'.default.CorrodedMessage= class'OverlaySettings'.default.Corroded_DM;
  class'TournamentGameInfo'.default.MaleSuicideMessage= class'OverlaySettings'.default.MaleSuicide_DM;
  class'TournamentGameInfo'.default.FemaleSuicideMessage= class'OverlaySettings'.default.FemaleSuicide_DM;
}

function ResetCustomDeathMsg()
{
  class'OverlaySettings'.default.IH_DM=IH_DeathMsg_Default;
  IH_DeathMsg.SetValue(IH_DeathMsg_Default);
  class'OverlaySettings'.default.trans_DM=TL_DeathMsg_Default;
  TL_DeathMsg.SetValue(TL_DeathMsg_Default);
  class'OverlaySettings'.default.enforcer_DM=ENF_DeathMsg_Default;
  ENF_DeathMsg.SetValue(ENF_DeathMsg_Default);
  class'OverlaySettings'.default.bio_DM=BIO_DeathMsg_Default;
  BIO_DeathMsg.SetValue(BIO_DeathMsg_Default);
  class'OverlaySettings'.default.shock_DM=SHOCK_DeathMsg_Default;
  SHOCK_DeathMsg.SetValue(SHOCK_DeathMsg_Default);
  class'OverlaySettings'.default.pulse_DM=PULSE_DeathMsg_Default;
  PULSE_DeathMsg.SetValue(PULSE_DeathMsg_Default);
  class'OverlaySettings'.default.ripper_DM=RIPPER_DeathMsg_Default;
  RIPPER_DeathMsg.SetValue(RIPPER_DeathMsg_Default);
  class'OverlaySettings'.default.mini_DM=MINI_DeathMsg_Default;
  MINI_DeathMsg.SetValue(MINI_DeathMsg_Default);
  class'OverlaySettings'.default.flak_DM=FLAK_DeathMsg_Default;
  FLAK_DeathMsg.SetValue(FLAK_DeathMsg_Default);
  class'OverlaySettings'.default.RL_DM=RL_DeathMsg_Default;
  RL_DeathMsg.SetValue(RL_DeathMsg_Default);
  class'OverlaySettings'.default.sniper_DM=SNIPER_DeathMsg_Default;
  SNIPER_DeathMsg.SetValue(SNIPER_DeathMsg_Default);
  class'OverlaySettings'.default.Fall_DM=FALL_DeathMsg_Default;
  FALL_DeathMsg.SetValue(FALL_DeathMsg_Default);
  IG_DeathMsg.SetValue(IG_DeathMsg_Default);
  class'OverlaySettings'.default.IG_DM=IG_DeathMsg_Default;
  class'OverlaySettings'.default.Drowned_DM=DROWNED_DeathMsg_Default;
  DROWNED_DeathMsg.SetValue(DROWNED_DeathMsg_Default);
  class'OverlaySettings'.default.Burned_DM=BURNED_DeathMsg_Default;
  BURNED_DeathMsg.SetValue(BURNED_DeathMsg_Default);
  class'OverlaySettings'.default.Corroded_DM=CORRODED_DeathMsg_Default;
  CORRODED_DeathMsg.SetValue(CORRODED_DeathMsg_Default);
  class'OverlaySettings'.default.MaleSuicide_DM=MaleSuicide_DeathMsg_Default;
  MaleSuicide_DeathMsg.SetValue(MaleSuicide_DeathMsg_Default);
  class'OverlaySettings'.default.FemaleSuicide_DM=FemaleSuicide_DeathMsg_Default;
  FemaleSuicide_DeathMsg.SetValue(FemaleSuicide_DeathMsg_Default);
  SaveToConfig();
}

static final function ResetToDefaultDeathMsg()
{
  class'impacthammer'.default.DeathMessage = "%o got smeared by %k's piston.";
  class'translocator'.default.DeathMessage = "%k telefragged %o!";
  class'enforcer'.default.DeathMessage = "%k riddled %o full of holes with the %w.";
  class'ut_biorifle'.default.DeathMessage = "%o drank a glass of %k's dripping green load.";
  class'shockrifle'.default.DeathMessage = "%k inflicted mortal damage upon %o with the %w.";
  class'pulsegun'.default.DeathMessage = "%o ate %k's burning plasma death.";
  class'ripper'.default.DeathMessage = "%k ripped a chunk of meat out of %o with the %w.";
  class'minigun2'.default.DeathMessage = "%k's %w turned %o into a leaky piece of meat.";
  class'ut_flakcannon'.default.DeathMessage = "%o was ripped to shreds by %k's %w.";
  class'ut_eightball'.default.DeathMessage = "%o was smacked down by %k's %w.";
  class'sniperrifle'.default.DeathMessage = "%k put a bullet through %o's head.";
  class'SuperShockRifle'.default.DeathMessage = "%k electrified %o with the %w.";
  class'TournamentGameInfo'.default.FallMessage=" left a small crater.";
  class'TournamentGameInfo'.default.DrownedMessage=" forgot to come up for air.";
  class'TournamentGameInfo'.default.BurnedMessage=" was incinerated.";
  class'TournamentGameInfo'.default.CorrodedMessage=" was slimed.";
  class'TournamentGameInfo'.default.MaleSuicideMessage=" killed his own dumb self.";
  class'TournamentGameInfo'.default.FemaleSuicideMessage=" killed her own dumb self.";
}

defaultproperties
{
	IH_DeathMsg_Default="%k  >  I H  >  %o"
	TL_DeathMsg_Default="%k  >  T L  >  %o"
	ENF_DeathMsg_Default="%k  >  E N F  >  %o"
	BIO_DeathMsg_Default="%k  >  B I O  >  %o"
	SHOCK_DeathMsg_Default="%k  >  S H O C K  >  %o"
	PULSE_DeathMsg_Default="%k  >  P U L S E  >  %o"
	RIPPER_DeathMsg_Default="%k  >  R I P P E R  >  %o"
	MINI_DeathMsg_Default="%k  >  M I N I  >  %o"
	FLAK_DeathMsg_Default="%k  >  F L A K  >  %o"
	RL_DeathMsg_Default="%k  >  R L  >  %o"
	SNIPER_DeathMsg_Default="%k  >  S N I P E R  >  %o"
	IG_DeathMsg_Default="%k  > >  >  %o"
	FALL_DeathMsg_Default="  >  F A L L"
	DROWNED_DeathMsg_Default="  >  D R O W N E D"
	BURNED_DeathMsg_Default="  >  B U R N E D"
	CORRODED_DeathMsg_Default="  >  S L I M E D"
	MaleSuicide_DeathMsg_Default="  >  S E L F"
	FemaleSuicide_DeathMsg_Default="  >  S E L F"
}
