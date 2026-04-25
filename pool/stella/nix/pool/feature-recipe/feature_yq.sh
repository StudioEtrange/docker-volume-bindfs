if [ ! "$_yq_INCLUDED_" = "1" ]; then
_yq_INCLUDED_=1

# This is the go tool 'yq' : https://github.com/mikefarah/yq
# This is NOT the same than python tool named 'yq'  https://github.com/kislyuk/yq

feature_yq() {
	FEAT_NAME="yq"
	FEAT_LIST_SCHEMA="4_53_2@x64:binary 4_47_1@x64:binary 4_53_2@x86:binary 4_47_1@x86:binary 4_46_1@x64:binary 4_46_1@x86:binary 4_13_2@x64:binary 3_4_1@x64:binary 3_3_4@x64:binary 3_3_0@x64:binary 3_1_2@x64:binary 3_1_2@x86:binary"
	
	FEAT_DEFAULT_FLAVOUR="binary"

	FEAT_DESC="yq is a portable command-line YAML processor"
	FEAT_LINK="https://mikefarah.gitbook.io/yq/ https://github.com/mikefarah/yq"
}


feature_yq_4_53_2() {
	FEAT_VERSION="4_53_2"

	if [ "${STELLA_CURRENT_PLATFORM}" = "linux" ]; then
		if [ "${STELLA_CURRENT_CPU_FAMILY}" = "intel" ]; then
			FEAT_BINARY_URL_x86="https://github.com/mikefarah/yq/releases/download/v4.53.2/yq_linux_386"
			FEAT_BINARY_URL_FILENAME_x86="yq_linux_386_${FEAT_VERSION}"
			FEAT_BINARY_URL_PROTOCOL_x86="HTTP"
			FEAT_BINARY_URL_x64="https://github.com/mikefarah/yq/releases/download/v4.53.2/yq_linux_amd64"
			FEAT_BINARY_URL_FILENAME_x64="yq_linux_amd64_${FEAT_VERSION}"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP"
		fi
		if [ "${STELLA_CURRENT_CPU_FAMILY}" = "arm" ]; then
			FEAT_BINARY_URL_x86="https://github.com/mikefarah/yq/releases/download/v4.53.2/yq_linux_arm"
			FEAT_BINARY_URL_FILENAME_x86="yq_linux_arm_${FEAT_VERSION}"
			FEAT_BINARY_URL_PROTOCOL_x86="HTTP"
			FEAT_BINARY_URL_x64="https://github.com/mikefarah/yq/releases/download/v4.53.2/yq_linux_arm64"
			FEAT_BINARY_URL_FILENAME_x64="yq_linux_arm64_${FEAT_VERSION}"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP"
		fi
	fi
	if [ "${STELLA_CURRENT_PLATFORM}" = "darwin" ]; then
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://github.com/mikefarah/yq/releases/download/v4.53.2/yq_darwin_amd64"
			FEAT_BINARY_URL_FILENAME_x64="yq_darwin_amd64_${FEAT_VERSION}"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP"
		fi
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "arm" ]; then
			FEAT_BINARY_URL_x64="https://github.com/mikefarah/yq/releases/download/v4.53.2/yq_darwin_arm64"
			FEAT_BINARY_URL_FILENAME_x64="yq_darwin_arm64_${FEAT_VERSION}"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP"
		fi
	fi

	FEAT_INSTALL_TEST="${FEAT_INSTALL_ROOT}/yq"
	FEAT_SEARCH_PATH="${FEAT_INSTALL_ROOT}"
}

