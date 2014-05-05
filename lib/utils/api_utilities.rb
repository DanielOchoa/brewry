module Brewry
  # underscores and symbolizes a Hash or Hash of Hashes recursively,
  # foreignkeys second argument transforms the id of the hash into
  # the :guid symbol by default.
  def self.underscore_and_symbolize(obj, foreignkeys = :guid)
    obj.inject({}) do |hash, (key, val)|
      val = underscore_and_symbolize(val) if val.kind_of? Hash
      if key == 'id'
        hash.shift
        hash[foreignkeys] = val
      else
        hash[key.underscore.to_sym] = val
      end
      hash
    end
  end
end
