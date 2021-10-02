return {
    settings = {
        intelephense = {
            diagnostics = {
                typeErrors = false,
                undefinedMethods = false,
                undefinedTypes = false,
            },
            format = {enable = false},
            files = {
                exclude = {
                    '**/.git/**',
                    '**/.svn/**',
                    '**/.hg/**',
                    '**/CVS/**',
                    '**/.DS_Store/**',
                    '**/node_modules/**',
                    '**/bower_components/**',
                    '**/vendor/**/{Test,test,Tests,tests}/**/*Test.php',
                },
            },
        },
    },
}
