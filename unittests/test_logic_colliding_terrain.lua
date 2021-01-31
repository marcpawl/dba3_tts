lu = require('externals/luaunit/luaunit')
require('scripts/data/data_settings')
require('scripts/data/data_tables')
require('scripts/data/data_terrain')
require('scripts/data/data_troops')
--require('scripts/data/data_troops_greek_successors')
--require('scripts/data/data_armies_book_I')
--require('scripts/data/data_armies_book_II')
--require('scripts/data/data_armies_book_III')
--require('scripts/data/data_armies_book_IV')
require('scripts/base_cache')
require('scripts/log')
require('scripts/utilities_lua')
require('scripts/utilities')
require('scripts/logic_terrain')
require('scripts/logic_gizmos')
require('scripts/logic_spawn_army')
require('scripts/logic_dead')
require('scripts/logic_dice')
require('scripts/logic_history_stack')
require('scripts/logic')
require('scripts/uievents')

-- Simulate TTS function
Player={}
Player.getPlayers = function()
  return { {color="Red"}, {color="Blue"} }
end

function test_terrain_not_invisible_if_colliding_with_not_base()
  local tree1_registered = nil
  local tree1 = { 
      getName = function() return 'tree' end,
      registerCollisions = function(stay) 
          tree1_registered = stay
        end,
    }
  local tree2 = { getName = function() return 'tree' end }
  register_colliding_terrain(tree1)
  lu.assertEquals(false, tree1_registered)
  local info = { collision_object=tree2 }
  onObjectCollisionEnter(tree1, info)
end

function test_terrain_invisible_if_colliding_with_base()
  local tree1_invisible = {}
  local tree1 = { 
      getName = function() return 'tree' end,
      registerCollisions = function(stay) end,
      setInvisibleTo = function(players) tree1_invisible = players end,
    }
  local bow = { getName = function() return 'base bow' end }
  register_colliding_terrain(tree1)
  local info = { collision_object=bow }
  onObjectCollisionEnter(tree1, info)
  lu.assertFalse(is_table_empty( tree1_invisible ) )
end


function test_terrain_visible_if_base_leaves()
  local tree1_invisible = {}
  local tree1 = { 
      getName = function() return 'tree' end,
      registerCollisions = function(stay) end,
      setInvisibleTo = function(players) tree1_invisible = players end,
    }
  local bow = { getName = function() return 'base bow' end }
  register_colliding_terrain(tree1)
  local info = { collision_object=bow }
  onObjectCollisionEnter(tree1, info)
  onObjectCollisionExit(tree1, info)
  lu.assertTrue(is_table_empty( tree1_invisible ) )
end

function test_terrain_visible_if_base_leaves_after_multiple_entries()
  local tree1_invisible = {}
  local tree1 = { 
      getName = function() return 'tree' end,
      registerCollisions = function(stay) end,
      setInvisibleTo = function(players) tree1_invisible = players end,
    }
  local bow = { getName = function() return 'base bow' end }
  register_colliding_terrain(tree1)
  local info = { collision_object=bow }
  onObjectCollisionEnter(tree1, info)
  onObjectCollisionEnter(tree1, info)
  onObjectCollisionEnter(tree1, info)
  onObjectCollisionExit(tree1, info)
  lu.assertTrue(is_table_empty( tree1_invisible ) )
end

function test_non_terrain_ignored_for_collision_enter()
  local bow = { getName = function() return 'base bow' end }
  local aux = { getName = function() return 'base aux' end }
  local info = { collision_object=bow }
  onObjectCollisionEnter(aux, info)
end

function test_non_terrain_ignored_for_collision_exit()
  local bow = { getName = function() return 'base bow' end }
  local aux = { getName = function() return 'base aux' end }
  local info = { collision_object=bow }
  onObjectCollisionExit(aux, info)
end

os.exit( lu.LuaUnit.run() )
