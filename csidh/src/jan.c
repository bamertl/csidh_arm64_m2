#include "benchmark.h"

void random_user(void){
    int i = 0;
    for(int j = 0; j < 10000; j++){
        i = i + 1;
    }
}

int main(void)
{
    measure_everything(random_user);
}
