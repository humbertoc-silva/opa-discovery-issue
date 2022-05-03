#!/bin/bash
cd unsigned-policy-bundle
tar -czvf ../unsigned-policy-bundle.tar.gz -C . $(ls -A .)