TARGET_USES_QCOM_BSP := true
TARGET_USES_QCA_NFC := true

ifeq ($(TARGET_USES_QCOM_BSP), true)
# Add QC Video Enhancements flag
TARGET_ENABLE_QC_AV_ENHANCEMENTS := true
endif #TARGET_USES_QCOM_BSP

DEVICE_PACKAGE_OVERLAYS := device/qcom/msm8610/overlay

#TARGET_DISABLE_DASH := true
#TARGET_DISABLE_OMX_SECURE_TEST_APP := true

ifeq ($(TARGET_ENABLE_QC_AV_ENHANCEMENTS), true)
# media_profiles and media_codecs xmls for 8610
PRODUCT_COPY_FILES += device/qcom/msm8610/media/media_profiles_8610.xml:system/etc/media_profiles.xml \
                      device/qcom/msm8610/media/media_codecs_8610.xml:system/etc/media_codecs.xml
endif #TARGET_ENABLE_QC_AV_ENHANCEMENTS

$(call inherit-product, device/qcom/common/common.mk)

PRODUCT_NAME := msm8610
PRODUCT_DEVICE := msm8610

# Audio configuration file
PRODUCT_COPY_FILES += \
    device/qcom/msm8610/audio_policy.conf:system/etc/audio_policy.conf \
    device/qcom/msm8610/audio_effects.conf:system/vendor/etc/audio_effects.conf \
    device/qcom/msm8610/mixer_paths.xml:system/etc/mixer_paths.xml

PRODUCT_PACKAGES += \
    libqcomvisualizer \
    libqcomvoiceprocessing

# Bluetooth configuration files
#PRODUCT_COPY_FILES += \
    system/bluetooth/data/main.le.conf:system/etc/bluetooth/main.conf
#add by shiqian.zhou@t2mobile.com for trace_util
PRODUCT_PACKAGES += trace_util
PRODUCT_PACKAGES += libtraceability
#add by shiqian.zhou@t2mobile.com


#fstab.qcom
PRODUCT_PACKAGES += fstab.qcom
PRODUCT_COPY_FILES += \
    device/qcom/msm8610/WCNSS_qcom_cfg.ini:system/etc/wifi/WCNSS_qcom_cfg.ini \
    device/qcom/msm8610/WCNSS_qcom_wlan_nv.bin:persist/WCNSS_qcom_wlan_nv.bin

#Added by weijin.wen@t2mobile.com ,add recovery & modem version showed in *#3228#,start
PRODUCT_PACKAGES += mverproxy
#End: Added by weijin.wen@t2mobile.com ,add recovery & modem version showed in *#3228#

#ANT stack
PRODUCT_PACKAGES += \
    AntHalService \
    libantradio \
    antradio_app

PRODUCT_PACKAGES += \
    wpa_supplicant_overlay.conf \
    p2p_supplicant_overlay.conf

PRODUCT_PACKAGES += wcnss_service

#[FEATURE]-Add-BEGIN by T2M.weiqing.cao,01/20/2015,CR-908228,retrofit
PRODUCT_PACKAGES += \
    factory_test
#[FEATURE]-Add-END by T2M.weiqing.cao

# Sensors feature definition file/s
PRODUCT_COPY_FILES += \
   frameworks/native/data/etc/android.hardware.sensor.barometer.xml:system/etc/permissions/android.hardware.sensor.barometer.xml

# Enable strict operation
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    persist.sys.strict_op_enable=false

PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    persist.sys.whitelist=/system/etc/whitelist_appops.xml

PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    camera2.portability.force_api=1

PRODUCT_COPY_FILES += \
    device/qcom/msm8610/whitelist_appops.xml:system/etc/whitelist_appops.xml

# NFC packages
ifeq ($(TARGET_USES_QCA_NFC),true)
NFC_D := false

ifeq ($(NFC_D), true)
    PRODUCT_PACKAGES += \
        libnfcD-nci \
        libnfcD_nci_jni \
        nfc_nci.msm8610 \
        NfcDNci \
        Tag \
        com.android.nfc_extras \
        com.android.nfc.helper \
        SmartcardService \
        org.simalliance.openmobileapi \
        org.simalliance.openmobileapi.xml \
        com.android.qcom.nfc_extras \
        com.gsma.services.nfc \
        libassd
else
    PRODUCT_PACKAGES += \
    libnfc-nci \
    libnfc_nci_jni \
    nfc_nci.pn54x.default \
    NfcNci \
    Tag \
    com.android.nfc_extras
endif
# NFCEE access control
ifeq ($(TARGET_BUILD_VARIANT),user)
	NFCEE_ACCESS_PATH := device/qcom/$(TARGET_PRODUCT)/nfc/nfcee_access.xml
else
	NFCEE_ACCESS_PATH := device/qcom/$(TARGET_PRODUCT)/nfc/nfcee_access_debug.xml
endif


#add custom app filemanager

PRODUCT_PACKAGES += \
  TctFileManager


# file that declares the MIFARE NFC constant
# Commands to migrate prefs from com.android.nfc3 to com.android.nfc
# NFC access control + feature files + configuration
PRODUCT_COPY_FILES += \
        packages/apps/Nfc/migrate_nfc.txt:system/etc/updatecmds/migrate_nfc.txt \
        frameworks/native/data/etc/com.nxp.mifare.xml:system/etc/permissions/com.nxp.mifare.xml \
        frameworks/native/data/etc/com.android.nfc_extras.xml:system/etc/permissions/com.android.nfc_extras.xml \
        frameworks/native/data/etc/android.hardware.nfc.xml:system/etc/permissions/android.hardware.nfc.xml\
        frameworks/native/data/etc/android.hardware.nfc.hce.xml:system/etc/permissions/android.hardware.nfc.hce.xml \
        $(NFCEE_ACCESS_PATH):system/etc/nfcee_access.xml \
        external/libnfc-nci/halimpl/pn547/libnfc-nxp.conf:system/etc/libnfc-nxp.conf \
        external/libnfc-nci/halimpl/pn547/libnfc-brcm.conf:system/etc/libnfc-brcm.conf \
        external/libnfc-nci/halimpl/pn547/libpn547_fw.so:system/vendor/firmware/libpn547_fw.so 

# Enable NFC Forum testing by temporarily changing the PRODUCT_BOOT_JARS
# line has to be in sync with build/target/product/core_base.mk
#PRODUCT_BOOT_JARS := core:conscrypt:okhttp:core-junit:bouncycastle:ext:com.android.nfc.helper:framework:framework2:telephony-common:voip-common:mms-common:android.policy:services:apache-xml:webviewchromium:telephony-msim

ifeq ($(NFC_D), true)
#PRODUCT_BOOT_JARS += org.simalliance.openmobileapi:com.android.qcom.nfc_extras:com.gsma.services.nfc
endif

endif # BOARD_HAVE_QCA_NFC
PRODUCT_BOOT_JARS += qcmediaplayer \
                     oem-services \
                     qcom.fmradio \
                     org.codeaurora.Performance \
                     vcard \
                     tcmiface
