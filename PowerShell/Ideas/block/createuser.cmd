@Echo off

Echo "Create user"
NET USER Admin "P@ssw0rd" /ADD

echo "Add To Administratgors Group"
NET LOCALGROUP "Администраторы" "Admin" /ADD

Echo "Created User Details"
NET USER "Admin"
