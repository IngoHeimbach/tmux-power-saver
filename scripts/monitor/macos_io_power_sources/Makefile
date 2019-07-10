INCLUDES =
CFLAGS = -Wall -O2 -mmacosx-version-min=10.5 $(INCLUDES)
LIBS= -framework IOKit -framework CoreFoundation
LDFLAGS = $(LIBS)

all: battery_check

battery_check: battery_check.o
	$(CC) -o $@ $^ $(LDFLAGS)

%.o: %.c
	$(CC) -c $(CFLAGS) $<

clean:
	rm -f battery_check *.o

.PRECIOUS: %.o
.PHONY: all clean
