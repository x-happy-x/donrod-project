<?php

namespace api\tools {

    class Permissions
    {
        public array $data;

        public function __construct(Database $db, int $class = 5)
        {
            $this->data = [];
            $res = $db->query("SELECT name, value FROM user_permission WHERE class = $class");
            foreach ($res->fetch_all(MYSQLI_ASSOC) as $row)
                $this->data[$row['name']] = $row['value'];
        }

        public function get(string $data, string $type): bool
        {
            if (isset($this->data['full']) && str_contains($this->data['full'], 'access')) {
                return true;
            } elseif (isset($this->data[$data])) {
                return str_contains($this->data[$data], $type);
            } else {
                return false;
            }
        }

        public function read(string $data): bool
        {
            return $this->get($data, "read");
        }

        public function write(string $data): bool
        {
            return $this->get($data, "write");
        }

        public function add(string $data): bool
        {
            return $this->get($data, "add");
        }

        public function delete(string $data): bool
        {
            return $this->get($data, "delete");
        }
    }
}