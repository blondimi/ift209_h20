#include <iostream>

void foo()
{
  std::cout << "foo()" << std::endl;

  while (true) { }
}

int main()
{
  foo();
}
