# Exchange PowerShell modülünü yükle
 
Add-PSSnapin Microsoft.Exchange.Management.PowerShell.SnapIn
 
#Kullanıcıları ve Mailtips bilgileri tanımla
 
$users = @("testuser1@contoso.com","testuser2@contoso.com","testuser3@contoso.com")
$mailtips = @("Lutfen, Sifrenizi kimseyle paylasmayın"," Supheli emailler için addin butonunu kullanınız")
 
# Her bir kullanıcı için rastgele bir cümle seçme ve MailTips olarak atama
 
foreach ($user in $users) 
{
    $mailbox = get-mailbox $user
    # Rastgele bir cümle seçme
    $randomSentence = $mailtips | Get-Random
    # Kullanıcıya rastgele cümleyi MailTips olarak atama
    Set-Mailbox -Identity $mailbox -MailTip $randomSentence
}