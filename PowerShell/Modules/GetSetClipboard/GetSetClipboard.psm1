# I usually use the cb alias (for GetSet-Clipboard) because it is two way i.e can get or set the clipboard:

# cb                # gets the contents of the clipboard
# "john" | cb       # sets the clipboard to "john"
# cb -s             # gets the clipboard and splits it into lines

Add-Type -AssemblyName System.Windows.Forms

Function Get-Clipboard {
    param([switch]$SplitLines)

    $text = [Windows.Forms.Clipboard]::GetText();

    if ($SplitLines) {
        $xs = $text -split [Environment]::NewLine
        if ($xs.Length -gt 1 -and -not($xs[-1])) {
            $xs[0..($xs.Length - 2)]
        } else {
            $xs
        }
    } else {
        $text
    }
}

function Set-Clipboard {
    $in = @($input)

    $out = 
        if ($in.Length -eq 1 -and $in[0] -is [string]) { $in[0] }
        else { $in | Out-String }

    [Windows.Forms.Clipboard]::SetText($out);
}

function GetSet-Clipboard {
    param([switch]$SplitLines, [Parameter(ValueFromPipeLine=$true)]$ObjectSet)

    if ($input) {
        $ObjectSet = $input;
    }

    if ($ObjectSet) {
        $ObjectSet | Set-Clipboard
    } else {
        Get-Clipboard -SplitLines:$SplitLines
    }
}

Set-Alias cb GetSet-Clipboard

Export-ModuleMember -Function *-* -Alias *