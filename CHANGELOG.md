# Changelog

All notable changes to this Ansible training project will be documented in this file.

## [1.1.0] - 2025-11-10

### Fixed
- Fixed `gather_facts` issue in playbooks 02 and 05
  - Changed `gather_facts: no` to `gather_facts: yes` in `02-file-operations.yml`
  - Changed `gather_facts: no` to `gather_facts: yes` in `05-handlers.yml`
  - Both playbooks were using `ansible_date_time` which requires facts to be gathered
  - This fixes the error: "'ansible_date_time' is undefined"

### Added
- Automatic prerequisite installation scripts
  - `install-prerequisites.sh` - Auto-installs Ansible, Python, pip, and dependencies
  - `setup-and-run.sh` - One-command setup and execution
  - Updated `verify-setup.sh` to offer automatic installation
- Docker support
  - `Dockerfile` for containerized training environment
  - `docker-compose.yml` for easy container management
  - `.dockerignore` for optimized builds
- Enhanced documentation
  - `GETTING_STARTED.md` - Quick start guide
  - Updated `README.md` with installation instructions
  - This `CHANGELOG.md` file
- Updated Jenkinsfile to automatically install prerequisites

### Changed
- All playbooks now have `gather_facts: yes` for consistency
- Enhanced error handling in installation scripts
- Improved OS detection and multi-distro support

## [1.0.0] - 2025-11-10

### Initial Release
- 6 progressive training lessons covering Ansible basics
- Configuration files (ansible.cfg, inventory.ini)
- Jinja2 templates for dynamic configurations
- Helper scripts for running individual or all lessons
- Comprehensive documentation and quick reference guide
- Jenkins pipeline configuration
- Support for localhost-only training (controller and node in same container)
