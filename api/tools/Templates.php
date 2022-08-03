<?php

namespace api\tools {

    class Templates
    {
        // Шаблонизатор
        public static function templateText($text, $row = null): bool|array|string
        {
            if (isset($row) && is_array($row)) {
                foreach (array_keys($row) as $key) {
                    $text = self::replace_template($text, $key, $row[$key]);
                }
            }
            return $text;
        }

        // Шаблонизатор
        public static function template($name, $row = null): bool|array|string
        {
            $file = ROOT_DIR . "/templates/" . $name . ".php";
            $temp = file_get_contents($file);
            if (isset($row) && is_array($row)) {
                foreach (array_keys($row) as $key) {
                    $temp = self::replace_template($temp, $key, $row[$key]);
                }
            }
            return $temp;
        }

        // Мульти-шаблонизатор (для списков)
        public static function multi_template($name, $result, $where = null, $else = null): string
        {
            $file = ROOT_DIR . "/templates/" . $name . ".php";
            $temp = file_get_contents($file);
            $output = "";
            $i = 0;
            if (isset($result) && $result != null) {
                while (!is_array($result) ? $row = $result->fetch_assoc() : isset($result[$i]) && $row = $result[$i++]) {
                    $output_2 = $temp;
                    foreach (array_keys($row) as $key) {
                        $output_2 = self::replace_template($output_2, $key, $row[$key]);
                    }
                    if (isset($where) && is_array($where)) {
                        foreach (array_keys($where) as $key) {
                            if (array_key_exists($key, $row)) {
                                foreach (array_keys($where[$key]) as $key2) {
                                    if (isset($where[$key][$key2][$row[$key]])) {
                                        $output_2 = self::replace_template($output_2, $key2, $where[$key][$key2][$row[$key]]);
                                    } else {
                                        $output_2 = self::replace_template($output_2, $key2, $else != null && isset($else[$key2]) ? $else[$key2] : '');
                                    }
                                }
                            }
                        }
                    }

                    $output .= $output_2;
                }
            }
            return $output;
        }

        // Быстрое получение HTML кода для вставки стилей из указаной папки
        public static function getStylesLink($styles, $path = 'styles/'): string
        {
            $output = '';
            if (isset($styles) && $styles != null && is_array($styles)) {
                foreach ($styles as $style) {
                    $output .= "<link rel='stylesheet' href='$path$style.css'>";
                }
            }
            return $output;
        }

        // Быстрое получение HTML кода для вставки скриптов из указаной папки
        public static function getScriptsLink($scripts, $path = 'scripts/'): string
        {
            $output = '';
            if (isset($scripts) && $scripts != null && is_array($scripts)) {
                foreach ($scripts as $script) {
                    $output .= "<script src='$path$script.js'></script>";
                }
            }
            return $output;
        }

        // Поиск и замена блока
        public static function replace_template($temp, $find, $replace): array|string
        {
            return str_replace("{% " . $find . " %}", $replace, $temp);
        }

    }
}