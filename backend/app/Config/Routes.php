<?php

use CodeIgniter\Router\RouteCollection;

/**
 * @var RouteCollection $routes
 */

$routes->group('api', ['namespace' => 'App\Controllers'], function($routes) {
    $routes->get('health', 'Health::index');
    $routes->post('auth/login', 'Auth::login');
    $routes->post('auth/logout', 'Auth::logout');
    $routes->get('auth/me', 'Auth::me');
    
    // Example protected routes with role filters
    $routes->group('patients', ['filter' => 'role:Doctor,Nurse,RecordsOfficer,ClinicAdmin'], function($routes) {
        $routes->post('/', 'Patient::create');
        $routes->get('search', 'Patient::search');
        $routes->get('(:num)/chart', 'Patient::chart/$1');
    });
});
