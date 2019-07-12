#include <stdio.h>
#include <math.h>

int main(void) {

	double baseclk = 50e6;
	double target = 8.113e6;
	
	int best_divisor = 0;
	int best_multipler = 0;
	double best_error = -1;
	
	for(int mult = 1; mult <= 64; mult++) {
		int divis = round(baseclk*mult/target);
		if(divis>0) {
			double yield = baseclk*mult/divis;
			double error = fabs((yield-target)/target);
			if(best_error < 0 || error < best_error) {
				best_error = error;
				best_multipler = mult;
				best_divisor = divis;
			}
		}
	}
	
	printf("target: %0.0f, bestmatch: %i/%i, yeild: %0.0f error: %f\r\n", target, best_multipler, best_divisor, baseclk*best_multipler/best_divisor, best_error);
	
	return 0;
}
