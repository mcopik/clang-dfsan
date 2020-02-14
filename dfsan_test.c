#include <sanitizer/dfsan_interface.h>
#include <assert.h>

int main(void)
{

  int i = 1;
  dfsan_label i_label = dfsan_create_label("i", 0);
  dfsan_set_label(i_label, &i, sizeof(i));

  int j = 2;
  dfsan_label j_label = dfsan_create_label("j", 0);
  dfsan_set_label(j_label, &j, sizeof(j));

  int test = i + j;
  dfsan_label test_label = dfsan_read_label(&test, sizeof(test));
  assert(dfsan_has_label(test_label, i_label));
  assert(dfsan_has_label(test_label, j_label));

  return 0;
}
