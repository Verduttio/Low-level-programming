#include <iostream>
#include <algorithm>
#include <cmath>
#include <cstring>
// Funkcje z zadania 2
// kopiuje n liczb typu int z zrodla do celu 
void kopiuj(unsigned int * cel, unsigned int * zrodlo, unsigned int n);
// zeruje tablice liczb typu int o rozmiarze n
void zeruj(unsigned int * tablica, unsigned int n);

void displayArray(unsigned int* tab, int n) {
	std::cout << "////Displaying array/////" << std::endl;
	for(int i = 0; i < n; i++) {
		std::cout << "i: " << i << ", tab: " << tab[i] << std::endl;
	}
	std::cout << std::endl;
	std::cout << std::endl;
	
}

class BigInt{  
  
public:  
	unsigned int rozmiar;   
  unsigned int * dane;      

  explicit BigInt(unsigned int rozmiar) 
  : rozmiar(rozmiar), dane( new unsigned[rozmiar] ){
    zeruj(dane, rozmiar);  
  }  
  BigInt(const BigInt & x)   
  :  rozmiar(x.rozmiar),       dane(new unsigned[x.rozmiar]){     
    kopiuj(dane, x.dane, x.rozmiar);  
  }    
  BigInt & operator=(const BigInt & x) {    
    if(rozmiar != x.rozmiar){      
      unsigned * tmp = new unsigned[x.rozmiar];      
      delete[] dane;       
      rozmiar = x.rozmiar;      
      dane = tmp;    
    }    
    kopiuj(dane, x.dane, x.rozmiar);    
    return *this;  
  }  
  ~BigInt(){		    
    delete[] dane;  
  }
  
  // do zaimplementowania w zadaniu 3  
  int dodaj(unsigned int n);  
  int pomnoz(unsigned int n);  
  int podzielZReszta(unsigned int n);    
  BigInt & operator=(const char * liczba) {
	  size_t liczba_size = strlen(liczba);
	  
	  rozmiar = liczba_size;
	  //std::cout << "rozmiar: " << rozmiar << std::endl;
	  
	  delete[] dane;
	  dane = new unsigned int [rozmiar];
	  zeruj(dane, rozmiar);
	  
	  for(int i = 0; i < liczba_size; i++) {
		  pomnoz(10);
		  dodaj(liczba[i]-'0');
		  //std::cout << "->" << *this << std::endl;
		  //displayArray(dane, rozmiar);
	  }
	  
	  displayArray(dane, rozmiar);
	  
	  return *this;  
	  
	  	  
  }  
  
  
  friend std::ostream & operator << (std::ostream & str, const BigInt & x);
  
  bool empty() {
	  for(int i = 0; i < rozmiar; i++) {
		  if(dane[i] != 0) return false;
	  }
	  return true;
  }
  
  // do zaimplementowania w zadaniu 4  
  friend BigInt operator+ (const BigInt & a, const BigInt & b);  
  friend BigInt operator- (const BigInt & a, const BigInt & b);
}; 

std::ostream & operator << (std::ostream & str, const BigInt & x) {
	// Dzielimy liczbę przez 10 i reszta to będzie kolejna cyfra (od końca)
	
	BigInt copy(x);
	
	std::string number = "";
	while(!copy.empty()) {
		int remainder = copy.podzielZReszta(10);
		number += std::to_string(remainder);
		//std::cout << "number: " << remainder << std::endl;
		//displayArray(copy.dane, copy.rozmiar);
	}
	
	std::reverse(number.begin(), number.end());
	
	str << number;
	
	return str;
		
}




using namespace std;



