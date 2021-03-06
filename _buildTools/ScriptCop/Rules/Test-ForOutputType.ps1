function Test-ForOutputType
{
    <#
    .Synopsis
        Tests for the presence of an output type
    .Description
        Tests for the presence of an output type.  
        If the output type isn't a declared object, this also checks to see that the output 
    .Example
        Get-Command CommandToTest | 
            Test-ForOutputType        
    .Link
        Test-Command
    #>
    param(
    [Parameter(ParameterSetName='TestCommandInfo',Mandatory=$true,ValueFromPipeline=$true)]
    [Management.Automation.CommandInfo]
    $CommandInfo
    )
        
    
    process {    
        #region Check that commands have an output type
        if (-not $commandInfo.OutputType) {
            Write-Error "$CommandInfo does not have an output type"
            return            
        }
        #endregion Check that commands have an output type
        
        #region Check dynamic property bags 
        if ($commandInfo -is [Management.Automation.FunctionInfo]) {
            $help  = Get-Help $commandInfo.Name        
            $notesText = if ($help.alertSet) {
                $help.alertSet.alert | 
                    Select-Object -ExpandProperty Text
            } else { "" }
        }
        
        foreach ($outType in $commandInfo.OutputType) {        
            if ($outType.Name -and -not $outType.Type) 
            {
                # It's an unnanmed type.  Make sure that the type is documented somewhere.
                # If it's a function, check for the presence of the name within the notes section of help
                if ($commandInfo -is [Management.Automation.FunctionInfo]) {
                    if ($notesText -and $notesText -notlike "*$($outType.Name)*") {
                        Write-Error "$CommandInfo returns a custom type, but doesn't document it in the function's notes"                        
                    }
                } elseif ($commandInfo -is [Management.Automation.CmdletInfo]) {
                    if ($notesText -and $notesText -notlike "*$($outType.Name)*") {
                        Write-Error "$CommandInfo returns a custom type, and that command has help, but doesn't document it in the commands's notes"                        
                    }
                    # If the type is compiled, look for an internal class in the same namespace as the cmdlet called ".PS${OutputTypeName}"
                    $expectedPsuedoTypeName = if ($outType.Name.Contains(".")) {
                        $outType.Name 
                    } else {
                        $commandInfo.ImplementingType.Namespace + ".PS" + $outType.Name 
                    }
                    
                    $psuedoType = $commandInfo.ImplementingType.GetAssembly().GetType("$expectedPsuedoTypeName")
                    if (-not $psuedoType) {
                        Write-Error "$commandInfo returns a property bag, but does not have an internal type declaring what properties should exist on that property bag.
Declare a class (preferably an internal class)"
                        continue
                    }
                    
                    $staticProperties = Get-Member -InputObject $psuedoType -MemberType Properties -Static
                    if (-not $staticProperties) {
                        Write-Error "$commandInfo returns a property bag, but does not have an internal type declaring what properties should exist on that property bag"
                        continue
                    }
                    
                }

            }
        }
        
        #endregion Check dynamic property bags 
        
        
        
    }
} 
 
