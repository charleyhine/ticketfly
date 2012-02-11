module Ticketfly
  require 'open-uri'
  require 'json'
  
  class Org
    attr_accessor :id, :name, :json
  end  
  
  class Venue
    attr_accessor :id, :name, :json
  end
  
  class Orgs
    def self.get_all
      base_uri = "http://www.ticketfly.com/api/orgs/list.json"
      max_results = 200

      orgs = []
      total_pages = 1
      page = 1

      begin
        result = JSON.parse(open(base_uri + "?maxResults=" + max_results.to_s + "&pageNum=" + page.to_s).read)
        total_pages = result["totalPages"]
        result['orgs'].each do |o|
          org = Org.new
          org.id = o['id']
          org.name = o['name']
          org.json = o
          orgs << org
        end
        page += 1
      end while not page > total_pages
      orgs
    end
  end
  
  class Venues
    def self.get_all
      base_uri = "http://www.ticketfly.com/api/venues/list.json"
      max_results = 200

      venues = []
      total_pages = 1
      page = 1

      begin
        result = JSON.parse(open(base_uri + "?maxResults=" + max_results.to_s + "&pageNum=" + page.to_s).read)
        total_pages = result["totalPages"]
        result['venues'].each do |v|
          venue = Venue.new
          venue.id = v['id']
          venue.name = v['name']
          venue.json = v
          venues << venue
        end
        page += 1
      end while not page > total_pages
      venues
    end
  end
end