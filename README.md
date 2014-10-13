Outils d'administration pour la plateforme Tandoori
===================================================

Ansible est utilisé pour assurer l'administration des machines et la gestion de leur configuration.

Installation
------------

```bash
$ ansible-galaxy install -r requirements.txt
```

Installation des configuration collectd
---------------------------------------

```bash
$ ansible-playbook -i production site.yml --limit reverse_proxies --tags collectd -u admin -s
```
