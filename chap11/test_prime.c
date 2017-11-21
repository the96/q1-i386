#include <stdio.h>

extern int isPrime(unsigned int a);

int main() {
    unsigned int x;
    while (scanf("%u", &x) != EOF) {
        if (isPrime(x)) {
            printf("prime\n");
        } else {
            printf("not prime\n");
        }
    }
    return 0;
}
