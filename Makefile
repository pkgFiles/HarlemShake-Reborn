TARGET := iphone:clang:latest:13.7
INSTALL_TARGET_PROCESSES = SpringBoard
THEOS_PACKAGE_SCHEME = rootless

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = HarlemShakeReborn

HarlemShakeReborn_FILES = $(shell find Sources/HarlemShakeReborn -name '*.swift') $(shell find Sources/HarlemShakeRebornC -name '*.m' -o -name '*.c' -o -name '*.mm' -o -name '*.cpp')
HarlemShakeReborn_SWIFTFLAGS = -ISources/HarlemShakeRebornC/include
HarlemShakeReborn_CFLAGS = -fobjc-arc -ISources/HarlemShakeRebornC/include
HarlemShakeReborn_PRIVATE_FRAMEWORKS = SpringBoard SpringBoardHome

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += Preferences
include $(THEOS_MAKE_PATH)/aggregate.mk
