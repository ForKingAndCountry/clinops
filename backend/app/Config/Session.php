<?php

namespace Config;

use CodeIgniter\Config\BaseConfig;

class Session extends BaseConfig
{
    public $driver = 'CodeIgniter\Session\Handlers\RedisHandler';
    public $cookieName = 'ci_session';
    public $expiration = 7200;
    public $timeToUpdate = 300;
    public $regenerateDestroy = false;
    public $sessionMatchIP = false;
    public $savePath = 'tcp://' . (getenv('REDIS_HOST') ?: 'redis') . ':' . (getenv('REDIS_PORT') ?: '6379');
    public $DBGroup = 'default';
    public $database = null;
    public $cookieSecure = false;
    public $cookieHTTPOnly = true;
    public $cookieSameSite = 'Lax';
    public $userAgent = false;
    public $IPValidation = false;
}
