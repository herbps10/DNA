#include <stdio.h>
int main(void) {
	char stop_codons[3][3] = {{'T', 'A', 'G'}, {'T', 'A', 'A'}, {'T', 'G', 'A'}};

	for(int i = 0; i < 3; i++) {
		int sum = 0;
		for(int k = 0; k < 3; k++) {
			sum += stop_codons[i][k] << k;
		}

		printf("%i\n", sum);
	}

	return 0;
}
