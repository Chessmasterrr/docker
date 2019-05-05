This is a WireGuard server in a docker container.

# Usage

Prerequisites:
* WireGuard is installed on the host
* A WireGuard configuration file exist on the host in <CONFDIR> and is readable for a user with <UID>

To use the wireguard container use the following command:

`sudo docker run --name wireguard --restart=always --cap-add net_admin --cap-add sys_module -u <UID> -p 51820:51820/udp -v <CONFDIR>/wg0.conf:/etc/wireguard/wg0.conf -v /lib/modules:/lib/modules -d chessmasterrr/wireguard`
