<?php

return [
    'version' => env('APP_VERSION', '1.0.0'),
    'pagination' => [
        'default_per_page' => 15,
        'max_per_page' => 100,
    ],
    'uploads' => [
        'avatar' => [
            'max_size' => 2048,
            'allowed_types' => ['jpg', 'jpeg', 'png', 'gif'],
            'dimensions' => [
                'max_width' => 1000,
                'max_height' => 1000,
            ],
        ],
    ],
    'cache' => [
        'user_activity_ttl' => 300,
        'default_ttl' => 3600,
    ],
    'rate_limits' => [
        'api' => [
            'attempts' => 100,
            'decay_minutes' => 1,
        ],
        'login' => [
            'attempts' => 5,
            'decay_minutes' => 15,
        ],
    ],
];
