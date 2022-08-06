<?php

namespace api\stat {

    $result = [];
    $result['schemaVersion'] = 1;
    $result['label'] = "STATUS";
    $result['message'] = "BETA";
    $result['color'] = "orange";

    echo json_encode($result, JSON_UNESCAPED_UNICODE);

}