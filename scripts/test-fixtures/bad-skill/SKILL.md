# Bad Skill

This is a deliberately malformed skill file used for testing the skill-validator.
It has no YAML frontmatter, no description field, no gotchas, and no gate keywords.

## Overview

This skill does something generic. It is not well defined and lacks the
structural elements required by the EOP governance checks.

## Instructions

Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod
tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,
quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo
consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse
cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat
non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium
doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore
veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim
ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit.

At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis
praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias
excepturi sint occaecati cupiditate non provident, similique sunt in culpa
qui officia deserunt mollitia animi, id est laborum et dolorum fuga.

## Configuration

Set the following environment variables before running:

- `SOME_VAR` — controls the behavior
- `ANOTHER_VAR` — sets the output format
- `YET_ANOTHER` — toggles verbose mode

## Usage

Run the skill by invoking it from the command line:

```
/bad-skill
```

Then follow the prompts.

## Notes

This section contains additional notes about the skill that are not
particularly useful but add line count to the file. The purpose of
this fixture is to trigger validation failures in the skill-validator
script during testing.

Remember that this file intentionally violates the EOP governance
requirements. It should score very poorly on all checks.

## Additional Filler

More content to push the file past 50 lines so that the body-length
waiver does not apply for checks 06 and 07. This ensures those checks
are actually evaluated rather than being waived.

The quick brown fox jumps over the lazy dog. Pack my box with five
dozen liquor jugs. How vexingly quick daft zebras jump.

Sphinx of black quartz, judge my vow. Two driven jocks help fax my
big quiz. The five boxing wizards jump quickly.
