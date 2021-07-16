#define VER_1

#include <iostream>

#include "rtti-exception.h"

#define RESULT 3

int main( int argc, char **argv){
  try{
    do_something( RESULT-2);
  }
  catch( LongExceptionName &excep){
    std::cout << "caught " << excep.num << std::endl;
    if(excep.num != RESULT)
      return 1;
  }
  return 0;
}
