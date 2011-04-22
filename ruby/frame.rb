def get_codons(sequence, frame)
	n = ((sequence.length - frame) / 3).floor

	codons = []
	n.times do |i|
		codons.push sequence[(frame + i * 3)...(frame + i * 3 + 3)].join("")
	end

	return codons
end

def codon_to_protein(codon)

end

stop = ["TAG", "TGA", "TAA"]

file = File.open("chr1.fa", "r")

sequence = []
counter = 0
file.each do |line|
	next if line.include? ">" 
	sequence.concat line.chomp.upcase.split("").delete_if { |x| x == "N" }
	counter += 1

	break if counter == 29999
end

threads = []

(0..6).to_a.each do |frame|
	threads << Thread.new(sequence, frame) do |seq, f|
		codons = get_codons(seq, f)

		matches = stop & codons
		if matches.length > 0
			#puts "Found stop codon in reading frame: " + frame.to_s
			#puts codons[0..codons.index(matches[0])].inspect
		end
	end
end

threads.each { |t| t.join }
