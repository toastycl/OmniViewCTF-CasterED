class OverlayConfigContent expands UWindowDialogClientWindow;

var UMenuLabelControl Settings;
var UMenuLabelControl GeneralOptions;
var UMenuLabelControl BehaviourOptions;
var UMenuLabelControl ScoreBoard;
var UMenuLabelControl OverlayControl;
var UMenuLabelControl OverlayStatus;
var UMenuLabelControl HotKeyBind;
var UMenuLabelControl HotKeyMenu;
var UMenuLabelControl CompareKeyBind;
var UMenuLabelControl CompareKeyMenu;
var UMenuLabelControl MVPKeyBind;
var UMenuLabelControl MVPKeyMenu;
var UMenuLabelControl PlayerCamKeyBind;
var UMenuLabelControl PlayerCamKeyMenu;
var UMenuLabelControl ViewToggleKeyBind;
var UMenuLabelControl ViewToggleKeyMenu;
var UMenuLabelControl Line;

var UWindowCheckbox ItemTimer;
var UWindowCheckbox HealthArmor;
var UWindowCheckbox FC_Info;
var UWindowCheckbox ScoreBoardState;
var UWindowCheckbox ShowAccuracy;
var UWindowCheckbox HighContrastMode;
var UWindowCheckbox MsgLengthKF;
var UWindowCheckbox PlayerNumbers;
var UWindowCheckbox EasySwitch;
var UWindowCheckbox AutoAdjustCam;
var UWindowCheckbox AutoViewFC;

var UWindowComboControl FlagEffects;
var UWindowComboControl FontSizeChat;
var UWindowComboControl FontSizeKF;
var UWindowComboControl AmpEffects;
var UWindowComboControl AutoAdjustCamDelay;

var UMenuRaisedButton HotKeyButton;
var UMenuRaisedButton CompareKeyButton;
var UMenuRaisedButton MVPKeyButton;
var UMenuRaisedButton PlayerCamKeyButton;
var UMenuRaisedButton ViewToggleKeyButton;
var UWindowSmallButton OverlayButton;
var UWindowSmallCloseButton CancelButton;

var bool bMenu;
var bool bCompareKey;
var bool bMVPKey;
var bool bPlayerCamKey;
var bool bViewToggleKey;

var string RealKeyName[255];
var string OldMenuKey;
var string OldCompareKey;
var string OldMVPKey;
var string OldPlayerCamKey;
var string OldViewToggleKey;

var overlayhud OHUD;

