#include <iostream>

void bar()
{
  std::cout << "bar()" << std::endl;

  bar();
}

int main()
{
  bar();
}
