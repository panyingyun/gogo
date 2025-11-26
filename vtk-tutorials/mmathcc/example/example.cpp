// example.cpp

#include <iostream>
#include "mmathcc.h"

int main()
{
    double a = 100;
    int b = 2;
    using MMathCC::Arithmetic;
    std::cout << "a + b = " << Arithmetic::Add(a, b) << std::endl;
    std::cout << "a - b = " << Arithmetic::Subtract(a, b) << std::endl;
    std::cout << "a * b = " << Arithmetic::Multiply(a, b) << std::endl;
    std::cout << "a / b = " << Arithmetic::Divide(a, b) << std::endl;

    return 0;
}