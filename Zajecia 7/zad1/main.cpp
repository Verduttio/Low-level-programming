#include <iostream>

extern "C" int suma (int n, int * tab);

int main()
{
  int tab[] = {1,2,3,4};
  int wynik = suma(4, tab);
  
  int tab2[] = {4, -2, 10, 43, -41};
  int wynik2 = suma(5, tab);
  
  std::cout << "SUM: " << 10 << ", OUTPUT: " << wynik << " | " <<(wynik==10 ? "TRUE" : "FALSE") << std::endl;
  std::cout << "SUM: " << 14 << ", OUTPUT: " << wynik2 << " | " <<(wynik2==14 ? "TRUE" : "FALSE") << std::endl;
  
  return 0;
}
