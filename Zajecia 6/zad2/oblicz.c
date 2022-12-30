#include <stdio.h>

long oblicz(short x, int y, long z) {
	int poweredY = 1;
	for(int i = 0; i < x; i++) {
		poweredY *= y;
	}
	
	printf("[1]: %d \n", poweredY);
	
	int negative = 0;
	if(poweredY < 0) {
		poweredY += 31;
		negative = 1;
	}
	
	printf("[2]: %d \n", poweredY);
	
	// Take only 5 first bits and add *z*
	long compressed = (poweredY & 31);
	
	printf("[3]: %ld \n", compressed);
	
	if(negative == 1) compressed -= 31;
	
	printf("[4]: %ld \n", compressed);
	return compressed + z;
}; 

int main(){
	short x;
    int y;
	long z;
	printf(" Podaj trzy liczby : ");
	scanf("%hd %d %ld", &x, &y, &z);	
	printf(" Wynik : %ld \n", oblicz(x, y, z));
	return 0;
}
