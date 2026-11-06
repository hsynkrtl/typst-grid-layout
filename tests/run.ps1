$ErrorActionPreference = "Continue"

$typst = Get-Command typst -ErrorAction SilentlyContinue
if ($null -eq $typst) {
  throw "Typst was not found on PATH."
}

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$tempDirectory = Join-Path ([System.IO.Path]::GetTempPath()) ("typst-grid-layout-tests-" + [guid]::NewGuid().ToString("N"))
New-Item -ItemType Directory -Path $tempDirectory | Out-Null

try {
  $validTest = Join-Path $PSScriptRoot "valid.typ"
  $outputFile = Join-Path $tempDirectory "valid.pdf"
  $output = & typst compile --root $repoRoot $validTest $outputFile 2>&1
  if ($LASTEXITCODE -ne 0) {
    throw "Valid configuration test failed:`n$($output -join "`n")"
  }

  $svgFile = Join-Path $tempDirectory "valid-{p}.svg"
  $output = & typst compile --root $repoRoot --format svg $validTest $svgFile 2>&1
  if ($LASTEXITCODE -ne 0) {
    throw "Valid layout rendering test failed:`n$($output -join "`n")"
  }
  $renderedSvg = Get-Content (Join-Path $tempDirectory "valid-1.svg") -Raw
  $cellBorderCount = [regex]::Matches($renderedSvg, 'stroke="#ff4136"').Count
  if ($cellBorderCount -ne 12) {
    throw "Expected twelve debug border segments for three cells, found $cellBorderCount."
  }
  Write-Output "PASS valid configurations, rendering, and split cells"

  $failureCases = @(
    @{ File = "missing-columns.typ"; Message = "The ``columns`` argument is required." },
    @{ File = "zero-columns.typ"; Message = "The column count must be greater than zero." },
    @{ File = "empty-columns.typ"; Message = "The ``columns`` array must not be empty." },
    @{ File = "invalid-columns.typ"; Message = "``columns`` must be a positive integer or an array of track sizes." },
    @{ File = "invalid-span.typ"; Message = "A cell span must be at least 1." },
    @{ File = "too-many-layout-arguments.typ"; Message = "layout() accepts at most one positional argument." },
    @{ File = "named-layout-argument.typ"; Message = "layout() does not accept named arguments." }
  )

  foreach ($testCase in $failureCases) {
    $inputFile = Join-Path $PSScriptRoot $testCase.File
    $outputFile = Join-Path $tempDirectory ($testCase.File + ".pdf")
    $output = & typst compile --root $repoRoot $inputFile $outputFile 2>&1
    if ($LASTEXITCODE -eq 0) {
      throw "Expected $($testCase.File) to fail, but compilation succeeded."
    }

    $diagnostic = $output -join "`n"
    if (-not $diagnostic.Contains($testCase.Message)) {
      throw "$($testCase.File) failed with an unexpected diagnostic:`n$diagnostic"
    }
    Write-Output "PASS $($testCase.File)"
  }
}
finally {
  Remove-Item -LiteralPath $tempDirectory -Recurse -Force
}
