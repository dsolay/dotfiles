local iron = require('iron')
iron.core.add_repl_definitions {
  lua = {
    croissant = {
      command = {'croissant'}
    }
  },
}

iron.core.set_config {
  preferred = {
    python  = 'ptipython',
    lua     = 'croissant'
  }
}
