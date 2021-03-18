#!/bin/bash

# Fast fail the script on failures.
set -e

dart pub global activate coverage

dart test --coverage="coverage"
pub global activate remove_from_coverage
pub global run remove_from_coverage:remove_from_coverage -f packages/stream_feed/coverage/lcov.info -r '.g.dart$'
format_coverage --lcov --in=coverage --out=coverage.lcov --packages=.packages --report-on=lib