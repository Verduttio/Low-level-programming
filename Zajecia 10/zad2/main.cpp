#include <stdio.h>
#include <immintrin.h>

void scaleSSE(float * wynik, float * data, int n){
    /// TODO !!!!
    ///OUT(i,j) = (IN(2*i,2*j) + IN(2*i +1,2*j) + IN(2*i,2*j + 1) + IN(2*i + 1,2*j + 1))/4
    for(int i=0; i<n/2; i+=4) {
        __m128 xmm0 = _mm_loadu_ps(&data[2*i]);
        __m128 xmm1 = _mm_loadu_ps(&data[n + 2*i]);

        __m128 xmm2 = _mm_loadu_ps(&data[2*(i+2)]);
        __m128 xmm3 = _mm_loadu_ps(&data[n + 2*(i+2)]);

        xmm0 = _mm_add_ps(xmm0, xmm1);
        xmm2 = _mm_add_ps(xmm2, xmm3);

        xmm0 = _mm_hadd_ps(xmm0, xmm2);

        __m128 four = _mm_set_ps1(4.0);
        xmm0 = _mm_div_ps(xmm0, four);

        _mm_storeu_ps(&wynik[i], xmm0);
    }

}

int main(void) {

    const int N = 400, HL = 1078;
    float data[N][N],
            wynik[N][N];
    unsigned char header[HL];
    int i, j;

    FILE *strm;
    strm = fopen("circle3.bmp", "rb");
    fread(header, 1, HL, strm);  // wczytuje header
    for (i = 0; i < N; i++)             // wczytuje dane bitmapy
        for (j = 0; j < N; j++)         // konwertując piksele na float
            data[i][j] = (float) fgetc(strm);
    fclose(strm);

    // właściwe skalowanie bitmapy wiersz po wierszu
    for (i = 0; i < N / 2; i++)
        scaleSSE(wynik[i], data[2 * i], N);

    // Modyfikujemy rozmiar bitmapy w nagłówku
    header[4] = 0;
    header[3] = 160;
    header[2] = 118; // rozmiar pliku

    header[18] = 200;
    header[19] = 0;  // szerokość bitmapy
    header[22] = 200;
    header[23] = 0;  // wysokość bitmapy

    // Zapisuje wynik do pliku
    strm = fopen("wynik3.bmp", "wb");
    fwrite(header, 1, HL, strm);
    for (i = 0; i < N / 2; i++)
        for (j = 0; j < N / 2; j++)    // konwertuje wyniki na skalę szarości
            fputc((unsigned char) wynik[i][j], strm);
    fclose(strm);
}
