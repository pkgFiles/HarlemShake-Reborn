TARGET := iphone:clang:latest:13.7

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = HarlemShakeRebornPrefs

HarlemShakeRebornPrefs_FILES = $(shell find Sources/HarlemShakeRebornPrefs -name '*.swift') $(shell find Sources/HarlemShakeRebornPrefsC -name '*.m' -o -name '*.c' -o -name '*.mm' -o -name '*.cpp')
HarlemShakeRebornPrefs_SWIFTFLAGS = -ISources/HarlemShakeRebornPrefsC/include
HarlemShakeRebornPrefs_INSTALL_PATH = /Library/PreferenceBundles
HarlemShakeRebornPrefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk
