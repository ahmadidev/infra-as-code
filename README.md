# infra-as-code


Three stages:
- Upgrade: Upgrade OS or apps manually
- Config: Config OS or apps according to relevant config file in this repo
- Backup: Backups services and run in schedule

[diagram]

TODO:
- [ ] Rewrite k8s.sh,rocketchat.sh on yaml.
- [ ] Use haproxy for k8s master api advertise address.
- [ ] Refactore kube
- [ ] Use containerd as container runtime interface in k8s
- [ ] Automate Install apps
- [ ] Fix quote password in backup/backup-k8s.yaml:20
