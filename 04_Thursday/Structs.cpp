#include <cstddef>
#include <stdio.h>

template <typename T>
struct RegularPolygon {
  size_t number_of_sides_;
  T side_length_;
  RegularPolygon(const size_t n, const T& l) : number_of_sides_(n), side_length_(l) {}
  T perimeter() const { return side_length_ * number_of_sides_; }
};

template <typename T>
struct Square : RegularPolygon<T> {
  Square(const T& length) : RegularPolygon<T>(4, length) {}
  T area() const {
    return RegularPolygon<T>::side_length_ * RegularPolygon<T>::side_length_;
  }
};

int main() {
  const RegularPolygon<double> triangle{3, 4.4};
  printf("Triangle perimeter: %1.2f\n", triangle.perimeter());
  const RegularPolygon<size_t> hex{6, 7};
  printf("Hex perimeter: %lu\n", hex.perimeter());
  const Square<double> square{8.0};
  printf("Square area: %1.15f\n", square.area());
  return 0;
}