function Created()
{
  local int CurY;
  local uwindowwindow child;
  Cury = 20;

  Super.Created();
  SetAcceptsFocus();

  Settings = UMenuLabelControl(CreateControl(Class'UMenuLabelControl', 0.0, 5.0, 240.0, 1.0));
  Settings.SetText ("Basic Settings");
  Settings.Align = TA_Center;
  Settings.SetFont (F_Bold);

  GeneralOptions = UMenuLabelControl(CreateControl(Class'UMenuLabelControl',10.0, CurY, 225.0, 1.0));
  GeneralOptions.SetText ("Appearance");
  GeneralOptions.SetFont (F_Bold);
  Cury = Cury + 20;

  // item timer on/off //
  ItemTimer = UWindowCheckbox(CreateControl(class'UWindowCheckbox', 10.0, CurY, 225.0, 1.0));
  ItemTimer.SetText("Show item timer");
  ItemTimer.SetHelpText("");
  ItemTimer.SetFont (F_Normal);
  ItemTimer.bChecked = class'OverlaySettings'.default.bShowItemTimer;
  ItemTimer.bDisabled = true;
  Cury = Cury + 20;

  // HP and armor on/off //
  HealthArmor = UWindowCheckbox(CreateControl(class'UWindowCheckbox', 10.0, CurY, 225.0, 1.0));
  HealthArmor.SetText("Show health and armor");
  HealthArmor.SetHelpText("");
  HealthArmor.SetFont (F_Normal);
  HealthArmor.bChecked = class'OverlaySettings'.default.bShowHealthArmor;
  HealthArmor.bDisabled = true;
  Cury = Cury + 20;

  // FC name on/off //
  FC_Info = UWindowCheckbox(CreateControl(class'UWindowCheckbox', 10.0, CurY, 225.0, 1.0));
  FC_Info.SetText("Show FC name on top");
  FC_Info.SetHelpText("");
  FC_Info.SetFont (F_Normal);
  FC_Info.bChecked = class'OverlaySettings'.default.bFC_Info;
  FC_Info.bDisabled = true;
  Cury = Cury + 20;

  // effects for stolen flag //
  FlagEffects = UWindowComboControl(CreateControl(class'UWindowComboControl', 10.0, CurY, 225.0, 50.0));
  FlagEffects.SetText ("Effects for stolen flags");
  FlagEffects.SetHelpText ("");
  FlagEffects.SetFont (F_Normal);
  FlagEffects.AddItem ("Off");
  FlagEffects.AddItem ("Static");
  FlagEffects.AddItem ("Dynamic");
  FlagEffects.SetSelectedIndex (class'OverlaySettings'.default.iFlagEffects);
  FlagEffects.EditBoxWidth = 60;
  FlagEffects.bCanEdit = false;
  Cury = Cury + 20;

  // font size for chat //
  FontSizeChat = UWindowComboControl(CreateControl(class'UWindowComboControl', 10.0, CurY, 225.0, 50.0));
  FontSizeChat.SetText ("Font size for chat");
  FontSizeChat.SetHelpText ("");
  FontSizeChat.SetFont (F_Normal);
  FontSizeChat.AddItem ("Small");
  FontSizeChat.AddItem ("Medium");
  FontSizeChat.AddItem ("Large");
  FontSizeChat.SetSelectedIndex (class'OverlaySettings'.default.iFontSizeChat);
  FontSizeChat.EditBoxWidth = 60;
  FontSizeChat.bCanEdit = false;
  Cury = Cury + 20;

  // font size for kill feed //
  FontSizeKF = UWindowComboControl(CreateControl(class'UWindowComboControl', 10.0, CurY, 225.0, 50.0));
  FontSizeKF.SetText ("Font size for kill feed");
  FontSizeKF.SetHelpText ("");
  FontSizeKF.SetFont (F_Normal);
  FontSizeKF.AddItem ("Small");
  FontSizeKF.AddItem ("Medium");
  FontSizeKF.AddItem ("Large");
  FontSizeKF.SetSelectedIndex (class'OverlaySettings'.default.iFontSizeKF);
  FontSizeKF.EditBoxWidth = 60;
  FontSizeKF.bCanEdit = false;
  Cury = Cury + 20;

  // custom messages for kill feed //
  MsgLengthKF = UWindowCheckbox(CreateControl(class'UWindowCheckbox', 10.0, CurY, 225.0, 1.0));
  MsgLengthKF.SetText("Custom messages for kill feed");
  MsgLengthKF.SetHelpText("");
  MsgLengthKF.SetFont (F_Normal);
  MsgLengthKF.bChecked = class'OverlaySettings'.default.bMsgLengthKF;
  MsgLengthKF.bDisabled = true;
  Cury = Cury + 30;

  //// options for behaviour ////
  BehaviourOptions = UMenuLabelControl(CreateControl(Class'UMenuLabelControl',10.0, CurY, 225.0, 1.0));
  BehaviourOptions.SetText ("Behaviour");
  BehaviourOptions.SetFont (F_Bold);
  Cury = Cury + 20;

  // easy switching from free cam to player view //
  EasySwitch = UWindowCheckbox(CreateControl(class'UWindowCheckbox', 10.0, CurY, 225.0, 1.0));
  EasySwitch.SetText("Easy switch to player from free cam");
  EasySwitch.SetHelpText("");
  EasySwitch.SetFont (F_Normal);
  EasySwitch.bChecked = class'OverlaySettings'.default.bEasySwitch;
  EasySwitch.bDisabled = true;
  Cury = Cury + 20;

  // auto turn cam in 3rd person view //
  AutoAdjustCam = UWindowCheckbox(CreateControl(class'UWindowCheckbox', 10.0, CurY, 225.0, 1.0));
  AutoAdjustCam.SetText("Auto turn 3rd person cam");
  AutoAdjustCam.SetHelpText("");
  AutoAdjustCam.SetFont (F_Normal);
  AutoAdjustCam.bChecked = class'OverlaySettings'.default.bAutoAdjustCam;
  AutoAdjustCam.bDisabled = true;
  Cury = Cury + 20;

  // delay for auto view //
  AutoAdjustCamDelay = UWindowComboControl(CreateControl(class'UWindowComboControl', 10.0, CurY, 225.0, 50.0));
  AutoAdjustCamDelay.SetText ("Delay for auto turn 3rd person cam");
  AutoAdjustCamDelay.SetHelpText ("");
  AutoAdjustCamDelay.SetFont (F_Normal);
  AutoAdjustCamDelay.AddItem ("1s");
  AutoAdjustCamDelay.AddItem ("3s");
  AutoAdjustCamDelay.AddItem ("5s");
  AutoAdjustCamDelay.SetSelectedIndex (class'OverlaySettings'.default.iAutoAdjustCamDelay);
  AutoAdjustCamDelay.EditBoxWidth = 30;
  AutoAdjustCamDelay.bCanEdit = false;
  Cury = Cury + 20;

  // auto switch view to FC //
  AutoViewFC = UWindowCheckbox(CreateControl(class'UWindowCheckbox', 10.0, CurY, 225.0, 1.0));
  AutoViewFC.SetText("Auto switch view to FC");
  AutoViewFC.SetHelpText("");
  AutoViewFC.SetFont (F_Normal);
  AutoViewFC.bChecked = class'OverlaySettings'.default.bAutoViewFC;
  AutoViewFC.bDisabled = true;
  Cury = Cury + 20;

  // hotkey //
  HotKeyMenu = UMenuLabelControl(CreateControl(class'UMenuLabelControl', 10.0, CurY + 2, 180.0, 1.0));
  HotKeyMenu.SetText("In-game menu key");
  HotKeyMenu.SetHelpText("");
  HotKeyMenu.SetFont(F_Normal);

  HotKeyButton = UMenuRaisedButton(CreateControl(class'UMenuRaisedButton', 140.0, CurY - 2, 80.0, 1.0));
  HotKeyButton.SetHelpText("");
  HotKeyButton.Align = TA_Center;
  HotKeyButton.bDisabled = false;
  HotKeyButton.bAcceptsFocus = false;
  HotKeyButton.bIgnoreLDoubleClick = true;
  HotKeyButton.bIgnoreMDoubleClick = true;
  HotKeyButton.bIgnoreRDoubleClick = true;
  HotKeyButton.NotifyWindow = Self;

  HotKeyBind = UMenuLabelControl(CreateControl(class'UMenuLabelControl', 180.0, CurY + 2, 50.0 + 5.0, 1.0));
  HotKeyBind.SetText("");
  HotKeyBind.SetFont(1);
  Cury = Cury + 24;

  // Unreal Arena player compare hotkey //
  CompareKeyMenu = UMenuLabelControl(CreateControl(class'UMenuLabelControl', 10.0, CurY + 2, 180.0, 1.0));
  CompareKeyMenu.SetText("Player Compare key");
  CompareKeyMenu.SetHelpText("Open/close Player Compare. Player A is the current spectator target.");
  CompareKeyMenu.SetFont(F_Normal);

  CompareKeyButton = UMenuRaisedButton(CreateControl(class'UMenuRaisedButton', 140.0, CurY - 2, 80.0, 1.0));
  CompareKeyButton.SetHelpText("Press, then choose a key.");
  CompareKeyButton.Align = TA_Center;
  CompareKeyButton.bDisabled = false;
  CompareKeyButton.bAcceptsFocus = false;
  CompareKeyButton.bIgnoreLDoubleClick = true;
  CompareKeyButton.bIgnoreMDoubleClick = true;
  CompareKeyButton.bIgnoreRDoubleClick = true;
  CompareKeyButton.NotifyWindow = Self;

  CompareKeyBind = UMenuLabelControl(CreateControl(class'UMenuLabelControl', 180.0, CurY + 2, 50.0 + 5.0, 1.0));
  CompareKeyBind.SetText("");
  CompareKeyBind.SetFont(1);
  Cury = Cury + 24;

  // MVP Focus hotkey //
  MVPKeyMenu = UMenuLabelControl(CreateControl(class'UMenuLabelControl', 10.0, CurY + 2, 180.0, 1.0));
  MVPKeyMenu.SetText("MVP Focus key");
  MVPKeyMenu.SetHelpText("Open/close the detailed MVP breakdown panel.");
  MVPKeyMenu.SetFont(F_Normal);

  MVPKeyButton = UMenuRaisedButton(CreateControl(class'UMenuRaisedButton', 140.0, CurY - 2, 80.0, 1.0));
  MVPKeyButton.SetHelpText("Press, then choose a key.");
  MVPKeyButton.Align = TA_Center;
  MVPKeyButton.bDisabled = false;
  MVPKeyButton.bAcceptsFocus = false;
  MVPKeyButton.bIgnoreLDoubleClick = true;
  MVPKeyButton.bIgnoreMDoubleClick = true;
  MVPKeyButton.bIgnoreRDoubleClick = true;
  MVPKeyButton.NotifyWindow = Self;

  MVPKeyBind = UMenuLabelControl(CreateControl(class'UMenuLabelControl', 180.0, CurY + 2, 55.0, 1.0));
  MVPKeyBind.SetText("");
  MVPKeyBind.SetFont(1);
  Cury = Cury + 24;

  // Unreal Arena experimental first-person Player Cam hotkey //
  PlayerCamKeyMenu = UMenuLabelControl(CreateControl(class'UMenuLabelControl', 10.0, CurY + 2, 180.0, 1.0));
  PlayerCamKeyMenu.SetText("Player Cam key");
  PlayerCamKeyMenu.SetHelpText("Experimental: lock a first-person secondary camera to the current spectator target.");
  PlayerCamKeyMenu.SetFont(F_Normal);

  PlayerCamKeyButton = UMenuRaisedButton(CreateControl(class'UMenuRaisedButton', 140.0, CurY - 2, 80.0, 1.0));
  PlayerCamKeyButton.SetHelpText("Press, then choose a key.");
  PlayerCamKeyButton.Align = TA_Center;
  PlayerCamKeyButton.bDisabled = false;
  PlayerCamKeyButton.bAcceptsFocus = false;
  PlayerCamKeyButton.bIgnoreLDoubleClick = true;
  PlayerCamKeyButton.bIgnoreMDoubleClick = true;
  PlayerCamKeyButton.bIgnoreRDoubleClick = true;
  PlayerCamKeyButton.NotifyWindow = Self;

  PlayerCamKeyBind = UMenuLabelControl(CreateControl(class'UMenuLabelControl', 180.0, CurY + 2, 55.0, 1.0));
  PlayerCamKeyBind.SetText("");
  PlayerCamKeyBind.SetFont(1);
  Cury = Cury + 24;

  ViewToggleKeyMenu = UMenuLabelControl(CreateControl(class'UMenuLabelControl', 10.0, CurY + 2, 180.0, 1.0));
  ViewToggleKeyMenu.SetText("View toggle key");
  ViewToggleKeyMenu.SetHelpText("Toggle the main spectator view between BehindView 0 and BehindView 1.");
  ViewToggleKeyMenu.SetFont(F_Normal);

  ViewToggleKeyButton = UMenuRaisedButton(CreateControl(class'UMenuRaisedButton', 140.0, CurY - 2, 80.0, 1.0));
  ViewToggleKeyButton.SetHelpText("Press, then choose a key.");
  ViewToggleKeyButton.Align = TA_Center;
  ViewToggleKeyButton.bDisabled = false;
  ViewToggleKeyButton.bAcceptsFocus = false;
  ViewToggleKeyButton.bIgnoreLDoubleClick = true;
  ViewToggleKeyButton.bIgnoreMDoubleClick = true;
  ViewToggleKeyButton.bIgnoreRDoubleClick = true;
  ViewToggleKeyButton.NotifyWindow = Self;

  ViewToggleKeyBind = UMenuLabelControl(CreateControl(class'UMenuLabelControl', 180.0, CurY + 2, 55.0, 1.0));
  ViewToggleKeyBind.SetText("");
  ViewToggleKeyBind.SetFont(1);
  Cury = Cury + 30;

  //// options for on screen score board ////
  ScoreBoard = UMenuLabelControl(CreateControl(Class'UMenuLabelControl',10.0, CurY, 225.0, 1.0));
  ScoreBoard.SetText ("On-screen Score Board");
  ScoreBoard.SetFont (F_Bold);
  Cury = Cury + 20;

  // score board on/off //
  ScoreBoardState = UWindowCheckbox(CreateControl(class'UWindowCheckbox', 10.0, CurY, 225.0, 1.0));
  ScoreBoardState.SetText("Enable on-screen score board");
  ScoreBoardState.SetHelpText("");
  ScoreBoardState.SetFont (F_Normal);
  ScoreBoardState.bChecked = class'OverlaySettings'.default.bScoreBoardState;
  ScoreBoardState.bDisabled = true;
  Cury = Cury + 20;

  // display accuracy on/off //
  ShowAccuracy = UWindowCheckbox(CreateControl(class'UWindowCheckbox', 10.0, CurY, 225.0, 1.0));
  ShowAccuracy.SetText("Show accuracy info");
  ShowAccuracy.SetHelpText("");
  ShowAccuracy.SetFont (F_Normal);
  ShowAccuracy.bChecked = class'OverlaySettings'.default.bShowAccuracy;
  ShowAccuracy.bDisabled = true;
  Cury = Cury + 20;

  // effects for player with amp //
  AmpEffects = UWindowComboControl(CreateControl(class'UWindowComboControl', 10.0, CurY, 225.0, 50.0));
  AmpEffects.SetText ("Effects for players with amp");
  AmpEffects.SetHelpText ("");
  AmpEffects.SetFont (F_Normal);
  AmpEffects.AddItem ("Off");
  AmpEffects.AddItem ("Min");
  AmpEffects.AddItem ("Max");
  AmpEffects.SetSelectedIndex (class'OverlaySettings'.default.iAmpEffects);
  AmpEffects.EditBoxWidth = 40;
  AmpEffects.bCanEdit = false;
  Cury = Cury + 20;

  // high contrast mode on/off //
  HighContrastMode = UWindowCheckbox(CreateControl(class'UWindowCheckbox', 10.0, CurY, 225.0, 1.0));
  HighContrastMode.SetText("Enable high contrast mode");
  HighContrastMode.SetHelpText("");
  HighContrastMode.SetFont (F_Normal);
  HighContrastMode.bChecked = class'OverlaySettings'.default.bHighContrastMode;
  HighContrastMode.bDisabled = true;
  Cury = Cury + 20;

  // show player # on/off //
  PlayerNumbers = UWindowCheckbox(CreateControl(class'UWindowCheckbox', 10.0, CurY, 225.0, 1.0));
  PlayerNumbers.SetText("Show player numbers");
  PlayerNumbers.SetHelpText("");
  PlayerNumbers.SetFont (F_Normal);
  PlayerNumbers.bChecked = class'OverlaySettings'.default.bPlayerNumbers;
  PlayerNumbers.bDisabled = true;
  Cury = Cury + 16;

  Line = UMenuLabelControl(CreateControl(Class'UMenuLabelControl', 10.0, Cury, 225.0, 1.0));
  Line.SetText ("____________________________________________");
  Line.Align = TA_Center;
  Line.SetFont (F_Normal);
  Cury = Cury + 20;

  // overlay control //
  OverlayControl = UMenuLabelControl(CreateControl(Class'UMenuLabelControl',0.0, CurY, 240.0, 1.0));
  OverlayControl.SetText ("Overlay Control");
  OverlayControl.Align = TA_Center;
  OverlayControl.SetFont (F_Bold);
  Cury = Cury + 20;

  // button //
  OverlayButton = UWindowSmallButton(CreateWindow(class'UWindowSmallButton',35.0 , CurY, 175.0, 18.0));
  OverlayButton.SetText( "..." );
  OverlayButton.SetFont (F_Normal);
  OverlayButton.NotifyWindow = Self;
  Cury = Cury + 20;

  // status info //
  OverlayStatus = UMenuLabelControl(CreateControl(Class'UMenuLabelControl',10.0, CurY, 225.0, 1.0));
  OverlayStatus.SetText ("Status:");
  OverlayStatus.Align = TA_Center;
  OverlayStatus.SetFont (F_Normal);
  Cury = Cury + 20;

  for(Child = LastChildWindow;Child != None; Child = Child.PrevSiblingWindow)
  Child.bAcceptsFocus=False;

  SetAcceptsFocus();
  LoadExistingKeys();

  // Content dimensions used by UWindowScrollingDialogClient.  Keep the
  // full options page at its natural height and let the parent provide
  // a vertical scrollbar whenever the visible tab is shorter.
  DesiredWidth = 225;
  DesiredHeight = CurY + 16;
}


