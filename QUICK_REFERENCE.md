# Ansible Quick Reference Guide

## Essential Commands

### Running Playbooks
```bash
# Basic execution
ansible-playbook playbook.yml

# Verbose output
ansible-playbook playbook.yml -v      # verbose
ansible-playbook playbook.yml -vv     # more verbose
ansible-playbook playbook.yml -vvv    # debug level

# Dry run (don't make changes)
ansible-playbook playbook.yml --check

# Syntax check
ansible-playbook playbook.yml --syntax-check

# List tasks
ansible-playbook playbook.yml --list-tasks

# List hosts
ansible-playbook playbook.yml --list-hosts
```

### Ad-hoc Commands
```bash
# Ping all hosts
ansible all -m ping

# Get facts
ansible all -m setup

# Run a command
ansible all -m command -a "uptime"

# Copy a file
ansible all -m copy -a "src=/path/to/file dest=/path/to/dest"

# Install a package (requires sudo)
ansible all -m apt -a "name=vim state=present" --become
```

### Inventory Commands
```bash
# List all hosts
ansible all --list-hosts

# List hosts in a group
ansible webservers --list-hosts

# Show inventory
ansible-inventory --list
ansible-inventory --graph
```

## Common Modules

### File Operations
```yaml
# Create/manage files and directories
- file:
    path: /path/to/file
    state: directory|file|absent|link
    mode: '0755'
    owner: user
    group: group

# Copy files
- copy:
    src: source/file
    dest: /dest/file
    mode: '0644'
    backup: yes

# Template files
- template:
    src: template.j2
    dest: /path/to/config
    mode: '0644'

# Manage lines in files
- lineinfile:
    path: /path/to/file
    line: "text to add"
    regexp: '^pattern'
    state: present|absent
```

### Package Management
```yaml
# APT (Debian/Ubuntu)
- apt:
    name: package_name
    state: present|absent|latest
    update_cache: yes

# YUM (RHEL/CentOS)
- yum:
    name: package_name
    state: present|absent|latest

# Generic package
- package:
    name: package_name
    state: present
```

### Service Management
```yaml
- service:
    name: service_name
    state: started|stopped|restarted|reloaded
    enabled: yes|no
```

### Command Execution
```yaml
# Run commands
- command: /path/to/command arg1 arg2
  args:
    chdir: /path/to/directory
    creates: /path/to/file  # skip if exists

# Run shell commands
- shell: echo $HOME
  args:
    executable: /bin/bash
```

## Playbook Structure

### Basic Playbook
```yaml
---
- name: Playbook Name
  hosts: target_hosts
  gather_facts: yes|no
  become: yes|no

  vars:
    variable_name: value

  tasks:
    - name: Task description
      module_name:
        parameter: value
```

### Variables
```yaml
# Simple variable
vars:
  app_port: 8080

# List
vars:
  users:
    - alice
    - bob

# Dictionary
vars:
  database:
    host: localhost
    port: 5432

# Using variables
{{ variable_name }}
{{ users[0] }}
{{ database.host }}
```

### Loops
```yaml
# Simple loop
- name: Create users
  user:
    name: "{{ item }}"
  loop:
    - alice
    - bob

# Loop with dictionary
- name: Configure apps
  copy:
    content: "{{ item.config }}"
    dest: "/etc/{{ item.name }}.conf"
  loop:
    - { name: 'app1', config: 'content1' }
    - { name: 'app2', config: 'content2' }

# Loop with loop_control
- name: Install packages
  package:
    name: "{{ item }}"
  loop:
    - vim
    - git
  loop_control:
    label: "{{ item }}"  # Only show item in output
```

### Conditionals
```yaml
# When clause
- name: Task
  debug:
    msg: "Running"
  when: ansible_os_family == "Debian"

# Multiple conditions
- name: Task
  debug:
    msg: "Running"
  when:
    - ansible_distribution == "Ubuntu"
    - ansible_distribution_version == "20.04"

# Or conditions
- name: Task
  debug:
    msg: "Running"
  when: ansible_distribution == "Ubuntu" or ansible_distribution == "Debian"
```

### Handlers
```yaml
tasks:
  - name: Update config
    copy:
      src: config.conf
      dest: /etc/app/config.conf
    notify: Restart service

handlers:
  - name: Restart service
    service:
      name: myapp
      state: restarted
```

## Jinja2 Template Syntax

### Variables
```jinja2
{{ variable_name }}
{{ dict.key }}
{{ list[0] }}
```

### Conditionals
```jinja2
{% if condition %}
  text
{% elif other_condition %}
  other text
{% else %}
  default text
{% endif %}
```

### Loops
```jinja2
{% for item in list %}
  {{ item }}
{% endfor %}

{% for key, value in dict.items() %}
  {{ key }}: {{ value }}
{% endfor %}
```

### Filters
```jinja2
{{ variable | default('default_value') }}
{{ variable | upper }}
{{ variable | lower }}
{{ list | length }}
{{ number | int }}
{{ string | replace('old', 'new') }}
```

## Directory Structure

### Recommended Layout
```
project/
├── ansible.cfg
├── inventory/
│   ├── production
│   └── staging
├── group_vars/
│   ├── all.yml
│   └── webservers.yml
├── host_vars/
│   └── hostname.yml
├── roles/
│   └── role_name/
│       ├── tasks/
│       ├── handlers/
│       ├── templates/
│       ├── files/
│       ├── vars/
│       └── defaults/
├── playbooks/
│   └── deploy.yml
└── README.md
```

## Best Practices

1. **Use version control** - Keep playbooks in Git
2. **Name tasks clearly** - Use descriptive task names
3. **Use variables** - Don't hardcode values
4. **Use roles** - Organize complex playbooks
5. **Test with --check** - Always dry-run first
6. **Use handlers** - For service restarts
7. **Document** - Add comments and README files
8. **Use tags** - For selective execution
9. **Keep it simple** - Don't over-complicate
10. **Use ansible-vault** - For sensitive data

## Debugging

### Display Variables
```yaml
- debug:
    var: variable_name

- debug:
    msg: "Value is {{ variable }}"
```

### Register Output
```yaml
- command: /some/command
  register: result

- debug:
    var: result.stdout_lines
```

### Fact Gathering
```yaml
# View all facts
- setup:
  register: facts

- debug:
    var: facts
```

### Common Variables
- `ansible_hostname` - Hostname
- `ansible_os_family` - OS family (Debian, RedHat, etc.)
- `ansible_distribution` - Distribution name
- `ansible_distribution_version` - OS version
- `ansible_architecture` - Architecture
- `ansible_date_time` - Date/time information
- `ansible_env` - Environment variables

## Error Handling

```yaml
# Ignore errors
- command: /might/fail
  ignore_errors: yes

# Change when task is "changed"
- command: /some/command
  changed_when: false

# Failed when custom condition
- command: /some/command
  register: result
  failed_when: "'ERROR' in result.stdout"

# Block with rescue
- block:
    - name: Might fail
      command: /risky/command
  rescue:
    - name: Handle failure
      debug:
        msg: "Task failed, handling it"
  always:
    - name: Always runs
      debug:
        msg: "Cleanup"
```

## Tags

```yaml
tasks:
  - name: Install packages
    package:
      name: vim
    tags:
      - packages
      - install

# Run specific tags
# ansible-playbook playbook.yml --tags "install"
# ansible-playbook playbook.yml --skip-tags "packages"
```
