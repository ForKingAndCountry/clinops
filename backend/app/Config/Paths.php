<?php

namespace Config;

/**
 * Paths
 *
 * Holds the paths that are used by the system to
 * locate the main directories, app, system, and writable.
 */
class Paths
{
    /**
     * ---------------------------------------------------------------
     * SYSTEM PATH NAME
     * ---------------------------------------------------------------
     *
     * This must contain the name of your "system" directory.
     * Set the path if it is not in the same directory as this file.
     */
    public $systemDirectory = __DIR__ . '/../../vendor/codeigniter4/framework/system';

    /**
     * ---------------------------------------------------------------
     * APP PATH NAME
     * ---------------------------------------------------------------
     *
     * If you want this front controller to use a different "application"
     * directory than the default one you can set its name here. The
     * path can also be absolute or relative to the front controller.
     */
    public $appDirectory = __DIR__ . '/..';

    /**
     * ---------------------------------------------------------------
     * WRITABLE PATH NAME
     * ---------------------------------------------------------------
     *
     * You can set the name of the directory for writable files
     * here. The path can also be absolute or relative to the front
     * controller.
     */
    public $writableDirectory = __DIR__ . '/../../writable';

    /**
     * ---------------------------------------------------------------
     * TESTS PATH NAME
     * ---------------------------------------------------------------
     *
     * You can set the name of the directory for test files.
     * The path can also be absolute or relative to the front
     * controller.
     */
    public $testsDirectory = __DIR__ . '/../../tests';

    /**
     * ---------------------------------------------------------------
     * VIEW PATH NAME
     * ---------------------------------------------------------------
     *
     * You can set the name of the directory for view files.
     * The path can also be absolute or relative to the front
     * controller.
     */
    public $viewDirectory = __DIR__ . '/../Views';
}
