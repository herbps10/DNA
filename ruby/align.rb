class Matrix
	def initialize(sequence1, sequence2)
		@sequence1 = sequence1.split("")
		@sequence2 = sequence2.split("")

		@mismatch_penalty = -1
		@match_score = 2
		@gap_penalty = -2

		# Initialize the matrix
		@matrix = Hash.new

		# We have to make the dimensions one larger than the lengths of the sequences because there the first row and column have no corresponding base
		(@sequence1.length + 1).times do |i|
			(@sequence2.length + 1).times do |j|
				@matrix[[i, j]] = 0
			end
		end
	end

	# Determines if the bases from both sequences match at given position s1 in sequence1 and s2 in sequence2. If there is a match, then it returns 1. otherwise, it returns a score of 0.
	def match_score(s1, s2)
		s = @mismatch_penalty
		s =  @match_score if @sequence1[s1] == @sequence2[s2]

		return s
	end

	# Determines the score for a given position in the matrix
	def score(x, y)
		# The value is given by looking at the value to the upper left diagonal, the value to the left, and the value to the right.

		# the value of the diagonal plus the match score
		diagonal = @matrix[[x-1, y-1]] + match_score(x - 1, y - 1) 

		# The cell to the left
		left = @matrix[[x - 1, y]] + @gap_penalty

		# The cell to the right
		right = @matrix[[x, y - 1]] + @gap_penalty

		return [diagonal, left, right].max # return the maximum of these values.
	end

	def fill
		[@sequence1.length, @sequence2.length].min.times do |n|
			@matrix[[n + 1, n + 1]] = score(n + 1, n + 1)

			((n + 2)..@sequence1.length).to_a.each do |j|
				@matrix[[j, n + 1]] = score(j, n + 1)
			end

			# Fill in all the values to the right
			((n + 2)..@sequence2.length).to_a.each do |i|
				@matrix[[n + 1, i]] = score(n + 1, i)
			end
		end
	end

	# Prints out the matrix for inspection
	def inspect
		puts " " * 7 + @sequence2.join(" " * 2)

		(@sequence1.length + 1).times do |i|
			if i > 0
				print @sequence1[i - 1] + " " 
			else
				print " " * 2
			end

			(@sequence2.length + 1).times do |j|
				print " " if @matrix[[i, j]] < 0
				print " " * 2 if @matrix[[i, j]] >= 0
				print @matrix[[i, j]].to_s
			end
			puts
		end
	end

	def next_position(x, y)
		left = [x-1, y]
		top = [x, y-1]
		diagonal = [x-1, y-1]

		values = [@matrix[left], @matrix[top], @matrix[diagonal]]

		# If all the values are equal, then go diagonal
		return diagonal if @matrix[left] == @matrix[top] == @matrix[diagonal]

		# Otherwise, return the maximum value
		return [left, top, diagonal].at([@matrix[left], @matrix[top], @matrix[diagonal].
	end

	def solve
		position = [@sequence1.length, @sequence2.length]
	end
end

matrix = Matrix.new("GGATCGA", "GAATTCAGTTA")

matrix.fill

matrix.solve
