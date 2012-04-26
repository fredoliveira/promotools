class Chart
	# things to monitor
	attr_accessor :artists, :labels

	def initialize(artists, labels)
		@artists = artists
		@labels = labels
	end

	def parse(results)
		output = ""
		for row in results
			# if the track is by a monitored artist, or by a monitored remixer, or from a monitored label
			if ((@artists & row[:artists]).length > 0) || ((@artists & row[:remixers]).length > 0) || (@labels.include?(row[:label]))
				# add it to the output
		 		output += "#{row[:position]} - #{row[:artists][0]} - #{row[:track]}. Price: #{row[:price]}\n"
		 	end
		end	

		output = "** Not charted **\n" if output == ""
		return output
	end
end