function LoadExistingKeys()
{
  local int i;
  local string KeyName, Alias;

  i = 0;

  for (i = 0; i < 255; i++)
  {
    KeyName = GetPlayerOwner().ConsoleCommand("KEYNAME " $ string(i));
    RealKeyName[i] = KeyName;

    if(KeyName != "")
    {
      Alias = GetPlayerOwner().ConsoleCommand("KEYBINDING " $ KeyName);

      if(Contains(Alias,"|showovo") )
      {
        HotKeyButton.SetText(KeyName);
        OldMenuKey = KeyName;
      }

      if(Contains(Alias,"|uacompare") )
      {
        CompareKeyButton.SetText(KeyName);
        OldCompareKey = KeyName;
      }

      if(Contains(Alias,"|uamvpfocus") )
      {
        MVPKeyButton.SetText(KeyName);
        OldMVPKey = KeyName;
      }

      if(Contains(Alias,"|uaplayercam") )
      {
        PlayerCamKeyButton.SetText(KeyName);
        OldPlayerCamKey = KeyName;
      }

      if(Contains(Alias,"|uatoggleview") )
      {
        ViewToggleKeyButton.SetText(KeyName);
        OldViewToggleKey = KeyName;
      }
    }
  }
  return;
}

function DisplayInfo()
{
  if(!HotKeyButton.bDisabled)
    HotKeyBind.SetText("...");
  if(!CompareKeyButton.bDisabled)
    CompareKeyBind.SetText("...");
  if(!MVPKeyButton.bDisabled)
    MVPKeyBind.SetText("...");
  if(!PlayerCamKeyButton.bDisabled)
    PlayerCamKeyBind.SetText("...");
  if(!ViewToggleKeyButton.bDisabled)
    ViewToggleKeyBind.SetText("...");
  return;
}

