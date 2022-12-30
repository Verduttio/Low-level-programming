#include <iostream>
using namespace std;

// kopiuje n liczb typu int z zrodla do celu 
void kopiuj(unsigned int * cel, unsigned int * zrodlo, unsigned int n);

// zeruje tablice liczb typu int o rozmiarze n
void zeruj(unsigned int * tablica, unsigned int n);

void displayArray(unsigned int * tab, int n) {
	cout << "[";
	for(int i = 0; i < n; i++) {
		cout << tab[i] << ", ";
	}
	cout << "]\n";
}


int main() {
	unsigned int tab1 [] = {1,2,3,4,5,6};
	unsigned int tab2 [] = {9,8,7,6,5,4};
	unsigned int tab3 [] = {0,0,0,0,0,0};
	
	unsigned int n = 6;
	
	kopiuj(tab3, tab1, n);
	
	cout << "tab3: \n";
	displayArray(tab3, n);
	
	cout << "tab1: \n";
	displayArray(tab1, n);
	
	zeruj(tab1, n);
	cout << "tab1: \n";
	displayArray(tab1, n);

	return 0;
}
