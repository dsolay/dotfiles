require('twilight').setup {
    dimming = {
        alpha = 0.50, -- amount of dimming
        -- we try to get the foreground from the highlight groups or fallback color
        color = {'Normal', '#ffffff'},
    },
}
