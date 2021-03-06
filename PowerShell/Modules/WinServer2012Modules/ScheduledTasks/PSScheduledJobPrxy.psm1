# .ExternalHelp PSScheduledJobPrxy.psm1-help.xml 
function New-ScheduledTaskTrigger
{

[CmdletBinding(DefaultParameterSetName='Once')]
param(
    [Parameter(ParameterSetName='Daily')]
    [int]
    ${DaysInterval},

    [Parameter(ParameterSetName='Weekly')]
    [int]
    ${WeeksInterval},

    [Parameter(ParameterSetName='AtLogon')]
    [Parameter(ParameterSetName='AtStartup')]
    [Parameter(ParameterSetName='Daily')]
    [Parameter(ParameterSetName='Once')]
    [Parameter(ParameterSetName='Weekly')]
    [timespan]
    ${RandomDelay},

    [Parameter(ParameterSetName='Once', Mandatory=$true)]
    [Parameter(ParameterSetName='Daily', Mandatory=$true)]
    [Parameter(ParameterSetName='Weekly', Mandatory=$true)]
    [datetime]
    ${At},

    [Parameter(ParameterSetName='AtLogon')]
    [ValidateNotNullOrEmpty()]
    [string]
    ${User},

    [Parameter(ParameterSetName='Weekly', Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [System.DayOfWeek[]]
    ${DaysOfWeek},

    [Parameter(ParameterSetName='AtStartup', Mandatory=$true, Position=0)]
    [switch]
    ${AtStartup},

    [Parameter(ParameterSetName='AtLogon', Mandatory=$true, Position=0)]
    [switch]
    ${AtLogOn},

    [Parameter(ParameterSetName='Once', Mandatory=$true, Position=0)]
    [switch]
    ${Once},

    [Parameter(ParameterSetName='Once')]
    [timespan]
    ${RepetitionInterval},

    [Parameter(ParameterSetName='Once')]
    [timespan]
    ${RepetitionDuration},

    [Parameter(ParameterSetName='Daily', Mandatory=$true, Position=0)]
    [switch]
    ${Daily},

    [Parameter(ParameterSetName='Weekly', Mandatory=$true, Position=0)]
    [switch]
    ${Weekly})

begin
{
    try {
        $outBuffer = $null
        if ($PSBoundParameters.TryGetValue('OutBuffer', [ref]$outBuffer))
        {
            $PSBoundParameters['OutBuffer'] = 1
        }
        $wrappedCmd = $ExecutionContext.InvokeCommand.GetCommand('New-JobTrigger', [System.Management.Automation.CommandTypes]::Cmdlet)
        $scriptCmd = {& $wrappedCmd @PSBoundParameters }
        $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
        $steppablePipeline.Begin($PSCmdlet)
    } catch {
        throw
    }
}

process
{
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
}

end
{
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
}
<#

.ForwardHelpTargetName New-ScheduledTaskTrigger
.ForwardHelpCategory Cmdlet

#>

}