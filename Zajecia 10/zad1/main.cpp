#include <cstdlib>
#include <cstdio>
#include <ctime>
#include <smmintrin.h>
#include <emmintrin.h>
#include <iostream>

using namespace std;
int main(){
    const int prog = 100000;
    const int rozmiar = 100;
    unsigned int tab[rozmiar];

    //srand(time(0));
    srand(2021);  // dla powtarzalności testów

    for(int i=0; i<rozmiar; ++i){
        tab[i] = rand() % prog;
    }
    unsigned int max_bad = 0;
    for(int i=0; i<rozmiar; ++i){
        if(max_bad < tab[i])
            max_bad = tab[i];
    }
    printf("%d\n", max_bad);
    ////////////////////////////////

    // https://developercommunity.visualstudio.com/t/msvc2017-incorrect-code-when-m128i-value-is-initia/848629
    __m128i max = _mm_set_epi32(0,0,0,0);

    for(int i=0; i<rozmiar; i+=4){
        __m128i current = _mm_loadu_si128((__m128i const*)(tab + i));    // movdqu - kopiuj wektor liczb całkowitych (16 bajtów) spod dowolnego adresu
        max = _mm_max_epu32(max, current);              // compare packed unsigned 32-bit integers, and store packed maximum values
    }

    unsigned int maxes [4];
    _mm_storeu_si128((__m128i*) maxes, max);              // movdqu m128, xmm

//    printf("---------------------\n");
//    for(int i = 0; i < 4; i++) {
//        printf("%d\n", maxes[i]);
//    }
//    printf("---------------------\n");

    unsigned int finalMax = 0;
    for(int i = 0; i < 4; i++) {
        if(maxes[i] > finalMax) {
            finalMax = maxes[i];
        }
    }

    printf("%d\n", finalMax);
    return 0;
}