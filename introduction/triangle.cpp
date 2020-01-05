#include <iostream>

unsigned long triangle(unsigned long n)
{
  unsigned long t = 0;

  while (n > 0) {
    t += n;
    n -= 1;
  }

  return t;
}

int main()
{
  std::cout << triangle(4) << std::endl;
}
