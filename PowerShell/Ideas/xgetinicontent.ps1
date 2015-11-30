# В качестве примера работы с хэш-таблицами хочу привести код функции чтения значений ini-файла, по-моему она прекрасна:
# http://habrahabr.ru/post/254999/

function Get-IniContent  {
    Param (
        [String]$Filepath
    )
    $IniContent = @{}
    switch -Regex -File $Filepath {
        '^\[(.+)\]' {
            $Section = $matches[1]
            $IniContent[$Section] = @{}
            $CommentCount = 0
        }
        "^(;.*)$"  {
            $Value = $matches[1]
            $CommentCount = $CommentCount + 1
            $Name = 'Comment' + $CommentCount
            $IniContent[$Section][$Name] = $Value
        }
        '(.+?)\s*=(.*)' {
            $Name, $Value = $matches[1..2]
            $IniContent[$Section][$Name] = $Value
        }
    }
    Write-Output $IniContent
}
# Ed Wilson, Microsoft Scripting Guy

Get-IniContent -Filepath D:\Shturman\Bin\Shturman.ini