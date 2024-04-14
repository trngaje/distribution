CC?=gcc
CFLAGS+= -DRGB30
LDFLAGS=$(CFLAGS)
LDLIBS=-levdev -lpthread
OBJS=evdevd.o fifo.o
TARGET=evdevd

all: $(TARGET)

clean:
	rm -f *.o
	rm -f $(TARGET)

$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) -o $@ $(OBJS) $(LDLIBS) $(LDFLAGS)

evdevd.o: evdevd.c
fifo.o: fifo.c