function KeyDown(int Key, float X, float Y)
{
  ProcessKey(Key, RealKeyName[Key]);
  bMenu = false;
  bCompareKey = false;
  bMVPKey = false;
  bPlayerCamKey = false;
  bViewToggleKey = false;
  HotKeyButton.bDisabled = false;
  CompareKeyButton.bDisabled = false;
  MVPKeyButton.bDisabled = false;
  PlayerCamKeyButton.bDisabled = false;
  ViewToggleKeyButton.bDisabled = false;
  HotKeyBind.SetText("");
  CompareKeyBind.SetText("");
  MVPKeyBind.SetText("");
  PlayerCamKeyBind.SetText("");
  ViewToggleKeyBind.SetText("");
}

function ProcessKey(int KeyNo, string KeyName)
{
  if ( (KeyName == "") || (KeyName == "Escape")
  || ((KeyNo >= 0x70 ) && (KeyNo <= 0x79)) // function keys
  || ((KeyNo >= 0x30 ) && (KeyNo <= 0x39))) // number keys
  {
  return;
  }

  if(bMenu)
  {
    SetMenuKey(KeyNo, KeyName);
    return;
  }
  if(bCompareKey)
  {
    SetCompareKey(KeyNo, KeyName);
    return;
  }
  if(bMVPKey)
  {
    SetMVPKey(KeyNo, KeyName);
    return;
  }
  if(bPlayerCamKey)
  {
    SetPlayerCamKey(KeyNo, KeyName);
    return;
  }
  if(bViewToggleKey)
  {
    SetViewToggleKey(KeyNo, KeyName);
    return;
  }
  return;
}

