require 'chart'
require 'beatport'

# things to look for
artists = ["Xinobi", "Moullinex", "Lazydisco"]
label = ["Discotexas"]

# init
beatport = Beatport.new
chart = Chart.new(artists, label)

# run
output = "House chart:\n\n"
output += chart.parse(beatport.get_house)
output += "\nNu-disco chart:\n\n"
output += chart.parse(beatport.get_nudisco)

# email
def email_results(results)
  config = YAML.load_file("config.yml")

  Pony.mail(:to => config["config"]["mailto"], :subject => "Discotexas @ Beatport", :body => results, :via => :smtp, :via_options => {
    :address              => config["config"]["mailserver"],
    :port                 => config["config"]["port"],
    :enable_starttls_auto => config["config"]["tls"],
    :user_name            => config["config"]["username"],
    :password             => config["config"]["password"],
    :authentication       => :plain,
    :domain               => config["config"]["domain"]
  })
end

email_results(output)