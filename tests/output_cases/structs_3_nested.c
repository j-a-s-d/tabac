struct Company {
  char co_id[20];
  char co_name[64];
  struct Employee {
    int employee_id;
    char name[128];
    int salary;
  };
};

struct Some {
  int blah;
  struct Other {
    int foo;
    char bar[128];
  };
};
struct Another {};

