if [ ! "$_TEMPLATE-BUNDLE_INCLUDED_" = "1" ]; then
_TEMPLATE-BUNDLE_INCLUDED_=1


feature_template-bundle() {
	FEAT_NAME=template-bundle
	FEAT_LIST_SCHEMA="1_0_0@x64 1_0_0@x86"
	FEAT_DEFAULT_ARCH=x64

	FEAT_DESC="template is foo"
	FEAT_LINK="https://github.com/bar/template"

	# should be MERGE or NESTED or LIST or MERGE_LIST
	# NESTED : each item will be installed inside the bundle path in a separate directory (with each feature name but without version)
	#		 sample :	bundle#1 is nested features featA#1_0 featB#2_0
	#				feature_folder/bundle/1/featA/<featA_files>
	#									   /featB/<featB_files>
	# MERGE : each item will be installed in the bundle path (without each feature name/version)
	#		 sample :	bundle#1 is merged features featA#1_0 featB#2_0
	#				feature_folder/bundle/1/<featA_files>
	#									   /<featB_files>
	# LIST : this bundle is just a list of item that will be installed normally
	#		 sample :	bundle#1 is a list of features featA#1_0 featB#2_0
	#				feature_folder/bundle/1/<empty>
	#							  /featA/1_0/<featA_files>
	#							  /featB/2_0/<featB_files>
	# MERGE_LIST : this bundle is a list of items that will be installed in a MERGED way (without bundle name nor version in path AND without each feature name/version)
	#				feature_folder/<featA_files>
	#							  /<featB_files>
	FEAT_BUNDLE="NESTED"
}



feature_template-bundle_1_0_0() {
	# if FEAT_ARCH is not not null, properties FOO_ARCH=BAR will be selected and setted as FOO=BAR
	# if FOO_ARCH is empty, FOO will not be changed

	FEAT_VERSION=1_0_0

	# Dependencies
	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES_x86=
	FEAT_BINARY_DEPENDENCIES_x64=

	# Properties for bundle
	FEAT_BUNDLE_ITEM=
	FEAT_BUNDLE_ITEM_x86="foo#1_0_0@x86 bar#1_0_0@x86"
	FEAT_BUNDLE_ITEM_x84="foo#1_0_0@x64 bar#1_0_0@x64"

	# callback are list of functions
	# automatic callback each time this bundle is initialized
	FEAT_ENV_CALLBACK=feature_template-bundle_setenv
	# automatic callback after all items in bundle list are installed
	FEAT_BUNDLE_CALLBACK=

	# List of files to test if feature is installed
	FEAT_INSTALL_TEST=$FEAT_INSTALL_ROOT/bin/template-bundle
	# PATH to add to system PATH
	FEAT_SEARCH_PATH=$FEAT_INSTALL_ROOT/bin

}

feature_template-bundle_setenv()  {
	TEMPLATE_BUNDLE_HOME=$FEAT_INSTALL_ROOT
	export TEMPLATE_BUNDLE_HOME_HOME
}



fi
