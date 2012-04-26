require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'pony'

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
  return e.css('span')[1].content.gsub(',', '.').to_f
end

def email_results(results)
  config = YAML.load_file("config.yml")

  Pony.mail(:to => config["config"]["mailto"], :subject => "Discotexas @ Beatport", :body => results, :via => :smtp, :via_options => {
    :address              => config["config"]["mailserver"],
    :port                 => config["config"]["port"],
    :enable_starttls_auto => config["config"]["tls"],
    :user_name            => config["config"]["username"],
    :password             => config["config"]["password"],
    :authentication       => :plain, # :plain, :login, :cram_md5, no auth by default
    :domain               => config["config"]["domain"] # the HELO domain provided by the client to the server
  })
end

url = "http://www.beatport.com/genre/indie-dance-nu-disco/37/top-100"
doc = Nokogiri::HTML(open(url))
output = "Indie Dance / Nu Disco Top 100 standings: #{Time.now}\n\n"

doc.css('div.top-100 table.track-grid tr.playRow').each do |row|
  #	id = parse_id(row.css('td')[1])
  artists = parse_artists(row.css('td')[4].content)
  remixers = parse_artists(row.css('td')[5].content)
  position = parse_position(row.css('td')[0].content)
  track = parse_track(row.css('td')[3].content)
  date = parse_date(row.css('td')[8].content)
  price = parse_price(row.css('td'))
  label = parse_label(row.css('td')[6].content)

  if label == "Discotexas" or artists.include?("Moullinex") or artists.include?("Xinobi") or artists.include?("Lazydisco") or remixers.include?("Moullinex") or remixers.include?("Xinobi") or remixers.include?("Lazydisco")
    output += "#{position} - #{track}. Current price: #{price}\n"
  end
end

email_results(output)
