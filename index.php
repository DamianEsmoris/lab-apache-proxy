<?php
    $ip = $_SERVER['REMOTE_ADDR'] ?? 'Ni idea';
    echo "Hola, te has conectado desde: " . $ip;
