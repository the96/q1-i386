#include <stdio.h>

extern int isPrime(unsigned int a, char b[]);

int main() {
    unsigned int x;
    unsigned int max = 0xfffffff;//1048576;
    char sieve[max];
    while (scanf("%u", &x) != EOF) {
        if (x > max) {
            printf("over number of max\n");
            continue;
        }
        if (!isPrime(x,sieve)) {
            printf("prime\n");
        } else {
            printf("not prime\n");
        }
    }
    return 0;
}
