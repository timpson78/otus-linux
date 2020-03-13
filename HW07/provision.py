#!/usr/bin/python

import os

os.system('setenforce Permissive')
os.system('yum install epel-release -y && yum install spawn-fcgi php php-cli mod_fcgid httpd -y')
os.system('cp ./opt/* /opt/')
os.system('chmod 755 /opt/watchlog.sh')
os.system('cp ./var/log/* /var/log/')
os.system('cp ./etc/sysconfig/* /etc/sysconfig/')
os.system('cp -f ./etc/systemd/system/* /etc/systemd/system/')
os.system('cp -f ./etc/rc.d/init.d/* /etc/rc.d/init.d/')
os.system('cp -f ./etc/httpd/conf/* /etc/httpd/conf/')
os.system('cp -f ./usr/lib/systemd/system/* /usr/lib/systemd/system/')
os.system('systemctl start watchlog.timer')
os.system('systemctl start spawn-fcgi')
os.system('systemctl start httpd@first')
os.system('systemctl start httpd@second')
