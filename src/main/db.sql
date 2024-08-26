CREATE DATABASE IF NOT EXISTS console;
USE console;

CREATE TABLE IF NOT EXISTS location_data (
    id INT AUTO_INCREMENT PRIMARY KEY,
    distance_num VARCHAR(255),
    wifi VARCHAR(255),
    area VARCHAR(255),
    wifi_name VARCHAR(255),
    address VARCHAR(255),
    detail_address VARCHAR(255),
    floor VARCHAR(255),
    wifi_type VARCHAR(255),
    wifi_organ VARCHAR(255),
    service VARCHAR(255),
    mesh VARCHAR(255),
    install_year VARCHAR(255),
    in_out VARCHAR(255),
    connect VARCHAR(255),
    X VARCHAR(255),
    Y VARCHAR(255),
    work_year VARCHAR(255)
);