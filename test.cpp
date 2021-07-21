#include <verilated.h>

#include "Vtest.h"
#include "bsg_nonsynth_dpi_clock_gen.hpp"
using namespace bsg_nonsynth_dpi;

int main(int argc, char** argv, char** env) {
  Vtest* tb=new Vtest;
  tb->eval();
  
  while (!Verilated::gotFinish()) {
    bsg_timekeeper::next();
    tb->eval();
  }

  printf("Executing final\n");
  tb->final();

  printf("Exiting\n");
  exit(EXIT_SUCCESS);
}
