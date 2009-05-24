# config/router.pl

router {
    match '/' => to { controller => 'Root', action => 'index' };
    match '/welcome' => to { controller => 'Welcome', action => 'index' };
};
