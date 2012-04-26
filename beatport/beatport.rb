require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'pony'

class Beatport
  attr_reader :results

  def initialize
    @results = [] # usually an array of length 100
  end

  def get_house
    parse "http://www.beatport.com/genre/house/5/top-100"
    @results
  end

  def get_nudisco
    parse "http://www.beatport.com/genre/indie-dance-nu-disco/37/top-100"
    @results
  end

  def get_breaks
    parse "http://www.beatport.com/genre/breaks/9/top-100"
    @results
  end

  def get_chillout
    parse "http://www.beatport.com/genre/chill-out/10/top-100"
    @results
  end

  def get_djtools
    parse "http://www.beatport.com/genre/dj-tools/16/top-100"
    @results
  end

  def get_deephouse
    parse "http://www.beatport.com/genre/deep-house/12/top-100"
    @results
  end

  def get_dnb
    parse "http://www.beatport.com/genre/drum-and-bass/1/top-100"
    @results
  end

  def get_dubstep
    parse "http://www.beatport.com/genre/dubstep/18/top-100"
    @results
  end

  def get_electro
    parse "http://www.beatport.com/genre/electro-house/17/top-100"
    @results
  end

  def get_electronica
    parse "http://www.beatport.com/genre/electronica/3/top-100"
    @results
  end

  def get_funk
    parse "http://www.beatport.com/genre/funk-r-and-b/40/top-100"
    @results
  end

  def get_glitch
    parse "http://www.beatport.com/genre/glitch-hop/49/top-100"
    @results
  end

  def get_harddance
    parse "http://www.beatport.com/genre/hard-dance/8/top-100"
    @results
  end

  def get_hardcore
    parse "http://www.beatport.com/genre/hardcore-hard-techno/2/top-100"
    @results
  end

  def get_hiphop
    parse "http://www.beatport.com/genre/hip-hop/38/top-100"
    @results
  end

  def get_minimal
    parse "http://www.beatport.com/genre/minimal/14/top-100"
    @results
  end

  def get_poprock
    parse "http://www.beatport.com/genre/pop-rock/39/top-100"
    @results
  end

  def get_proghouse
    parse "http://www.beatport.com/genre/progressive-house/15/top-100"
    @results
  end

  def get_psytrance
    parse "http://www.beatport.com/genre/psy-trance/13/top-100"
    @results
  end

  def get_reggae
    parse "http://www.beatport.com/genre/reggae-dub/41/top-100"
    @results
  end

  def get_techhouse
    parse "http://www.beatport.com/genre/tech-house/11/top-100"
    @results
  end

  def get_techno
    parse "http://www.beatport.com/genre/techno/6/top-100"
    @results
  end

  def get_trance
    parse "http://www.beatport.com/genre/trance/7/top-100"
    @results
  end

  private

  def parse(url)
    doc = Nokogiri::HTML(open(url))
    doc.css('div.top-100 table.track-grid tr.playRow').each_with_index do |row, i|
      position = parse_position(row.css('td')[0].content)
      @results[i] = {}

      @results[i][:artists] = parse_artists(row.css('td')[4].content)
      @results[i][:remixers] = parse_artists(row.css('td')[5].content)
      @results[i][:position] = position
      @results[i][:track] = parse_track(row.css('td')[3].content)
      @results[i][:date] = parse_date(row.css('td')[8].content)
      @results[i][:price] = parse_price(row.css('td')[9])
      @results[i][:label] = parse_label(row.css('td')[6].content)
    end
  end

  # retuns the internal beatport id for a given track
  def parse_id(e)
    return e.css('a')[0].attribute('data-play').content.split(':')[1].to_i
  end
  
  # returns an array of artists involved in a release
  def parse_artists(content)
    artists = []
    content.split(",").each do |a|
      artists << a.lstrip.rstrip
    end
    return artists
  end
  
  # returns a string with the track name
  def parse_track(content)
    return content.lstrip.rstrip
  end
  
  # returns the chart position
  def parse_position(content)
    return content.lstrip.rstrip.to_i
  end
  
  # parse a release date
  def parse_date(content)
    return content.lstrip.rstrip
  end
  
  # parse the label
  def parse_label(content)
    return content.lstrip.rstrip
  end
  
  # parse the release price
  def parse_price(e)
    # prices can be restricted
    begin
      return e.css('span')[1].content.gsub(',', '.').to_f
    rescue
      return 0.0
    end
  end
end