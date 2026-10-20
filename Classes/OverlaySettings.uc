class OverlaySettings extends Info config(OmniViewCTF_CasterED);

var config bool bShowItemTimer, bShowHealthArmor, bFC_Info, bMsgLengthKF, bEasySwitch, bAutoAdjustCam, bAutoViewFC, bScoreBoardState, bShowAccuracy,
bHighContrastMode, bPlayerNumbers, bShowShield, bShowAmp, bShowKeg, bShowArmor, bShowPads, bShowBoots, bShowInvis,
bShowPlayerNames, bShowUnrealArenaLogo;

var config int iFlagEffects, iAmpEffects, iFontSizeChat, iFontSizeKF, iAutoAdjustCamDelay, iOBSOffset, iPlayerNameDistance, iUnrealArenaLogoSize;

var config string IH_DM, trans_DM, enforcer_DM, bio_DM, shock_DM, pulse_DM, ripper_DM, mini_DM, flak_DM, RL_DM, sniper_DM, IG_DM,
Fall_DM, Drowned_DM, Burned_DM, Corroded_DM, MaleSuicide_DM, FemaleSuicide_DM;

defaultproperties
{
	bShowItemTimer=True
	bShowHealthArmor=True
	bFC_Info=True
	bMsgLengthKF=True
	bEasySwitch=True
	bAutoAdjustCam=True
	bScoreBoardState=True
	bPlayerNumbers=True
	bShowShield=True
	bShowAmp=True
	bShowKeg=True
	bShowArmor=True
	bShowPads=True
	bShowBoots=True
	bShowInvis=True
	bShowPlayerNames=True
	bShowUnrealArenaLogo=False
	iPlayerNameDistance=3500
	iUnrealArenaLogoSize=1
	iFlagEffects=1
	iAmpEffects=2
	iFontSizeChat=0
	iFontSizeKF=1
	iAutoAdjustCamDelay=1
	IH_DM="%k  >  I H  >  %o"
	trans_DM="%k  >  T L  >  %o"
	enforcer_DM="%k  >  E N F  >  %o"
	bio_DM="%k  >  B I O  >  %o"
	shock_DM="%k  >  S H O C K  >  %o"
	pulse_DM="%k  >  P U L S E  >  %o"
	ripper_DM="%k  >  R I P P E R  >  %o"
	mini_DM="%k  >  M I N I  >  %o"
	flak_DM="%k  >  F L A K  >  %o"
	RL_DM="%k  >  R L  >  %o"
	sniper_DM="%k  >  S N I P E R  >  %o"
	IG_DM="%k  > >  >  %o"
	Fall_DM="  >  F A L L"
	Drowned_DM="  >  D R O W N E D"
	Burned_DM="  >  B U R N E D"
	Corroded_DM="  >  S L I M E D"
	MaleSuicide_DM="  >  S E L F"
	FemaleSuicide_DM="  >  S E L F"
}
