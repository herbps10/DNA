#include <stdio.h>
#include "mpi.h"

#define TRUE 1
#define FALSE 0

// Compares the base pairs in two codon arrays to see if they are the same codon
int codon_compare(char *codon1, char *codon2) {
	for(int i = 0; i < 3; i++) {
		if(codon1[i] != codon2[i]) {
			return FALSE;
		}
	}

	return TRUE;
}

int main(int argc, char *argv[]) {
	MPI_Init(&argc, &argv);

	int numprocs, rank;
	MPI_Comm_size(MPI_COMM_WORLD, &numprocs);
	MPI_Comm_rank(MPI_COMM_WORLD, &rank);

	int frame = rank;

	FILE *fhandle = fopen("/root/dna/DNA/data/chr1.fa", "r");

	if(fhandle == NULL) {
		printf("Cannot open file");
		MPI_Finalize();
		return(0);
	}
	else {
		printf("Successfully opened file\n");
	}

	char buffer = '\0';
	int ignoreLine = FALSE;

	int num_stops[3] = {0, 0, 0};  // keeps a running total of how many stop codons have been found in each reading frame
	int frame_enabled[3] = {0, 0, 0}; // keeps track of which reading frames have been reached and are enabled
	
	// the codons array is filled with the three base pairs that make up a codon for each frame. After three base pairs for a frame are read, they are tested against the stop codons to see if they match.
	int codons[3] = {0, 0, 0};

	// I precalculated these using codon_number_test.c
	int stop_codons[3] = {498, 474, 486};

	// base_counter keeps track of which base pair we are on. It does NOT count the total number of characters in the file -- only valid base pairs.
	char base;
	int base_counter = 0;
	int codon_position;
	while((buffer = getc(fhandle)) != EOF) {
		// Reading frames are enabled one by one. The first to be enabled is the zero frame, then the first and second frame.
		if(base_counter <= 6) {
			frame_enabled[base_counter] = 1;
		}

		if(buffer == '<' || buffer == ';') {
			ignoreLine = TRUE;
			continue;
		}

		if(buffer == '\n') {
			ignoreLine = FALSE;
			continue;
		}

		if(ignoreLine == TRUE) continue;

		switch(buffer) {
			case 'a':
			case 'A':
				base = 'A';
				break;
			case 'c':
			case 'C':
				base = 'C';
				break;
			case 'g':
			case 'G':
				base = 'G';
				break;
			case 't':
			case 'T':
				base = 'T';
				break;
			default:
				continue;
		}

		// Check to make sure this reading frame is enabled.
		// When would a reading frame not be enabled? say for example we are on the first base pair.
		// Then the only enabled reading frame would be frame 0. Frame 1 and 2 wouldn't have kicked in yet.
		if(frame_enabled[frame] == TRUE) {
			// This gets us what position we are in the codon (0, 1, or 2)
			codon_position = (base_counter - frame) % 3;
			codons[frame] += base << codon_position;

			// If we are on the last base pair of a codon
			if(codon_position != 0 && codon_position % 3 == 2) {
				for(int i = 0; i < 3; i++) {
					if(codons[frame] == stop_codons[i]) {
						num_stops[frame] += 1;
						break;
					}
				}

				codons[frame] = 0;
			}
		}

		base_counter++;

		//if(base_counter >= 100) break;
	}

	printf("Frame %i: %i stop codons\n", frame, num_stops[frame]);

	fclose(fhandle);

	MPI_Finalize();

	printf("\n");
}
