$smtp = "SMTP Address"
$FromEmail = "Email Address"
$subject = "Subject Line"

$body = "Body"              

$smtpServ = new-object Net.Mail.SmtpClient($smtp)
$msg = new-object Net.Mail.MailMessage
$msg.Subject = $subject
$msg.From = $FromEmail
$msg.IsBodyHtml = $True
$msg.To.Add("ToEmail")
$msg.Body = $body

$smtpServ.Send($msg)