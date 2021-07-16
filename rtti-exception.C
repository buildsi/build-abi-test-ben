#include "rtti-exception.h"

extern int do_something( int num){
  num=num+2;
  throw LongExceptionName(num);
}
