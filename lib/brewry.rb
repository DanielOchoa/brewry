require 'rubygems'
require 'httparty'

class Brewry
  include HTTParty
  #include ApiUtilities

  attr_accessor :search_hash

  base_uri 'http://api/brewerydb.com/v2'
  @@api_key = nil

  # config block:
  # Brewry.configure do |config|
  #   config.api_key = 'some_api_key'
  # end
  def self.configure
    yield self
  end

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

  private

  # Used by the method_missing method for dynamic searches
  def self.search_for(path, options = {})
    query   = build_query(options)
    search  = get("/#{path}", query)
    return_pretty_results(search)
  end

  def self.return_pretty_results(payload)
    return query_error(payload) if payload['status'] == 'failure'
    data = payload.parsed_response['data']
    data.map do |obj|
      obj = underscore_and_symbolize obj
    end if data
  end

  def self.build_query(search = {})
    search_hash = clean_search_hash
    search_hash[:query].merge! search; search_hash
  end

  def self.query_error(search)
    underscore_and_symbolize search
    # TODO: throw some exception or special fail construct
  end

  def self.clean_search_hash
    { query: { key: @@api_key } }
  end
end
