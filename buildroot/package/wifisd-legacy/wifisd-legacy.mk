#############################################################
#
# wifisd-legacy
#
#############################################################
WIFISD_LEGACY_VERSION:=1.8
WIFISD_LEGACY_SOURCE:=wifisd-legacy-$(WIFISD_LEGACY_VERSION).tar.gz

WIFISD_LEGACY_LIB_MODULES=\
	ath6k \
	ka2000-sdio.ko \
	ka2000-sdhc.ko \
	gpio_i2c.ko \
	ar6000.ko

define WIFISD_LEGACY_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/lib/modules/legacy
	for m in $(WIFISD_LEGACY_LIB_MODULES); do \
		cp -r $(@D)/$$m $(TARGET_DIR)/lib/modules/legacy; \
	done
endef

$(eval $(generic-package))

