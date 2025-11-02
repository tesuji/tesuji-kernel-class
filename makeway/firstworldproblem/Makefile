obj-m += echo.o

# Set KDIR to your kernel build or headers path
KDIR ?= /lib/modules/6.8.0-83-generic/build

all:
	$(MAKE) -C $(KDIR) M=$(PWD) modules

clean:
	$(MAKE) -C $(KDIR) M=$(PWD) clean

