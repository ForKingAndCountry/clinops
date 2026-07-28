<?php

namespace Config;

use CodeIgniter\Config\BaseConfig;

class Auth extends BaseConfig
{
    public $views = [
        'login' => '\CodeIgniter\Shield\Views\login',
    ];

    public $redirects = [
        'login' => '/',
        'logout' => 'login',
        'register' => '/',
    ];

    public $sessionConfig = [
        'driver' => 'CodeIgniter\Shield\Authentication\Handlers\SessionHandler',
    ];

    public $authenticator = [
        'chains' => [
            'session' => [
                'CodeIgniter\Shield\Authentication\Handlers\SessionHandler',
            ],
        ],
        'defaults' => [
            'session',
        ],
    ];

    public $recordActiveDate = true;

    public $allowRegistration = false;

    public $minimumPasswordLength = 8;

    public $passwordValidators = [
        'CodeIgniter\Shield\Authentication\Passwords\NothingPersonalValidator',
        'CodeIgniter\Shield\Authentication\Passwords\DictionaryValidator',
        'CodeIgniter\Shield\Authentication\Passwords\PwnedValidator',
    ];

    public $userProvider = 'CodeIgniter\Shield\Models\UserModel';
}
