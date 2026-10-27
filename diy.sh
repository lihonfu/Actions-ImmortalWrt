# 请在下方输入自定义命令(一般用来安装第三方插件)(可以留空)
# Please enter the custom command below (usually used to install third-party plugins) (can be left blank)

# Work around an upstream MediaTek HNAT patch incompatibility in the 6.6 tree.
# These 9999-* patches reference MTK_FE_* / MTK_WIFI_* symbols that are not
# defined in the kernel revision used by this build, which causes the
# driver compilation failure in drivers/net/ethernet/mediatek/mtk_eth_soc.c.
# Remove only the known incompatible HNAT reset/FDB patches before the kernel is built.
for patch in target/linux/mediatek/patches-6.6/9999-*.patch; do
    if [ -f "$patch" ]; then
        echo "Removing incompatible MediaTek patch: $patch"
        rm -f "$patch"
    fi
done

# Keep the existing third-party packages
 git clone --depth=1 https://github.com/EOYOHOO/UA2F.git package/UA2F
 git clone --depth=1 https://github.com/EOYOHOO/rkp-ipid.git package/rkp-ipid

# ---------------------------------------------------------------------------
# 机型：只编译 cmcc_rax3000m（该仓库中它就是 NAND 机型，eMMC 版是 cmcc_rax3000me）
# ---------------------------------------------------------------------------
sed -i -E 's/^CONFIG_TARGET_mediatek_filogic_DEVICE_([A-Za-z0-9_-]+)=y$/# CONFIG_TARGET_mediatek_filogic_DEVICE_\1 is not set/' .config
sed -i -E 's/^# (CONFIG_TARGET_mediatek_filogic_DEVICE_cmcc_rax3000m) is not set$/\1=y/' .config
grep -q '^CONFIG_TARGET_mediatek_filogic_DEVICE_cmcc_rax3000m=y$' .config || echo 'CONFIG_TARGET_mediatek_filogic_DEVICE_cmcc_rax3000m=y' >> .config
sed -i -E 's/^CONFIG_PACKAGE_u-boot-mt7981_cmcc_rax3000me=y$/# CONFIG_PACKAGE_u-boot-mt7981_cmcc_rax3000me is not set/' .config
grep -q '^CONFIG_PACKAGE_u-boot-mt7981_cmcc_rax3000m-nand=y$' .config || echo 'CONFIG_PACKAGE_u-boot-mt7981_cmcc_rax3000m-nand=y' >> .config

# ---------------------------------------------------------------------------
# 翻墙软件：只用官方 feeds 自带的 v2rayA，去掉第三方的 OpenClash / passwall 残留
# ---------------------------------------------------------------------------
sed -i -E 's/^CONFIG_PACKAGE_luci-app-openclash=y$/# CONFIG_PACKAGE_luci-app-openclash is not set/' .config
sed -i -E 's/^CONFIG_PACKAGE_luci-app-passwall_INCLUDE_([A-Za-z0-9_]+)=y$/# CONFIG_PACKAGE_luci-app-passwall_INCLUDE_\1 is not set/' .config
grep -q '^CONFIG_PACKAGE_luci-app-v2raya=y$' .config || echo 'CONFIG_PACKAGE_luci-app-v2raya=y' >> .config
grep -q '^CONFIG_PACKAGE_luci-i18n-v2raya-zh-cn=y$' .config || echo 'CONFIG_PACKAGE_luci-i18n-v2raya-zh-cn=y' >> .config