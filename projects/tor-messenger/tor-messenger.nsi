;NSIS Installer for Tor Browser Bundle
;Written by Moritz Bartl
;released under Public Domain

;--------------------------------
;Modern" UI

  !include "MUI2.nsh"

;--------------------------------
;General
 
  ; location of Tor Browser bundle to put into installer
  !define TBBSOURCE ".\Tor Browser\"  

  Name "Tor Browser"
  OutFile "torbrowser-install.exe"

  ;Default installation folder
  InstallDir "$DESKTOP\Tor Browser"
  
  ;Best (but slowest) compression
  SetCompressor /SOLID lzma
  SetCompressorDictSize 32

  ;Request application privileges for Windows Vista
  RequestExecutionLevel user

;--------------------------------
;Interface Configuration

  !define MUI_ICON   "torbrowser.ico"
  !define MUI_ABORTWARNING

;--------------------------------
;Modern UI settings
  !define MUI_FINISHPAGE_NOREBOOTSUPPORT     ; we don't require a reboot
  !define MUI_FINISHPAGE_RUN
  !define MUI_FINISHPAGE_RUN_FUNCTION "StartTorBrowser"
  !define MUI_FINISHPAGE_SHOWREADME ; misuse for option to create shortcut; less ugly than MUI_PAGE_COMPONENTS
  !define MUI_FINISHPAGE_SHOWREADME_TEXT "&Add Start Menu && Desktop shortcuts"
  !define MUI_FINISHPAGE_SHOWREADME_FUNCTION "CreateShortCuts"
;--------------------------------
;Pages

  !define MUI_PAGE_CUSTOMFUNCTION_LEAVE CheckIfTargetDirectoryExists
  !insertmacro MUI_PAGE_DIRECTORY
  !insertmacro MUI_PAGE_INSTFILES
  !insertmacro MUI_PAGE_FINISH

;--------------------------------
;Languages

  !insertmacro MUI_LANGUAGE "English" ;first language is the default language
  !insertmacro MUI_LANGUAGE "French"
  !insertmacro MUI_LANGUAGE "German"
  !insertmacro MUI_LANGUAGE "Spanish"
  !insertmacro MUI_LANGUAGE "SpanishInternational"
  !insertmacro MUI_LANGUAGE "SimpChinese"
  !insertmacro MUI_LANGUAGE "TradChinese"
  !insertmacro MUI_LANGUAGE "Japanese"
  !insertmacro MUI_LANGUAGE "Korean"
  !insertmacro MUI_LANGUAGE "Italian"
  !insertmacro MUI_LANGUAGE "Dutch"
  !insertmacro MUI_LANGUAGE "Danish"
  !insertmacro MUI_LANGUAGE "Swedish"
  !insertmacro MUI_LANGUAGE "Norwegian"
  !insertmacro MUI_LANGUAGE "NorwegianNynorsk"
  !insertmacro MUI_LANGUAGE "Finnish"
  !insertmacro MUI_LANGUAGE "Greek"
  !insertmacro MUI_LANGUAGE "Russian"
  !insertmacro MUI_LANGUAGE "Portuguese"
  !insertmacro MUI_LANGUAGE "PortugueseBR"
  !insertmacro MUI_LANGUAGE "Polish"
  !insertmacro MUI_LANGUAGE "Ukrainian"
  !insertmacro MUI_LANGUAGE "Czech"
  !insertmacro MUI_LANGUAGE "Slovak"
  !insertmacro MUI_LANGUAGE "Croatian"
  !insertmacro MUI_LANGUAGE "Bulgarian"
  !insertmacro MUI_LANGUAGE "Hungarian"
  !insertmacro MUI_LANGUAGE "Thai"
  !insertmacro MUI_LANGUAGE "Romanian"
  !insertmacro MUI_LANGUAGE "Latvian"
  !insertmacro MUI_LANGUAGE "Macedonian"
  !insertmacro MUI_LANGUAGE "Estonian"
  !insertmacro MUI_LANGUAGE "Turkish"
  !insertmacro MUI_LANGUAGE "Lithuanian"
  !insertmacro MUI_LANGUAGE "Slovenian"
  !insertmacro MUI_LANGUAGE "Serbian"
  !insertmacro MUI_LANGUAGE "SerbianLatin"
  !insertmacro MUI_LANGUAGE "Arabic"
  !insertmacro MUI_LANGUAGE "Farsi"
  !insertmacro MUI_LANGUAGE "Hebrew"
  !insertmacro MUI_LANGUAGE "Indonesian"
  !insertmacro MUI_LANGUAGE "Mongolian"
  !insertmacro MUI_LANGUAGE "Luxembourgish"
  !insertmacro MUI_LANGUAGE "Albanian"
  !insertmacro MUI_LANGUAGE "Breton"
  !insertmacro MUI_LANGUAGE "Belarusian"
  !insertmacro MUI_LANGUAGE "Icelandic"
  !insertmacro MUI_LANGUAGE "Malay"
  !insertmacro MUI_LANGUAGE "Bosnian"
  !insertmacro MUI_LANGUAGE "Kurdish"
  !insertmacro MUI_LANGUAGE "Irish"
  !insertmacro MUI_LANGUAGE "Uzbek"
  !insertmacro MUI_LANGUAGE "Galician"
  !insertmacro MUI_LANGUAGE "Afrikaans"
  !insertmacro MUI_LANGUAGE "Catalan"
  !insertmacro MUI_LANGUAGE "Esperanto"

;--------------------------------
;Multi Language support: Read strings from separate file

; !include torbrowser-langstrings.nsi

;--------------------------------
;Reserve Files
  
  ;If you are using solid compression, files that are required before
  ;the actual installation should be stored first in the data block,
  ;because this will make your installer start faster.
  
  !insertmacro MUI_RESERVEFILE_LANGDLL

;--------------------------------
;Installer Sections

Section "Tor Browser Bundle" SecTBB

  SetOutPath "$INSTDIR"
  File /r "${TBBSOURCE}\*.*"
  SetOutPath "$INSTDIR\Browser"
  CreateShortCut "$INSTDIR\Start Tor Browser.lnk" "$INSTDIR\Browser\firefox.exe"

SectionEnd

Function CreateShortcuts

  CreateShortCut "$SMPROGRAMS\Start Tor Browser.lnk" "$INSTDIR\Browser\firefox.exe" 
  CreateShortCut "$DESKTOP\Start Tor Browser.lnk" "$INSTDIR\Browser\firefox.exe"

FunctionEnd
;--------------------------------
;Installer Functions

Function .onInit

  !insertmacro MUI_LANGDLL_DISPLAY

FunctionEnd

;--------------------------------
;Helper Functions

Function CheckIfTargetDirectoryExists
${If} ${FileExists} "$INSTDIR\*.*"
 MessageBox MB_YESNO "The destination directory already exists. You can try to upgrade the Tor Browser Bundle, but if you run into any problems, use a new directory instead. Continue?" IDYES NoAbort
   Abort
 NoAbort:
${EndIf}
FunctionEnd


Function StartTorBrowser
ExecShell "open" "$INSTDIR/Start Tor Browser.lnk"
FunctionEnd

