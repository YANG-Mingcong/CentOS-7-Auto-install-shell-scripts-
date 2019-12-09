#run in root user
yum -y upgrade

yum install -y net-tools vim

yum install -y ftp vsftpd
systemctl enable vsftpd.service
mkdir -p /etc/vsftpd/vconf
mkdir -p /data/ftp
useradd -s /sbin/nologin -d /data/ftp vsftpd

cp /etc/vsftpd/vsftpd.conf /etc/vsftpd/vsftpd.conf.orginal

sed -i "s/^.*anonymous_enable.*/anonymous_enable=NO/g" /etc/vsftpd/vsftpd.conf
sed -i "/^xferlog_std_format*a*/ s/^/#/" /etc/vsftpd/vsftpd.conf
sed -i "s/#idle_session_timeout=600/idle_session_timeout=900/" /etc/vsftpd/vsftpd.conf
sed -i "s/#nopriv_user=ftpsecure/nopriv_user=vsftpd/" /etc/vsftpd/vsftpd.conf
sed -i "/#chroot_list_enable=YES/i\chroot_local_user=YES" /etc/vsftpd/vsftpd.conf
sed -i 's/listen=NO/listen=YES/' /etc/vsftpd/vsftpd.conf
sed -i 's/listen_ipv6=YES/listen_ipv6=NO/' /etc/vsftpd/vsftpd.conf

echo 'allow_writeable_chroot=YES
guest_enable=YES
guest_username=vsftpd
local_root=/data/ftp/$USER
user_sub_token=$USER
virtual_use_local_privs=YES
user_config_dir=/etc/vsftpd/vconf' >> /etc/vsftpd/vsftpd.conf

#------------------------------------------------------------------------------------
# Configure pam (/etc/pam.d/vsftpd)
#------------------------------------------------------------------------------------

