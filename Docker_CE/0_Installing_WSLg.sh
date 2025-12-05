#####################################################################
#           Installing WSLg
#####################################################################
wsl --list --online
wsl --install -d Ubuntu
wsl -d Ubuntu

# other WSL commands
# wsl --set-default Ubuntu
# wsl --list
# wsl --unregister Ubuntu

# Optionally you can disable the automount by editing the /etc/wsl.conf file in your WSL distribution:
# # sudo nano /etc/wsl.conf
# [automount]
# enabled = false

# You need to restart the WSL distribution to apply the changes:
# wsl --terminate Ubuntu

# Optionally you can auto appending Windows paths by editing the /etc/wsl.conf file in your WSL distribution:
# # sudo nano /etc/wsl.conf
# [interop]
# appendWindowsPath = false

# You need to restart the WSL distribution to apply the changes:
# wsl --terminate Ubuntu

#####################################################################
#           Testing wsl 
#####################################################################
wsl -d Ubuntu
cat /etc/os-release
exit

wsl -d Ubuntu cat /etc/os-release
$result = wsl -d Ubuntu cat /etc/os-release