feature_yq_4_47_1() {
	FEAT_VERSION="4_47_1"

	if [ "${STELLA_CURRENT_PLATFORM}" = "linux" ]; then
		if [ "${STELLA_CURRENT_CPU_FAMILY}" = "intel" ]; then
			FEAT_BINARY_URL_x86="https://github.com/mikefarah/yq/releases/download/v4.47.1/yq_linux_386"
			FEAT_BINARY_URL_FILENAME_x86="yq_linux_386_${FEAT_VERSION}"
			FEAT_BINARY_URL_PROTOCOL_x86="HTTP"
			FEAT_BINARY_URL_x64="https://github.com/mikefarah/yq/releases/download/v4.47.1/yq_linux_amd64"
			FEAT_BINARY_URL_FILENAME_x64="yq_linux_amd64_${FEAT_VERSION}"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP"
		fi
		if [ "${STELLA_CURRENT_CPU_FAMILY}" = "arm" ]; then
			FEAT_BINARY_URL_x86="https://github.com/mikefarah/yq/releases/download/v4.47.1/yq_linux_arm"
			FEAT_BINARY_URL_FILENAME_x86="yq_linux_arm_${FEAT_VERSION}"
			FEAT_BINARY_URL_PROTOCOL_x86="HTTP"
			FEAT_BINARY_URL_x64="https://github.com/mikefarah/yq/releases/download/v4.47.1/yq_linux_arm64"
			FEAT_BINARY_URL_FILENAME_x64="yq_linux_arm64_${FEAT_VERSION}"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP"
		fi
	fi
	if [ "${STELLA_CURRENT_PLATFORM}" = "darwin" ]; then
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://github.com/mikefarah/yq/releases/download/v4.47.1/yq_darwin_amd64"
			FEAT_BINARY_URL_FILENAME_x64="yq_darwin_amd64_${FEAT_VERSION}"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP"
		fi
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "arm" ]; then
			FEAT_BINARY_URL_x64="https://github.com/mikefarah/yq/releases/download/v4.47.1/yq_darwin_arm64"
			FEAT_BINARY_URL_FILENAME_x64="yq_darwin_arm64_${FEAT_VERSION}"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP"
		fi
	fi

	FEAT_INSTALL_TEST="${FEAT_INSTALL_ROOT}/yq"
	FEAT_SEARCH_PATH="${FEAT_INSTALL_ROOT}"
}


feature_yq_4_46_1() {
	FEAT_VERSION="4_46_1"

	if [ "${STELLA_CURRENT_PLATFORM}" = "linux" ]; then
		if [ "${STELLA_CURRENT_CPU_FAMILY}" = "intel" ]; then
			FEAT_BINARY_URL_x86="https://github.com/mikefarah/yq/releases/download/v4.46.1/yq_linux_386"
			FEAT_BINARY_URL_FILENAME_x86="yq_linux_386_${FEAT_VERSION}"
			FEAT_BINARY_URL_PROTOCOL_x86="HTTP"
			FEAT_BINARY_URL_x64="https://github.com/mikefarah/yq/releases/download/v4.46.1/yq_linux_amd64"
			FEAT_BINARY_URL_FILENAME_x64="yq_linux_amd64_${FEAT_VERSION}"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP"
		fi
		if [ "${STELLA_CURRENT_CPU_FAMILY}" = "arm" ]; then
			FEAT_BINARY_URL_x86="https://github.com/mikefarah/yq/releases/download/v4.46.1/yq_linux_arm"
			FEAT_BINARY_URL_FILENAME_x86="yq_linux_arm_${FEAT_VERSION}"
			FEAT_BINARY_URL_PROTOCOL_x86="HTTP"
			FEAT_BINARY_URL_x64="https://github.com/mikefarah/yq/releases/download/v4.46.1/yq_linux_arm64"
			FEAT_BINARY_URL_FILENAME_x64="yq_linux_arm64_${FEAT_VERSION}"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP"
		fi
	fi
	if [ "${STELLA_CURRENT_PLATFORM}" = "darwin" ]; then
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://github.com/mikefarah/yq/releases/download/v4.46.1/yq_darwin_amd64"
			FEAT_BINARY_URL_FILENAME_x64="yq_darwin_amd64_${FEAT_VERSION}"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP"
		fi
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "arm" ]; then
			FEAT_BINARY_URL_x64="https://github.com/mikefarah/yq/releases/download/v4.46.1/yq_darwin_arm64"
			FEAT_BINARY_URL_FILENAME_x64="yq_darwin_arm64_${FEAT_VERSION}"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP"
		fi
	fi

	FEAT_INSTALL_TEST="${FEAT_INSTALL_ROOT}/yq"
	FEAT_SEARCH_PATH="${FEAT_INSTALL_ROOT}"

}


