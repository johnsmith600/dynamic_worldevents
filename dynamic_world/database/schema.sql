CREATE TABLE IF NOT EXISTS `dynamic_events` (
    `id` VARCHAR(50) NOT NULL,
    `type` VARCHAR(50) NOT NULL,
    `data` LONGTEXT NOT NULL,
    `state` VARCHAR(20) NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `dynamic_event_entities` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `event_id` VARCHAR(50) NOT NULL,
    `entity_type` VARCHAR(20) NOT NULL, -- 'ped', 'vehicle', 'object'
    `model` VARCHAR(50) NOT NULL,
    `coords` VARCHAR(255) NOT NULL,
    `heading` FLOAT NOT NULL,
    `metadata` LONGTEXT, -- health, armor, etc.
    FOREIGN KEY (`event_id`) REFERENCES `dynamic_events`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
