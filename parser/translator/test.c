#include <stdio.h>

int fibonacci(int n) {
    int a = 0;
    int b = 1;
    int c;

    if (n == 0) {
        a = 1;
    } else if (n == 1) {
        return b;
    }

    for (int i = 2; i <= n; i = i + 1) {
        c = a + b;
        a = b;
        b = c;
    }
    
    return b;
}