feature_yq_4_13_2() {
	FEAT_VERSION="4_13_2"

	if [ "${STELLA_CURRENT_PLATFORM}" = "linux" ]; then
		FEAT_BINARY_URL_x86="https://github.com/mikefarah/yq/releases/download/v4.13.2/yq_linux_386"
		FEAT_BINARY_URL_FILENAME_x86="yq_linux_386_${FEAT_VERSION}"
		FEAT_BINARY_URL_PROTOCOL_x86="HTTP"
		FEAT_BINARY_URL_x64="https://github.com/mikefarah/yq/releases/download/v4.13.2/yq_linux_amd64"
		FEAT_BINARY_URL_FILENAME_x64="yq_linux_amd64_${FEAT_VERSION}"
		FEAT_BINARY_URL_PROTOCOL_x64="HTTP"

	fi
	if [ "${STELLA_CURRENT_PLATFORM}" = "darwin" ]; then
		FEAT_BINARY_URL_x64="https://github.com/mikefarah/yq/releases/download/v4.13.2/yq_darwin_amd64"
		FEAT_BINARY_URL_FILENAME_x64="yq_darwin_amd64_${FEAT_VERSION}"
		FEAT_BINARY_URL_PROTOCOL_x64="HTTP"
	fi

	FEAT_INSTALL_TEST="${FEAT_INSTALL_ROOT}/yq"
	FEAT_SEARCH_PATH="${FEAT_INSTALL_ROOT}"

}



feature_yq_3_4_1() {
	FEAT_VERSION="3_4_1"

	if [ "${STELLA_CURRENT_PLATFORM}" = "linux" ]; then
		FEAT_BINARY_URL_x86="https://github.com/mikefarah/yq/releases/download/3.4.1/yq_linux_386"
		FEAT_BINARY_URL_FILENAME_x86="yq_linux_386_${FEAT_VERSION}"
		FEAT_BINARY_URL_PROTOCOL_x86="HTTP"
		FEAT_BINARY_URL_x64="https://github.com/mikefarah/yq/releases/download/3.4.1/yq_linux_amd64"
		FEAT_BINARY_URL_FILENAME_x64="yq_linux_amd64_${FEAT_VERSION}"
		FEAT_BINARY_URL_PROTOCOL_x64="HTTP"

	fi
	if [ "${STELLA_CURRENT_PLATFORM}" = "darwin" ]; then
		FEAT_BINARY_URL_x86="https://github.com/mikefarah/yq/releases/download/3.4.1/yq_darwin_386"
		FEAT_BINARY_URL_FILENAME_x86="yq_darwin_386_${FEAT_VERSION}"
		FEAT_BINARY_URL_PROTOCOL_x86="HTTP"
		FEAT_BINARY_URL_x64="https://github.com/mikefarah/yq/releases/download/3.4.1/yq_darwin_amd64"
		FEAT_BINARY_URL_FILENAME_x64="yq_darwin_amd64_${FEAT_VERSION}"
		FEAT_BINARY_URL_PROTOCOL_x64="HTTP"
	fi

	FEAT_INSTALL_TEST="${FEAT_INSTALL_ROOT}/yq"
	FEAT_SEARCH_PATH="${FEAT_INSTALL_ROOT}"

}


feature_yq_3_3_4() {
	FEAT_VERSION="3_3_4"

	if [ "${STELLA_CURRENT_PLATFORM}" = "linux" ]; then
		FEAT_BINARY_URL_x86="https://github.com/mikefarah/yq/releases/download/3.3.4/yq_linux_386"
		FEAT_BINARY_URL_FILENAME_x86="yq_linux_386_${FEAT_VERSION}"
		FEAT_BINARY_URL_PROTOCOL_x86="HTTP"
		FEAT_BINARY_URL_x64="https://github.com/mikefarah/yq/releases/download/3.3.4/yq_linux_amd64"
		FEAT_BINARY_URL_FILENAME_x64="yq_linux_amd64_${FEAT_VERSION}"
		FEAT_BINARY_URL_PROTOCOL_x64="HTTP"

	fi
	if [ "${STELLA_CURRENT_PLATFORM}" = "darwin" ]; then
		FEAT_BINARY_URL_x86="https://github.com/mikefarah/yq/releases/download/3.3.4/yq_darwin_386"
		FEAT_BINARY_URL_FILENAME_x86="yq_darwin_386_${FEAT_VERSION}"
		FEAT_BINARY_URL_PROTOCOL_x86="HTTP"
		FEAT_BINARY_URL_x64="https://github.com/mikefarah/yq/releases/download/3.3.4/yq_darwin_amd64"
		FEAT_BINARY_URL_FILENAME_x64="yq_darwin_amd64_${FEAT_VERSION}"
		FEAT_BINARY_URL_PROTOCOL_x64="HTTP"
	fi

	FEAT_INSTALL_TEST="${FEAT_INSTALL_ROOT}/yq"
	FEAT_SEARCH_PATH="${FEAT_INSTALL_ROOT}"

}

