function loopNodes {
    param ($oElmntParent,$strPath)
    [string[]]$ignoredList = Get-Content -Path "$path\.powershellignore.txt"

    $dirInfo = New-Object System.IO.DirectoryInfo $strPath
    $dirInfo.GetDirectories() | % {
        if (!($ignoredList.Contains($_.Name))) {
            $OutNull = $oElmntChild = $xmlDoc.CreateElement("dir")
            $OutNull = $oElmntChild.SetAttribute("name", $_.Name)
            $OutNull = $oElmntParent.AppendChild($oElmntChild)
            loopNodes $oElmntChild ($strPath + "\" + $_.Name)
        }
    }
    $dirInfo.GetFiles() | % {
        if (!($ignoredList.Contains($_.Name))) {
            $OutNull = $oElmntChild = $xmlDoc.CreateElement("script")
            $OutNull = $oElmntChild.SetAttribute("name", $_.Name)

            $firstLine = [IO.File]::ReadLines($_.FullName, [text.encoding]::UTF8) | Select-Object -first 1
            if ($firstLine -like "--DEPENDENCIES:*") {
                $dependencies = $firstLine.split(":")[1]
                $OutNull = $oElmntChild.SetAttribute("dependencies", $dependencies.Trim())
            }

            $OutNull = $oElmntParent.AppendChild($oElmntChild)
        }
    }
}

function Get {
    $path = Get-Location
    $path = $path.tostring()

    $xmlDoc = New-Object xml
    if($path -ne '') {
            $OutNull = $xmlDoc.AppendChild($xmlDoc.CreateProcessingInstruction("xml", "version='1.0'"))
            $OutNull = $oElmntRoot = $xmlDoc.CreateElement("root")
            $OutNull = $xmlDoc.AppendChild($oElmntRoot)
            loopNodes $oElmntRoot $path
    } 
    $OutNull = $xmlDoc.Save("$path\index.xml")
} 