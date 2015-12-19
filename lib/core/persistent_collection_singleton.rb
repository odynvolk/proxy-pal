require 'core/singleton'
require 'core/persistent_collection'

class PersistentCollectionSingleton < PersistentCollection
  include Singleton
end
