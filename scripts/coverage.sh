#!/bin/bash

# Fast fail the script on failures.
set -e

dart pub global activate coverage

flutter test --coverage
dart pub global activate remove_from_coverage
dart pub global run remove_from_coverage:remove_from_coverage -f coverage/lcov.info -r '\.g\.dart$' -r '\.freezed\.dart$'