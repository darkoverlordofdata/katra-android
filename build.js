({
    appDir: './dev',
    baseUrl: './js',
    dir: './www',
    modules: [
        {
            name: 'index'
        }
    ],
    optimize: 'uglify',
    removeCombined: true,
    paths: {
        jquery: "vendor/jquery-2.0.3",
        jquerymobile: "vendor/jquery.mobile-1.3.2",
        underscore: "vendor/lodash.underscore",
        backbone: "vendor/backbone",
        katra: "lib/katra",
        kc: "lib/kc.bnf",
        rte: "lib/rte.android"
    },
    shim: {
        backbone: {
            deps: ["underscore", "jquery"],
            exports: "Backbone"
        }
    }
})