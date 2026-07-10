# Shell Script Rules

## End-of-File Marker

<ul>

Always add `#EOF` as the final line of every shell script.

Leave one blank line between the last line of code and `#EOF`.

After adding the marker, commit the change with the message `oci: (shell-script-rules:eof-marker)`.

### Example

<ul>

```sh
# ... last line of code ...

#EOF
```

```sh
git commit -m "oci: (shell-script-rules:eof-marker)"
```

</ul>

</ul>

## Google Shell Style Guide

<ul>

<!-- Validation approach: shellcheck catches syntax/lint issues but does not cover
     all Google style requirements. The AI must ALSO manually review the script
     against every rule below, which maps 1:1 to the sections of the Google Shell
     Style Guide (https://google.github.io/styleguide/shellguide.html).
     Both steps are required before the script is considered compliant. -->

Run `shellcheck --format=gcc` against the script and fix all reported issues.
Then manually verify each rule below.

Fix any violations found, then commit with the message `oci: (shell-script-rules:google-style)`.

```sh
shellcheck --format=gcc path/to/script.sh
git commit -m "oci: (shell-script-rules:google-style)"
```

---

### Background: Which Shell to Use

<ul>

Use `bash` for all shell scripts. No other shell is permitted.
Shebang must be `#!/usr/bin/env bash`.

See: <span style="font-family: monospace;">Background: Which Shell to Use</span>.  
[https://google.github.io/styleguide/shellguide.html#which-shell-to-use](https://google.github.io/styleguide/shellguide.html#which-shell-to-use)

</ul>

### Background: When to use Shell

<ul>

Shell is only used for small utilities or simple wrappers.
Scripts that exceed ~100 lines, require complex data structures, or perform
non-trivial string manipulation should be rewritten in Python or another language.

See: <span style="font-family: monospace;">Background: When to use Shell</span>.  
[https://google.github.io/styleguide/shellguide.html#when-to-use-shell](https://google.github.io/styleguide/shellguide.html#when-to-use-shell)

</ul>

---

### Shell Files and Interpreter Invocation: File Extensions

<ul>

Executables should have no extension or a `.sh` extension.
Libraries that are sourced by other scripts must use a `.sh` extension and must
not be executable.

See: <span style="font-family: monospace;">Shell Files and Interpreter Invocation: File Extensions</span>.  
[https://google.github.io/styleguide/shellguide.html#file-extensions](https://google.github.io/styleguide/shellguide.html#file-extensions)

</ul>

### Shell Files and Interpreter Invocation: SUID/SGID

<ul>

SUID and SGID are forbidden on shell scripts.
Use `sudo` for privilege escalation instead.

See: <span style="font-family: monospace;">Shell Files and Interpreter Invocation: SUID/SGID</span>.  
[https://google.github.io/styleguide/shellguide.html#suidsgid](https://google.github.io/styleguide/shellguide.html#suidsgid)

</ul>

---

### Environment: STDOUT vs STDERR

<ul>

Error messages must go to STDERR. Use:
```sh
echo "Error: something went wrong" >&2
```
Informational output goes to STDOUT.

See: <span style="font-family: monospace;">Environment: STDOUT vs STDERR</span>.  
[https://google.github.io/styleguide/shellguide.html#stdout-vs-stderr](https://google.github.io/styleguide/shellguide.html#stdout-vs-stderr)

</ul>

---

### Comments: File Header

<ul>

Every script must begin with a top-level comment describing its contents,
purpose, and usage.

See: <span style="font-family: monospace;">Comments: File Header</span>.  
[https://google.github.io/styleguide/shellguide.html#file-header](https://google.github.io/styleguide/shellguide.html#file-header)

</ul>

### Comments: Function Comments

<ul>

Every function must have a comment describing its purpose, arguments, outputs,
and return values (if non-obvious). Place the comment immediately above the
function.

See: <span style="font-family: monospace;">Comments: Function Comments</span>.  
[https://google.github.io/styleguide/shellguide.html#function-comments](https://google.github.io/styleguide/shellguide.html#function-comments)

</ul>

### Comments: Implementation Comments

<ul>

Comment non-obvious, tricky, or important blocks of code.
Do not comment every line.

See: <span style="font-family: monospace;">Comments: Implementation Comments</span>.  
[https://google.github.io/styleguide/shellguide.html#implementation-comments](https://google.github.io/styleguide/shellguide.html#implementation-comments)

</ul>

### Comments: TODO Comments

<ul>

Use `# TODO(username): description` format for TODOs.

See: <span style="font-family: monospace;">Comments: TODO Comments</span>.  
[https://google.github.io/styleguide/shellguide.html#todo-comments](https://google.github.io/styleguide/shellguide.html#todo-comments)

</ul>

---

### Formatting: Indentation

<ul>

Indent with 2 spaces. No tabs.

See: <span style="font-family: monospace;">Formatting: Indentation</span>.  
[https://google.github.io/styleguide/shellguide.html#indentation](https://google.github.io/styleguide/shellguide.html#indentation)

</ul>

### Formatting: Line Length and Long Strings

<ul>

Maximum line length is 80 characters.
Use `\` to break long lines. Here-strings and heredocs are exempt.

See: <span style="font-family: monospace;">Formatting: Line Length and Long Strings</span>.  
[https://google.github.io/styleguide/shellguide.html#line-length-and-long-strings](https://google.github.io/styleguide/shellguide.html#line-length-and-long-strings)

</ul>

### Formatting: Pipelines

<ul>

If a pipeline fits on one line, keep it on one line.
If it must be split, each stage goes on its own line indented by 2 spaces, with
`|` at the end of each line (not the start).

See: <span style="font-family: monospace;">Formatting: Pipelines</span>.  
[https://google.github.io/styleguide/shellguide.html#pipelines](https://google.github.io/styleguide/shellguide.html#pipelines)

</ul>

### Formatting: Loops

<ul>

Put `; do` and `; then` on the same line as `while`, `for`, and `if`:
```sh
for f in "${files[@]}"; do
  ...
done
```

See: <span style="font-family: monospace;">Formatting: Loops</span>.  
[https://google.github.io/styleguide/shellguide.html#loops](https://google.github.io/styleguide/shellguide.html#loops)

</ul>

### Formatting: Case statement

<ul>

Indent alternatives by 2 spaces. `;;` goes on its own line at the same
indentation as the alternative body.
```sh
case "${expr}" in
  pattern)
    action
    ;;
esac
```

See: <span style="font-family: monospace;">Formatting: Case statement</span>.  
[https://google.github.io/styleguide/shellguide.html#case-statement](https://google.github.io/styleguide/shellguide.html#case-statement)

</ul>

### Formatting: Variable expansion

<ul>

Always use `"${var}"` (braces + quotes) for variable expansion.
Bare `$var` is not permitted. Single-letter positional params (`$1`) are exempt
from braces but must still be quoted.

See: <span style="font-family: monospace;">Formatting: Variable expansion</span>.  
[https://google.github.io/styleguide/shellguide.html#variable-expansion](https://google.github.io/styleguide/shellguide.html#variable-expansion)

</ul>

### Formatting: Quoting

<ul>

- Always quote strings containing variables, command substitutions, spaces, or
  shell meta characters.
- Use `$'...'` syntax for strings requiring escape sequences.
- Do not quote integer literals or `[[ ... ]]` right-hand sides where word
  splitting is not a concern and the guide explicitly permits it.

See: <span style="font-family: monospace;">Formatting: Quoting</span>.  
[https://google.github.io/styleguide/shellguide.html#quoting](https://google.github.io/styleguide/shellguide.html#quoting)

</ul>

---

### Features and Bugs: ShellCheck

<ul>

All scripts must pass `shellcheck --format=gcc` with zero warnings or errors.

See: <span style="font-family: monospace;">Features and Bugs: ShellCheck</span>.  
[https://google.github.io/styleguide/shellguide.html#shellcheck](https://google.github.io/styleguide/shellguide.html#shellcheck)

</ul>

### Features and Bugs: Command Substitution

<ul>

Use `$(command)` instead of backticks.

See: <span style="font-family: monospace;">Features and Bugs: Command Substitution</span>.  
[https://google.github.io/styleguide/shellguide.html#command-substitution](https://google.github.io/styleguide/shellguide.html#command-substitution)

</ul>

### Features and Bugs: Test, [ and [[

<ul>

Use `[[ ... ]]` for all conditionals. Never use `[ ]` or `test`.

See: <span style="font-family: monospace;">Features and Bugs: Test, [ and [[</span>.  
[https://google.github.io/styleguide/shellguide.html#test--and-](https://google.github.io/styleguide/shellguide.html#test--and-)

</ul>

### Features and Bugs: Testing Strings

<ul>

Test for empty/non-empty strings with:
```sh
[[ -z "${var}" ]]   # empty
[[ -n "${var}" ]]   # non-empty
```
Never compare to an empty string literal `""`.

See: <span style="font-family: monospace;">Features and Bugs: Testing Strings</span>.  
[https://google.github.io/styleguide/shellguide.html#testing-strings](https://google.github.io/styleguide/shellguide.html#testing-strings)

</ul>

### Features and Bugs: Wildcard Expansion of Filenames

<ul>

Always quote globs or use arrays when expanding filenames to prevent unexpected
word splitting.

See: <span style="font-family: monospace;">Features and Bugs: Wildcard Expansion of Filenames</span>.  
[https://google.github.io/styleguide/shellguide.html#wildcard-expansion-of-filenames](https://google.github.io/styleguide/shellguide.html#wildcard-expansion-of-filenames)

</ul>

### Features and Bugs: Eval

<ul>

`eval` is forbidden. Refactor to avoid it.

See: <span style="font-family: monospace;">Features and Bugs: Eval</span>.  
[https://google.github.io/styleguide/shellguide.html#eval](https://google.github.io/styleguide/shellguide.html#eval)

</ul>

### Features and Bugs: Arrays

<ul>

Use arrays for lists of items instead of space-separated strings when the
elements may contain spaces.

See: <span style="font-family: monospace;">Features and Bugs: Arrays</span>.  
[https://google.github.io/styleguide/shellguide.html#arrays](https://google.github.io/styleguide/shellguide.html#arrays)

</ul>

### Features and Bugs: Pipes to While

<ul>

Use process substitution `< <(command)` instead of piping into `while read`
to avoid subshell variable scoping issues:
```sh
while read -r line; do
  ...
done < <(command)
```

See: <span style="font-family: monospace;">Features and Bugs: Pipes to While</span>.  
[https://google.github.io/styleguide/shellguide.html#pipes-to-while](https://google.github.io/styleguide/shellguide.html#pipes-to-while)

</ul>

### Features and Bugs: Arithmetic

<ul>

Use `(( ... ))` for arithmetic and `$(( ... ))` for arithmetic expansion.
Never use `let` or `expr`.

See: <span style="font-family: monospace;">Features and Bugs: Arithmetic</span>.  
[https://google.github.io/styleguide/shellguide.html#arithmetic](https://google.github.io/styleguide/shellguide.html#arithmetic)

</ul>

---

### Naming Conventions: Function Names

<ul>

Use `lowercase_with_underscores` for function names.
Separate libraries from the main script by prefixing functions with `namespace::`.

See: <span style="font-family: monospace;">Naming Conventions: Function Names</span>.  
[https://google.github.io/styleguide/shellguide.html#function-names](https://google.github.io/styleguide/shellguide.html#function-names)

</ul>

### Naming Conventions: Variable Names

<ul>

Use `lowercase_with_underscores` for local/loop variables.

See: <span style="font-family: monospace;">Naming Conventions: Variable Names</span>.  
[https://google.github.io/styleguide/shellguide.html#variable-names](https://google.github.io/styleguide/shellguide.html#variable-names)

</ul>

### Naming Conventions: Constants and Environment Variable Names

<ul>

Use `UPPERCASE_WITH_UNDERSCORES` for constants and exported environment variables.
Declare constants with `readonly` or `declare -r`.

See: <span style="font-family: monospace;">Naming Conventions: Constants and Environment Variable Names</span>.  
[https://google.github.io/styleguide/shellguide.html#constants-and-environment-variable-names](https://google.github.io/styleguide/shellguide.html#constants-and-environment-variable-names)

</ul>

### Naming Conventions: Source Filenames

<ul>

Use `lowercase_with_underscores` for script filenames. E.g. `my_script.sh`.

See: <span style="font-family: monospace;">Naming Conventions: Source Filenames</span>.  
[https://google.github.io/styleguide/shellguide.html#source-filenames](https://google.github.io/styleguide/shellguide.html#source-filenames)

</ul>

### Naming Conventions: Read-only Variables

<ul>

Declare read-only variables with `readonly varname` or `declare -r varname`.

See: <span style="font-family: monospace;">Naming Conventions: Read-only Variables</span>.  
[https://google.github.io/styleguide/shellguide.html#read-only-variables](https://google.github.io/styleguide/shellguide.html#read-only-variables)

</ul>

### Naming Conventions: Use Local Variables

<ul>

Declare all function-internal variables with `local`. This prevents leaking
into the global scope.

See: <span style="font-family: monospace;">Naming Conventions: Use Local Variables</span>.  
[https://google.github.io/styleguide/shellguide.html#use-local-variables](https://google.github.io/styleguide/shellguide.html#use-local-variables)

</ul>

### Naming Conventions: Function Location

<ul>

Place all functions together, before any non-comment non-`set` code.
Do not mix function definitions and executable code.

See: <span style="font-family: monospace;">Naming Conventions: Function Location</span>.  
[https://google.github.io/styleguide/shellguide.html#function-location](https://google.github.io/styleguide/shellguide.html#function-location)

</ul>

### Naming Conventions: main

<ul>

Scripts long enough to contain functions must have a `main` function that is
called at the end of the script:
```sh
main "$@"
```

See: <span style="font-family: monospace;">Naming Conventions: main</span>.  
[https://google.github.io/styleguide/shellguide.html#main](https://google.github.io/styleguide/shellguide.html#main)

</ul>

---

### Calling Commands: Checking Return Values

<ul>

Always check return values. Use `if`, `||`, or `set -e`.
Do not silently ignore failures.

See: <span style="font-family: monospace;">Calling Commands: Checking Return Values</span>.  
[https://google.github.io/styleguide/shellguide.html#checking-return-values](https://google.github.io/styleguide/shellguide.html#checking-return-values)

</ul>

### Calling Commands: Builtin Commands vs. External Commands

<ul>

Prefer shell builtins over external commands when they are equivalent.
E.g. prefer `${var#prefix}` over `sed`, `echo` over `printf` for simple output.

See: <span style="font-family: monospace;">Calling Commands: Builtin Commands vs. External Commands</span>.  
[https://google.github.io/styleguide/shellguide.html#builtin-commands-vs-external-commands](https://google.github.io/styleguide/shellguide.html#builtin-commands-vs-external-commands)

</ul>

</ul>


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

## Google Shell Style Guide

<!-- Validation approach: shellcheck catches syntax/lint issues but does not cover
     all Google style requirements. The AI must ALSO manually review the script
     against every rule below, which maps 1:1 to the sections of the Google Shell
     Style Guide (https://google.github.io/styleguide/shellguide.html).
     Both steps are required before the script is considered compliant. -->

Run `shellcheck --format=gcc` against the script and fix all reported issues.
Then manually verify each rule below.

Fix any violations found, then commit with the message `oci: (shell-script-rules:google-style)`.

```sh
shellcheck --format=gcc path/to/script.sh
git commit -m "oci: (shell-script-rules:google-style)"
```

---

### Background: Which Shell to Use

Use `bash` for all shell scripts. No other shell is permitted.
Shebang must be `#!/usr/bin/env bash`.

See: <span style="font-family: monospace;">Background: Which Shell to Use</span>.  
[https://google.github.io/styleguide/shellguide.html#which-shell-to-use](https://google.github.io/styleguide/shellguide.html#which-shell-to-use)

### Background: When to use Shell

Shell is only used for small utilities or simple wrappers.
Scripts that exceed ~100 lines, require complex data structures, or perform
non-trivial string manipulation should be rewritten in Python or another language.

See: <span style="font-family: monospace;">Background: When to use Shell</span>.  
[https://google.github.io/styleguide/shellguide.html#when-to-use-shell](https://google.github.io/styleguide/shellguide.html#when-to-use-shell)

---

### Shell Files and Interpreter Invocation: File Extensions

Executables should have no extension or a `.sh` extension.
Libraries that are sourced by other scripts must use a `.sh` extension and must
not be executable.

See: <span style="font-family: monospace;">Shell Files and Interpreter Invocation: File Extensions</span>.  
[https://google.github.io/styleguide/shellguide.html#file-extensions](https://google.github.io/styleguide/shellguide.html#file-extensions)

### Shell Files and Interpreter Invocation: SUID/SGID

SUID and SGID are forbidden on shell scripts.
Use `sudo` for privilege escalation instead.

See: <span style="font-family: monospace;">Shell Files and Interpreter Invocation: SUID/SGID</span>.  
[https://google.github.io/styleguide/shellguide.html#suidsgid](https://google.github.io/styleguide/shellguide.html#suidsgid)

---

### Environment: STDOUT vs STDERR

Error messages must go to STDERR. Use:
```sh
echo "Error: something went wrong" >&2
```
Informational output goes to STDOUT.

See: <span style="font-family: monospace;">Environment: STDOUT vs STDERR</span>.  
[https://google.github.io/styleguide/shellguide.html#stdout-vs-stderr](https://google.github.io/styleguide/shellguide.html#stdout-vs-stderr)

---

### Comments: File Header

Every script must begin with a top-level comment describing its contents,
purpose, and usage.

See: <span style="font-family: monospace;">Comments: File Header</span>.  
[https://google.github.io/styleguide/shellguide.html#file-header](https://google.github.io/styleguide/shellguide.html#file-header)

### Comments: Function Comments

Every function must have a comment describing its purpose, arguments, outputs,
and return values (if non-obvious). Place the comment immediately above the
function.

See: <span style="font-family: monospace;">Comments: Function Comments</span>.  
[https://google.github.io/styleguide/shellguide.html#function-comments](https://google.github.io/styleguide/shellguide.html#function-comments)

### Comments: Implementation Comments

Comment non-obvious, tricky, or important blocks of code.
Do not comment every line.

See: <span style="font-family: monospace;">Comments: Implementation Comments</span>.  
[https://google.github.io/styleguide/shellguide.html#implementation-comments](https://google.github.io/styleguide/shellguide.html#implementation-comments)

### Comments: TODO Comments

Use `# TODO(username): description` format for TODOs.

See: <span style="font-family: monospace;">Comments: TODO Comments</span>.  
[https://google.github.io/styleguide/shellguide.html#todo-comments](https://google.github.io/styleguide/shellguide.html#todo-comments)

---

### Formatting: Indentation

Indent with 2 spaces. No tabs.

See: <span style="font-family: monospace;">Formatting: Indentation</span>.  
[https://google.github.io/styleguide/shellguide.html#indentation](https://google.github.io/styleguide/shellguide.html#indentation)

### Formatting: Line Length and Long Strings

Maximum line length is 80 characters.
Use `\` to break long lines. Here-strings and heredocs are exempt.

See: <span style="font-family: monospace;">Formatting: Line Length and Long Strings</span>.  
[https://google.github.io/styleguide/shellguide.html#line-length-and-long-strings](https://google.github.io/styleguide/shellguide.html#line-length-and-long-strings)

### Formatting: Pipelines

If a pipeline fits on one line, keep it on one line.
If it must be split, each stage goes on its own line indented by 2 spaces, with
`|` at the end of each line (not the start).

See: <span style="font-family: monospace;">Formatting: Pipelines</span>.  
[https://google.github.io/styleguide/shellguide.html#pipelines](https://google.github.io/styleguide/shellguide.html#pipelines)

### Formatting: Loops

Put `; do` and `; then` on the same line as `while`, `for`, and `if`:
```sh
for f in "${files[@]}"; do
  ...
done
```

See: <span style="font-family: monospace;">Formatting: Loops</span>.  
[https://google.github.io/styleguide/shellguide.html#loops](https://google.github.io/styleguide/shellguide.html#loops)

### Formatting: Case statement

Indent alternatives by 2 spaces. `;;` goes on its own line at the same
indentation as the alternative body.
```sh
case "${expr}" in
  pattern)
    action
    ;;
esac
```

See: <span style="font-family: monospace;">Formatting: Case statement</span>.  
[https://google.github.io/styleguide/shellguide.html#case-statement](https://google.github.io/styleguide/shellguide.html#case-statement)

### Formatting: Variable expansion

Always use `"${var}"` (braces + quotes) for variable expansion.
Bare `$var` is not permitted. Single-letter positional params (`$1`) are exempt
from braces but must still be quoted.

See: <span style="font-family: monospace;">Formatting: Variable expansion</span>.  
[https://google.github.io/styleguide/shellguide.html#variable-expansion](https://google.github.io/styleguide/shellguide.html#variable-expansion)

### Formatting: Quoting

- Always quote strings containing variables, command substitutions, spaces, or
  shell meta characters.
- Use `$'...'` syntax for strings requiring escape sequences.
- Do not quote integer literals or `[[ ... ]]` right-hand sides where word
  splitting is not a concern and the guide explicitly permits it.

See: <span style="font-family: monospace;">Formatting: Quoting</span>.  
[https://google.github.io/styleguide/shellguide.html#quoting](https://google.github.io/styleguide/shellguide.html#quoting)

---

### Features and Bugs: ShellCheck

All scripts must pass `shellcheck --format=gcc` with zero warnings or errors.

See: <span style="font-family: monospace;">Features and Bugs: ShellCheck</span>.  
[https://google.github.io/styleguide/shellguide.html#shellcheck](https://google.github.io/styleguide/shellguide.html#shellcheck)

### Features and Bugs: Command Substitution

Use `$(command)` instead of backticks.

See: <span style="font-family: monospace;">Features and Bugs: Command Substitution</span>.  
[https://google.github.io/styleguide/shellguide.html#command-substitution](https://google.github.io/styleguide/shellguide.html#command-substitution)

### Features and Bugs: Test, [ and [[

Use `[[ ... ]]` for all conditionals. Never use `[ ]` or `test`.

See: <span style="font-family: monospace;">Features and Bugs: Test, [ and [[</span>.  
[https://google.github.io/styleguide/shellguide.html#test--and-](https://google.github.io/styleguide/shellguide.html#test--and-)

### Features and Bugs: Testing Strings

Test for empty/non-empty strings with:
```sh
[[ -z "${var}" ]]   # empty
[[ -n "${var}" ]]   # non-empty
```
Never compare to an empty string literal `""`.

See: <span style="font-family: monospace;">Features and Bugs: Testing Strings</span>.  
[https://google.github.io/styleguide/shellguide.html#testing-strings](https://google.github.io/styleguide/shellguide.html#testing-strings)

### Features and Bugs: Wildcard Expansion of Filenames

Always quote globs or use arrays when expanding filenames to prevent unexpected
word splitting.

See: <span style="font-family: monospace;">Features and Bugs: Wildcard Expansion of Filenames</span>.  
[https://google.github.io/styleguide/shellguide.html#wildcard-expansion-of-filenames](https://google.github.io/styleguide/shellguide.html#wildcard-expansion-of-filenames)

### Features and Bugs: Eval

`eval` is forbidden. Refactor to avoid it.

See: <span style="font-family: monospace;">Features and Bugs: Eval</span>.  
[https://google.github.io/styleguide/shellguide.html#eval](https://google.github.io/styleguide/shellguide.html#eval)

### Features and Bugs: Arrays

Use arrays for lists of items instead of space-separated strings when the
elements may contain spaces.

See: <span style="font-family: monospace;">Features and Bugs: Arrays</span>.  
[https://google.github.io/styleguide/shellguide.html#arrays](https://google.github.io/styleguide/shellguide.html#arrays)

### Features and Bugs: Pipes to While

Use process substitution `< <(command)` instead of piping into `while read`
to avoid subshell variable scoping issues:
```sh
while read -r line; do
  ...
done < <(command)
```

See: <span style="font-family: monospace;">Features and Bugs: Pipes to While</span>.  
[https://google.github.io/styleguide/shellguide.html#pipes-to-while](https://google.github.io/styleguide/shellguide.html#pipes-to-while)

### Features and Bugs: Arithmetic

Use `(( ... ))` for arithmetic and `$(( ... ))` for arithmetic expansion.
Never use `let` or `expr`.

See: <span style="font-family: monospace;">Features and Bugs: Arithmetic</span>.  
[https://google.github.io/styleguide/shellguide.html#arithmetic](https://google.github.io/styleguide/shellguide.html#arithmetic)

---

### Naming Conventions: Function Names

Use `lowercase_with_underscores` for function names.
Separate libraries from the main script by prefixing functions with `namespace::`.

See: <span style="font-family: monospace;">Naming Conventions: Function Names</span>.  
[https://google.github.io/styleguide/shellguide.html#function-names](https://google.github.io/styleguide/shellguide.html#function-names)

### Naming Conventions: Variable Names

Use `lowercase_with_underscores` for local/loop variables.

See: <span style="font-family: monospace;">Naming Conventions: Variable Names</span>.  
[https://google.github.io/styleguide/shellguide.html#variable-names](https://google.github.io/styleguide/shellguide.html#variable-names)

### Naming Conventions: Constants and Environment Variable Names

Use `UPPERCASE_WITH_UNDERSCORES` for constants and exported environment variables.
Declare constants with `readonly` or `declare -r`.

See: <span style="font-family: monospace;">Naming Conventions: Constants and Environment Variable Names</span>.  
[https://google.github.io/styleguide/shellguide.html#constants-and-environment-variable-names](https://google.github.io/styleguide/shellguide.html#constants-and-environment-variable-names)

### Naming Conventions: Source Filenames

Use `lowercase_with_underscores` for script filenames. E.g. `my_script.sh`.

See: <span style="font-family: monospace;">Naming Conventions: Source Filenames</span>.  
[https://google.github.io/styleguide/shellguide.html#source-filenames](https://google.github.io/styleguide/shellguide.html#source-filenames)

### Naming Conventions: Read-only Variables

Declare read-only variables with `readonly varname` or `declare -r varname`.

See: <span style="font-family: monospace;">Naming Conventions: Read-only Variables</span>.  
[https://google.github.io/styleguide/shellguide.html#read-only-variables](https://google.github.io/styleguide/shellguide.html#read-only-variables)

### Naming Conventions: Use Local Variables

Declare all function-internal variables with `local`. This prevents leaking
into the global scope.

See: <span style="font-family: monospace;">Naming Conventions: Use Local Variables</span>.  
[https://google.github.io/styleguide/shellguide.html#use-local-variables](https://google.github.io/styleguide/shellguide.html#use-local-variables)

### Naming Conventions: Function Location

Place all functions together, before any non-comment non-`set` code.
Do not mix function definitions and executable code.

See: <span style="font-family: monospace;">Naming Conventions: Function Location</span>.  
[https://google.github.io/styleguide/shellguide.html#function-location](https://google.github.io/styleguide/shellguide.html#function-location)

### Naming Conventions: main

Scripts long enough to contain functions must have a `main` function that is
called at the end of the script:
```sh
main "$@"
```

See: <span style="font-family: monospace;">Naming Conventions: main</span>.  
[https://google.github.io/styleguide/shellguide.html#main](https://google.github.io/styleguide/shellguide.html#main)

---

### Calling Commands: Checking Return Values

Always check return values. Use `if`, `||`, or `set -e`.
Do not silently ignore failures.

See: <span style="font-family: monospace;">Calling Commands: Checking Return Values</span>.  
[https://google.github.io/styleguide/shellguide.html#checking-return-values](https://google.github.io/styleguide/shellguide.html#checking-return-values)



### Calling Commands: Builtin Commands vs. External Commands

Prefer shell builtins over external commands when they are equivalent.
E.g. prefer `${var#prefix}` over `sed`, `echo` over `printf` for simple output.

See: <span style="font-family: monospace;">Calling Commands: Builtin Commands vs. External Commands</span>.  
[https://google.github.io/styleguide/shellguide.html#builtin-commands-vs-external-commands](https://google.github.io/styleguide/shellguide.html#builtin-commands-vs-external-commands)

