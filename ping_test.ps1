$hostsFilePath = Join-Path ([System.IO.Path]::GetTempPath()) "host.txt"
$hosts = Get-Content $hostsFilePath
$results = @{}
Write-Host "获取完成"
Write-Host "开始PING"
Write-Host ""
Write-Host ""
foreach ($hostname in $hosts) {   
    if (-not [string]::IsNullOrWhiteSpace($hostname)) {
        $hostnameWithoutPort = [regex]::Replace($hostname, ":\d+$", "")
        $ping = New-Object System.Net.NetworkInformation.Ping
        try {
            $reply = $ping.Send($hostnameWithoutPort, 1000)
            if ($reply.Status -eq 'Success') { 
                $avgTime = $reply.RoundtripTime
                $lossRate = 0
                $results[$hostname] = @{
                    'avg_time' = $avgTime
                    'loss_rate' = $lossRate
                }
                Write-Host "主机: ${hostname}"
                Write-Host "平均时间: ${avgTime} 毫秒"
                Write-Host "丢包率: ${lossRate}%"
                Write-Host ""
            } else {
                Write-Host "无法找到主机 ${hostname}: Ping 请求未能找到主机。"
                Write-Host ""
            }
        } catch {
            Write-Host "Ping 请求期间发生异常：${hostname} - $_"
            Write-Host "该主机无法进行测试，请在实际环境中体验。"
            Write-Host ""
        }
    } else {
        Write-Warning "跳过空或空白的主机名。"
    }
}
if ($results.Count -gt 0) {
    $bestHost = $null
    $bestAvgTime = [int]::MaxValue
    $bestLossRate = [int]::MaxValue
    foreach ($hostname in $results.Keys) {
        if ($results[$hostname].avg_time -lt $bestAvgTime -or ($results[$hostname].avg_time -eq $bestAvgTime -and $results[$hostname].loss_rate -lt $bestLossRate)) {
            $bestHost = $hostname
            $bestAvgTime = $results[$hostname].avg_time
            $bestLossRate = $results[$hostname].loss_rate
        }
    }
    if ($bestHost) {
        Write-Host ""
        Write-Host ""
        Write-Host ""
        Write-Host ""
        Write-Host "以下是最佳主机"
        Write-Host ""
        Write-Host "最佳主机: ${bestHost}"
        Write-Host "平均时间: ${bestAvgTime} 毫秒"
        Write-Host "丢包率: ${bestLossRate}%"
    } else {
        Write-Host "没有找到有效结果。"
    }
} else {
    
    Write-Host "没有找到有效结果。"
}
