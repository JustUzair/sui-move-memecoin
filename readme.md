# Memecoin Contract Documentation

Take a look at the memecoin deployed: https://suiscan.xyz/testnet/tx/27x3uzHUDBaAH9vzWD9LcMezrYvNCFHCyYCsecA8Fbu8

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

# Deploying Memecoin

```bash
sui client publish
```

## Output

```bash
Transaction Digest: 27x3uzHUDBaAH9vzWD9LcMezrYvNCFHCyYCsecA8Fbu8
╭──────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
│ Transaction Data                                                                                             │
├──────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ Sender: 0x51e3abddab89e8054627fff5222e04be6f8c66f17a13ddbe280933082a2f836b                                   │
│ Gas Owner: 0x51e3abddab89e8054627fff5222e04be6f8c66f17a13ddbe280933082a2f836b                                │
│ Gas Budget: 45008400 MIST                                                                                    │
│ Gas Price: 1000 MIST                                                                                         │
│ Gas Payment:                                                                                                 │
│  ┌──                                                                                                         │
│  │ ID: 0x73195369699cf1e74f1db856d42f41c9b122e91583a75d17707b0619b615270c                                    │
│  │ Version: 373126724                                                                                        │
│  │ Digest: FL5DdBF1jxQrrZskDGDPBWHXsMkPzS8oDxiPYseT7fav                                                      │
│  └──                                                                                                         │
│                                                                                                              │
│ Transaction Kind: Programmable                                                                               │
│ ╭──────────────────────────────────────────────────────────────────────────────────────────────────────────╮ │
│ │ Input Objects                                                                                            │ │
│ ├──────────────────────────────────────────────────────────────────────────────────────────────────────────┤ │
│ │ 0   Pure Arg: Type: address, Value: "0x51e3abddab89e8054627fff5222e04be6f8c66f17a13ddbe280933082a2f836b" │ │
│ ╰──────────────────────────────────────────────────────────────────────────────────────────────────────────╯ │
│ ╭─────────────────────────────────────────────────────────────────────────╮                                  │
│ │ Commands                                                                │                                  │
│ ├─────────────────────────────────────────────────────────────────────────┤                                  │
│ │ 0  Publish:                                                             │                                  │
│ │  ┌                                                                      │                                  │
│ │  │ Dependencies:                                                        │                                  │
│ │  │   0x0000000000000000000000000000000000000000000000000000000000000001 │                                  │
│ │  │   0x0000000000000000000000000000000000000000000000000000000000000002 │                                  │
│ │  └                                                                      │                                  │
│ │                                                                         │                                  │
│ │ 1  TransferObjects:                                                     │                                  │
│ │  ┌                                                                      │                                  │
│ │  │ Arguments:                                                           │                                  │
│ │  │   Result 0                                                           │                                  │
│ │  │ Address: Input  0                                                    │                                  │
│ │  └                                                                      │                                  │
│ ╰─────────────────────────────────────────────────────────────────────────╯                                  │
│                                                                                                              │
│ Signatures:                                                                                                  │
│    FEOC9+LR84FQcd+I0bV7nkc8xg6V+6wmr9eejEhB+b0/bgpnl6cypjtE38q1T24qabd8T+oFaVURPKpk7RiYCQ==                  │
│                                                                                                              │
╰──────────────────────────────────────────────────────────────────────────────────────────────────────────────╯
╭───────────────────────────────────────────────────────────────────────────────────────────────────╮
│ Transaction Effects                                                                               │
├───────────────────────────────────────────────────────────────────────────────────────────────────┤
│ Digest: 27x3uzHUDBaAH9vzWD9LcMezrYvNCFHCyYCsecA8Fbu8                                              │
│ Status: Success                                                                                   │
│ Executed Epoch: 791                                                                               │
│                                                                                                   │
│ Created Objects:                                                                                  │
│  ┌──                                                                                              │
│  │ ID: 0x1c14e8bb49b54bf8f5d23479856c656cc1d2b7a8ce97de6a984b036f64ca4940                         │
│  │ Owner: Account Address ( 0x51e3abddab89e8054627fff5222e04be6f8c66f17a13ddbe280933082a2f836b )  │
│  │ Version: 373126725                                                                             │
│  │ Digest: 53sDyn43NrMw2J3knY2eszX7Q2xrMtYPaP43jmY1gMqD                                           │
│  └──                                                                                              │
│  ┌──                                                                                              │
│  │ ID: 0x30790ae78ee6c9d3e5abf2f0ff5334b2cadd42c588b0b599576442692640496e                         │
│  │ Owner: Account Address ( 0x51e3abddab89e8054627fff5222e04be6f8c66f17a13ddbe280933082a2f836b )  │
│  │ Version: 373126725                                                                             │
│  │ Digest: 3kN7SMg2SiUST4jtmpQF2hRTAwCBXd1CwNr4jDoeqSun                                           │
│  └──                                                                                              │
│  ┌──                                                                                              │
│  │ ID: 0x34bf11f6465cded41c134d8f1a252644b7fa2d52ba1295d98b1495ac8fca912f                         │
│  │ Owner: Account Address ( 0x51e3abddab89e8054627fff5222e04be6f8c66f17a13ddbe280933082a2f836b )  │
│  │ Version: 373126725                                                                             │
│  │ Digest: 2C3RSN1uvpXnCGyN7nRfkqUeoAJQL3iHwjhSsrDQnAUW                                           │
│  └──                                                                                              │
│  ┌──                                                                                              │
│  │ ID: 0x8a59addd17ea366d380eaf91511b3812ddae6777117ec3b9d5691bfbd268a63a                         │
│  │ Owner: Account Address ( 0x51e3abddab89e8054627fff5222e04be6f8c66f17a13ddbe280933082a2f836b )  │
│  │ Version: 373126725                                                                             │
│  │ Digest: 56D1RiqDfhBVwTE8rLcN5tXC4zzTnCPqH2G5PCEkDRNR                                           │
│  └──                                                                                              │
│  ┌──                                                                                              │
│  │ ID: 0x8be66e68566724920a9415bd8886f9db3f04ecc98d155920d5803a83b916d0b1                         │
│  │ Owner: Immutable                                                                               │
│  │ Version: 1                                                                                     │
│  │ Digest: GZ6kbwNGsmLQ1UzA7VHyBxGDnHSfxnCoqrtKWjWrCo6T                                           │
│  └──                                                                                              │
│  ┌──                                                                                              │
│  │ ID: 0xcd4842d1026b17a460150b98566092f33bc18c0177e45c62432e5aa9305924bd                         │
│  │ Owner: Immutable                                                                               │
│  │ Version: 373126725                                                                             │
│  │ Digest: ErfpxaoPm3Zz9qTghrDCpTRRnUrYAXUwThmZoGzfYSnk                                           │
│  └──                                                                                              │
│  ┌──                                                                                              │
│  │ ID: 0xd4c2e13e06a32265368acda12d1f5ab423b3397ec291c86dd4db70bc55d52324                         │
│  │ Owner: Account Address ( 0x51e3abddab89e8054627fff5222e04be6f8c66f17a13ddbe280933082a2f836b )  │
│  │ Version: 373126725                                                                             │
│  │ Digest: EBJaMx9ArR9KLmoLf2wuawE8Gd9ofbr8Pi4vyA7WBBRf                                           │
│  └──                                                                                              │
│  ┌──                                                                                              │
│  │ ID: 0xfee81977b843ae3ba302ec696a47dc56d924cc551b7881fdb607a2906a9b966e                         │
│  │ Owner: Account Address ( 0x51e3abddab89e8054627fff5222e04be6f8c66f17a13ddbe280933082a2f836b )  │
│  │ Version: 373126725                                                                             │
│  │ Digest: EADXyqij1Qa9ejrpdPxHtNiVdrLS5zfB6WzgQGRrw92N                                           │
│  └──                                                                                              │
│ Mutated Objects:                                                                                  │
│  ┌──                                                                                              │
│  │ ID: 0x73195369699cf1e74f1db856d42f41c9b122e91583a75d17707b0619b615270c                         │
│  │ Owner: Account Address ( 0x51e3abddab89e8054627fff5222e04be6f8c66f17a13ddbe280933082a2f836b )  │
│  │ Version: 373126725                                                                             │
│  │ Digest: DkuRTB4pXKhwmed8bNSH35MfQHs9mH9HFTbhqynnmPrY                                           │
│  └──                                                                                              │
│ Gas Object:                                                                                       │
│  ┌──                                                                                              │
│  │ ID: 0x73195369699cf1e74f1db856d42f41c9b122e91583a75d17707b0619b615270c                         │
│  │ Owner: Account Address ( 0x51e3abddab89e8054627fff5222e04be6f8c66f17a13ddbe280933082a2f836b )  │
│  │ Version: 373126725                                                                             │
│  │ Digest: DkuRTB4pXKhwmed8bNSH35MfQHs9mH9HFTbhqynnmPrY                                           │
│  └──                                                                                              │
│ Gas Cost Summary:                                                                                 │
│    Storage Cost: 43008400 MIST                                                                    │
│    Computation Cost: 1000000 MIST                                                                 │
│    Storage Rebate: 978120 MIST                                                                    │
│    Non-refundable Storage Fee: 9880 MIST                                                          │
│                                                                                                   │
│ Transaction Dependencies:                                                                         │
│    2uvg3HheUT45CWZRSRfdcHxA6ewqeWpxCVPZUdJLuD66                                                   │
│    6pZ2bpkwLwnCH4qdHS1NcJypXLFUNvSHRKfKXhZvXQuo                                                   │
│    HXKCeARRb9t54UF9eZnfyxHzvYnKxwrQ53juihuuDaGk                                                   │
╰───────────────────────────────────────────────────────────────────────────────────────────────────╯
╭─────────────────────────────────────────────────────────────────────────────────────────────────────────╮
│ Transaction Block Events                                                                                │
├─────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│  ┌──                                                                                                    │
│  │ EventID: 27x3uzHUDBaAH9vzWD9LcMezrYvNCFHCyYCsecA8Fbu8:0                                              │
│  │ PackageID: 0x8be66e68566724920a9415bd8886f9db3f04ecc98d155920d5803a83b916d0b1                        │
│  │ Transaction Module: jelo                                                                             │
│  │ Sender: 0x51e3abddab89e8054627fff5222e04be6f8c66f17a13ddbe280933082a2f836b                           │
│  │ EventType: 0x8be66e68566724920a9415bd8886f9db3f04ecc98d155920d5803a83b916d0b1::jelo::CoinCreated     │
│  │ ParsedJSON:                                                                                          │
│  │   ┌─────────┬───────────────────────────┐                                                            │
│  │   │ message │ Coin Created Successfully │                                                            │
│  │   ├─────────┼───────────────────────────┤                                                            │
│  │   │ name    │ JELO                      │                                                            │
│  │   ├─────────┼───────────────────────────┤                                                            │
│  │   │ symbol  │ JELO                      │                                                            │
│  │   └─────────┴───────────────────────────┘                                                            │
│  └──                                                                                                    │
│  ┌──                                                                                                    │
│  │ EventID: 27x3uzHUDBaAH9vzWD9LcMezrYvNCFHCyYCsecA8Fbu8:1                                              │
│  │ PackageID: 0x8be66e68566724920a9415bd8886f9db3f04ecc98d155920d5803a83b916d0b1                        │
│  │ Transaction Module: jelo                                                                             │
│  │ Sender: 0x51e3abddab89e8054627fff5222e04be6f8c66f17a13ddbe280933082a2f836b                           │
│  │ EventType: 0x8be66e68566724920a9415bd8886f9db3f04ecc98d155920d5803a83b916d0b1::jelo::CommunityMinted │
│  │ ParsedJSON:                                                                                          │
│  │   ┌───────────┬────────────────────────────────────────────────────────────────────┐                 │
│  │   │ amount    │ 700000000000000000                                                 │                 │
│  │   ├───────────┼────────────────────────────────────────────────────────────────────┤                 │
│  │   │ message   │ Community Mint to Admin Successful                                 │                 │
│  │   ├───────────┼────────────────────────────────────────────────────────────────────┤                 │
│  │   │ recipient │ 0x51e3abddab89e8054627fff5222e04be6f8c66f17a13ddbe280933082a2f836b │                 │
│  │   └───────────┴────────────────────────────────────────────────────────────────────┘                 │
│  └──                                                                                                    │
╰─────────────────────────────────────────────────────────────────────────────────────────────────────────╯
╭─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
│ Object Changes                                                                                                          │
├─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ Created Objects:                                                                                                        │
│  ┌──                                                                                                                    │
│  │ ObjectID: 0x1c14e8bb49b54bf8f5d23479856c656cc1d2b7a8ce97de6a984b036f64ca4940                                         │
│  │ Sender: 0x51e3abddab89e8054627fff5222e04be6f8c66f17a13ddbe280933082a2f836b                                           │
│  │ Owner: Account Address ( 0x51e3abddab89e8054627fff5222e04be6f8c66f17a13ddbe280933082a2f836b )                        │
│  │ ObjectType: 0x2::coin::TreasuryCap<0x8be66e68566724920a9415bd8886f9db3f04ecc98d155920d5803a83b916d0b1::jelo::JELO>   │
│  │ Version: 373126725                                                                                                   │
│  │ Digest: 53sDyn43NrMw2J3knY2eszX7Q2xrMtYPaP43jmY1gMqD                                                                 │
│  └──                                                                                                                    │
│  ┌──                                                                                                                    │
│  │ ObjectID: 0x30790ae78ee6c9d3e5abf2f0ff5334b2cadd42c588b0b599576442692640496e                                         │
│  │ Sender: 0x51e3abddab89e8054627fff5222e04be6f8c66f17a13ddbe280933082a2f836b                                           │
│  │ Owner: Account Address ( 0x51e3abddab89e8054627fff5222e04be6f8c66f17a13ddbe280933082a2f836b )                        │
│  │ ObjectType: 0x2::package::UpgradeCap                                                                                 │
│  │ Version: 373126725                                                                                                   │
│  │ Digest: 3kN7SMg2SiUST4jtmpQF2hRTAwCBXd1CwNr4jDoeqSun                                                                 │
│  └──                                                                                                                    │
│  ┌──                                                                                                                    │
│  │ ObjectID: 0x34bf11f6465cded41c134d8f1a252644b7fa2d52ba1295d98b1495ac8fca912f                                         │
│  │ Sender: 0x51e3abddab89e8054627fff5222e04be6f8c66f17a13ddbe280933082a2f836b                                           │
│  │ Owner: Account Address ( 0x51e3abddab89e8054627fff5222e04be6f8c66f17a13ddbe280933082a2f836b )                        │
│  │ ObjectType: 0x8be66e68566724920a9415bd8886f9db3f04ecc98d155920d5803a83b916d0b1::jelo::OperatorsRegistry              │
│  │ Version: 373126725                                                                                                   │
│  │ Digest: 2C3RSN1uvpXnCGyN7nRfkqUeoAJQL3iHwjhSsrDQnAUW                                                                 │
│  └──                                                                                                                    │
│  ┌──                                                                                                                    │
│  │ ObjectID: 0x8a59addd17ea366d380eaf91511b3812ddae6777117ec3b9d5691bfbd268a63a                                         │
│  │ Sender: 0x51e3abddab89e8054627fff5222e04be6f8c66f17a13ddbe280933082a2f836b                                           │
│  │ Owner: Account Address ( 0x51e3abddab89e8054627fff5222e04be6f8c66f17a13ddbe280933082a2f836b )                        │
│  │ ObjectType: 0x8be66e68566724920a9415bd8886f9db3f04ecc98d155920d5803a83b916d0b1::jelo::CEXRegistry                    │
│  │ Version: 373126725                                                                                                   │
│  │ Digest: 56D1RiqDfhBVwTE8rLcN5tXC4zzTnCPqH2G5PCEkDRNR                                                                 │
│  └──                                                                                                                    │
│  ┌──                                                                                                                    │
│  │ ObjectID: 0xcd4842d1026b17a460150b98566092f33bc18c0177e45c62432e5aa9305924bd                                         │
│  │ Sender: 0x51e3abddab89e8054627fff5222e04be6f8c66f17a13ddbe280933082a2f836b                                           │
│  │ Owner: Immutable                                                                                                     │
│  │ ObjectType: 0x2::coin::CoinMetadata<0x8be66e68566724920a9415bd8886f9db3f04ecc98d155920d5803a83b916d0b1::jelo::JELO>  │
│  │ Version: 373126725                                                                                                   │
│  │ Digest: ErfpxaoPm3Zz9qTghrDCpTRRnUrYAXUwThmZoGzfYSnk                                                                 │
│  └──                                                                                                                    │
│  ┌──                                                                                                                    │
│  │ ObjectID: 0xd4c2e13e06a32265368acda12d1f5ab423b3397ec291c86dd4db70bc55d52324                                         │
│  │ Sender: 0x51e3abddab89e8054627fff5222e04be6f8c66f17a13ddbe280933082a2f836b                                           │
│  │ Owner: Account Address ( 0x51e3abddab89e8054627fff5222e04be6f8c66f17a13ddbe280933082a2f836b )                        │
│  │ ObjectType: 0x2::coin::Coin<0x8be66e68566724920a9415bd8886f9db3f04ecc98d155920d5803a83b916d0b1::jelo::JELO>          │
│  │ Version: 373126725                                                                                                   │
│  │ Digest: EBJaMx9ArR9KLmoLf2wuawE8Gd9ofbr8Pi4vyA7WBBRf                                                                 │
│  └──                                                                                                                    │
│  ┌──                                                                                                                    │
│  │ ObjectID: 0xfee81977b843ae3ba302ec696a47dc56d924cc551b7881fdb607a2906a9b966e                                         │
│  │ Sender: 0x51e3abddab89e8054627fff5222e04be6f8c66f17a13ddbe280933082a2f836b                                           │
│  │ Owner: Account Address ( 0x51e3abddab89e8054627fff5222e04be6f8c66f17a13ddbe280933082a2f836b )                        │
│  │ ObjectType: 0x8be66e68566724920a9415bd8886f9db3f04ecc98d155920d5803a83b916d0b1::jelo::AdminCapability                │
│  │ Version: 373126725                                                                                                   │
│  │ Digest: EADXyqij1Qa9ejrpdPxHtNiVdrLS5zfB6WzgQGRrw92N                                                                 │
│  └──                                                                                                                    │
│ Mutated Objects:                                                                                                        │
│  ┌──                                                                                                                    │
│  │ ObjectID: 0x73195369699cf1e74f1db856d42f41c9b122e91583a75d17707b0619b615270c                                         │
│  │ Sender: 0x51e3abddab89e8054627fff5222e04be6f8c66f17a13ddbe280933082a2f836b                                           │
│  │ Owner: Account Address ( 0x51e3abddab89e8054627fff5222e04be6f8c66f17a13ddbe280933082a2f836b )                        │
│  │ ObjectType: 0x2::coin::Coin<0x2::sui::SUI>                                                                           │
│  │ Version: 373126725                                                                                                   │
│  │ Digest: DkuRTB4pXKhwmed8bNSH35MfQHs9mH9HFTbhqynnmPrY                                                                 │
│  └──                                                                                                                    │
│ Published Objects:                                                                                                      │
│  ┌──                                                                                                                    │
│  │ PackageID: 0x8be66e68566724920a9415bd8886f9db3f04ecc98d155920d5803a83b916d0b1                                        │
│  │ Version: 1                                                                                                           │
│  │ Digest: GZ6kbwNGsmLQ1UzA7VHyBxGDnHSfxnCoqrtKWjWrCo6T                                                                 │
│  │ Modules: jelo                                                                                                        │
│  └──                                                                                                                    │
╰─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯
╭───────────────────────────────────────────────────────────────────────────────────────────────────╮
│ Balance Changes                                                                                   │
├───────────────────────────────────────────────────────────────────────────────────────────────────┤
│  ┌──                                                                                              │
│  │ Owner: Account Address ( 0x51e3abddab89e8054627fff5222e04be6f8c66f17a13ddbe280933082a2f836b )  │
│  │ CoinType: 0x2::sui::SUI                                                                        │
│  │ Amount: -43030280                                                                              │
│  └──                                                                                              │
│  ┌──                                                                                              │
│  │ Owner: Account Address ( 0x51e3abddab89e8054627fff5222e04be6f8c66f17a13ddbe280933082a2f836b )  │
│  │ CoinType: 0x8be66e68566724920a9415bd8886f9db3f04ecc98d155920d5803a83b916d0b1::jelo::JELO       │
│  │ Amount: 700000000000000000                                                                     │
│  └──                                                                                              │
╰───────────────────────────────────────────────────────────────────────────────────────────────────╯
```
