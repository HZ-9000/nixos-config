{
	preservation = {
		enable = true;
		preserveAt = "/persist";

		# State that should survive an otherwise ephemeral root filesystem.
		directories = [
			"/var/lib/nixos"
			"/var/lib/systemd"
			"/var/lib/NetworkManager"
			"/var/lib/bluetooth"
			"/var/lib/AccountsService"
			"/var/lib/sssd"
			"/var/lib/fprint"
		];

		files = [
			"/etc/machine-id"
			"/var/lib/systemd/random-seed"
			"/etc/ssh/ssh_host_rsa_key"
			"/etc/ssh/ssh_host_rsa_key.pub"
			"/etc/ssh/ssh_host_ed25519_key"
			"/etc/ssh/ssh_host_ed25519_key.pub"
			"/etc/ssh/ssh_host_ecdsa_key"
			"/etc/ssh/ssh_host_ecdsa_key.pub"
		];
	};
}