function SetMenuKey(int KeyNo, string KeyName)
{
  local int i;
  local string TempBind;

  TempBind = GetPlayerOwner().ConsoleCommand("KEYBINDING " $ KeyName);
  TempBind = StrReplace(TempBind,"|showovo","");
  GetPlayerOwner().ConsoleCommand("SET Input " $ KeyName @ TempBind $"|showovo"); // append to existing keybinds
  HotKeyButton.SetText(KeyName);

  for (i = 0; i < 255; i++)
  {
    KeyName = RealKeyName[i];

    if (i == KeyNo) // skip current key
    continue;

    TempBind = GetPlayerOwner().ConsoleCommand("KEYBINDING " $ KeyName);

    if (Contains(TempBind,"|SHOWOVO"))
    {
      TempBind = StrReplace(TempBind,"|showovo","");
      GetPlayerOwner().ConsoleCommand("SET Input "$KeyName@TempBind); // remove |showovo from existing keybind
    }

    if ( Caps(TempBind) == "SHOWOVO"  )
    GetPlayerOwner().ConsoleCommand("SET Input "$KeyName);
  }
  return;
}

function SetCompareKey(int KeyNo, string KeyName)
{
  local int i;
  local string TempBind, ScanKey;

  TempBind = GetPlayerOwner().ConsoleCommand("KEYBINDING " $ KeyName);
  TempBind = StrReplace(TempBind,"|uacompare","");
  GetPlayerOwner().ConsoleCommand("SET Input " $ KeyName @ TempBind $ "|uacompare");
  CompareKeyButton.SetText(KeyName);

  for (i = 0; i < 255; i++)
  {
    ScanKey = RealKeyName[i];
    if (i == KeyNo || ScanKey == "")
      continue;

    TempBind = GetPlayerOwner().ConsoleCommand("KEYBINDING " $ ScanKey);
    if (Contains(TempBind,"|UACOMPARE"))
    {
      TempBind = StrReplace(TempBind,"|uacompare","");
      GetPlayerOwner().ConsoleCommand("SET Input " $ ScanKey @ TempBind);
    }
    if (Caps(TempBind) == "UACOMPARE")
      GetPlayerOwner().ConsoleCommand("SET Input " $ ScanKey);
  }
}

