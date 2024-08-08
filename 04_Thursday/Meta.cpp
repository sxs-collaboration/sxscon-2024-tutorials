#include <cstddef>
namespace tmpl {
template <typename...>
struct list {};
}  // namespace tmpl

template <typename...>
struct TypeDisplayer;

template <size_t X>
struct Number {
  static constexpr size_t value = X;
};

template <size_t X, size_t Y>
struct Sum {
  using result = Number<X + Y>;
};

int main() {
  using list_of_types = tmpl::list<double, int, Sum<4,5>, Sum<4,5>::result, Number<57>>;
  constexpr size_t value = Sum<4,5>::result::value;
  TypeDisplayer<list_of_types> for_type_printing;
  return 0;
}
