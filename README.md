# clang-dfsan

## Docker files for images with LLVM, clang and libcxx compiled with dataflow taint analysis (dfsan).

`dfsan` image provides the LLVM's clang with a complete C++ toolchain that has been compiled with dataflow (taint) sanitization. It uses GNU's libc6 and LLVM's compiler-rt, libcxx, and libunwind built with tainting.

`cfsan` image provides the same functionalities, except that it uses an LLVM fork with control-flow tainting added to the `dfsan` sanitizer.

Example:

```c++
#include <vector>
#include <numeric>
#include <cassert>

#include <sanitizer/dfsan_interface.h>

int main(void)
{

  int i = 1;
  dfsan_label i_label = dfsan_create_label("i", 0);
  dfsan_set_label(i_label, &i, sizeof(i));

  int j = 2;
  dfsan_label j_label = dfsan_create_label("j", 0);
  dfsan_set_label(j_label, &j, sizeof(j));

  std::vector<int> vec{1, 2, i};
  dfsan_label test_label = dfsan_read_label(&vec.at(2), sizeof(int));
  assert(dfsan_has_label(test_label, i_label));

  int test = std::accumulate(vec.begin(), vec.end(), j);
  test_label = dfsan_read_label(&test, sizeof(test));
  assert(dfsan_has_label(test_label, i_label));
  assert(dfsan_has_label(test_label, j_label));

  return 0;
}
```

Simply pull the images `mcopik/clang-dfsan:dfsan-9.0` and `mcopik/clang-dfsan:cfsan-9.0`, build the source file using our wrapper: `clang++-dfsan dfsan_test.cpp -o dfsan_test.exe` (or with clang++-cfsan), and execute `./dfsan_test.exe`. Feel free to modify Docker files according to your needs.


