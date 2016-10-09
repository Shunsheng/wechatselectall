TARGET = iphone:latest:7.0
ARCHS = armv7 arm64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = wechatselectall
wechatselectall_FILES = Tweak.xm
wechatselectall_FRAMEWORKS = UIKit CoreFoundation Foundation 

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 WeChat"
