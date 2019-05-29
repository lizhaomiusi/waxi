#!/bin/bash
#
mysql << \EOF
use mysql;
RENAME USER `root`@`::1` TO `root`@`%`;
FLUSH PRIVILEGES;
SET PASSWORD FOR `root`@`%`=PASSWORD('root');
FLUSH PRIVILEGES;
exit
EOF
