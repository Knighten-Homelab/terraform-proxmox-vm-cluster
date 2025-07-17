# Migration Plan: Align with terraform-proxmox-vm Repository

## Overview
This document outlines the detailed migration plan to align the `terraform-proxmox-vm-cluster` module with the latest changes in https://github.com/Knighten-Homelab/terraform-proxmox-vm, specifically adopting reusable GitHub Actions workflows and updating project configuration.

## Analysis Summary

### Current State vs Target State
- **Current**: Manual semantic-release setup with local dependencies
- **Target**: Reusable GitHub Actions workflows for CI/CD automation
- **Key Change**: Migration from self-managed semantic-release to centralized reusable workflows

## Detailed Migration Tasks

### Task 1: Create GitHub Actions Workflows ✅ COMPLETED
**Priority**: High  
**Estimated Effort**: 30 minutes

#### Files to Create:
1. **`.github/workflows/pr-open-tf-lint-and-scan.yml`**
   - **Purpose**: Automated linting and security scanning for pull requests
   - **Content Changes**:
     ```yaml
     name: PR Opened - Lint and Test Terraform Changes
     run-name: Terraform Change Detected In PR ${{ github.event.number }} on ${{ github.head_ref }} - Lint and Test
     
     on:
       pull_request:
         types:
           - opened
           - reopened
           - synchronize
     
     permissions:
       contents: read
     
     jobs:
       terraform-validation:
         uses: Knighten-Homelab/gha-reusable-workflows/.github/workflows/terraform-lint-and-security-scan.yaml@main
         with:
           runs-on: ubuntu-latest
           infra-directory: ./
     ```
   - **Why**: Replaces manual linting with automated CI/CD pipeline

2. **`.github/workflows/push-main-release.yml`**
   - **Purpose**: Automated semantic release when code is pushed to main
   - **Content Changes**:
     ```yaml
     name: Push Main - Create Semantic Release
     run-name: New Commit Detected on Main - Create Release
     
     on:
       push:
         branches:
           - main
         paths-ignore:
           - 'CHANGELOG.md'
     
     permissions:
       contents: write
       issues: write
       pull-requests: write
     
     jobs:
       semantic-release:
         uses: Knighten-Homelab/gha-reusable-workflows/.github/workflows/semantic-release-to-gh.yaml@main
         with:
           runs-on: ubuntu-latest
     ```
   - **Why**: Replaces local semantic-release setup with centralized workflow

### Task 2: Convert Commitlint Configuration
**Priority**: High  
**Estimated Effort**: 5 minutes

#### Files to Modify:
1. **`commitlint.config.ts` → `commitlint.config.js`**
   - **Current Content**:
     ```typescript
     module.exports = {extends: ['@commitlint/config-conventional']}
     ```
   - **New Content**:
     ```javascript
     module.exports = {
       extends: ['@commitlint/config-conventional']
     }
     ```
   - **Why**: Aligns with target repository's JavaScript configuration
   - **Action**: Delete `.ts` file after creating `.js` file

### Task 3: Simplify Package.json Dependencies ✅ COMPLETED
**Priority**: High  
**Estimated Effort**: 10 minutes

#### Files to Modify:
1. **`package.json`**
   - **Dependencies to Remove**:
     ```json
     "@semantic-release/changelog": "6.0.3",
     "@semantic-release/commit-analyzer": "11.0.0",
     "@semantic-release/git": "10.0.1",
     "@semantic-release/github": "9.2.0",
     "conventional-changelog-conventionalcommits": "8.0.0",
     "semantic-release": "1f22.0.5"
     ```
   - **Dependencies to Keep**:
     ```json
     "@commitlint/cli": "^19.4.1",
     "@commitlint/config-conventional": "^19.4.1",
     "husky": "^9.1.6"
     ```
   - **Scripts Changes**:
     - **Remove**: `"pre-commit-gha": ""`
     - **Keep**: `"prepare": "husky"`
   - **Why**: Semantic release is now handled by GitHub Actions, not local dependencies

### Task 4: Add Provider Constraints to versions.tf
**Priority**: High  
**Estimated Effort**: 10 minutes

#### Files to Modify:
1. **`versions.tf`**
   - **Current Content**:
     ```hcl
     terraform {
       required_version = ">= 1.9.8"
     }
     ```
   - **New Content**:
     ```hcl
     terraform {
       required_version = ">= 1.9.8"
     
       required_providers {
         proxmox = {
           source  = "telmate/proxmox"
           version = "3.0.2-rc01"
         }
         powerdns = {
           source  = "pan-net/powerdns"
           version = "1.5.0"
         }
       }
     }
     ```
   - **Why**: Explicit provider versions prevent breaking changes and align with base module

### Task 5: Update CLAUDE.md Documentation
**Priority**: Medium  
**Estimated Effort**: 15 minutes

#### Files to Modify:
1. **`CLAUDE.md`**
   - **Sections to Add**:
     - GitHub Actions workflow commands
     - CI/CD pipeline description
     - Reusable workflows dependency information
   - **New Content to Add**:
     ```markdown
     ### GitHub Actions
     - **PR Workflow**: Automatic linting and security scanning on pull requests
     - **Release Workflow**: Automatic semantic versioning and releases on main branch pushes
     - **Reusable Workflows**: Uses `Knighten-Homelab/gha-reusable-workflows` for consistency
     
     ### CI/CD Commands
     - View workflow runs: Check GitHub Actions tab
     - Manual workflow trigger: Not applicable (automatic triggers only)
     - Workflow debugging: Check workflow logs in GitHub Actions
     ```
   - **Sections to Update**:
     - Remove semantic-release commands
     - Update development workflow section
     - Add GitHub Actions integration notes

## Implementation Order
1. **Task 1** ✅ (GitHub workflows) - Main CI/CD implementation
2. **Task 3** ✅ (package.json) - Dependency cleanup
3. **Task 4** (versions.tf) - Foundation change, no dependencies
4. **Task 2** (commitlint config) - Simple conversion
5. **Task 5** (CLAUDE.md) - Documentation update

## Testing Strategy
1. **Validate Terraform**: Run `terraform validate` after versions.tf update
2. **Test Commitlint**: Run `npx commitlint --from=HEAD~1 --to=HEAD --verbose`
3. **Verify Dependencies**: Run `npm install` after package.json changes
4. **GitHub Actions**: Create test PR to verify workflow execution

## Rollback Plan
- Keep backup of original files before modification
- If workflows fail, temporarily disable GitHub branch protection
- Revert package.json if dependency issues occur

## Dependencies
- Access to `Knighten-Homelab/gha-reusable-workflows` repository
- GitHub repository permissions for Actions
- No external service dependencies