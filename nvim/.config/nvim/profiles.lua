--[[
     /  /\         /__/\         /  /\         /  /\          ___        ___          /__/\
    /  /:/         \  \:\       /  /:/_       /  /::\        /__/\      /  /\        |  |::\
   /  /:/           \__\:\     /  /:/ /\     /  /:/\:\       \  \:\    /  /:/        |  |:|:\
  /  /:/  ___   ___ /  /::\   /  /:/ /:/_   /  /:/  \:\       \  \:\  /__/::\      __|__|:|\:\
 /__/:/  /  /\ /__/\  /:/\:\ /__/:/ /:/ /\ /__/:/ \__\:\  ___  \__\:\ \__\/\:\__  /__/::::| \:\
 \  \:\ /  /:/ \  \:\/:/__\/ \  \:\/:/ /:/ \  \:\ /  /:/ /__/\ |  |:|    \  \:\/\ \  \:\~~\__\/
  \  \:\  /:/   \  \::/       \  \::/ /:/   \  \:\  /:/  \  \:\|  |:|     \__\::/  \  \:\
   \  \:\/:/     \  \:\        \  \:\/:/     \  \:\/:/    \  \:\__|:|     /__/:/    \  \:\
    \  \::/       \  \:\        \  \::/       \  \::/      \__\::::/      \__\/      \  \:\
     \__\/         \__\/         \__\/         \__\/           ~~~~                   \__\/

    A config switcher written in Lua by NTBBloodbath and Vhyrro.
--]] -- Defines the profiles you want to use
local profiles = {
    ide = {
        '~/.nvim-profiles/ide',
        { plugins = 'packer', preconfigure = 'packer' },
    },
    minimal = {
        '~/.nvim-profiles/minimal',
        { plugins = 'packer', preconfigure = 'packer' },
    },
    testing = {
        '~/.nvim-profiles/testing',
        { plugins = 'packer', preconfigure = 'packer' },
    },
}

local default_profile = 'ide'

-- return <name_of_config>, <list_of_profiles>

return default_profile, profiles
