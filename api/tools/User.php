<?php

namespace api\tools {

    class User
    {

        public int $id = -1;
        public int $session_id = -1;
        public string $name;
        public string $mail;
        public string $pass;
        public int $class;
        public string $token;
        public ?Permissions $permissions = null;

        public array $result;
        public bool $auth = false;

        private string $pass_regex = "/^(?=\S{8,})(?=\S*[a-z])(?=\S*[A-Z])(?=\S*[\d])\w*$/";

        protected Database $db;

        public function __construct(Database $db, string $token = '')
        {
            $this->db = $db;
            $this->result = [];
            $this->auth(token: $token);
        }

        public function perm(): Permissions
        {
            if ($this->permissions == null)
                $this->permissions = new Permissions($this->db);
            return $this->permissions;
        }

        private function validMail(string $email, bool $auth = true): bool
        {
            $this->result['message'] = "";
            if (filter_var($email, FILTER_VALIDATE_EMAIL)) {
                $this->result['message'] = "Указанный адрес электронной почты уже зарегистрирован";
                return $auth || $this->db->get("COUNT(*)", "users", "mail = '$email'") == 0;
            }
            return false;
        }

        private function validName(string $name): bool
        {
            if (strlen($name) > 0) {
                return true;
            }
            return false;
        }

        private function validPass(string $pass): bool
        {
            return strlen($pass) < 32 && preg_match($this->pass_regex, $pass);
        }

        public function reg(string $name, string $mail, string $pass, int $class = 4): bool
        {
            if (!$this->auth) {
                $name = str_replace(array("/", "'" . '"', "|", "\\", "?", ":", ";"), "", $name);
                if (!$this->validName($name)) {
                    $this->result['success'] = 0;
                    $this->result['message'] = "Не верно указано имя";
                    $this->auth = false;
                    return false;
                } else if (!$this->validMail($mail, false)) {
                    $this->result['success'] = 0;
                    if (strlen($this->result['message']) == 0)
                        $this->result['message'] = "Не верно указан адрес электронной почты";
                    $this->auth = false;
                    return false;
                } else if (!$this->validPass($pass)) {
                    $this->result['success'] = 0;
                    $this->result['message'] = "Не верно указан пароль";
                    $this->auth = false;
                    return false;
                }
                if (is_numeric($class) && $this->db->run("user/get-class-auth", ['id' => 'id = ' . $class])->num_rows > 0) {
                    $r = $this->db->run("user/insert", ['name' => $name, 'mail' => $mail, 'pass' => $pass, 'class' => $class]);
                    $r = $r > 0 && $this->auth($mail, $pass);
                    if ($r) {
                        $this->sendMailTemplate("register");
                    }
                    return $r;
                }
                $this->result['success'] = 0;
                $this->result['message'] = "Не верно указан тип пользователя";
                return false;
            }
            return true;
        }

        private function set_data($query): void
        {
            $user = $query->fetch_assoc();
            $this->id = $user['id'];
            $this->name = $user['name'];
            $this->mail = $user['mail'];
            $this->pass = $user['pass'];
            $this->class = $user['class'];
            if (isset($user['session']))
                $this->session_id = $user['session'];
            $this->permissions = new Permissions($this->db, $this->class);
        }

        public function save_activity(): bool {
            $ip = $_SERVER['REMOTE_ADDR'];
            $id = $this->id >= 0? $this->id."" : "NULL";
            $res = $this->db->insert("user_history", "user, ip, data", "$id, '$ip', '".json_encode($_SERVER['REQUEST_URI'], JSON_UNESCAPED_UNICODE)."'");
            return $res === true || $res === 1;
        }

        public function auth(string $mail = '', string $pass = '', string $token = ''): bool
        {
            if (!$this->auth) {
                if (isset($token) && is_string($token) && strlen($token) > 0) {
                    $this->token = $token;
                    $query = $this->db->run("user/auth/get-session", ["token" => $this->token]);
                    if ($query->num_rows == 0) {
                        $this->result['success'] = 0;
                        $this->result['message'] = "Токен авторизации не верный, либо просрочен";
                        return false;
                    }
                    $this->set_data($query);
                    $this->save_activity();
//                    if ($this->save_activity())
//                        echo 'success';
//                    else
//                        echo $this->db->error();
                } else {
                    if (!$this->validMail($mail)) {
                        $this->result['success'] = 0;
                        $this->result['message'] = "Не верно указан адрес электронной почты";
                        $this->auth = false;
                        return false;
                    } else if (!$this->validPass($pass)) {
                        $this->result['success'] = 0;
                        $this->result['message'] = "Не верно указан пароль";
                        $this->auth = false;
                        return false;
                    }

                    $query = $this->db->run("user/auth/get", ['mail' => $mail, 'pass' => $pass]);
                    if ($query->num_rows == 0) {
                        $this->result['success'] = 0;
                        $this->result['message'] = "Не верный адрес электорнной почты или пароль";
                        return false;
                    }

                    $this->set_data($query);

                    $this->token = md5(microtime() . $this->mail . $this->pass . time());
                    if ($this->db->run("user/auth/insert", ["user" => $this->id, "token" => $this->token, "app" => "site"])) {
                        setcookie('auth_token', $this->token, strtotime("+30 days"), "/");
                        $this->session_id = $this->db->get('id', 'auth', "user = $this->id AND token = '$this->token'");
                    } else {
                        return false;
                    }
                }
                $this->auth = true;
            }
            return true;
        }

        public function sendMail(string $subject, string $message, string $altMessage = '', array $attachment = null): array
        {
            $mail = new MailX("donrod");
            $result = [];
            $result['message'] = $mail->sendToUser($this, $subject, $message, $altMessage, $attachment);
            if ($result['message'] === true) {
                $result['success'] = 1;
                $result['message'] = 'Сообщение отправлено';
            } else {
                $result['success'] = 0;
            }
            return $result;
        }

        public function sendMailTemplate(string $template, array $keys = null, array $attachment = null): array
        {
            $result = [];
            if (!$this->auth) {
                $result['success'] = 0;
                $result['message'] = 'Вы не авторизованы';
                return $result;
            }
            $mail = new MailX("donrod");
            if ($keys == null) {
                $keys = [];
            }
            $keys['url'] = (isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] === 'on'? "https" : "http")."://$_SERVER[HTTP_HOST]";
            $keys['user->id'] = $this->id;
            $keys['user->name'] = $this->name;
            $keys['user->mail'] = $this->mail;
            $keys['user->pass'] = $this->pass;
            $keys['user->class'] = $this->class;
            $result['message'] = $mail->sendTemplateToUser($this->db, $this, $template, $keys, $attachment);
            if ($result['message'] === true) {
                $result['success'] = 1;
                $result['message'] = 'Сообщение отправлено';
            } else {
                $result['success'] = 0;
            }
            return $result;
        }
    }
}
