<?php

namespace Config;

use CodeIgniter\Config\BaseConfig;

class App extends BaseConfig
{
    public $baseURL = 'http://localhost:80/';
    public $allowedHostnames = [];
    public $indexPage = '';
    public $uriProtocol = 'REQUEST_URI';
    public $defaultLocale = 'en';
    public $negotiateLocale = false;
    public $supportedLocales = ['en'];
    public $timeZone = 'UTC';
    public $charset = 'UTF-8';
    public $forceGlobalSecureRequests = false;
    public $sessionDriver = 'CodeIgniter\Session\RedisHandler';
    public $sessionCookieName = 'ci_session';
    public $sessionExpiration = 7200;
    public $sessionTimeToUpdate = 300;
    public $sessionRegenerateDestroy = false;
    public $sessionMatchIP = false;
    public $proxyIPs = '';
    public $CSRFProtection = false;
    public $CSRFTokenName = 'csrf_test_name';
    public $CSRFHeaderName = 'X-CSRF-TOKEN';
    public $CSRFCookieName = 'csrf_cookie_name';
    public $CSRFExpire = 7200;
    public $CSRFRegenerate = true;
    public $CSRFRedirect = true;
    public $CSPEnabled = false;
}
