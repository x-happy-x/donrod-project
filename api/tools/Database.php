<?php

namespace api\tools {

    use Error;
    use mysqli;
    use mysqli_result;
    use mysqli_sql_exception;

    class Database
    {

        protected string $user;
        protected string $password;
        protected string $database;
        protected string $server;
        protected string $port;

        protected ?mysqli $db = null;
        protected bool $is_connect = false;

        public string $error = "";

        public function __construct(string $config)
        {
            $url = ROOT_DIR . "/configs/$config-db.json";
            $conf = json_decode(file_get_contents($url), true);
            $this->user = $conf['user'];
            $this->password = $conf['password'];
            $this->database = $conf['database'];
            $this->server = $conf['server'];
            $this->port = $conf['port'];
        }

        public function error(): string
        {
            return $this->db->error;
        }

        public function affected_rows(): int|string
        {
            return $this->db->affected_rows;
        }

        public function connect(): string
        {
            $this->db = new mysqli($this->server, $this->user, $this->password, $this->database, $this->port);
            if ($this->db->connect_errno) {
                $this->is_connect = false;
                return $this->db->error;
            }
            $this->is_connect = true;
            return 'success';
        }

        public function query($sql): int|bool|mysqli_result
        {
            if (!$this->is_connect) $this->connect();
            try {
                return $this->db->query($sql);
            } catch (mysqli_sql_exception $exc) {
                $this->error = $exc;
                return 0;
            }
        }

        public function insert($table, $keys, $values): mysqli_result|bool|int
        {
            return $this->query("INSERT INTO $table ($keys) VALUES ($values)");
        }

        public function delete($table, $where): mysqli_result|bool|int
        {
            return $this->query("DELETE FROM $table WHERE $where");
        }

        public function clear($table): mysqli_result|bool|int
        {
            return $this->query("TRUNCATE `$table`");
        }

        public function run_and_get($name, $row = null)
        {
            $res = $this->run($name, $row);
            try {
                $res = $res->fetch_row();
                if (is_array($res) && count($res) > 0)
                    $res = $res[0];
                else
                    $this->error = "no result";
            } catch (Error $exc) {
                $this->error = $exc;
            }
            return $res;
        }

        public function get($key, $table, $where = null)
        {
            $res = $this->query("SELECT $key FROM $table ".(is_string($where) && strlen($where) > 1?"WHERE $where ":"")." LIMIT 1");
            try {
                $res = $res->fetch_row();
                if (is_array($res) && count($res) > 0)
                    $res = $res[0];
                else
                    $this->error = "no result";
            } catch (Error $exc) {
                $this->error = $exc;
            }
            return $res;
        }

        public function count($table, $where = null)
        {
            return $this->get("count(*)", $table, $where);
        }

        public function run($name, $row = null, $escape_row = true): int|bool|mysqli_result
        {
            if (!$this->is_connect) $this->connect();
            $file = ROOT_DIR . "/templates/sql/" . $name . ".sql";
            $temp = file_get_contents($file);
            $temps = explode(';', $temp);
            $r = 0;
            for ($i = 0; $i < count($temps); $i++) {
                $temp = $temps[$i];
                if (strlen($temp) < 5) continue;
                if (isset($row) && is_array($row)) {
                    if ($escape_row) {
                        foreach (array_keys($row) as $key)
                            $row[$key] = $this->escape_to_string($row[$key]);
                    }
                    foreach (array_keys($row) as $key)
                        $temp = str_replace("{% " . $key . " %}", $row[$key], $temp);
                }
                // echo $temp;
                $r = $this->query($temp);
                if ($i + 1 == count($temps) || !$r) return $r;
            }
            // echo $temp;
            return $r;
        }


        public function union_run($names, $row = null, $limit = 10, $str_cut = 'LIMIT', $query_line = "SELECT * FROM (({% unions %})) T", $query_param = "unions", $join_str = ') UNION ('): mysqli_result|bool|int
        {
            if (!$this->is_connect) $this->connect();
            $t = [];
            if (isset($row) && is_array($row)) {
                foreach (array_keys($row) as $key)
                    $row[$key] = $this->escape_to_string($row[$key]);
            }
            foreach ($names as $name) {
                $file = ROOT_DIR . "/templates/sql/" . $name . ".sql";
                $temp = file_get_contents($file);
                if (isset($row) && is_array($row))
                    foreach (array_keys($row) as $key)
                        $temp = str_replace("{% " . $key . " %}", $row[$key], $temp);
                $str_pos = strpos($temp, $str_cut);
                if ($str_pos !== false)
                    $temp = substr($temp, 0, $str_pos - 1);
                $t[] = $temp;
            }
            if (isset($row) && is_array($row))
                foreach (array_keys($row) as $key)
                    $query_line = str_replace("{% $key %}", $row[$key], $query_line);
            $temp = str_replace("{% $query_param %}", join($join_str, $t), $query_line . " LIMIT $limit");
            // echo $temp;
            return $this->query($temp);
        }

