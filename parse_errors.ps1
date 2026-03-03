$inputFile = "TRANSFER_ERRORS.txt"
$outputFile = "FORMATED_TRANSFERS.csv"

# Servers list
$servers = @{
    "12" = "classic"
    "13" = "cent"
    "14" = "pro"
    "15" = "demo"
}

$result = @()

Get-Content $inputFile | ForEach-Object {

    $line = $_

    # account
    if ($line -match 'Account number #(\d+) \((.*?)\)') {
        $fromAcc = "$($matches[1])-$($matches[2])"
    }

    # amount
    if ($line -match ',\s*(-?[0-9]+(?:\.[0-9]+)?\s+USD)') {
    $amount = $matches[1]
    }

    # comment T:30129682:12:7001404
    if ($line -match 'T:(\d+):(\d+):(\d+)') {

        $toLogin = $matches[1]
        $serverId = $matches[2]
        $transferId = $matches[3]

        $serverName = $servers[$serverId]

        if (-not $serverName) {
            $serverName = "srv$serverId"
        }

        $toAcc = "$toLogin-$serverName"

        $result += [PSCustomObject]@{
            transfer_id = $transferId
            from        = $fromAcc
            to          = $toAcc
            amount      = $amount
        }
    }
}

$result | Export-Csv $outputFile -NoTypeInformation -Encoding UTF8 -Delimiter "`t"

Write-Host "[Done]: Result in FORMATED_TRANSFERS.csv file) //!\\ JUST COPY Result from file -> PASTE (CTRL+V) IN EXCEL //!\\"
