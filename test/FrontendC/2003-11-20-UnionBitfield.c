// RUN: %llvmgcc -S %s -o - | llvm-as -o /dev/null

struct printf_spec {
  unsigned int minus_flag:1;
  char converter;
};

void parse_doprnt_spec () {
  struct printf_spec spec;
  spec.minus_flag = 1;
}

