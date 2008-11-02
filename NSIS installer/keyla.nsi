; Headers

!include MUI2.nsh

; Constants

!define ICON          ..\keyla\res\Icon.ico
!define PROGRAM_NAME  keyla
!define VERSION_SHORT 0.1.2
!define VERSION 0.1.2.0
!define WNDCLASS      "keyla main window"

; Version information

VIProductVersion ${VERSION}
VIAddVersionKey "LegalCopyright" "© Евгений Аршинов, 2008"
VIAddVersionKey "FileDescription" "Переключатель раскладки клавиатуры"
VIAddVersionKey "FileVersion" ${VERSION}
  ; TODO: Find a way to provide "Language"

; General configuration

InstallDir   $PROGRAMFILES\${PROGRAM_NAME}
Name         ${PROGRAM_NAME}
OutFile      keyla-${VERSION_SHORT}-setup.exe

  ;Get installation folder from registry if available
InstallDirRegKey HKCU "Software\${PROGRAM_NAME}" "installDir"

; General configuration for MUI

!define MUI_ICON   ${ICON}
!define MUI_UNICON ${ICON}

; Pages configuration

!define MUI_ABORTWARNING

; List of pages

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE ..\LICENSE
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES

!define MUI_FINISHPAGE_RUN $INSTDIR\${PROGRAM_NAME}.exe
!define MUI_FINISHPAGE_SHOWREADME
!define MUI_FINISHPAGE_SHOWREADME_TEXT "Автоматически запускать keyla при входе в систему"
!define MUI_FINISHPAGE_SHOWREADME_FUNCTION AddToAutostart
Function AddToAutostart
  CreateShortCut $SMSTARTUP\${PROGRAM_NAME}.lnk $INSTDIR\${PROGRAM_NAME}.exe
FunctionEnd

!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

; Language

!insertmacro MUI_LANGUAGE "Russian"

; Callbacks

Function .onInit 
  ReadRegStr $R0 HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PROGRAM_NAME}" "UninstallString"
  StrCmp $R0 "" done
  MessageBox MB_YESNO|MB_ICONEXCLAMATION "Программа уже установлена. Удалить предыдущую версию?" IDYES uninst
  Abort 
uninst:
  ClearErrors
  Exec $INSTDIR\Uninstall.exe	
done:
FunctionEnd

Function un.onInit
  retry:
  FindWindow $0 "${WNDCLASS}"
  StrCmp $0 0 continue
    MessageBox MB_RETRYCANCEL|MB_ICONEXCLAMATION "Для продолжения установки завершите работу keyla и повторите попытку" IDRETRY retry
    Abort
  continue:
FunctionEnd

; Sections

Section

  ; Files 
  SetOutPath $INSTDIR
  File ..\keyla\Release\keyla.exe
  SetOutPath $INSTDIR\icons
  File ..\icons\*.ico
  
  ;  Registry keys
  WriteRegStr HKCU Software\${PROGRAM_NAME} installDir $INSTDIR
  
  ; Start menu items
  CreateDirectory $SMPROGRAMS\${PROGRAM_NAME}
  CreateShortCut $SMPROGRAMS\${PROGRAM_NAME}\${PROGRAM_NAME}.lnk $INSTDIR\${PROGRAM_NAME}.exe
  
  ; Uninstaller registry keys
  WriteRegStr HKLM Software\Microsoft\Windows\CurrentVersion\Uninstall\${PROGRAM_NAME} DisplayName "keyla - переключатель раскладок клавиатуры"
  WriteRegStr HKLM Software\Microsoft\Windows\CurrentVersion\Uninstall\${PROGRAM_NAME} UninstallString $INSTDIR\Uninstall.exe
  
  ; Uninstaller
  WriteUninstaller $INSTDIR\Uninstall.exe
  
SectionEnd

 
Section Uninstall

  ;Current working directory can not be deleted. So change it
  SetOutPath $TEMP
  
  ;Files 
  Delete $INSTDIR\${PROGRAM_NAME}.exe
  Delete $INSTDIR\Uninstall.exe
  RMDir /r $INSTDIR\icons
  RMDir $INSTDIR
  
  ;Start menu items
  RMDir /r $SMPROGRAMS\${PROGRAM_NAME}
  
  ; Autostart
  Delete $SMSTARTUP\${PROGRAM_NAME}.lnk
  
  ;Uninstaller registry keys 
  DeleteRegKey HKLM Software\Microsoft\Windows\CurrentVersion\Uninstall\${PROGRAM_NAME}
  
SectionEnd
