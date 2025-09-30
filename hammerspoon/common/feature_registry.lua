-- Feature Registry Module -----------------------------------------------
--------------------------------------------------------------------------
-- Central registry for toggle features to prevent circular dependencies
-- Features register themselves, and consumers (like modals) query the registry

local M = {}

-- Internal storage for registered features
local features = {}

-- Register a feature instance
-- @param name string - Unique identifier for the feature (e.g., "caffeine", "autoreload")
-- @param instance table - The toggle feature instance with methods like isEnabled(), toggle(), etc.
function M.register(name, instance)
   assert(type(name) == "string", "Feature name must be a string")
   assert(type(instance) == "table", "Feature instance must be a table")

   if features[name] then
      hs.printf("[Registry] Warning: Overwriting existing feature '%s'", name)
   end

   features[name] = instance
   hs.printf("[Registry] Registered feature: %s", name)
end

-- Get a registered feature instance
-- @param name string - The feature identifier
-- @return table|nil - The feature instance, or nil if not found
function M.get(name)
   local feature = features[name]
   if not feature then
      hs.printf("[Registry] Warning: Feature '%s' not found in registry", name)
   end
   return feature
end

-- Get all registered features
-- @return table - Dictionary of all registered features
function M.getAll()
   return features
end

return M
