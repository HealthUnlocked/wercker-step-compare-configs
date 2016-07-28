Compare configs
---------------

Compare two configuration files (local sample vs existing config on S3), to determine which properties, if any, need to added to and/or removed from existing config.

Assumes file is `property=value` format, where each property is on a new line. Comments (lines starting with `#`) are ignored.

## Options

- `sample` - sample file path in relation to current wercker directory
- `actual` - url to the existing config file on S3

In addition `aws` CLI needs be installed on the machine and two environment variables need be defined (to access the configuration file residing on S3):

- `$AWS_ACCESS_KEY_ID`
- `$AWS_SECRET_ACCESS_KEY`

## Example

```yml
build:
  steps:
    compare-configs:
      sample: foo.sample.properties
      actual: s3://configs.healthunlocked.com/path/to/etc/foo.properties
```
