# Start out by making en empty directory
New-Item .\TestDirectory -ItemType Directory -Force
        
# Now let's create two scripts.  The first script has 
# a 50/50 chance of saying "Hello World" or "Goodbye World"        
'
if ((0,1 | Get-Random)) {
    "Hello World"
} else {
    "Goodbye World"
}
' |
    Out-File .\TestDirectory\Chance.ps1
        
# The second script will say Hello World or Goodbye World depending
# on if it was passed a parameter
'
param ($a)
if ($a) {
    "Hello World"
} else {
    "Goodbye World"
}
' > .\TestDirectory\Parameter.ps1

# We pipe the output of Get-ChildItem into Show-ScriptCoverage.  This will run
# each of the scripts, and return a property bag containing:
# - The name of the file that is being instrumented
# - The output of the script
# - Any errors encountered running the script
# - A visual representation of what lines in the script were hit
# By Piping it into Select-Object and expanding the coverage property, we'll
# just see what lines were hit        
Get-ChildItem .\TestDirectory |
    Show-ScriptCoverage | 
    Select-Object -ExpandProperty Coverage
        
# Cool.  Now let's be polite and clean up the files we created
Remove-Item .\TestDirectory -Recurse -Force 
