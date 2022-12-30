#include <cstdio>
using namespace std;
unsigned int rotate(unsigned int x, int n = 1);
unsigned char rotate(unsigned char x, int n = 1);

template <typename T>
void test(){
  T a = 1, b = 127;
  printf("%u  %u\n", (unsigned)rotate(a, 1), (unsigned)rotate(b,1));
  printf("%u  %u\n", (unsigned)rotate(a, 8), (unsigned)rotate(b,8));
  printf("%u  %u\n", (unsigned)rotate(a, 31), (unsigned)rotate(b,31));
  printf("--------\n");
}

int main(){
  test<unsigned char>();
  test<unsigned int>();
  return 0;
}

/** Spodziewane wyjście
2  254
1  127
128  191
--------
2  254
256  32512
2147483648  2147483711
--------
*/
