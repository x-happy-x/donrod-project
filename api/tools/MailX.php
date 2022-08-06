<?php

namespace api\tools;

use api\tools\PHPMailer\Exception;
use api\tools\PHPMailer\PHPMailer;

class MailX
{
    private array $config;

    public function __construct(string $config)
    {
        $url = ROOT_DIR . "configs/$config-mail.json";
        $conf = json_decode(file_get_contents($url), true);
        $this->config = $conf;
    }

    public function send(array|string $to, string $subject, string $message, string $altMessage = '', array $attachment = null, $useSMTP = false): bool|string
    {
        $mail = new PHPMailer(true);

        try {
            // Подключение к почтовому сервису
            // $mail->SMTPDebug = SMTP::DEBUG_SERVER;
            $mail->Host = $this->config['host'];
            if ($useSMTP) {
                $mail->isSMTP();
                $mail->SMTPAuth = true;
                $mail->Username = $this->config['send-mail'];
                $mail->Password = $this->config['password'];
                $mail->SMTPSecure = PHPMailer::ENCRYPTION_SMTPS;
                $mail->Port = $this->config['port'];
            }
            //TCP port to connect to; use 587 if you have set `SMTPSecure = PHPMailer::ENCRYPTION_STARTTLS`

            // Настраивание адресов
            $mail->setFrom($this->config['send-mail'], $this->config['name']);
            if (is_string($to)) {
                $mail->addAddress($to);
            } else {
                foreach ($to as $user) {
                    $mail->addAddress($user['mail'], $user['name'] ?? '');
                }
            }
            $mail->addReplyTo($this->config['reply-mail'], $this->config['name']);
            if (isset($this->config['bcc-mail']))
                $mail->addBCC($this->config['bcc-mail']);

            // Прикрепить файлы
            if ($attachment != null) {
                foreach ($attachment as $attach) {
                    $mail->addAttachment($attach['path'], $attach['name'] ?? '');
                }
            }

            // Содержимое письма
            $mail->isHTML(true);
            $mail->Subject = $subject;
            $mail->Body = $message;
            $mail->AltBody = $altMessage;
            $mail->CharSet = $this->config['charset'];

            $mail->send();
            return true;

        } catch (Exception) {
            return "Сообщение не было отправлено. Error: $mail->ErrorInfo";
        }
    }

    public function sendToUser(User $user, string $subject, string $message, string $altMessage = '', array $attachment = null, $useSMTP = false): bool|string
    {
        if ($user->auth)
            return $this->send(array(
                array(
                    "mail" => $user->mail,
                    "name" => $user->name
                )
            ), $subject, $message, $altMessage, $attachment, $useSMTP);
        else
            return "Пользователь не авторизован";
    }

    public function sendTemplate(Database $db, array|string $to, string $template, array $keys, $attachment = null, $useSMTP = false): bool|string
    {
        $subjectText = $db->run_and_get("user/mail/get-template", ['name' => $template . '-title']);
        if (!is_string($subjectText)) {
            echo 'dassd' . $subjectText . $db->error;
            return $db->error();
        }
        $subjectText = Templates::templateText($subjectText, $keys);
        $messageText = $db->run_and_get("user/mail/get-template", ['name' => $template . '-message']);
        if (!is_string($messageText)) {
            echo 'dassd' . $messageText . $db->error;
            return $db->error();
        }
        $messageText = Templates::templateText($messageText, $keys);
        return $this->send($to, $subjectText, $messageText, attachment: $attachment, useSMTP: $useSMTP);
    }

    public function sendTemplateToUser(Database $db, User $user, string $template, array $keys, $attachment = null, $useSMTP = false): bool|string
    {
        if ($user->auth)
            return $this->sendTemplate($db, array(
                array(
                    "mail" => $user->mail,
                    "name" => $user->name
                )
            ), $template, $keys, $attachment, $useSMTP);
        else
            return "Пользователь не авторизован";
    }
}