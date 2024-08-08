#include <cmath>
#include <cstddef>
#include <stdio.h>
#include <string>

double distance_2d(const double length, const double width) {
  return sqrt(length * length + width * width);
}

int main() {
  const std::string hello{"Hello, world"};
  constexpr double length{3.1};
  constexpr double height{4.2};
  const auto distance = distance_2d(length, height);
  printf("%s %1.15f\n", hello.c_str(), distance);

  if (length < height) {
    printf("Length < width\n");
  } else {
    printf("Length >= width\n");
  }
  
  for (size_t i = 0; i < 10; ++i) {
    printf("%lu\n", i*i);
  }
  return 0;
}
