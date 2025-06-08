# Terraform Coding Guidelines
 
## Code Style & Structure
- Always use [Terraform v1.9+] features where possible.
- Use consistent indentation (2 spaces) for readability.
- Group related resources logically (e.g., networking, compute, storage).
- Keep resource blocks short and well-organised—avoid large, complex blocks.
 
## Module Usage
- Prefer reusable modules over repeating code.
- Use standard module structure: `main.tf`, `variables.tf`, `outputs.tf`, `README.md`.
- For shared modules, source them from the approved GitHub org or Terraform Registry.
 
## Variables & Outputs
- All variables must have descriptions and types defined.
- Avoid hardcoding values—use variables or locals.
- Outputs should be meaningful and named consistently for reuse in parent modules.
 
##  Security & Secrets
- Never hardcode secrets or credentials.
- Use environment variables or secure backends like Azure Key Vault, AWS Secrets Manager, or Vault.
- Sensitive outputs should be marked with `sensitive = true`.
 
## Validation & Testing
- Include `terraform validate` and `terraform fmt -check` in CI.
- Use `pre-commit` hooks to enforce formatting and checks before merge.
- Run `terraform plan` with a named workspace in all pipelines.
- All Terraform suggestions must pass `terraform validate` and `terraform fmt -check`
 
## Naming & Tags
- Use consistent resource naming with project, environment, and region prefixes (e.g., `app-dev-uks-vm1`).
- All resources must have tags for `Name`, `Environment`, and `Owner`.
 
## Comments & Docs
- Add comments for complex resources or unusual patterns.
- Include a README in each module with usage examples and input/output documentation.

## Terraform imports and exports
- Use azexport: https://github.com/Azure/aztfexport to export non managed configurations in Azure to Terraform
- 

# Reference
https://thomasthornton.cloud/2025/04/16/why-github-copilot-custom-instructions-matter/