function SetMVPKey(int KeyNo, string KeyName)
{
  local int i;
  local string TempBind, ScanKey;

  TempBind = GetPlayerOwner().ConsoleCommand("KEYBINDING " $ KeyName);
  TempBind = StrReplace(TempBind,"|uamvpfocus","");
  GetPlayerOwner().ConsoleCommand("SET Input " $ KeyName @ TempBind $ "|uamvpfocus");
  MVPKeyButton.SetText(KeyName);

  for (i = 0; i < 255; i++)
  {
    ScanKey = RealKeyName[i];
    if (i == KeyNo || ScanKey == "")
      continue;

    TempBind = GetPlayerOwner().ConsoleCommand("KEYBINDING " $ ScanKey);
    if (Contains(TempBind,"|UAMVPFOCUS"))
    {
      TempBind = StrReplace(TempBind,"|uamvpfocus","");
      GetPlayerOwner().ConsoleCommand("SET Input " $ ScanKey @ TempBind);
    }
    if (Caps(TempBind) == "UAMVPFOCUS")
      GetPlayerOwner().ConsoleCommand("SET Input " $ ScanKey);
  }
}

function SetPlayerCamKey(int KeyNo, string KeyName)
{
  local int i;
  local string TempBind, ScanKey;

  TempBind = GetPlayerOwner().ConsoleCommand("KEYBINDING " $ KeyName);
  TempBind = StrReplace(TempBind,"|uaplayercam","");
  GetPlayerOwner().ConsoleCommand("SET Input " $ KeyName @ TempBind $ "|uaplayercam");
  PlayerCamKeyButton.SetText(KeyName);

  for (i = 0; i < 255; i++)
  {
    ScanKey = RealKeyName[i];
    if (i == KeyNo || ScanKey == "")
      continue;

    TempBind = GetPlayerOwner().ConsoleCommand("KEYBINDING " $ ScanKey);
    if (Contains(TempBind,"|UAPLAYERCAM"))
    {
      TempBind = StrReplace(TempBind,"|uaplayercam","");
      GetPlayerOwner().ConsoleCommand("SET Input " $ ScanKey @ TempBind);
    }
    if (Caps(TempBind) == "UAPLAYERCAM")
      GetPlayerOwner().ConsoleCommand("SET Input " $ ScanKey);
  }
}

function SetViewToggleKey(int KeyNo, string KeyName)
{
  local int i;
  local string TempBind, ScanKey;

  TempBind = GetPlayerOwner().ConsoleCommand("KEYBINDING " $ KeyName);
  TempBind = StrReplace(TempBind,"|uatoggleview","");
  GetPlayerOwner().ConsoleCommand("SET Input " $ KeyName @ TempBind $ "|uatoggleview");
  ViewToggleKeyButton.SetText(KeyName);

  for (i = 0; i < 255; i++)
  {
    ScanKey = RealKeyName[i];
    if (i == KeyNo || ScanKey == "")
      continue;

    TempBind = GetPlayerOwner().ConsoleCommand("KEYBINDING " $ ScanKey);
    if (Contains(TempBind,"|UATOGGLEVIEW"))
    {
      TempBind = StrReplace(TempBind,"|uatoggleview","");
      GetPlayerOwner().ConsoleCommand("SET Input " $ ScanKey @ TempBind);
    }
    if (Caps(TempBind) == "UATOGGLEVIEW")
      GetPlayerOwner().ConsoleCommand("SET Input " $ ScanKey);
  }
}

