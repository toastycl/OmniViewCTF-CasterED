class OverlayAboutWindow expands UWindowPageWindow;

var UMenuLabelControl OV_Title;
var UMenuLabelControl OV_Version;
var UMenuLabelControl OV_ReleaseDate;
var UMenuLabelControl OV_Source;
var OverlayLink OV_Source_Link;
var UMenuLabelControl OV_License;
var OverlayLink OV_License_Link;
var UMenuLabelControl OV_MadeBy;
var UMenuLabelControl OV_Credits;
var UMenuLabelControl OV_Line;
var UMenuLabelControl OV_End;

function Created()
{
    local int CurY;
    Cury = 53;

    Super.Created();

    OV_Title = UMenuLabelControl(CreateControl(Class'UMenuLabelControl', 0.0, 25.0, 240.0, 1.0));
    OV_Title.SetText ("OmniViewCTF - Caster Edition");
   	OV_Title.Align = TA_Center;
   	OV_Title.TextColor.R = 0;
	OV_Title.TextColor.G = 0;
	OV_Title.TextColor.B = 168;
    // Caster Edition title: use the regular bold font so the full name
    // fits inside the existing About page at all supported UI scales.
    OV_Title.SetFont (F_Bold);

    OV_Line = UMenuLabelControl(CreateControl(Class'UMenuLabelControl', 10.0, Cury, 225.0, 1.0));
    OV_Line.SetText ("____________________________________________");
   	OV_Line.Align = TA_Center;
    OV_Line.SetFont (F_Normal);
    Cury = Cury + 20;

    OV_Version = UMenuLabelControl(CreateControl(Class'UMenuLabelControl', 15.0, Cury, 70.0, 1.0));
    OV_Version.SetText ("Version:");
   	OV_Version.Align = TA_Left;
    OV_Version.SetFont (F_Normal);

    OV_Version = UMenuLabelControl(CreateControl(Class'UMenuLabelControl', 85.0, Cury, 150.0, 1.0));
    OV_Version.SetText ("2.2 Caster Edition - ToastyCL");
   	OV_Version.Align = TA_Left;
    OV_Version.SetFont (F_Normal);
    Cury = Cury + 14;

    OV_ReleaseDate = UMenuLabelControl(CreateControl(Class'UMenuLabelControl', 15.0, Cury, 70.0, 1.0));
    OV_ReleaseDate.SetText ("Released:");
   	OV_ReleaseDate.Align = TA_Left;
    OV_ReleaseDate.SetFont (F_Normal);

    OV_ReleaseDate = UMenuLabelControl(CreateControl(Class'UMenuLabelControl', 85.0, Cury, 150.0, 1.0));
    OV_ReleaseDate.SetText ("25th October 2026");
   	OV_ReleaseDate.Align = TA_Left;
    OV_ReleaseDate.SetFont (F_Normal);
    Cury = Cury + 14;

    OV_MadeBy = UMenuLabelControl(CreateControl(Class'UMenuLabelControl', 15.0, Cury, 70.0, 1.0));
    OV_MadeBy.SetText ("Previous fork:");
   	OV_MadeBy.Align = TA_Left;
    OV_MadeBy.SetFont (F_Normal);

    OV_MadeBy = UMenuLabelControl(CreateControl(Class'UMenuLabelControl', 85.0, Cury, 150.0, 1.0));
    OV_MadeBy.SetText ("1.1 rX edit");
   	OV_MadeBy.Align = TA_Left;
    OV_MadeBy.SetFont (F_Normal);
    Cury = Cury + 14;

    OV_Source = UMenuLabelControl(CreateControl(Class'UMenuLabelControl', 15.0, Cury, 225.0, 1.0));
    OV_Source.SetText ("Source:");
   	OV_Source.Align = TA_Left;
    OV_Source.SetFont (F_Normal);

    OV_Source_Link = OverlayLink(CreateControl(Class'OverlayLink', 90.0, Cury, 225.0, 1.0));
    OV_Source_Link.SetText ("OV4CTF.toxik.info");
    OV_Source_Link.URL = "https://OV4CTF.toxik.info/";
   	OV_Source_Link.Align = TA_Left;
    OV_Source_Link.SetFont (F_Normal);
    Cury = Cury + 12;

    OV_License = UMenuLabelControl(CreateControl(Class'UMenuLabelControl', 15.0, Cury, 225.0, 1.0));
    OV_License.SetText ("License:");
   	OV_License.Align = TA_Left;
    OV_License.SetFont (F_Normal);

    OV_License_Link = OverlayLink(CreateControl(Class'OverlayLink', 90.0, Cury, 225.0, 1.0));
    OV_License_Link.SetText ("CC BY-SA 4.0");
    OV_License_Link.URL = "https://creativecommons.org/licenses/by-sa/4.0/";
   	OV_License_Link.Align = TA_Left;
    OV_License_Link.SetFont (F_Normal);
    Cury = Cury + 12;

    OV_Line = UMenuLabelControl(CreateControl(Class'UMenuLabelControl', 10.0, Cury, 225.0, 1.0));
    OV_Line.SetText ("____________________________________________");
   	OV_Line.Align = TA_Center;
    OV_Line.SetFont (F_Normal);
    Cury = Cury + 20;

    OV_Credits = UMenuLabelControl(CreateControl(Class'UMenuLabelControl', 0.0, Cury, 240.0, 1.0));
    OV_Credits.SetText ("Original OmniView4CTF by Waylander aka double_u.");
   	OV_Credits.Align = TA_Center;
    OV_Credits.SetFont (F_Normal);
    Cury = Cury + 12;

    OV_Credits = UMenuLabelControl(CreateControl(Class'UMenuLabelControl', 0.0, Cury, 240.0, 1.0));
    OV_Credits.SetText ("");
   	OV_Credits.Align = TA_Center;
    OV_Credits.SetFont (F_Normal);
    Cury = Cury + 12;

    OV_Credits = UMenuLabelControl(CreateControl(Class'UMenuLabelControl', 0.0, Cury, 240.0, 1.0));
    OV_Credits.SetText ("Immense credits to ANUSHUNTER5000");
   	OV_Credits.Align = TA_Center;
    OV_Credits.SetFont (F_Normal);
    Cury = Cury + 12;

    OV_Credits = UMenuLabelControl(CreateControl(Class'UMenuLabelControl', 0.0, Cury, 240.0, 1.0));
    OV_Credits.SetText ("for all the help. Thank you so much!");
   	OV_Credits.Align = TA_Center;
    OV_Credits.SetFont (F_Normal);
    Cury = Cury + 12;

    OV_Credits = UMenuLabelControl(CreateControl(Class'UMenuLabelControl', 0.0, Cury, 240.0, 1.0));
    OV_Credits.SetText ("");
   	OV_Credits.Align = TA_Center;
    OV_Credits.SetFont (F_Normal);
    Cury = Cury + 12;

    OV_Credits = UMenuLabelControl(CreateControl(Class'UMenuLabelControl', 0.0, Cury, 240.0, 1.0));
    OV_Credits.SetText ("Thanks to everyone who helped me with this.");
   	OV_Credits.Align = TA_Center;
    OV_Credits.SetFont (F_Normal);
    Cury = Cury + 12;

    OV_Credits = UMenuLabelControl(CreateControl(Class'UMenuLabelControl', 0.0, Cury, 240.0, 1.0));
    OV_Credits.SetText ("See the ReadMe for all acknowledgments.");
   	OV_Credits.Align = TA_Center;
    OV_Credits.SetFont (F_Normal);
    Cury = Cury + 12;

    OV_Line = UMenuLabelControl(CreateControl(Class'UMenuLabelControl', 10.0, Cury, 225.0, 1.0));
    OV_Line.SetText ("____________________________________________");
   	OV_Line.Align = TA_Center;
    OV_Line.SetFont (F_Normal);
    Cury = Cury + 20;

    OV_End = UMenuLabelControl(CreateControl(Class'UMenuLabelControl', 0.0, Cury, 240.0, 1.0));
    OV_End.SetText ("Please read and understand the included");
   	OV_End.Align = TA_Center;
    OV_End.SetFont (F_Normal);
    Cury = Cury + 12;

    OV_End = UMenuLabelControl(CreateControl(Class'UMenuLabelControl', 0.0, Cury, 240.0, 1.0));
    OV_End.SetText ("ReadMe before using this tool.");
   	OV_End.Align = TA_Center;
    OV_End.SetFont (F_Normal);
    Cury = Cury + 12;

    OV_End = UMenuLabelControl(CreateControl(Class'UMenuLabelControl', 0.0, Cury, 240.0, 1.0));
    OV_End.SetText ("");
   	OV_End.Align = TA_Center;
    OV_End.SetFont (F_Normal);
    Cury = Cury + 12;

    OV_End = UMenuLabelControl(CreateControl(Class'UMenuLabelControl', 0.0, Cury, 240.0, 1.0));
    OV_End.SetText ("GL & HF!");
   	OV_End.Align = TA_Center;
    OV_End.SetFont (F_Normal);
    Cury = Cury + 12;
}

defaultproperties
{
}
