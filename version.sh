echo
echo "Scripting"
echo "--------------------------------------------------------------------------------"
echo -n "Perl: "; perl -v | awk '/This is perl/ {split($4,a,"v"); print a[2]}'
echo -n "PHP: "; php -v | awk '/built/ {print $2}'
echo -n "Pear: "; pear version | awk 'NR == 1 {print $3}'
echo -n "Python: "; python -V 2>&1 | awk '{print $2}'
echo -n "Ruby: "; ruby -v | awk '{print $2, $3, $4, $5}'
echo -n "RubyGems: "; gem -v
echo -n "Rails: "; rails -v | awk '{print $2}'
echo
echo "Database"
echo "--------------------------------------------------------------------------------"
echo -n "MySQL: "; mysql -V | awk '{split($5,a,","); print a[1]}'
echo -n "PostgreSQL: "; psql --version | awk '/psql/ {print $3}'
echo
echo "Image Libraries"
echo "--------------------------------------------------------------------------------"
echo -n "GD: "; php -i | awk '/GD Version/ {split ($6,a,"("); print a[2]}'
echo -n "ImageMagick: "; convert -version | awk '/Version/ {print $3}'
echo
echo "Miscellaneous"
echo "--------------------------------------------------------------------------------"
echo -n "CentOS: "; rpm -qa *-release | grep centos
echo -n "Kernel: "; uname -r | awk '{split($1,a,"-"); print a[1]}'
echo -n "Apache: "; httpd -v | awk '/version/ {split($3,a,"/"); print a[2]}'
echo -n "Operating System: "; cat /etc/*release | awk '{print $1, $3}'
echo -n "Zend Optimizer: "; php -i | awk -F "nbsp;" '/Zend&/ {print $15}'
echo -n "Spam Assassin: "; perl -MMail::SpamAssassin -e 'print $Mail::SpamAssassin::VERSION; print "n"'
echo -n "OpenSSL: "; openssl version | awk '{split($2,a,"-"); print a[1]}'
echo -n "OpenSSH: "; ssh -V 2>&1 | awk '{split($1,a,","); print a[1]}'
echo -n "Bind: "; named -v | awk '{split($2,a,"-"); print a[1]}'
echo -n "Curl: "; curl -V | awk 'NR == 1 {print $2}'
echo -n "Horde: "; cat /var/cpanel/horde/version; echo
echo -n "cPanel: "; /usr/local/cpanel/cpanel -V
echo
echo "Version Control"
echo "--------------------------------------------------------------------------------"
echo -n "SVN: "; svn --version | awk '/version/ {print $3}' | head -1
echo -n "GIT: "; git --version | awk '{print $3}'
echo -n "CVS: "; cvs -v | awk '/client/ {print $5}'
