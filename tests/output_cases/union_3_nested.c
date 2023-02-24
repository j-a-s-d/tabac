union Company {
  char co_id[20];
  char co_name[64];
  union Employee {
    int employee_id;
    char name[128];
    int salary;
  };
};

union Some {
  int blah;
  union Other {
    int foo;
    char bar[128];
  };
};
union Another {};

