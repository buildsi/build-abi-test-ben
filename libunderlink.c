int backcall( char *arg);

char *libcall( char *arg){
  return arg+backcall(arg);
}
