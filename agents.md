########################################

# Agent Instructions for Terraform Repository

This document defines the **mandatory rules** for the AI agent operating in this Terraform repository.

The agent supports Terraform code generation and modification, plan diff reviews, and infrastructure design discussions.  
**Safety, clarity, and reproducibility are the highest priorities.**

---

## 0. Absolute Rules

### Do Not Proceed on Ambiguity

If requirements, assumptions, or design decisions are unclear, **the agent must stop and ask clarifying questions before proceeding**.

The following are strictly prohibited:

- Implementations based on assumptions or guesses
- Decisions based on implicit or unstated premises
- Design decisions based only on general best practices
- Autonomous implementations justified as “common patterns”

This rule applies to **code generation, plan diff reviews, and design consultations**.

---

## Language Requirement for Chat Responses

**Always respond in Japanese when answering in chat.**

---

## 1. Agent Role and Scope

### Allowed Responsibilities

The agent may:

- Create and modify Terraform code
- Propose module decomposition and variables / locals design
- Review and explain `terraform plan` diffs
- Provide design guidance for Azure / Terraform configurations
- Assist with documentation such as README.md and agents.md

### Prohibited Actions

The agent must not:

- Assume Apply or Destroy without explicit instruction
- Introduce changes that include unclear resource deletion or recreation
- Propose solutions that rely on manual Azure Portal operations
- Modify security or network settings based on assumptions

---

## 2. Terraform Operational Principles

### 2.1 Execution Model

- Terraform follows a **Plan -> Apply** workflow
- Plans must always be generated with `-out`
- `tfvars` and state must be separated per environment
- Direct editing of state files is strictly forbidden

### 2.2 Code Quality

- Keep diffs minimal
- Respect the intent and structure of existing code
- Consider modularization when reuse is expected
- Avoid magic numbers and hardcoding; consolidate into variables or locals

---

## 3. Naming and Structure Rules

- Azure resource names must strictly follow the naming rules defined in **README.md**
- Naming elements such as workload / env / region / instance must be managed via variables or locals
- Pay special attention to resources with strict naming constraints (e.g., Storage Accounts)
- Private DNS Zones must use the **official DNS names**, not abbreviations

---

## 4. Network and Security Constraints

### Explicit Confirmation Required

The following items **must be confirmed explicitly before implementation or modification**:

- VNet / Subnet CIDR ranges
- Subnet used for Private Endpoints
- Whether fixed private IP addresses are required
- Public Network Access (enabled or disabled)
- Firewall and IP restriction policies
- DNS resolution paths (Private DNS / Public DNS)

**Defaults or assumptions must never be used.**

---

## 5. Azure Resource-Specific Notes

### App Service

- Consider DNS behavior when using Private Endpoints
- Explicit confirmation is required when assuming `privatelink.azurewebsites.net`

### Storage Account

- Public access must be explicitly confirmed
- If usage of Blob / Queue / File is unclear, ask before proceeding

### PostgreSQL

- Flexible Server vs Single Server must be explicitly confirmed
- Do not implement until the connection model (Private Endpoint vs VNet Integration) is clearly defined

---

## 6. Plan Diff and Destructive Changes

### Mandatory Confirmation Before Proceeding

If a plan diff includes any of the following, **the agent must stop and provide impact analysis and confirmation**:

- Resource deletion (destroy)
- Resource recreation (replace)
- Resource name or address changes
- Changes to Subnets, Private Endpoints, or DNS Zones
- Recreation of persistent data resources such as DBs or Storage

Explanations must include:

- Scope of impact
- Reason the diff occurs
- Mitigation strategies or alternatives

---

## 7. Output Guidelines

- Terraform code must be presented **per file**
- Clearly explain what changes and why
- Separate decision-required items as **“Needs Confirmation”**

---

## 8. Handling Uncertainty

When information is missing:

1. Stop all work
2. List missing information
3. Ask clear and specific questions
4. Resume only after answers are provided

This process applies equally to design discussions, code generation, and plan diff reviews.

---

## 9. Repository Context

- This repository is currently used for a **PoC environment**
- Production (prd) constraints may be added in the future
- Do not assume automatic agent execution within CI/CD pipelines

---

## 10. Priority of This Document

- This `agents.md` defines the **highest-priority behavioral constraints** for the agent
- It takes precedence over README.md and code comments
- If conflicting instructions are given, the agent must point them out and request clarification

---

### Design Philosophy

Top priorities for this repository:

1. Safe experimentation
2. Predictable changes
3. No unintended breakage

**Clarity and confirmation take precedence over speed.**

---

## Change Policy

Changes to this `agents.md` must be made **explicitly**.  
Implicit rule relaxation or silent changes are strictly prohibited.
