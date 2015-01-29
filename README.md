Compare configs
---------------

Compare two configuration files (local sample vs remote existing), to determine which properties, if any, need to added to and/or removed from existing config.

Assumes file is property=value format, where each property is on a new line. Comments (lines starting with #) are ignored.

## Options

- `sample` - sample file path in relation to current wercker directory
- `actual` - full path to the existing config

In addition two environment variables should have already been defined (typically during steps to add hostname to known_hosts and copy contents of private SSH key to a file on disk):
- `$HOSTNAME` - the host with existing config
- `$PRIVATEKEY_PATH` - path to id_rsa on the build machine

## Example

```yml
build:
	steps:
		compfigs:
			sample: foo.sample.properties
			actual: /etc/foo.properties
```
