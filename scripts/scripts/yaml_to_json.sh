#!/bin/bash
python3 -c 'import sys, yaml, json; 
json.dump(yaml.load(sys.stdin, Loader=yaml.FullLoader), sys.stdout, indent=4)' <$1 >$2
echo '' >>$2
