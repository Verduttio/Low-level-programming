#include <iostream>
#include <cmath>
#include <immintrin.h>

using namespace std;
// width powinien dzielic sie przez 4
const int width = 300, height = 168;

void limitResult(float image[height][width], int i, int j) {
	if(image[i][j] > 255) {
		image[i][j] = 255;
	} else if(image[i][j] < 0) {
		image[i][j] = 0;
	}
}

void filtr(int imageWidth, int imageHeight, float image[height][width], 
           float weight[3][3], float result[height][width]){
			   
	__m128 weightSquare[3][3];			   
	__m128 resultSquare[3][3];  // __m128 po to aby już mieć wyliczone dla 4 kolejnych pikseli
	
	float weightTotal = 0;

	for (int i = 0; i < 3; i++) {
		for (int j = 0; j < 3; j++) {
			weightTotal += weight[i][j];
			weightSquare[i][j] = _mm_load_ps1(&weight[i][j]);
		}
	}
	__m128 weightTotalM128 = _mm_load_ps1(&weightTotal);
	

	// od 1 do size -1 ponieważ do wyznaczenia wartości danego piksela potrzebujemy jego sąsiadów
	for (int i = 1; i < imageHeight - 1; i++) {
		for (int j = 1; j < imageWidth - 1; j+=4) {
			
		  	// W resultSquare znajdują się wartości piskeli przemnożone przez odpowiadające im wagi
		  	// Najpierw ładujemy wartość piksela a potem ją wymnażamy
		  	// A na końcu dodajemy do siebie wartości wszystkich pikseli
		  	__m128 outputPixels = _mm_set_ps1(0.0);
			for (int x = 0; x < 3; x++) {
				for (int y = 0; y < 3; y++) {
					resultSquare [x] [y] = _mm_loadu_ps(&(image[i + (x-1)][j + (y-1)]));
					resultSquare [x] [y] = _mm_mul_ps (resultSquare [x] [y], weightSquare [x] [y]);
					outputPixels = _mm_add_ps(outputPixels, resultSquare[x][y]);
				}
			}
		  
			// Jeśli suma wag jest niezerowa to wykonujemy dzielenie
			if(weightTotal != 0) {
				outputPixels = _mm_div_ps(outputPixels, weightTotalM128);
			}

			_mm_storeu_ps(&(result[i][j]), outputPixels);     // Zapisujemy wynik
			
			// obcinamy wartości pikseli jesli nie mieszcza sie w przedziale
			limitResult(result, i, j);
			limitResult(result, i, j + 1);
			limitResult(result, i, j + 2);
			limitResult(result, i, j + 3);
		}
	}
}		   

int main(void)
{
    const int headerLength = 122; // 64; //sizeof(BMPHEAD);
    char header[headerLength];
    float data[3][height][width];    // tablica dla każdej składowej koloru
    float result[3][height][width];

    float weight[3][3]= { {0, -2, 0}, { -2, 11, -2}, {0, -2, 0} };
    
    int i,j,k;
    FILE *file;
    file=fopen("pigeon.bmp","rb");
    if(!file) { std::cerr << " Error opening file !"; exit(1); }
    fread(header, headerLength, 1, file);
    for(i=0;i<height;i++)
        for(j=0;j<width;j++)
           for(k=0; k<3; ++k)   
            data[k][i][j]=fgetc(file);
    fclose(file);
    
    for(i=0;i<3;i++)   // filtrujemy dla każdej składowej osobno
        filtr(width, height, data[i], weight, result[i]);

    file=fopen("result.bmp","wb");
    fwrite(header, headerLength, 1, file);
    for(i=0;i<height;i++)
      for(j=0;j<width;j++)
        for(k=0; k<3; ++k)
          fputc((unsigned char)result[k][i][j],file);
    fclose(file);
}