void test_Dodaj() {
	cout << "####TEST DODAJ####" << endl << endl;
	
	cout << "--Without BigInt overflow--" << endl;
	cout << "Dodaj 4294967295 + 2" << endl;
	BigInt a(2);
	a.dodaj(4294967295);
	int ret = a.dodaj(2);
	cout << "dane[0]: " << a.dane[0] << ", SHOULD BE: 1 ==> " << (a.dane[0] == 1 ? "TRUE" : "FALSE") << endl;
	cout << "dane[1]: " << a.dane[1] << ", SHOULD BE: 1 ==> " << (a.dane[1] == 1 ? "TRUE" : "FALSE") << endl;
	cout << "returned value: " << ret << ", SHOULD BE: 0 ==> " << (ret == 0 ? "TRUE" : "FALSE") << endl;
	cout << endl;
	
	cout << "Dodaj 4294967295 + 1" << endl;
	BigInt b(2);
	b.dodaj(4294967295);
	ret = b.dodaj(1);
	cout << "dane[0]: " << b.dane[0] << ", SHOULD BE: 0 ==> " << (b.dane[0] == 0 ? "TRUE" : "FALSE") << endl;
	cout << "dane[1]: " << b.dane[1] << ", SHOULD BE: 1 ==> " << (b.dane[1] == 1 ? "TRUE" : "FALSE") << endl;
	cout << "returned value: " << ret << ", SHOULD BE: 0 ==> " << (ret == 0 ? "TRUE" : "FALSE") << endl;
	cout << endl;
	
	
	cout << "--With BigInt overflow--" << endl;
	cout << "Dodaj 4294967295 + 1" << endl;
	BigInt c(1);
	c.dodaj(4294967295);
	ret = c.dodaj(1);
	cout << "returned value: " << ret << ", SHOULD BE: 1 ==> " << (ret == 1 ? "TRUE" : "FALSE") << endl; 
	
	cout << endl;
}

void test_Pomnoz() {
	cout << "####TEST POMNOZ####" << endl << endl;
	
	cout << "--Without BigInt overflow--" << endl;
	cout << "Pomnoz 1234 * 77" << endl;
	BigInt a(1);
	a.dodaj(1234);
	int ret = a.pomnoz(77);
	cout << "dane[0]: " << a.dane[0] << ", SHOULD BE: 95018 ==> " << (a.dane[0] == 95018 ? "TRUE" : "FALSE") << endl;
	cout << "returned value: " << ret << ", SHOULD BE: 0 ==> " << (ret == 0 ? "TRUE" : "FALSE") << endl;
	cout << endl;
	
	cout << "Pomnoz 4294967295 * 123" << endl;
	BigInt b(2);
	b.dodaj(4294967295);
	ret = b.pomnoz(123);
	cout << "dane[0]: " << b.dane[0] << ", SHOULD BE: 4294967173 ==> " << (b.dane[0] == 4294967173 ? "TRUE" : "FALSE") << endl;
	cout << "dane[1]: " << b.dane[1] << ", SHOULD BE: 122 ==> " << (b.dane[1] == 122 ? "TRUE" : "FALSE") << endl;
	cout << "returned value: " << ret << ", SHOULD BE: 0 ==> " << (ret == 0 ? "TRUE" : "FALSE") << endl;
	cout << endl;
	
	cout << "Pomnoz 4294967295 * 4294967295" << endl;
	BigInt c(3);
	c.dodaj(4294967295);
	ret = c.pomnoz(4294967295);
	cout << "dane[0]: " << c.dane[0] << ", SHOULD BE: 1 ==> " << (c.dane[0] == 1 ? "TRUE" : "FALSE") << endl;
	cout << "dane[1]: " << c.dane[1] << ", SHOULD BE: 4294967294 ==> " << (c.dane[1] == 4294967294 ? "TRUE" : "FALSE") << endl;
	cout << "dane[2]: " << c.dane[2] << ", SHOULD BE: 0 ==> " << (c.dane[2] == 0 ? "TRUE" : "FALSE") << endl;
	cout << "returned value: " << ret << ", SHOULD BE: 0 ==> " << (ret == 0 ? "TRUE" : "FALSE") << endl;
	cout << endl;
		
	cout << "Pomnoz 4294967295 * 4294967295 * 4294967295" << endl;
	BigInt cc(3);
	cc.dodaj(4294967295);
	ret = cc.pomnoz(4294967295);
	ret = cc.pomnoz(4294967295);
	cout << "dane[0]: " << cc.dane[0] << ", SHOULD BE: 4294967295 ==> " << (cc.dane[0] == 4294967295 ? "TRUE" : "FALSE") << endl;
	cout << "dane[1]: " << cc.dane[1] << ", SHOULD BE: 2 ==> " << (cc.dane[1] == 2 ? "TRUE" : "FALSE") << endl;
	cout << "dane[2]: " << cc.dane[2] << ", SHOULD BE: 4294967293 ==> " << (cc.dane[2] == 4294967293 ? "TRUE" : "FALSE") << endl;
	cout << "returned value: " << ret << ", SHOULD BE: 0 ==> " << (ret == 0 ? "TRUE" : "FALSE") << endl;
	cout << endl;
	
	cout << "--With BigInt overflow--" << endl;
	cout << "Pomnoz 4294967295 * 4294967295" << endl;
	BigInt d(1);
	d.dodaj(4294967295);
	ret = d.pomnoz(4294967295);
	cout << "returned value: " << ret << ", SHOULD BE: 1 ==> " << (ret == 1 ? "TRUE" : "FALSE") << endl;
	cout << endl;
}

