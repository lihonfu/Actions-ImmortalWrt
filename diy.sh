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
