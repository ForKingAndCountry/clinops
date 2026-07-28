<?php

namespace Config;

use CodeIgniter\Config\BaseConfig;

class Filters extends BaseConfig
{
    public $aliases = [
        'csrf'     => \CodeIgniter\Filters\CSRF::class,
        'toolbar'  => \CodeIgniter\Filters\DebugToolbar::class,
        'honeypot' => \CodeIgniter\Filters\Honeypot::class,
        'auth'     => \CodeIgniter\Shield\Filters\AuthFilter::class,
        'role'     => \App\Filters\RoleFilter::class,
    ];

    public $globals = [
        'before' => [
            // 'csrf',
        ],
        'after' => [
            'toolbar',
        ],
    ];

    public $methods = [];

    public $filters = [
        'auth' => ['before' => ['api/*', 'except' => ['api/auth/*', 'api/health']]],
    ];
}
