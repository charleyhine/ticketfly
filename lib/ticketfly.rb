module Ticketfly
  require 'open-uri'
  require 'json'
  
  class Org
    attr_accessor :id, :name, :json
    def self.build(json)
      org = Org.new
      org.id = json['id']
      org.name = json['name']
      org.json = json
      org
    end
  end  
  
  class Venue
    attr_accessor :id, :name, :json
    def self.build(json)
      venue = Venue.new
      venue.id = json['id']
      venue.name = json['name']
      venue.json = json
      venue
    end
  end
  
  class Headliner
    attr_accessor :id, :name, :json
    def self.build(json)
      headliner = Headliner.new
      headliner.id = json['id']
      headliner.name = json['name']
      headliner.json = json
      headliner
    end
  end

  class Event
    attr_accessor :id, :name, :venue, :org, :date, :json, :headliners
    def self.build(json)
      event = Event.new
      event.headliners = []
      event.id = json['id']
      event.name = json['name']
      event.json = json
      event.venue = Venue.build(json['venue'])
      event.org = Org.build(json['org'])
      event.date = json['startDate']
      event
    end
  end

  class Events
    def self.get_by_id(id)
      base_uri = "http://www.ticketfly.com/api/events/upcoming.json"
      max_results = 1
      result = JSON.parse(open(base_uri + "?eventId=" + id.to_s).read)
      Event.build(result['events'].first)
    end
    
    def self.get_next_event_by_venue_id(venue_id)
      base_uri = "http://www.ticketfly.com/api/events/upcoming.json"
      max_results = 1
      result = JSON.parse(open(base_uri + "?venueId=" + venue_id.to_s).read)
      Event.build(result['events'].first)
    end
    
    def self.get_by_venue_id(venue_id)
      base_uri = "http://www.ticketfly.com/api/events/upcoming.json"
      max_results = 200
      events = []
      total_pages = 1
      page = 1
      begin
        result = JSON.parse(open(base_uri + "?venueId=" + venue_id.to_s).read)
        total_pages = result["totalPages"]
        result['events'].each do |e|
          event = Event.build(e)
          events << event
        end
        page += 1
      end while not page > total_pages
      events
    end
    
    def self.search(query)
      base_uri = "http://www.ticketfly.com/api/events/upcoming.json"
      max_results = 200
      events = []
      total_pages = 1
      page = 1
      begin
        result = JSON.parse(open(base_uri + "?q=" + query.to_s).read)
        total_pages = result["totalPages"]
        result['events'].each do |e|
          event = Event.build(e)
          events << event
        end
        page += 1
      end while not page > total_pages
      events
    end
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
          org = Org.build(o)
          orgs << org
        end
        page += 1
      end while not page > total_pages
      orgs
    end
  end
  
  class Venues
    def self.get_all
      max_results = 200
      venues = []
      total_pages = 1
      page = 1
      begin
        base_uri = "http://www.ticketfly.com/api/venues/list.json"
        result = JSON.parse(open(base_uri + "?maxResults=" + max_results.to_s + "&pageNum=" + page.to_s).read)
        total_pages = result["totalPages"]
        result['venues'].each do |v|
          venue = Venue.build(v)
          venues << venue
        end
        page += 1
      end while not page > total_pages
      venues
    end
  end
end