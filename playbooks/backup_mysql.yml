---
#- name: delete old files
#  shell: find {{ filedir_ansible }} -name "*" -mtime +20 -delete
#  delegate_to: localhost

- name: get mysql backups
  hosts: sql-server
#  hosts: db_sql
  ignore_errors: yes
  vars:
    mysql_pass: "root1234"
    mysql_user: "root"
    mysql_backup_dir: "/home/user/backup/DB/temp/"

  tasks:
  - name: get db names
    shell: "mysql -h {{ ansible_host }} -u root -p{{ mysql_pass }} -e 'show databases' -s --skip-column-names"
    register: dblist

  - name: delete old files on mysql
    shell: "rm -rf {{ mysql_backup_dir }}"

  - name: create dir
    shell: "[ -d {{ mysql_backup_dir }} ] || mkdir -p {{ mysql_backup_dir }}"

  - name: create all databases backup
    shell: "mysqldump --events -h {{ ansible_host }} -u {{ mysql_user }} -p{{ mysql_pass }} --force --single-transaction --all-databases | gzip > {{mysql_backup_dir}}{{ lookup('pipe','date +%Y-%m-%d') }}-all_databases.sql.gz 2>/dev/null"


  - name: get namely db backups
    shell: "mysqldump --events -h {{ ansible_host }} -u {{ mysql_user }} -p{{ mysql_pass }} --force --single-transaction {{item}} | gzip > {{mysql_backup_dir}}{{ lookup('pipe','date +%Y-%m-%d') }}-{{item}}.sql.gz 2>/dev/null;"
    with_items: "{{ dblist.stdout_lines }}"

  - name: find
    shell: find {{ mysql_backup_dir }} -type f
    register: files_to_copy

  - name: create local dir
    shell: "[ -d /mnt/disk/backup/databases/{{ inventory_hostname }}/ ] || mkdir -p /mnt/disk/databases/{{ inventory_hostname }}/"
    delegate_to: localhost

  - name: fetch
    fetch:  src={{ item }} dest=/mnt/disk/backup/databases/{{ inventory_hostname }}/  flat=yes
    with_items: "{{ files_to_copy.stdout_lines }}"

##########################################
- name: get docker mysql backups
  hosts: zabbix-sql
  ignore_errors: yes
  vars:
    mysql_pass: "root1234"
    mysql_user: "root"
    mysql_backup_dir: "/home/user/backup/DB/temp/"
    docker_name: "mysql-server"

  tasks:
  - name: get db names
    shell: "docker exec -ti {{ docker_name }} mysql -h localhost -u root -p{{ mysql_pass }} -e 'show databases' -s --skip-column-names | grep -v Warning"
    register: dblist

  - name: delete old docker dir and host dir
    shell: "rm -rf {{ mysql_backup_dir }};docker exec -ti {{ docker_name }} sh -c 'rm -rf {{ mysql_backup_dir }}'"

#  - name: delete old host dir
#    shell: "rm -rf {{ mysql_backup_dir }}"

  - name: create dir
    shell: "[ -d {{ mysql_backup_dir }}{{ docker_name }} ] || mkdir -p {{ mysql_backup_dir }}{{ docker_name }}"

  - name: create docker dir
    shell: "docker exec -ti {{ docker_name }} sh -c '[ -d {{ mysql_backup_dir }} ] || mkdir -p {{ mysql_backup_dir }}'"

#  - name: create all databases backup
#    shell: "docker exec -ti {{ docker_name }} mysqldump --events -h localhost -u {{ mysql_user }} -p{{ mysql_pass }} --force --single-transaction --all-databases  {{mysql_backup_dir}}{{ lookup('pipe','date +%Y-%m-%d') }}-all_databases.sql 2>/dev/null"


