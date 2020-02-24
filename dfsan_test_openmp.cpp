
#include <vector>
#include <numeric>
#include <cassert>

#include <omp.h>

#include <sanitizer/dfsan_interface.h>

int main(void)
{

  int m = 1;
  dfsan_label m_label = dfsan_create_label("m", 0);
  dfsan_set_label(m_label, &m, sizeof(m));
  int n = 100;

  #pragma omp parallel
  {
    int * sum = new int[omp_get_num_threads()];
    #pragma omp for
    for(int i = 0; i < n; ++i)
      sum[omp_get_thread_num()] += m;
    dfsan_label test_label = dfsan_read_label(&sum[omp_get_thread_num()], sizeof(int));
    assert(dfsan_has_label(test_label, m_label));
    delete[] sum;
  }

  return 0;
}
