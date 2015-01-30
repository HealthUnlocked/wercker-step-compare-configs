if [ ! -n "$WERCKER_COMPARE_CONFIGS_SAMPLE" ]; then
  error 'Please specify sample config file (absolute or relative path)'
  exit 1
fi

if [ ! -n "$WERCKER_COMPARE_CONFIGS_ACTUAL" ]; then
  error 'Please specify sample config file (absolute path)'
  exit 1
fi

ACTUAL_CONFIG=`ssh -i $PRIVATEKEY_PATH -o StrictHostKeyChecking=no -o UserKnownHostsFile=no hu@$HOSTNAME "cat $WERCKER_COMPARE_CONFIGS_ACTUAL"`
ACTUAL_PROPERTIES=`echo "$ACTUAL_CONFIG" | grep -ioE "^[^#][a-z0-9 _-]+=" | sort`
SAMPLE_PROPERTIES=`grep -ioE "^[^#][a-z0-9 _-]+=" $WERCKER_COMPARE_CONFIGS_SAMPLE | sort`
if [ `comm <(echo "$ACTUAL_PROPERTIES") <(echo "$SAMPLE_PROPERTIES") -3 | wc -l` -gt "0" ]; then
	echo -e '\n/etc/ecliptic.properties file needs to be updated!'
	echo -e '\n\nProperties that need to be added:\n'
	comm <(echo "$ACTUAL_PROPERTIES") <(echo "$SAMPLE_PROPERTIES") -13
	echo -e '\n\nProperties that need to be removed:\n'
	comm <(echo "$ACTUAL_PROPERTIES") <(echo "$SAMPLE_PROPERTIES") -23
	exit 1;
fi
