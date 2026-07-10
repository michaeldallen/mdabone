# Shell Script Rules

## End-of-File Marker

Always add `#EOF` as the final line of every shell script.
Leave one blank line between the last line of code and `#EOF`.
After adding the marker, commit the change with the message `oci: (shell-script-rules:eof-marker)`.

### Example

```sh
# ... last line of code ...

#EOF
```

```sh
git commit -m "oci: (shell-script-rules:eof-marker)"
```
