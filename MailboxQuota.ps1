<#
MailAdresi

#>
 
 #Parametleri dışarıdan alacaksak burası aktif edilir

 #Param(
#	[parameter(Mandatory=$true)]
#	[String]$KullaniciAdi
 # )
 
#exchange komutlarını tanıtmak için
Add-PSSnapin Microsoft.Exchange.Management.PowerShell.SnapIn
 
#Tum forestteski sunucuların bilgilerini görebilmek için
#Set-AdServerSettings -ViewEntireForest $true
 
#Kullanıcının e-posta adresini belirtin
 
$KullaniciAdi = "test1@contoso.com"
$EklemeMiktariMB = 250
 
#Kullanıcı mevcudiyetini kontrol etmek.
 
$KontrolMailbox = Get-Mailbox -Identity $KullaniciAdi -ErrorAction SilentlyContinue
 
if ($KontrolMailbox -eq $null)
 
{ 
Write-Host "Kullanıcı için posta kutusu bulunamadı." 
}
 
else
{
 
# Kullanıcının posta kutusu istatistiklerini alın
 
$PostaKutusuIstatistikleri = Get-MailboxStatistics -Identity $KullaniciAdi
$PostaKutusu = Get-Mailbox -Identity $KullaniciAdi
 
# Kullanıcının kullanılan kota limitini alın
 
 
if ($PostaKutusu.ProhibitSendQuota.Value -eq $null)
 
{
$ProhibitSendQuotaMB = $PostaKutusuIstatistikleri.DatabaseProhibitSendQuota.Value.ToMB()
$IssueWarningQuotaMB = $PostaKutusuIstatistikleri.DatabaseIssueWarningQuota.Value.ToMB()
$ProhibitSendReceiveQuotaMB = $PostaKutusuIstatistikleri.DatabaseProhibitSendReceiveQuota.Value.ToMB()
}
 
else 
{
$ProhibitSendQuotaMB = $PostaKutusu.ProhibitSendQuota.Value.ToMB()
$IssueWarningQuotaMB = $PostaKutusu.IssueWarningQuota.Value.ToMB()
$ProhibitSendReceiveQuotaMB = $PostaKutusu.ProhibitSendReceiveQuota.Value.ToMB()
}
 
# Kota kullanımını yüzde olarak hesaplayın
 
$KullanilanKotaMB = $PostaKutusuIstatistikleri.TotalItemSize.Value.ToMB()
$KotaKullanimYuzdesi = ($KullanilanKotaMB / $ProhibitSendQuotaMB) * 100
 
# Eğer kota kullanımı %90 veya daha fazlaysa, ek alan ekleyin
 
if ($KotaKullanimYuzdesi -ge 90) 
{
    Write-Host "Kullanıcının posta kutusu kotası %90 veya daha fazla dolu. $EklemeMiktariMB MB ek alan ekleniyor."
    Set-Mailbox -Identity $KullaniciAdi -IssueWarningQuota ("$($IssueWarningQuotaMB + $EklemeMiktariMB) MB")  -ProhibitSendQuota ("$($ProhibitSendQuotaMB + $EklemeMiktariMB) MB") -ProhibitSendReceiveQuota ("$($ProhibitSendReceiveQuotaMB + $EklemeMiktariMB) MB") -UseDatabaseQuotaDefaults:$false 
}
Else
{
    Write-Host "Kullanıcının posta kutusu kotası %90'dan az dolu. Ek alan eklemeye gerek yok."
}
}