#  - name: get namely db backups
#    shell: "docker exec -ti {{ docker_name }} mysqldump --events -h localhost -u {{ mysql_user }} -p{{ mysql_pass }} --force --single-transaction {{item}} {{mysql_backup_dir}}{{ lookup('pipe','date +%Y-%m-%d') }}-{{item}}.sql 2>/dev/null;"
  - name: create all databases backup
    shell: "docker exec -ti {{ docker_name }} mysqldump --events -h localhost -u {{ mysql_user }} -p{{ mysql_pass }} --force --single-transaction --all-databases | gzip > {{mysql_backup_dir}}{{ docker_name }}/{{ lookup('pipe','date +%Y-%m-%d') }}-all_databases.sql.gz 2>/dev/null"

  - name: get namely db backups
    shell: "docker exec -ti {{ docker_name }} mysqldump --events -h localhost -u {{ mysql_user }} -p{{ mysql_pass }} --force --single-transaction {{item}} | gzip > {{mysql_backup_dir}}{{ docker_name }}/{{ lookup('pipe','date +%Y-%m-%d') }}-{{item}}.sql.gz 2>/dev/null;"
    with_items: "{{ dblist.stdout_lines }}"

  ``` bash
  - name: find
    shell: find {{ mysql_backup_dir }}{{ docker_name }} -type f
    register: files_to_copy

  - name: create local dir
    shell: "[ -d /mnt/disk/backup/databases/{{ inventory_hostname }}/{{ docker_name }} ] || mkdir -p /mnt/disk/databases/{{ inventory_hostname }}/{{ docker_name }}"
    delegate_to: localhost

  - name: fetch
    fetch:  src={{ item }} dest=/mnt/disk/backup/databases/{{ inventory_hostname }}/{{ docker_name }}/  flat=yes
    with_items: "{{ files_to_copy.stdout_lines }}"


##########################################
- name: get docker mysql backups
  hosts: zabbix-sql
  ignore_errors: yes
  vars:
    mysql_pass: "root1234"
    mysql_user: "root"
    mysql_backup_dir: "/home/user/backup/DB/temp/"
    docker_name: "jira-mysql-server"

  tasks:
  - name: get db names
    shell: "docker exec -ti {{ docker_name }} mysql -h localhost -u root -p{{ mysql_pass }} -e 'show databases' -s --skip-column-names | grep -v Warning"
    register: dblist

  - name: delete old docker dir and host dir
    shell: "rm -rf {{ mysql_backup_dir }};docker exec -ti {{ docker_name }} sh -c 'rm -rf {{ mysql_backup_dir }}'"

  - name: create dir
    shell: "[ -d {{ mysql_backup_dir }}{{ docker_name }} ] || mkdir -p {{ mysql_backup_dir }}{{ docker_name }}"

  - name: create docker dir
    shell: "docker exec -ti {{ docker_name }} sh -c '[ -d {{ mysql_backup_dir }} ] || mkdir -p {{ mysql_backup_dir }}'"

  - name: create all databases backup
    shell: "docker exec -ti {{ docker_name }} mysqldump --events -h localhost -u {{ mysql_user }} -p{{ mysql_pass }} --force --single-transaction --all-databases | gzip > {{mysql_backup_dir}}{{ docker_name }}/{{ lookup('pipe','date +%Y-%m-%d') }}-all_databases.sql.gz 2>/dev/null"

  - name: get namely db backups
    shell: "docker exec -ti {{ docker_name }} mysqldump --events -h localhost -u {{ mysql_user }} -p{{ mysql_pass }} --force --single-transaction {{item}} | gzip > {{mysql_backup_dir}}{{ docker_name }}/{{ lookup('pipe','date +%Y-%m-%d') }}-{{item}}.sql.gz 2>/dev/null;"
    with_items: "{{ dblist.stdout_lines }}"

  - name: find
    shell: find {{ mysql_backup_dir }}{{ docker_name }} -type f
    register: files_to_copy

  - name: create local dir
    shell: "[ -d /mnt/disk/backup/databases/{{ inventory_hostname }}/{{ docker_name }} ] || mkdir -p /mnt/disk/databases/{{ inventory_hostname }}/{{ docker_name }}"
    delegate_to: localhost

  - name: fetch
    fetch:  src={{ item }} dest=/mnt/disk/backup/databases/{{ inventory_hostname }}/{{ docker_name }}/  flat=yes
    with_items: "{{ files_to_copy.stdout_lines }}"
```
