# scan-dependencies.ps1 — deterministic dependency manifest scanner
# Outputs JSON to stdout for use by /context/seed-context and /context/update-context.
# Never guess versions; only parse known manifest formats.

param(
    [string]$Root = (Split-Path (Split-Path $PSScriptRoot -Parent) -Parent)
)

$ErrorActionPreference = 'SilentlyContinue'
$results = @{
    scanned_at = (Get-Date -Format 'yyyy-MM-ddTHH:mm:ssK')
    root       = (Resolve-Path $Root).Path
    manifests  = @()
    packages   = @()
}

function Add-Packages($source, $items) {
    foreach ($item in $items) {
        $results.packages += [ordered]@{
            name    = $item.name
            version = $item.version
            scope   = $item.scope
            source  = $source
        }
    }
}

# npm / node: package.json
Get-ChildItem -Path $Root -Filter 'package.json' -Recurse -File |
    Where-Object { $_.FullName -notmatch 'node_modules|\.context' } |
    ForEach-Object {
        $rel = $_.FullName.Substring($Root.Length).TrimStart('\', '/')
        $results.manifests += $rel
        try {
            $json = Get-Content $_.FullName -Raw | ConvertFrom-Json
            $scopes = @(
                @{ key = 'dependencies'; scope = 'runtime' },
                @{ key = 'devDependencies'; scope = 'dev' },
                @{ key = 'peerDependencies'; scope = 'peer' },
                @{ key = 'optionalDependencies'; scope = 'optional' }
            )
            foreach ($s in $scopes) {
                if ($json.PSObject.Properties.Name -contains $s.key -and $json.($s.key)) {
                    $json.($s.key).PSObject.Properties | ForEach-Object {
                        Add-Packages $rel @([ordered]@{ name = $_.Name; version = $_.Value; scope = $s.scope })
                    }
                }
            }
        } catch { }
    }

# Python: requirements.txt
Get-ChildItem -Path $Root -Filter 'requirements*.txt' -Recurse -File |
    Where-Object { $_.FullName -notmatch 'node_modules|\.context|\.venv|venv' } |
    ForEach-Object {
        $rel = $_.FullName.Substring($Root.Length).TrimStart('\', '/')
        $results.manifests += $rel
        Get-Content $_.FullName | ForEach-Object {
            $line = $_.Trim()
            if ($line -and $line -notmatch '^\s*#' -and $line -notmatch '^-r ') {
                if ($line -match '^([a-zA-Z0-9_\-\.]+)\s*(?:==|>=|<=|~=|!=|>|<)\s*(.+)$') {
                    Add-Packages $rel @([ordered]@{ name = $Matches[1]; version = $Matches[2]; scope = 'runtime' })
                } elseif ($line -match '^([a-zA-Z0-9_\-\.]+)$') {
                    Add-Packages $rel @([ordered]@{ name = $Matches[1]; version = '(unpinned)'; scope = 'runtime' })
                }
            }
        }
    }

# Python: pyproject.toml (basic [project.dependencies] extraction)
Get-ChildItem -Path $Root -Filter 'pyproject.toml' -Recurse -File |
    Where-Object { $_.FullName -notmatch 'node_modules|\.context|\.venv|venv' } |
    ForEach-Object {
        $rel = $_.FullName.Substring($Root.Length).TrimStart('\', '/')
        $results.manifests += $rel
        $content = Get-Content $_.FullName -Raw
        if ($content -match '(?ms)\[project\.dependencies\]\s*\n((?:[^\[]|\[(?!project))*?)(?=\[|$)') {
            $block = $Matches[1]
            [regex]::Matches($block, '"([^"]+)"') | ForEach-Object {
                $dep = $_.Groups[1].Value
                if ($dep -match '^([a-zA-Z0-9_\-\.]+)(.*)$') {
                    Add-Packages $rel @([ordered]@{ name = $Matches[1]; version = ($Matches[2].Trim() -replace '^[=<>~!]+', ''); scope = 'runtime' })
                }
            }
        }
    }

# Rust: Cargo.toml [dependencies]
Get-ChildItem -Path $Root -Filter 'Cargo.toml' -Recurse -File |
    Where-Object { $_.FullName -notmatch 'node_modules|\.context|target' } |
    ForEach-Object {
        $rel = $_.FullName.Substring($Root.Length).TrimStart('\', '/')
        $results.manifests += $rel
        $content = Get-Content $_.FullName -Raw
        if ($content -match '(?ms)\[dependencies\]\s*\n((?:[^\[]|\[(?!dependencies))*?)(?=\[|$)') {
            $block = $Matches[1]
            $block -split "`n" | ForEach-Object {
                $line = $_.Trim()
                if ($line -and $line -notmatch '^\s*#' -and $line -match '^([a-zA-Z0-9_\-\.]+)\s*=\s*"?([^"#]+)"?') {
                    Add-Packages $rel @([ordered]@{ name = $Matches[1]; version = $Matches[2].Trim(); scope = 'runtime' })
                }
            }
        }
    }

# Go: go.mod require block
Get-ChildItem -Path $Root -Filter 'go.mod' -Recurse -File |
    Where-Object { $_.FullName -notmatch 'node_modules|\.context' } |
    ForEach-Object {
        $rel = $_.FullName.Substring($Root.Length).TrimStart('\', '/')
        $results.manifests += $rel
        $inRequire = $false
        Get-Content $_.FullName | ForEach-Object {
            if ($_ -match '^\s*require\s*\(') { $inRequire = $true; return }
            if ($inRequire -and $_ -match '^\s*\)') { $inRequire = $false; return }
            if ($inRequire -and $_ -match '^\s*([^\s]+)\s+([^\s]+)') {
                Add-Packages $rel @([ordered]@{ name = $Matches[1]; version = $Matches[2]; scope = 'runtime' })
            }
        }
    }

# .NET: *.csproj PackageReference
Get-ChildItem -Path $Root -Filter '*.csproj' -Recurse -File |
    Where-Object { $_.FullName -notmatch 'node_modules|\.context' } |
    ForEach-Object {
        $rel = $_.FullName.Substring($Root.Length).TrimStart('\', '/')
        $results.manifests += $rel
        [xml]$xml = Get-Content $_.FullName
        $xml.Project.ItemGroup.PackageReference | ForEach-Object {
            Add-Packages $rel @([ordered]@{ name = $_.Include; version = $_.Version; scope = 'runtime' })
        }
    }

$results.manifests = @($results.manifests | Select-Object -Unique | Sort-Object)
$results | ConvertTo-Json -Depth 6
