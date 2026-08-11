#!/bin/bash
set -euo pipefail

echo "Testing strict mode..."

# Uncomment one at a time to test behavior

# Undefined variable (set -u)
# echo "$UNDEFINED_VAR"

# Failing command (set -e)
# false

# Pipeline failure (set -o pipefail)
# grep "text" nonexistentfile | wc -l

echo "Script completed."



# Scenario 1 — Test set -u (undefined variable)
# Comment these:
# echo "2) Testing failing command (set -e)"
# ls /directory-that-does-not-exist"

# echo "3) Testing pipe failure (set -o pipefail)"
# echo "hello" | grep "world"

# echo "Script completed"


# Scenario 2 — Test set -e (failing command)
# Comment these:
# echo "1) Testing undefined variable (set -u)"
# echo "Value: $UNDEFINED_VAR"
# echo "3) Testing pipe failure (set -o pipefail)"
# echo "hello" | grep "world"
# echo "Script completed"

# Scenario 3 — Test pipefail
# Now comment everything except pipe test.
# echo "3) Testing pipe failure (set -o pipefail)"
# echo "hello" | grep "world"