#
# проверка алгоритма фильтрации IP адресов по маске. утилита CheckIpAddress.exe
#
param (
	[string]$NetMask = "",
	[string]$IP = "127.0.0.1",
	[string]$mo1 = "4",
	[string]$mo2 = "3",
	[string]$mo3 = "2",
	[string]$mo4 = "1",
	[string]$ExpErrLev = "0",
	[switch]$Inv,
	[string]$ExeptMasks = "none"  # маски не участвующие в проверке 1.1.1.1;2.2.2.2;3.3.3.3

	#,
	#[string]$someone = $( Read-Host "Input password, please" )
)


$Debug		= $TRUE

.".\..\functions\log.ps1"

if ($NetMask)
{
	$nMask = $NetMask.Split("{.}")
	[string]$mo1 = $nMask[0]
	[string]$mo2 = $nMask[1]
	[string]$mo3 = $nMask[2]
	[string]$mo4 = $nMask[3]

}


if ($Inv)
{
	$NotMatchMask = "!";
}
Else
{
	$NotMatchMask = "";
}

$MaskListMatch = "fdsfdsf", "*",
"*.*",
"*.*.*",
"*.*.*.*"


$MaskList = "*",
"*.*",
"*.*.*",
"*.*.*.*",
"$mo1.$mo2.$mo3.$mo4",
"000$mo1.000$mo2.000$mo3.000$mo4",
"0$mo1.$mo2.$mo3.$mo4",
"00$mo1.$mo2.$mo3.$mo4",
"000$mo1.$mo2.$mo3.$mo4",
"$mo1.0$mo2.$mo3.$mo4",
"$mo1.00$mo2.$mo3.$mo4",
"$mo1.$mo2.0000$mo3.$mo4",
"$mo1.$mo2.$mo3.0000000$mo4",
"$mo1.*",
"00000$mo1.*",
"$mo1.*.*",
"0000$mo1.*.*",
"$mo1.*.*.$mo4",
"0000$mo1.*.*.00000$mo4",
"$mo1.$mo2.*.*",
"0000$mo1.00000$mo2.*.*",
"$mo1.*.*.*",
"0000$mo1.*.*.*",
"*.*.*.$mo4",
"*.*.*.0000$mo4",
"*.*.$mo3.$mo4",
"*.*.0000$mo3.0000$mo4",
"*.$mo2.$mo3.$mo4",
"*.0000$mo2.0000$mo3.0000$mo4",
"$mo1.*.$mo3.$mo4",
"000$mo1.*.000$mo3.000$mo4",
"$mo1.$mo2.*.$mo4",
"0000$mo1.0000$mo2.*.0000$mo4",
"$mo1.$mo2.$mo3.*",
"0000$mo1.000$mo2.000$mo3.*",
"*.$mo2.*.$mo4",
"*.00$mo2.*.00$mo4",
"*.$mo2.$mo3.*",
"*.0000$mo2.0000000$mo3.*",
"*.$mo2.*.*",
"*.00000$mo2.*.*",
"*.*.$mo3.*",
"*.*.0000$mo3.*"



function CheckIP($xmask, $IP, $ExpErrLev)
{
	$con = D:\share\CheckIpAddress.exe $xmask $IP



#write-host $xmask
	$ixmask = $xmask -replace "\!", "";
	if ([array]::indexof($MaskListMatch,$ixmask) -gt 0) 
	{ 
#write-host $Inv
		if ($Inv)
		{
			$ExpErrLevCurr = 4
#write-host "sfsdf"
		}
		Else
		{
			$ExpErrLevCurr = 0
#write-host "sfsdf"
		}
#write-host ([array]::indexof($MaskListMatch,$xmask))
	} 
	Else 
	{
		$ExpErrLevCurr = $ExpErrLev
	}
#$MaskListMatch.IndexOf($mask)
#write-host $ExpErrLevCurr

	if ($LASTEXITCODE -eq $ExpErrLevCurr)
	{
		return $TRUE;
	}
	Else
	{
		return $FALSE;
	}
}

#$i = -5;

#while ($i -lt 300)
#{
#	$mask = "192.168.1.*";
#	$IP = "192.168.0.1";
	
$ExeptMasksArr = $ExeptMasks.Split("{;}")

# сообщаем что проверяем
If ($Inv) {$NotMatch = "NotIn: "} Else {$NotMatch = ""};
$LogMessage = "Mask: $NotMatch$NetMask; IP: $IP; ExpectedErrLev: $ExpErrLev; ExeptMasks: $ExeptMasks";
WriteLog  $LogMessage "INFO"


# посли по маскам проверять
	foreach ($mask in $MaskList)
	{
		#[array]::indexof($ExeptMasksArr,$mask)
#		$mask
		if ([array]::indexof($ExeptMasksArr,$mask) -eq -1)
		{
#			Write-Host "gsfsgdsgds"
			$CheckResult = CheckIP $NotMatchMask$mask $IP $ExpErrLev #$Inv
		}
		Else
		{
			$CheckResult = -1;
#			$CheckResult
		}
#$LASTEXITCODE
		switch ($LASTEXITCODE)
		{
			(0)
			{
				$ErrLevText = "Possible"
			}
			(1)
			{
				$ErrLevText = "Bad_E1  "
			}
			(2)
			{
				$ErrLevText = "Go Out  "
			}
			(3)
			{
				$ErrLevText = "Bad_IP  "
			}
			(4)
			{
				$ErrLevText = "BadMask"
			}
			default
			{
				$ErrLevText = "UNCK"
			}
		}

		$mask = $mask -replace "\.", ".";
#		$t = $x -join ".";
		$LogMessage = "ErrLev=$LASTEXITCODE $ErrLevText;	Mask:[ $NotMatchMask $mask];			IP:[$IP]";
#$CheckResult
		if ($CheckResult -eq $TRUE) 
		{

			WriteLog  $LogMessage "MESS"
		}
		ElseIf ($CheckResult -eq -1)
		{
			WriteLog  "Mask $mask skipped" "MESS"
		}
		Else
		{
			if ($LASTEXITCODE -eq 3)
			{
				WriteLog $LogMessage "WARN"
			}
			Else
			{
				WriteLog $LogMessage "ERRr"
			}
		}
		
	}


#	if ($LASTEXITCODE -ne 0)
#	{
#		Write-Host $LASTEXITCODE
#	}
#	$i++;
#}