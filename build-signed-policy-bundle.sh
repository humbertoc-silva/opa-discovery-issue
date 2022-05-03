#!/bin/bash
cd signed-policy-bundle
opa sign --signing-key ../keys/private-key.pem --bundle .
tar -czvf ../signed-policy-bundle.tar.gz -C . $(ls -A .)