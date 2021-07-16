# Ben's standard compiler flags
CXXFLAGS=-g3 -fvar-tracking-assignments -gstatement-frontiers \
	-gvariable-location-views -grecord-gcc-switches -pipe -Wall \
	-Werror=format-security -Wp,-D_FORTIFY_SOURCE=2 -fexceptions \
	-Wp,-D_GLIBCXX_ASSERTIONS -fstack-protector-strong \
	-fstack-clash-protection -fcf-protection \
	-fasynchronous-unwind-tables -O2
CFLAGS=-g3 -fvar-tracking-assignments -gstatement-frontiers \
	-gvariable-location-views -grecord-gcc-switches -pipe -Wall \
	-Werror=format-security -Wp,-D_FORTIFY_SOURCE=2 -fexceptions \
	-Wp,-D_GLIBCXX_ASSERTIONS -fstack-protector-strong \
	-fstack-clash-protection -fcf-protection \
	-fasynchronous-unwind-tables -O2
LDFLAGS=-Wl,--no-undefined

TESTS=underlinked swap-underlinked exception swap-exception

.PHONY: clean all test $(TESTS)

# ------
all: underlinktest libunderlink1.so libunderlink2.so use-rtti-excep librttiexcep_v2.so

# ------ Underlinking ------
underlinktest: underlinktest.o libunderlink1.so
	gcc $(CFLAGS) $(LDFLAGS) -o underlinktest underlinktest.o -L. -l underlink1

# We don't want the LDFLAGS here because this library is intentionally
# underlinked
libunderlink1.so: libunderlink1.o
	gcc $(CFLAGS) -fPIC -shared -o libunderlink1.so libunderlink1.o

libunderlink2.so: libunderlink2.o
	gcc $(CFLAGS) -fPIC -shared -o libunderlink2.so libunderlink2.o

# ------ rtti-exception -----
use-rtti-excep: use-rtti-excep.o librttiexcep_v1.so
	g++ $(CFLAGS) $(LDFLAGS) -o use-rtti-excep -L. -l rttiexcep_v1 use-rtti-excep.o

use-rtti-excep.o: use-rtti-excep.C rtti-exception.h

librttiexcep_v1.so: rtti-v1.o
	g++ $(CXXFLAGS) $(LDFLAGS) -fPIC -shared -o librttiexcep_v1.so rtti-v1.o

librttiexcep_v2.so: rtti-v2.o
	g++ $(CXXFLAGS) $(LDFLAGS) -fPIC -shared -o librttiexcep_v2.so rtti-v2.o

rtti-v1.o: rtti-exception.C  rtti-exception.h
	g++ $(CXXFLAGS) -fPIC -c -o rtti-v1.o -DVER_1 rtti-exception.C

rtti-v2.o: rtti-exception.C  rtti-exception.h
	g++ $(CXXFLAGS) -fPIC -c -o rtti-v2.o -DVER_2 rtti-exception.C

# ------ TESTS ------
test: $(TESTS)

# -- underlink tests
underlinked: underlinktest libunderlink1.so 
	@./underlinktest.sh

swap-underlinked: underlinktest libunderlink2.so ../tools/swap-libs-audit.so
	@./swap-underlinked.sh

# -- exception tests
exception: use-rtti-excep librttiexcep_v1.so
	@./exceptiontest.sh

swap-exception: use-rtti-excep librttiexcep_v2.so ../tools/swap-libs-audit.so
	@./swap-exceptiontest.sh

# ----- Other -----
clean:
	rm -f *~ *.so *.so underlinktest use-rtti-excep
