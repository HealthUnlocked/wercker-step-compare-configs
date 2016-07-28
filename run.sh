if [ ! -n "$WERCKER_COMPARE_CONFIGS_SAMPLE" ]; then
  echo 'Please specify sample config file (absolute or relative path)'
  exit 1
fi

if [ ! -n "$WERCKER_COMPARE_CONFIGS_ACTUAL" ]; then
  echo 'Please specify the location of config file on S3'
  exit 1
fi

if ! which aws > /dev/null ; then
  echo 'AWS CLI not found!'
  exit 1
fi

ACTUAL_CONFIG=$(mktemp)
aws s3 cp $WERCKER_COMPARE_CONFIGS_ACTUAL $ACTUAL_CONFIG > /dev/null
ACTUAL_PROPERTIES=`cat $ACTUAL_CONFIG | grep -ioE "^[^#][a-z0-9 _-]+=" | sort`
SAMPLE_PROPERTIES=`grep -ioE "^[^#][a-z0-9 _-]+=" $WERCKER_COMPARE_CONFIGS_SAMPLE | sort`
rm $ACTUAL_CONFIG
if [ `comm <(echo "$ACTUAL_PROPERTIES") <(echo "$SAMPLE_PROPERTIES") -3 | wc -l` -gt "0" ]; then
  echo -e "\n$WERCKER_COMPARE_CONFIGS_ACTUAL file needs to be updated!"
  echo -e '\nProperties that need to be added:\n'
  comm <(echo "$ACTUAL_PROPERTIES") <(echo "$SAMPLE_PROPERTIES") -13
  echo -e '\nProperties that need to be removed:\n'
  comm <(echo "$ACTUAL_PROPERTIES") <(echo "$SAMPLE_PROPERTIES") -23
  exit 1;
fi
echo "Config file is up to date!"