feature_yq_3_3_0() {
	FEAT_VERSION="3_3_0"

	if [ "${STELLA_CURRENT_PLATFORM}" = "linux" ]; then
		FEAT_BINARY_URL_x86="https://github.com/mikefarah/yq/releases/download/3.3.0/yq_linux_386"
		FEAT_BINARY_URL_FILENAME_x86="yq_linux_386_${FEAT_VERSION}"
		FEAT_BINARY_URL_PROTOCOL_x86="HTTP"
		FEAT_BINARY_URL_x64="https://github.com/mikefarah/yq/releases/download/3.3.0/yq_linux_amd64"
		FEAT_BINARY_URL_FILENAME_x64="yq_linux_amd64_${FEAT_VERSION}"
		FEAT_BINARY_URL_PROTOCOL_x64="HTTP"

	fi
	if [ "${STELLA_CURRENT_PLATFORM}" = "darwin" ]; then
		FEAT_BINARY_URL_x86="https://github.com/mikefarah/yq/releases/download/3.3.0/yq_darwin_386"
		FEAT_BINARY_URL_FILENAME_x86="yq_darwin_386_${FEAT_VERSION}"
		FEAT_BINARY_URL_PROTOCOL_x86="HTTP"
		FEAT_BINARY_URL_x64="https://github.com/mikefarah/yq/releases/download/3.3.0/yq_darwin_amd64"
		FEAT_BINARY_URL_FILENAME_x64="yq_darwin_amd64_${FEAT_VERSION}"
		FEAT_BINARY_URL_PROTOCOL_x64="HTTP"
	fi

	FEAT_INSTALL_TEST="${FEAT_INSTALL_ROOT}/yq"
	FEAT_SEARCH_PATH="${FEAT_INSTALL_ROOT}"

}

feature_yq_3_1_2() {
	FEAT_VERSION="3_1_2"

	if [ "${STELLA_CURRENT_PLATFORM}" = "linux" ]; then
		FEAT_BINARY_URL_x86="https://github.com/mikefarah/yq/releases/download/3.1.2/yq_linux_386"
		FEAT_BINARY_URL_FILENAME_x86="yq_linux_386_${FEAT_VERSION}"
		FEAT_BINARY_URL_PROTOCOL_x86="HTTP"
		FEAT_BINARY_URL_x64="https://github.com/mikefarah/yq/releases/download/3.1.2/yq_linux_amd64"
		FEAT_BINARY_URL_FILENAME_x64="yq_linux_amd64_${FEAT_VERSION}"
		FEAT_BINARY_URL_PROTOCOL_x64="HTTP"

	fi
	if [ "${STELLA_CURRENT_PLATFORM}" = "darwin" ]; then
		FEAT_BINARY_URL_x86="https://github.com/mikefarah/yq/releases/download/3.1.2/yq_darwin_386"
		FEAT_BINARY_URL_FILENAME_x86="yq_darwin_386_${FEAT_VERSION}"
		FEAT_BINARY_URL_PROTOCOL_x86="HTTP"
		FEAT_BINARY_URL_x64="https://github.com/mikefarah/yq/releases/download/3.1.2/yq_darwin_amd64"
		FEAT_BINARY_URL_FILENAME_x64="yq_darwin_amd64_${FEAT_VERSION}"
		FEAT_BINARY_URL_PROTOCOL_x64="HTTP"
	fi

	FEAT_INSTALL_TEST="${FEAT_INSTALL_ROOT}/yq"
	FEAT_SEARCH_PATH="${FEAT_INSTALL_ROOT}"

}


feature_yq_install_binary() {

	__get_resource "${FEAT_NAME}" "${FEAT_BINARY_URL}" "${FEAT_BINARY_URL_PROTOCOL}" "${FEAT_INSTALL_ROOT}" "DEST_ERASE STRIP FORCE_NAME $FEAT_BINARY_URL_FILENAME"

	mv "${FEAT_INSTALL_ROOT}/${FEAT_BINARY_URL_FILENAME}" "${FEAT_INSTALL_ROOT}/yq"
	chmod +x "${FEAT_INSTALL_ROOT}/yq"

}


fi
