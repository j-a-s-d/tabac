#include <iostream.h>
#include <string.h>

#ifdef SOMETHING
  if (x != 0) {}
#else
  if (x != 1) {}
#endif
    int y = 2;

if (x == 2) {
  int z = 0;
  #ifdef X
  int xyz = 123;
  #endif
  z = 1;
}

if (x == 2) {
  int z = 0;
#ifdef X
  int xyz = 123;
#endif
  z = 1;
}
