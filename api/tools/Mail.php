<?php

namespace api\tools {

    class Mail
    {

        protected string $name;
        protected string $mail;
        protected string $charset;
        public bool $send_error = false;
        private string $mail_headers;
        private string $subject;
        private string $host;
        private string $to;

        public function __construct(string $config)
        {
            $url = ROOT_DIR . "configs/$config-mail.json";
            $conf = json_decode(file_get_contents($url), true);
            $this->mail = $conf['email'];
            $this->host = $conf['host'];
            $this->name = $conf['name'];
            $this->charset = 'utf8';
        }

        private function compile_headers()
        {
            $this->subject = "=?" . $this->charset . "?b?" . base64_encode($this->subject) . "?=";
            $from = "=?" . $this->charset . "?b?" . base64_encode($this->name) . "?=";
            $this->mail_headers = "MIME-Version: 1.0" . "\n";
            $this->mail_headers .= "Content-type: text/plain; charset=\"" . $this->charset . "\"" . "\n";
            $this->mail_headers .= "Subject: " . $this->subject . "\n";
            $this->mail_headers .= "To: " . $this->to . "\n";
            $this->mail_headers .= "From: \"" . $from . "\" <" . $this->mail . ">" . "\n";
            $this->mail_headers .= "Return-Path: <" . $this->mail . ">" . "\n";
            $this->mail_headers .= "X-Priority: 3" . "\n";
            $this->mail_headers .= "X-Mailer: PHP" . "\n";
        }

        public function send(string $to, string $subject, string $message): bool
        {
            $this->to = $to;
            $this->subject = $subject;
            $this->send_error = false;
            $this->compile_headers();
            if ($this->to && $this->mail && $this->subject) {
                ini_set("SMTP", $this->host);
                ini_set("sendmail_from", $this->mail);
                if (!@mail($this->to, $this->subject, $message, $this->mail_headers)) {
                    $this->send_error = true;
                }
            }
            return $this->send_error;
        }
    }
}