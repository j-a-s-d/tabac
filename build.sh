#!/usr/bin/env bash

nim c --define:release --threads:on --opt:speed -d:danger --out:bin/tabac src/tabac
cp src/tabac.cfg bin
