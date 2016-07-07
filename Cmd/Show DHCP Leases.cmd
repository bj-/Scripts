echo Required Domain Admins Rights or 
echo Add user to "DHCP Users" group (for read only access to DHCP server)


netsh dhcp server 172.16.30.11 scope 172.16.30.0 show clients 1
