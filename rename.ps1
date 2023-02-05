$path = Read-Host "Bitte Pfad angeben"
#$path = "C:\Users\Michael Somnitz\TuneFab\Amazon Music Converter\Converted\test"
$files = Get-ChildItem $path

[Reflection.Assembly]::LoadFrom( (Resolve-Path ("C:\code\mp3-renamer\lib\TagLibSharp.dll")))

foreach ($file in $files){


    $shell = New-Object -COMObject Shell.Application
    $folder = Split-Path $file.FullName
    $fileName = Split-Path $file.FullName -Leaf
    $shellfolder = $shell.Namespace($folder)
    $shellfile = $shellfolder.ParseName($fileName)
    
    $filePath = $file.FullName
    $song = [TagLib.File]::Create((resolve-path -LiteralPath $filePath))

    $folderPrefix = $song.Tag.Title.Split("-")
    if ($folderPrefix.Length -gt 1){
        $replaceString = $folderPrefix[0] + "- ";    
        $newFilename = $file.Directory.Name + " - " + $file.Name.Replace($replaceString, "").Replace(".mp3", "")
    } else {
        $newFilename = $file.Directory.Name + " - " + $shellfolder.GetDetailsOf($shellfile, 21)
    }
        
    $song.Tag.Title = $newFilename
    $song.Save()

    $newFilename = $newFilename + ".mp3"
    Rename-Item -Path $file.FullName -NewName $newFilename
    
}