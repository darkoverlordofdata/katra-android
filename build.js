({
    appDir: './tst',
    baseUrl: './js',
    dir: './www',
    modules: [
        {
            name: 'index'
        }
    ],
    fileExclusionRegExp: /^(r|build)\.js$/,
    optimize: 'uglify',
    removeCombined: true,
    paths: {
        jquery: "vendor/jquery-2.0.3.min",
        jquerymobile: "vendor/jquery.mobile-1.3.2.min",
        underscore: "vendor/lodash.underscore.min",
        backbone: "vendor/backbone-min",
        katra: "lib/katra",
        kc: "lib/kc"
    },
    shim: {
        backbone: {
            deps: ["underscore", "jquery"],
            exports: "Backbone"
        }
    }
})