        public function escape_to_string($str): string
        {
            return mysqli_real_escape_string($this->db, $str);
        }

        public function escape_from_string($str): string
        {
            return htmlspecialchars($str);
        }

        public function decode_from_string($str): string
        {
            return htmlspecialchars_decode($str);
        }

        public function close()
        {
            if ($this->is_connect) $this->db->close();
        }

        protected function _get_backup_($db_name, $tables = false, $only_create = false, $delete = true, $limit = 1000): string
        {
            $this->db->select_db($db_name);
            $this->db->query("SET NAMES 'utf8'");
            $queryTables = $this->db->query('SHOW TABLES');
            $used_tables = [];
            $target_tables = [];
            while ($row = $queryTables->fetch_row()) {
                $target_tables[] = $row[0];
            }
            if ($tables !== false) {
                $target_tables = array_intersect($target_tables, $tables);
            }
            $relations = $this->db->query("SELECT TABLE_NAME AS t1, REFERENCED_TABLE_NAME as t2 FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS WHERE CONSTRAINT_SCHEMA='$db_name';")->fetch_all();
            // $relations = [];
            // foreach ($relation as $row) {
            //     $relations[$row[0]] = $row[1];
            // }
            $table = $target_tables[0];
            while (true) {
                $found = false;
                foreach ($relations as $r) {
                    if (strcmp($r[0], $table) === 0 && !in_array($r[1], $used_tables)) {
                        $found = $r[1];
                        break;
                    }
                }
                if ($found !== false) {
                    $table = $found;
                    continue;
                }
                $result = $this->db->query("SELECT * FROM $table LIMIT $limit");
                $fields_amount = $result->field_count;
                $rows_num = $this->db->affected_rows;
                $res = $this->db->query('SHOW CREATE TABLE ' . $table);
                $TableMLine = $res->fetch_row();
                $content = (!isset($content) ? '' : $content) . "\n\n" . $TableMLine[1] . ";\n\n";
                if (!$only_create) {
                    for ($i = 0, $st_counter = 0; $i < $fields_amount; $i++, $st_counter = 0) {
                        while ($row = $result->fetch_row()) { //when started (and every after 100 command cycle):
                            if ($st_counter % 100 == 0 || $st_counter == 0) {
                                $content .= "\nINSERT INTO " . $table . " VALUES";
                            }
                            $content .= "\n(";
                            for ($j = 0; $j < $fields_amount; $j++) {
                                $row[$j] = str_replace("\n", "\\n", addslashes($row[$j]));
                                if ($row[$j] != "") {
                                    $content .= '"' . $row[$j] . '"';
                                } else {
                                    $content .= 'NULL';
                                }
                                if ($j < ($fields_amount - 1)) {
                                    $content .= ',';
                                }
                            }
                            $content .= ")";
                            if ((($st_counter + 1) % 100 == 0 && $st_counter != 0) || $st_counter + 1 == $rows_num) {
                                $content .= ";";
                            } else {
                                $content .= ",";
                            }
                            $st_counter = $st_counter + 1;
                        }
                    }
                }
                $content .= "\n\n\n";
                $used_tables[] = $table;
                array_splice($target_tables, array_search($table, $target_tables), 1);
                if (count($target_tables) > 0) {
                    $table = $target_tables[0];
                } else {
                    break;
                }
            }
            $delete_list = "";
            if ($delete) {
                for ($i = count($used_tables) - 1; $i >= 0; $i--) {
                    $table = $used_tables[$i];
                    $delete_list .= "DROP TABLE IF EXISTS `$table`;\n";
                }
            }
            return $delete_list . "\n\n" . $content;
        }

        function backup($db_name, $tables = false, $backup_name = false)
        {
            $content = $this->_get_backup_($db_name, $tables);
            $backup_name = $backup_name ?: $db_name . "___(" . date('H-i-s') . "_" . date('d-m-Y') . ")__rand" . rand(1, 11111111);
            file_put_contents(ROOT_DIR . "/backups/db/$backup_name.sql", $content);
        }

        function export($db_name, $tables = false, $backup_name = false)
        {
            $content = $this->_get_backup_($db_name, $tables);
            $backup_name = $backup_name ?: $db_name . "___(" . date('H-i-s') . "_" . date('d-m-Y') . ")__rand" . rand(1, 11111111) . ".sql";
            // $backup_name = $backup_name ? $backup_name : $db_name . ".sql";
            header('Content-Type: application/octet-stream');
            header("Content-Transfer-Encoding: Binary");
            header("Content-disposition: attachment; filename=\"" . $backup_name . "\"");
            echo $content;
        }

        public function __destruct()
        {
            $this->close();
        }
    }
}