function bool Contains(string str, string check)
{
  if (InStr(Caps(str), Caps(check)) > -1)
  return true;
  else
  return false;
}

final function string StrReplace(string str, string replace, string with)
{
  local int i;
  local string Input;

  Input = str;
  str = "";
  i = InStr(Input, Replace);

  while(i != -1)
  {
    str = str$Left(Input, i) $ With;
    Input = Mid(Input, i + Len(Replace));
	i = InStr(Input, Replace);
  }
  return str$Input;
}

function advSetCustomDeathMsg()
{
  class'OverlayAdvConfig'.static.SetCustomDeathMsg();
}

function advResetToDefaultDeathMsg()
{
  class'OverlayAdvConfig'.static.ResetToDefaultDeathMsg();
}

function loadHUD()
{
  local playerpawn pp;
  pp = root.getplayerowner();

  if (OHUD == none)
  {
    if (pp.myHUD != none)
    pp.myHUD.Destroy();
    pp.myhud = pp.Level.Spawn(class'OverlayHUD', pp);

    if ( class'OverlaySettings'.default.bMsgLengthKF == true )
    advSetCustomDeathMsg();
  }
  else
  {
    advResetToDefaultDeathMsg();
    OHUD.OS.Destroy();
    OHUD.Destroy();
    OHUD = none;
    pp.myhud = pp.level.spawn(pp.level.game.hudtype, pp);
  }
}

function SaveToConfig()
{
 if (OHUD != none)
 {
 class'OverlaySettings'.static.StaticSaveConfig();
 }
}

