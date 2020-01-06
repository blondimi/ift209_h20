#include <iostream>

void foo()
{
  while (true) {
    std::cout << "foo()" << std::endl;
  }
}

int main()
{
  foo();
}
