if [ ! "$_texinfo_INCLUDED_" = "1" ]; then
_texinfo_INCLUDED_=1


feature_texinfo() {
	FEAT_NAME="texinfo"

	FEAT_LIST_SCHEMA="7_2:source 7_1_1:source 5_1:source"
	
	FEAT_DEFAULT_FLAVOUR="source"

	FEAT_LINK="https://www.gnu.org/software/texinfo/"
	FEAT_DESC="Texinfo is the official documentation format of the GNU project. It is used by many non-GNU projects as well."
	

}

feature_texinfo_7_2() {
	FEAT_VERSION="7_2"

	FEAT_SOURCE_URL="https://ftp.gnu.org/gnu/texinfo/texinfo-7.2.tar.xz"
	FEAT_SOURCE_URL_FILENAME="texinfo-7.2.tar.xz"
	FEAT_SOURCE_URL_PROTOCOL="HTTP_ZIP"

	FEAT_SOURCE_CALLBACK="feature_texinfo_patch_for_texinfo_7_2_5"

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/bin/texindex"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT/bin"

}


feature_texinfo_7_1_1() {
	FEAT_VERSION="7_1_1"

	FEAT_SOURCE_URL="https://ftp.gnu.org/gnu/texinfo/texinfo-7.1.1.tar.gz"
	FEAT_SOURCE_URL_FILENAME="texinfo-7.1.1.tar.gz"
	FEAT_SOURCE_URL_PROTOCOL="HTTP_ZIP"

	FEAT_SOURCE_CALLBACK="feature_texinfo_patch_for_texinfo_7_1_1"

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/bin/texindex"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT/bin"

}

feature_texinfo_5_1() {
	FEAT_VERSION="5_1"

	FEAT_SOURCE_URL="http://ftp.gnu.org/gnu/texinfo/texinfo-5.1.tar.xz"
	FEAT_SOURCE_URL_FILENAME="texinfo-5.1.tar.xz"
	FEAT_SOURCE_URL_PROTOCOL="HTTP_ZIP"

	FEAT_SOURCE_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/bin/texindex"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT/bin"

}



feature_texinfo_patch_for_texinfo_7_2_5() {

	# debian patches https://sources.debian.org/patches/texinfo/7.2-5/
	# see list https://sources.debian.org/src/texinfo/7.2-5/debian/patches/series
	patches_url="https://sources.debian.org/data/main/t/texinfo/7.2-5/debian/patches/"
	patches_list="warn_missing_tex numerical-signal-names 0001-Fix-test-suite-failures-with-Perl-5.42.patch"

	for p in $patches_list; do
		echo "---- begin apply patch $p"
		__get_resource "patch $p" "${patches_url}/${p}" "HTTP" "$SRC_DIR" "FORCE_NAME ${FEAT_NAME}_${FEAT_VERSION}-patch-${p}"
		cd "$SRC_DIR"
		if [ -f "${FEAT_NAME}_${FEAT_VERSION}-patch-${p}" ]; then
			patch -Np1 < ${FEAT_NAME}_${FEAT_VERSION}-patch-${p}
		fi
		echo "---- end patch $p"
	done

}

feature_texinfo_patch_for_texinfo_7_1_1() {

	# debian patches https://sources.debian.org/patches/texinfo/7.1.1-1/
	# see list https://sources.debian.org/src/texinfo/7.1.1-1/debian/patches/series
	patches_url="https://sources.debian.org/data/main/t/texinfo/7.1.1-1/debian/patches"
	patches_list="warn_missing_tex numerical-signal-names"

	for p in $patches_list; do
		echo "---- begin apply patch $p"
		__get_resource "patch $p" "${patches_url}/${p}" "HTTP" "$SRC_DIR" "FORCE_NAME ${FEAT_NAME}_${FEAT_VERSION}-patch-${p}"
		cd "$SRC_DIR"
		if [ -f "${FEAT_NAME}_${FEAT_VERSION}-patch-${p}" ]; then
			patch -Np1 < ${FEAT_NAME}_${FEAT_VERSION}-patch-${p}
		fi
		echo "---- end patch $p"
	done

}

feature_texinfo_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"
	SRC_DIR="$STELLA_APP_FEATURE_ROOT/$FEAT_NAME-$FEAT_VERSION-src"

	__set_toolset "STANDARD"

	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$SRC_DIR" "DEST_ERASE STRIP"

	__feature_callback

	__auto_build "$FEAT_NAME" "$SRC_DIR" "$INSTALL_DIR" "EXCLUDE_FILTER $INSTALL_DIR/lib/texinfo|$INSTALL_DIR/share"


}


fi
