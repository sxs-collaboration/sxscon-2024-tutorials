#include <stdio.h>
#include <cstddef>
#include <cmath>

template <typename T>
double apply_3_times(const double initial, T func) {
  double result = initial;
  for (size_t i = 0; i < 3; ++i) {
    result = func(result);
  }
  return result;
}

int main() {
  constexpr double amp{2.0};
  const double cos3Times = apply_3_times(4.5, [&amp](const double x){return amp * cos(x);});
  printf("%1.15f\n", cos3Times);
  return 0;
}
