;This script is designed to remove line breaks from text copied to the clipboard via Ctrl + C, allowing for automatic adjustment to the target format when pasting, so that line breaks do not have to be removed manually afterward. The most common use case is likely copying text from a PDF into the ForumStar text system.
;It should also remove automatic hyphenation in the source text (indicated by a line break immediately following a hyphen), so that hyphens do not have to be manually removed from the copied text."

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.

^c::
Suspend, On  ; Suspend the script so the following ^c becomes a normal copy operation => Without Suspend, On, the script could start processing the clipboard immediately, before the content is fully copied, which could lead to inconsistent results.
Send, ^c  ; Send Ctrl+C to copy
Sleep, 50  ; Wait for the clipboard to update

; Check if the clipboard contains files (CF_HDROP) => Important because AutoHotkey interpretes files as a string containing the filepath, so not checking for this would make copying files and folders via ctrl+c impossible
if DllCall("IsClipboardFormatAvailable", "UInt", 15) ; 15 is the CF_HDROP format for files
{
    Suspend, Off  ; Resume the script
    return  ; Exit the hotkey without modifying the clipboard
}

; Step 1: Remove "-" followed directly by a line break
Clipboard := RegExReplace(Clipboard, "-\r\n|-\r|-\n", "")

; Step 2: Replace remaining line breaks with a space
Clipboard := RegExReplace(Clipboard, "\r\n|\r|\n", " ")

Suspend, Off  ; Resume the script
return
