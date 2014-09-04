require 'rubygems'
require 'httparty'
require 'utils/string_utils'
require 'brewry/exceptions'

module Brewry
  # TODO: Change class so it needs to be instantiated
  using StringUtils
  include HTTParty

  attr_accessor :search_hash

  ### Configuration ###

  base_uri 'http://api.brewerydb.com/v2'
  @@api_key = nil

  # Brewry.configure do |config|
  #   config.api_key = 'some_api_key'
  # end
  def self.configure
    yield self
  end

  def self.api_key
    @@api_key
  end

  def self.api_key=(apikey)
    @@api_key = apikey
  end

  ### Methods ###

  # override method_missing in order to create
  # dynamic methods for searches. Ex.:
  # BreweryDB.search_beers(name: 'Corona Light')
  # BreweryDB.search_styles()
  def self.method_missing(meth, *args, &block)
    if meth.to_s =~ /^search_(.+)$/
      search_for($1, *args)
    else
      super
    end
  end

  # standard beer search - WILL DEPRECATE IN THE FUTURE
  def self.beer_search(search)
    query  = build_query q: search, type: 'beer'
    search = get('/search', query)
    return_pretty_results(search)
  end

  # returns raw httparty query. See
  # http://www.brewerydb.com/developers/docs
  # for full range of options
  def self.raw_query(path, options)
    query = build_query(options)
    get(path, query)
  end

  # To use BreweryDB search path. Options are:
  # Ex. { q: 'Goosinator', type: 'beer' }
  def self.search(options)
    query   = build_query options
    search  = get('/search', query)
    return_pretty_results(search)
  end

  protected

  # Used by the method_missing method for dynamic searches
  def self.search_for(path, options = {})
    query   = build_query(options)
    search  = get("/#{path}", query)
    return_pretty_results(search)
  end

  # underscore_and_symbolize is defined in utils/api_utilities.rb
  def self.return_pretty_results(payload)
    return query_error(payload) if payload['status'] == 'failure'
    data = payload.parsed_response['data']
    data.map do |obj|
      obj = self.underscore_and_symbolize obj
    end if data
  end

  def self.build_query(search = {})
    search_hash = clean_search_hash
    search_hash[:query].merge! search; search_hash
  end

  def self.query_error(search)
    self.underscore_and_symbolize search
    # TODO: throw some exception or special fail construct
  end

  def self.clean_search_hash
    unless @@api_key
      raise MissingApiKey, "You must set a brewerydb api key before you can "\
                           "use this gem. Please see http://www.brewerydb.com"\
                           "/developers/docs for more information."
    end
    { query: { key: @@api_key } }
  end

  # TODO: User should be able to change the foreignkeys argument
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
