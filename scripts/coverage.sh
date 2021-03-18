#!/bin/bash

# Fast fail the script on failures.
set -e

dart pub global activate coverage

flutter test --coverage
pub global activate remove_from_coverage
pub global run remove_from_coverage:remove_from_coverage -f coverage/lcov.info -r '.g.dart$'