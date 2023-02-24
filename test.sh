#!/usr/bin/env bash

function runSuite() {
  rm -rf $1_cases/*.output
  nim c $1.nim &> /dev/null
  ./$1
  rm -rf $1
}

cd tests
runSuite forbidden
runSuite output
runSuite configuration
cd ..

