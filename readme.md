# Memecoin Contract Documentation

## Overview

This Memecoin is a Sui-based token implementation with controlled minting capabilities and multi-tiered access control. This contract manages token creation, distribution, and operator permissions while enforcing strict supply limits.

## Key Features

### Supply Management

- **Total Supply**: 1,000,000,000,000,000,000 (1e9) tokens
- **Allocations**:
  - Community Supply: 700,000,000,000,000,000 (70%)
  - CEX Supply: 200,000,000,000,000,000 (20%)
  - Operations Supply: 100,000,000,000,000,000 (10%)

### Access Control System

- **Admin Capability**: Root-level control over operator management
- **Operator Types**:
  - Standard Operators (OP): Can mint from operations supply
  - CEX Operators: Can mint from exchange allocation
- **Capability-Based Auth**: Requires both registry entry and capability object

## Security Architecture

### Minting Controls

- Role-specific supply limits enforced
- Anti-self-minting protection
- Dual authentication (capability + registry check)
- Supply overflow protection

### Registry Management

- Operator status tracked in Tables
- Capabilities automatically created/destroyed with roles
- Admin-only role modification functions

## Technical Implementation

### Core Structures

- `OperatorsRegistry`: Tracks standard operators and their allocations
- `CEXRegistry`: Manages exchange operators and their limits
- `TreasuryCap`: Controls token minting authority

### Critical Functions

- `op_mint()`: Operator-controlled minting with supply checks
- `cex_op_mint()`: Exchange-specific minting function
- `grant/revoke_role()`: Admin-only operator management

## Deployment Strategy

1. Initial minting of community supply to deployer
2. Gradual operator onboarding via admin functions
3. Controlled distribution through operator minting

## Usage Patterns

Operators should:

1. Receive capability object when granted role
2. Use capability for authorized minting
3. Never transfer capabilities to unauthorized parties

Admins should:

1. Securely store AdminCapability
2. Carefully verify operator addresses
3. Monitor supply allocations

This implementation demonstrates secure token distribution patterns suitable for projects requiring controlled, multi-party minting authority.
