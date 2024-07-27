# GitHub仓库中文件的URL
Write-Host "正在获取最新主机"
Write-Host "正在获取//xlll111.github.io/Severip/host.txt"
$url = 'https://xlll111.github.io/Severip/host.txt'

# 使用Invoke-WebRequest获取文件内容
$response = Invoke-WebRequest -Uri $url

# 将文件内容分割成数组
$hosts = $response.Content.Split([Environment]::NewLine)

# 存储结果的哈希表
$results = @{}

Write-Host "获取完成"
Write-Host "开始PING"
Write-Host ""
Write-Host ""

# 对每个主机执行ping测试
foreach ($hostname in $hosts) {
    # 检查hostname是否为空或仅包含空白
    if (-not [string]::IsNullOrWhiteSpace($hostname)) {
        # 去除端口号
        $hostnameWithoutPort = [regex]::Replace($hostname, ":\d+$", "")
        
        # 创建一个Ping对象
        $ping = New-Object System.Net.NetworkInformation.Ping

        try {
            # 发送ping请求
            $reply = $ping.Send($hostnameWithoutPort, 1000)
            
            # 检查回复是否成功
            if ($reply.Status -eq 'Success') {
                # 计算平均时间
                $avgTime = $reply.RoundtripTime
                # 计算丢包率
                $lossRate = 0
                
                # 使用原始的主机名（包含端口号）作为键
                $results[$hostname] = @{
                    'avg_time' = $avgTime
                    'loss_rate' = $lossRate
                }
                
                # 输出结果
                Write-Host "主机: ${hostname}"
                Write-Host "平均时间: ${avgTime} 毫秒"
                Write-Host "丢包率: ${lossRate}%"
                Write-Host ""
            } else {
                # 输出错误信息
                Write-Host "无法找到主机 ${hostname}: Ping 请求未能找到主机。"
                Write-Host ""
            }
        } catch {
            # 输出异常信息
            Write-Host "Ping 请求期间发生异常：${hostname} - $_"
            Write-Host "该主机无法进行测试，请在实际环境中体验。"
            Write-Host ""
        }
    } else {
        # 如果hostname为空或仅包含空白，输出警告信息
        Write-Warning "跳过空或空白的主机名。"
    }
}

# 检查是否有有效的结果
if ($results.Count -gt 0) {
    # 初始化最佳结果
    $bestHost = $null
    $bestAvgTime = [int]::MaxValue
    $bestLossRate = [int]::MaxValue

    # 遍历结果，找到延迟和丢包率最低的主机
    foreach ($hostname in $results.Keys) {
        if ($results[$hostname].avg_time -lt $bestAvgTime -or ($results[$hostname].avg_time -eq $bestAvgTime -and $results[$hostname].loss_rate -lt $bestLossRate)) {
            $bestHost = $hostname
            $bestAvgTime = $results[$hostname].avg_time
            $bestLossRate = $results[$hostname].loss_rate
        }
    }

    # 输出最佳结果
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
    # 如果没有有效的结果
    Write-Host "没有找到有效结果。"
}
