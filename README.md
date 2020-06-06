# A.S. Exam

### Deploy machine (optional)

We ship a terraform config to automatically setup arch machines. It
automatically creates a machine in the system libvirt (`qemu:///system`).

Dependencies:
  - libvirt
  - terraform
  - terraform-provider-libvirt

Before deploying adjust `cloud_init.cfg`. You will need to add your ssh key to
the `root` user to be able to do the initial configuration.

```
terraform apply
```

To retrive the IPs:
```
terraform output
```

If you want to deploy the configuration on an already existent arch machine, you
can skip this.

### Configure machine

First, you should populate `hosts` with you target ip address(es).

To configure a machine you it needs to be acessible via ssh. To configure the
machines deployed by terradorm for the first time, you will have to do it as
the `root` user.

```
ansible-playbook playbooks/as-system.yml --user root
```

After that, the users will be created, the sudo permissions will be set and
the ssh service will be configured. Our ssh configuration disallows login in
as `root` so you will have to use your user from now on.

You will be asked for your password when running the playbook as we need
`sudo` access. You should set your password before this (ssh to the server
and run `passwd`).

```
ansible-playbook playbooks/as-system.yml --user ffy00 --ask-become-pass
```