function Notify(UWindowDialogControl C, byte E)
{
  Super.Notify( C, E );
  if (OverlayStatus == none)
  return;

  if ( OHUD != None)
  OverlayButton.SetText( "Stop" );
  else
  OverlayButton.SetText( "Start" );

  if (OHUD != None )
  {
    switch(E)
	{
      case DE_Click:
      switch(C)
      {
        case OverlayButton:
          loadHUD();
        break;

        case HotKeyButton:
          if(HotKeyButton != none)
          {
            bMenu = true;
            HotKeyButton.bDisabled = true;
            DisplayInfo();
          }
        break;

        case CompareKeyButton:
          if(CompareKeyButton != none)
          {
            bCompareKey = true;
            CompareKeyButton.bDisabled = true;
            DisplayInfo();
          }
        break;

        case MVPKeyButton:
          if(MVPKeyButton != none)
          {
            bMVPKey = true;
            MVPKeyButton.bDisabled = true;
            DisplayInfo();
          }
        break;

        case PlayerCamKeyButton:
          if(PlayerCamKeyButton != none)
          {
            bPlayerCamKey = true;
            PlayerCamKeyButton.bDisabled = true;
            DisplayInfo();
          }
        break;

        case ViewToggleKeyButton:
          if(ViewToggleKeyButton != none)
          {
            bViewToggleKey = true;
            ViewToggleKeyButton.bDisabled = true;
            DisplayInfo();
          }
        break;

        case ViewToggleKeyButton:
          if(ViewToggleKeyButton != none)
          {
            bViewToggleKey = true;
            ViewToggleKeyButton.bDisabled = true;
            DisplayInfo();
          }
        break;
      }
      break;

      case DE_Change:
      switch(C)
      {
        case ItemTimer:
          class'OverlaySettings'.default.bShowItemTimer = ItemTimer.bChecked;
          SaveToConfig();
        break;

        case HealthArmor:
          class'OverlaySettings'.default.bShowHealthArmor = HealthArmor.bChecked;
          SaveToConfig();
        break;

        case FC_Info:
          class'OverlaySettings'.default.bFC_Info = FC_Info.bChecked;
          SaveToConfig();
        break;

        case FontSizeChat:
          class'OverlaySettings'.default.iFontSizeChat = FontSizeChat.GetSelectedIndex ();
          SaveToConfig();
        break;

        case FontSizeKF:
          class'OverlaySettings'.default.iFontSizeKF = FontSizeKF.GetSelectedIndex ();
          SaveToConfig();
        break;

        case MsgLengthKF:
          class'OverlaySettings'.default.bMsgLengthKF = MsgLengthKF.bChecked;
          if (MsgLengthKF.bChecked)
             advSetCustomDeathMsg();
          else
             advResetToDefaultDeathMsg();
          SaveToConfig();
        break;

        case ScoreBoardState:
          class'OverlaySettings'.default.bScoreBoardState = ScoreBoardState.bChecked;
          SaveToConfig();
        break;

        case ShowAccuracy:
          class'OverlaySettings'.default.bShowAccuracy = ShowAccuracy.bChecked;
          SaveToConfig();
        break;

        case FlagEffects:
          class'OverlaySettings'.default.iFlagEffects = FlagEffects.GetSelectedIndex ();
          SaveToConfig();
        break;

        case AmpEffects:
          class'OverlaySettings'.default.iAmpEffects = AmpEffects.GetSelectedIndex ();
          SaveToConfig();
        break;

        case HighContrastMode:
          class'OverlaySettings'.default.bHighContrastMode = HighContrastMode.bChecked;
          SaveToConfig();
        break;

        case PlayerNumbers:
          class'OverlaySettings'.default.bPlayerNumbers = PlayerNumbers.bChecked;
          SaveToConfig();
        break;

        case EasySwitch:
          class'OverlaySettings'.default.bEasySwitch = EasySwitch.bChecked;
          SaveToConfig();
        break;

        case AutoAdjustCam:
          class'OverlaySettings'.default.bAutoAdjustCam = AutoAdjustCam.bChecked;
          SaveToConfig();
        break;

        case AutoAdjustCamDelay:
          class'OverlaySettings'.default.iAutoAdjustCamDelay = AutoAdjustCamDelay.GetSelectedIndex ();
          SaveToConfig();
        break;

        case AutoViewFC:
          class'OverlaySettings'.default.bAutoViewFC = AutoViewFC.bChecked;
          SaveToConfig();
        break;
      }
      break;
    }
  }
  else
  {
    if (root.getplayerowner().myHUD.IsA('OverlayHUD'))
    {
      OHUD = OverlayHUD(root.getplayerowner().myHUD);
      OverlayStatus.SetText("Status: ACTIVE");
      ItemTimer.bChecked = class'OverlaySettings'.default.bShowItemTimer;
      ItemTimer.bDisabled = false;
      HealthArmor.bChecked = class'OverlaySettings'.default.bShowHealthArmor;
      HealthArmor.bDisabled = false;
      FC_Info.bChecked = class'OverlaySettings'.default.bFC_Info;
      FC_Info.bDisabled = false;
      FontSizeChat.SetSelectedIndex(class'OverlaySettings'.default.iFontSizeChat);
      FontSizeKF.SetSelectedIndex(class'OverlaySettings'.default.iFontSizeKF);
      MsgLengthKF.bChecked = class'OverlaySettings'.default.bMsgLengthKF;
      MsgLengthKF.bDisabled = false;
      ScoreBoardState.bChecked = class'OverlaySettings'.default.bScoreBoardState;
      ScoreBoardState.bDisabled = false;
      ShowAccuracy.bChecked = class'OverlaySettings'.default.bShowAccuracy;
      ShowAccuracy.bDisabled = false;
      FlagEffects.SetSelectedIndex(class'OverlaySettings'.default.iFlagEffects);
      AmpEffects.SetSelectedIndex(class'OverlaySettings'.default.iAmpEffects);
      HighContrastMode.bChecked = class'OverlaySettings'.default.bHighContrastMode;
      HighContrastMode.bDisabled = false;
      PlayerNumbers.bChecked = class'OverlaySettings'.default.bPlayerNumbers;
      PlayerNumbers.bDisabled = false;
      EasySwitch.bChecked = class'OverlaySettings'.default.bEasySwitch;
      EasySwitch.bDisabled = false;
      AutoAdjustCam.bChecked = class'OverlaySettings'.default.bAutoAdjustCam;
      AutoAdjustCam.bDisabled = false;
      AutoAdjustCamDelay.SetSelectedIndex(class'OverlaySettings'.default.iAutoAdjustCamDelay);
      AutoViewFC.bChecked = class'OverlaySettings'.default.bAutoViewFC;
      AutoViewFC.bDisabled = false;
    }
    else
    {
      OverlayStatus.SetText("Status: INACTIVE");
      ItemTimer.bDisabled = true;
      HealthArmor.bDisabled = true;
      FC_Info.bDisabled = true;
      MsgLengthKF.bDisabled = true;
      ShowAccuracy.bDisabled = true;
      HighContrastMode.bDisabled = true;
      PlayerNumbers.bDisabled = true;
      EasySwitch.bDisabled = true;
      AutoAdjustCam.bDisabled = true;
      AutoViewFC.bDisabled = true;
    }

  switch(E)
  {
    case DE_Click:
      switch(C)
      {
        case OverlayButton:
          loadHUD();
        break;

        case HotKeyButton:
          if(HotKeyButton != none)
          {
            bMenu = true;
            HotKeyButton.bDisabled = true;
            DisplayInfo();
          }
        break;

        case CompareKeyButton:
          if(CompareKeyButton != none)
          {
            bCompareKey = true;
            CompareKeyButton.bDisabled = true;
            DisplayInfo();
          }
        break;

        case MVPKeyButton:
          if(MVPKeyButton != none)
          {
            bMVPKey = true;
            MVPKeyButton.bDisabled = true;
            DisplayInfo();
          }
        break;

        case PlayerCamKeyButton:
          if(PlayerCamKeyButton != none)
          {
            bPlayerCamKey = true;
            PlayerCamKeyButton.bDisabled = true;
            DisplayInfo();
          }
        break;
      }
      break;
    }
  }
}

defaultproperties
{
}