void test_PodzielZReszta() {
	cout << "####TEST PODZIEL Z RESZTA####" << endl << endl;
	
	cout << "Podziel 4294967295 / 1234" << endl;
	BigInt a(1);
	a.dodaj(4294967295);
	int reszta = a.podzielZReszta(1234);
	cout << "dane[0]: " << a.dane[0] << ", SHOULD BE: 3480524 ==> " << (a.dane[0] == 3480524 ? "TRUE" : "FALSE") << endl;
	cout << "reszta: " << reszta << ", SHOULD BE: 679 ==> " << (reszta == 679 ? "TRUE" : "FALSE") << endl;
	cout << endl;
	
	
	cout << "Podziel 4294967295 * 4294967295 / 1234" << endl;
	BigInt c(2);
	c.dodaj(4294967295);
	c.pomnoz(4294967295);
	reszta = c.podzielZReszta(1234);
	cout << "dane[0]: " << c.dane[0] << ", SHOULD BE: 2820 ==> " << (c.dane[0] == 2820 ? "TRUE" : "FALSE") << endl;
	cout << "dane[1]: " << c.dane[1] << ", SHOULD BE: 4294967294 ==> " << (c.dane[1] == 4294967294 ? "TRUE" : "FALSE") << endl;
	cout << "reszta: " << reszta << ", SHOULD BE: 644 ==> " << (reszta == 644 ? "TRUE" : "FALSE") << endl;
	cout << endl;
	
}

void test_Wypisania() {
	BigInt a(1);
	a.dodaj(4294967295);
	cout << a << ", SHOULD BE: 4294967295" << endl;
}

void test_Przypisania() {
	BigInt a(2);
	
	a = "123456789";
	cout << a << ", SHOULD BE = 123456789" << endl;
	
	a = "12345678901234567890";
	cout << a << ", SHOULD BE = 12345678901234567890" << endl;
	
	
}

void test_Rozne() {
	cout << "####TEST ROZNE####" << endl << endl;
	
	//cout << "Pomnoz 0 * 10 + 4" << endl;
	//BigInt a(9);
	//int overflw = a.pomnoz(10);
	//cout << "ret mnozenie: " << overflw << ", SHOULD BE: 0 ==> " << (overflw == 0 ? "TRUE" : "FALSE") << endl;
	//overflw = a.dodaj(4);
	//cout << "ret dodaj: " << overflw << ", SHOULD BE: 0 ==> " << (overflw == 0 ? "TRUE" : "FALSE") << endl;
	//cout << "dane[0]: " << a.dane[0] << ", SHOULD BE: 4 ==> " << (a.dane[0] == 4 ? "TRUE" : "FALSE") << endl;
	
	//cout << "...*10 + 7" << endl;
	//overflw = a.pomnoz(10);
	//cout << "ret mnozenie: " << overflw << ", SHOULD BE: 0 ==> " << (overflw == 0 ? "TRUE" : "FALSE") << endl;
	//overflw = a.dodaj(7);
	//cout << "ret dodaj: " << overflw << ", SHOULD BE: 0 ==> " << (overflw == 0 ? "TRUE" : "FALSE") << endl;
	//cout << "dane[0]: " << a.dane[0] << ", SHOULD BE: 47 ==> " << (a.dane[0] == 47 ? "TRUE" : "FALSE") << endl;
	
	
	BigInt a(2);
	a.dodaj(123456789);
	cout << a.podzielZReszta(10) << endl;
	cout << a.podzielZReszta(10) << endl;
	cout << a.podzielZReszta(10) << endl;
	cout << a.podzielZReszta(10) << endl;
	cout << a.podzielZReszta(10) << endl;
	cout << a.podzielZReszta(10) << endl;
	cout << a.podzielZReszta(10) << endl;
	
	
	cout << endl;
	
	
	
}

int main() {
//	test_Dodaj();
	//test_Pomnoz();
//	test_PodzielZReszta();
	//test_Pomnoz();
//	test_Pomnoz();
//	test_Pomnoz();

	//test_Wypisania();
	
	test_Przypisania();
	
	//test_Rozne();
	
	
	return 0;
}
