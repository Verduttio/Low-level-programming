#include <iostream>

extern "C" int iloczyn (int n, ...);

int main()
{
  int wynik = iloczyn(4,1,2,3,4);
  int wynik2 = iloczyn(10, 1, 2, 3, 4, 1, 1, 1, 1, 1, 10);
  
  std::cout << "WARTOSC: " << 24 << ", OUTPUT: " << wynik << " | " <<(wynik==24 ? "TRUE" : "FALSE") << std::endl;
  std::cout << "WARTOSC: " << 240 << ", OUTPUT: " << wynik2 << " | " <<(wynik2==240 ? "TRUE" : "FALSE") << std::endl;
  
  return 0;
}
