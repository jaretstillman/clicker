param (
    [switch]$reset = $false
 )

Add-Type -AssemblyName System.Windows.Forms
#import mouse_event
Add-Type -MemberDefinition '[DllImport("user32.dll")] public static extern void mouse_event(int flags, int dx, int dy, int cButtons, int info);' -Name U32 -Namespace W;

echo "RESET = $reset"

#set cursor coordinates
if(-Not ((Test-Path env:NextX) -AND (Test-Path env:NextY)) -OR $reset)
{
    echo "Put your mouse over the 'Next' button within the next 10 seconds"
    Start-Sleep -Seconds 10
    $pos = [System.Windows.Forms.Cursor]::Position
    echo "Cursor Pos = $pos"
    [System.Environment]::SetEnvironmentVariable('NextX', $pos.X,'User')
    [System.Environment]::SetEnvironmentVariable('NextY', $pos.Y,'User')
    $env:NextX = $pos.X
    $env:NextY = $pos.Y
}
else #get cursor coordinates
{
  $x = [System.Environment]::GetEnvironmentVariable('NextX','user')
  $y = [System.Environment]::GetEnvironmentVariable('NextY','user')
  echo "Cursor X = $x"
  echo "Cursor Y = $y"
}

$x = [System.Environment]::GetEnvironmentVariable('NextX','user')
$y = [System.Environment]::GetEnvironmentVariable('NextY','user')

echo "Press Ctrl-C to quit"

while ($true)
{
  #set cursor
  [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($x, $y)

  #left mouse click
  [W.U32]::mouse_event(6,0,0,0,0);

  #sleep for 20 seconds
  Start-Sleep -Seconds 20
}
