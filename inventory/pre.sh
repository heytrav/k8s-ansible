#!/bin/bash
echo " { \"_meta\": { \"hostvars\": {} }, \"all\": { \"children\": [ \"dashboard\", \"bastion\", \"${PREFIX}\" ] }, \"dashboard\": { \"hosts\": [ \"${PREFIX}_rancher\" ] }, \"bastion\": { \"hosts\": [ \"${PREFIX}_bastion\" ] }, \"${PREFIX}\": { \"hosts\": [ \"${PREFIX}_bastion\", \"${PREFIX}_rancher\" ] } } "
