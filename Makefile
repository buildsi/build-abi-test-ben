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
all: underlinktest libunderlink.so use-rtti-excep librttiexcep.so

# ------ Underlinking ------
underlinktest: underlinktest.o libunderlink.so
	gcc $(CFLAGS) $(LDFLAGS) -o underlinktest underlinktest.o -L. -l underlink

# We don't want the LDFLAGS here because this library is intentionally
# underlinked
libunderlink.so: libunderlink.o
	gcc $(CFLAGS) -fPIC -shared -o libunderlink.so libunderlink.o

# ------ rtti-exception -----
use-rtti-excep: use-rtti-excep.o librttiexcep.so
	g++ $(CFLAGS) $(LDFLAGS) -o use-rtti-excep -L. -l rttiexcep use-rtti-excep.o

use-rtti-excep.o: use-rtti-excep.C rtti-exception.h

librttiexcep.so: rtti.o
	g++ $(CXXFLAGS) $(LDFLAGS) -fPIC -shared -o librttiexcep.so rtti.o

rtti.o: rtti-exception.C  rtti-exception.h
	g++ $(CXXFLAGS) -fPIC -c -o rtti.o -DVER_2 rtti-exception.C


# ------ TESTS ------
test: $(TESTS)

# ----- Other -----
clean:
	rm -f *~ *.so *.so underlinktest use-rtti-excep
