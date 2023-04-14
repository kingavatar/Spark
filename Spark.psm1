# Spark.psm1

function spark
{
  <#
    .SYNOPSIS
      This module is a very simple way to generate sparklines for powershell.
    .DESCRIPTION
      This module is a simple and efficient way to generate sparklines for powershell.
      This was ported from https://github.com/holman/spark which works for bash shell.

      This module exports a simple function spark which accepts integer array Input
      like 1,2,3,4 or (echo 1 2 3 4) either as piped or as argument like
      spark 1,2,3,4 , echo 1 2 3 4 | spark etc.

      This module doesn't implement any coloring which can achieved by piping the result
      into lolcat which was installed for windows machine.
    .EXAMPLE
      PS> spark 1,4,5,2

      Displays ▁▆█▃
      PS> spark (1..(tput cols))

      Displays a increasing sparkline for entire width of terminal
      PS> Get-Random -Min 1 -Max (tput cols) -Count (tput cols) | spark | lolcat

      Displays a Random colored sparklines for entire width of terminal

    .LINK
      https://github.com/kingavatar/SparkModule
  #>
  [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseBOMForUnicodeEncodedFile', '')]
  [CmdletBinding()]
  param(
    [Parameter(Mandatory=$false)]
    [switch]$h,

    [Parameter(Mandatory=$false)]
    [switch]$help,

    [Parameter(Mandatory=$false)]
    [switch]${-help},
    [Parameter(ValueFromPipeline = $true)]
    [int[]]$InputObject
  )

  begin
  {
    $sparkChars = "▁▂▃▄▅▆▇█"
    $sparkLen = $sparkChars.Length - 1
    $numbers = @()
  }

  process
  {
    if(-not $h -and -not $help -and -not ${-help} -and $InputObject)
    {
      # Append each input number to the array
      $numbers += $InputObject
    }
  }

  end
  {
    if ($h -or $help -or ${-help})
    {
      Write-Output "    usage: spark <numbers...>  Draw sparklines`
    examples: `
      spark 1,2,3,4,5 `
      spark (echo 1 2 3 4) `
      echo 1 2 3 4 | spark `
      seq 1 (tput cols) | spark `
      Get-Random -Min 1 -Max (tput cols) -Count (tput cols) | spark | lolcat`
    Options:  -h, -help Print help"
    }

    if ($numbers.Count -gt 0)
    {
      $stats = $numbers | Measure-Object -Minimum -Maximum
      $min = $stats.Minimum
      $max = $stats.Maximum
      $range = $max - $min
      if ($range -eq 0)
      { $range = 1
        $sparkChars = "▅▆"
      }
      foreach ($num in $numbers)
      {
        $index = [Math]::Round(($num - $min) / $range * $sparkLen)
        $output += ($sparkChars[$index])
      }
      Write-Output $output
    } else
    {
      Write-Output "    usage: spark <numbers...>  Draw sparklines`
    examples: `
      spark 1,2,3,4,5 `
      spark (echo 1 2 3 4) `
      echo 1 2 3 4 | spark `
      seq 1 (tput cols) | spark `
      Get-Random -Min 1 -Max (tput cols) -Count (tput cols) | spark | lolcat`
    Options:  -h, -help Print help"
    }
  }
}

Export-ModuleMember -Function spark
