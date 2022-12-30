#include <iostream>

extern "C" double wartosc (double a, double b, double x, int n);

int main()
{
  int wynik = wartosc(4.0, 3.0, 2.0, 2);
  int wynik2 = wartosc(1.0, -3.0, 13.0, 6);
  
  std::cout << "WARTOSC: " << 121 << ", OUTPUT: " << wynik << " | " <<(wynik==121 ? "TRUE" : "FALSE") << std::endl;
  std::cout << "WARTOSC: " << 1000000 << ", OUTPUT: " << wynik2 << " | " <<(wynik2==1000000 ? "TRUE" : "FALSE") << std::endl;
  
  return 0;
}
