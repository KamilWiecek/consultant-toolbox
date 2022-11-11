[CmdletBinding()]
param (
    [Parameter()]
    [String]
    $ResourceGroupName
)

$tempDirectory = New-Item -ItemType Directory -Name (New-Guid).Guid -Force
$exportRgOutput = Export-AzResourceGroup -ResourceGroupName $ResourceGroupName -Path $tempDirectory.PSPath -SkipAllParameterization

$bicepFileName = "$( $ResourceGroupName ).bicep"
bicep decompile $exportRgOutput.Path --outfile ./$bicepFileName 

Remove-Item -Path $tempDirectory.PSPath -Recurse -Force
