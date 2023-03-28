if [ ! "$_openjdk_INCLUDED_" = "1" ]; then
_openjdk_INCLUDED_=1


# Recipe for Open Java Development Kit (=JDK)

# CHANGE in Java/Oracle Licence model:
#		* It is impossible to automate oraclejdk download now
#		* Now there is OpenJDK and OracleJDK
#		* There is a lot of OpenJDK distributor including Oracle (so OpenJDK crom Oracle is not the same than OracleJDK)

# List of OpenJDK distributor : https://dzone.com/articles/java-and-the-jdks-which-one-to-use

OPENJDK_PROVIDER_LIST="adoptopenjdk"
DEFAULT_OPENJDK_PROVIDER="adoptopenjdk"
OPENJDK_PROVIDER="adoptopenjdk"


feature_openjdk() {
	#__feature_catalog_info "$OPENJDK_PROVIDER"
	#feature_$OPENJDK_PROVIDER
	#for s in $FEAT_LIST_SCHEMA; do
	#	__translate_schema "openjdk#${s}" "__temp_name" "__temp_ver"
	#	eval "feature_openjdk_${__temp_ver}() { feature_${OPENJDK_PROVIDER}_${__temp_ver}; }"
		#echo "feature_openjdk_${__temp_ver}() { feature_${OPENJDK_PROVIDER}_${__temp_ver}; }"
	#done
	#FEAT_NAME=openjdk
	return
}


fi
