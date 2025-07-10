module jelo_memecoin::jelo;

use std::string::String;
use sui::coin::{Self, TreasuryCap};
use sui::event;
use sui::table::{Self, Table};
use sui::url::new_unsafe_from_bytes;

// Errors
const EOperatorExists: u64 = 0;
const ETotalSupplyLimitReached: u64 = 1;
const EInsufficientOpSupply: u64 = 2;
const EInsufficientCexOpSupply: u64 = 3;
const EOperatorNotAuthorized: u64 = 4;
const ECannotMintToSelf: u64 = 5;
const EInvalidOPCap: u64 = 6;
const ECapabilityMismatch: u64 = 7;

// Constants
const TOTAL_SUPPLY: u64 = 1_000_000_000_000_000_000; // 1e9 JELO Tokens

const COMMUNITY_SUPPLY: u64 = 700_000_000_000_000_000;
// const INITIAL_SUPPLY: u64 = 100_000_000_000_000_000; // 1e9 JELO Tokens (Initial Community Supply)
const CEX_SUPPLY: u64 = 200_000_000_000_000_000;
const OPERATIONS_SUPPLY: u64 = 100_000_000_000_000_000;

// Events
public struct CoinCreated has copy, drop {
    message: String,
    name: String,
    symbol: String,
}

public struct CommunityMinted has copy, drop {
    message: String,
    recipient: address,
    amount: u64,
}
public struct OpMinted has copy, drop {
    message: String,
    operator: address,
    recipient: address,
    amount: u64,
}
public struct CexOpMinted has copy, drop {
    message: String,
    cex_operator: address,
    recipient: address,
    amount: u64,
}

// Capabilities
public struct AdminCapability has key {
    id: UID,
}

public struct CEXCapability has key, store {
    id: UID,
}

public struct OPCapability has key, store {
    id: UID,
}
// OTW
public struct JELO has drop {}

// Storage

public struct OperatorsRegistry has key, store {
    id: UID,
    is_op: Table<address, bool>,
    op_cap: Table<address, OPCapability>,
    op_total_supply: u64,
    op_minted: u64,
}
public struct CEXRegistry has key, store {
    id: UID,
    is_cex_op: Table<address, bool>,
    cex_op_cap: Table<address, CEXCapability>,
    cex_op_total_supply: u64,
    cex_op_minted: u64,
}

/*
 * @dev Jelo Memecoing
 * @dev 1 JELO = 1e9 units
*/
fun init(one_time_witness: JELO, ctx: &mut TxContext) {
    let admin_cap = AdminCapability { id: object::new(ctx) };
    let (mut treasury, metadata) = coin::create_currency(
        one_time_witness,
        9,
        b"JELO",
        b"JELO",
        b"Meet JELO. The Jelly-Fish Meme Coin",
        option::some(
            new_unsafe_from_bytes(
                b"https://fuchsia-eldest-xerinae-808.mypinata.cloud/ipfs/bafkreih4x37gkvt7c7uzk7rtcdqfq6rxlu2ddvjxmkut7zo53rcqlfi3am",
            ),
        ),
        ctx,
    );
    event::emit(CoinCreated {
        message: b"Coin Created Successfully".to_string(),
        name: metadata.get_name(),
        symbol: metadata.get_symbol().to_string(),
    });

    let op_registry = OperatorsRegistry {
        id: object::new(ctx),
        is_op: table::new(ctx),
        op_total_supply: OPERATIONS_SUPPLY,
        op_cap: table::new(ctx),
        op_minted: 0,
    };

    let cex_op_registry = CEXRegistry {
        id: object::new(ctx),
        is_cex_op: table::new(ctx),
        cex_op_total_supply: CEX_SUPPLY,
        cex_op_cap: table::new(ctx),
        cex_op_minted: 0,
    };
    event::emit(CommunityMinted {
        message: b"Community Mint to Admin Successful".to_string(),
        recipient: ctx.sender(),
        amount: COMMUNITY_SUPPLY,
    });
    mint(&mut treasury, COMMUNITY_SUPPLY, ctx.sender(), ctx);

    transfer::public_freeze_object(metadata);
    transfer::public_transfer(treasury, ctx.sender());
    transfer::transfer(admin_cap, ctx.sender());
    // op_party.transfer!(ctx.sender());
    transfer::transfer(op_registry, ctx.sender());
    transfer::transfer(cex_op_registry, ctx.sender());
}

public fun mint(
    treasury_cap: &mut TreasuryCap<JELO>,
    amount: u64,
    recipient: address,
    ctx: &mut TxContext,
) {
    let coin = coin::mint(treasury_cap, amount, ctx);
    transfer::public_transfer(coin, recipient);
}

// Operations and CEX Operations Minting with their respective limits

public fun op_mint(
    treasury_cap: &mut TreasuryCap<JELO>,
    op_cap: &OPCapability,
    op_registry: &mut OperatorsRegistry,
    cex_op_registry: &CEXRegistry,
    amount: u64,
    recipient: address,
    ctx: &mut TxContext,
) {
    assert!(&op_registry.op_cap[ctx.sender()] == op_cap, ECapabilityMismatch);
    assert!((op_cap.id.to_inner() == object::id_from_address(ctx.sender())), EInvalidOPCap);
    let is_operator = &op_registry.is_op[ctx.sender()];
    assert!(*is_operator, EOperatorNotAuthorized);
    assert!(!(recipient == ctx.sender()), ECannotMintToSelf);
    let totalMinted = COMMUNITY_SUPPLY + op_registry.op_minted + cex_op_registry.cex_op_minted;
    let opRemaining = op_registry.op_total_supply - op_registry.op_minted;
    assert!(totalMinted < TOTAL_SUPPLY, ETotalSupplyLimitReached);
    assert!(opRemaining >= amount, EInsufficientOpSupply);
    op_registry.op_minted = op_registry.op_minted + amount;
    event::emit(OpMinted {
        message: b"Op Minted Successfully".to_string(),
        amount: amount,
        recipient: recipient,
        operator: ctx.sender(),
    });
    let coin = coin::mint(treasury_cap, amount, ctx);
    transfer::public_transfer(coin, recipient);
}

public fun cex_op_mint(
    treasury_cap: &mut TreasuryCap<JELO>,
    cex_cap: &CEXCapability,
    op_registry: &OperatorsRegistry,
    cex_op_registry: &mut CEXRegistry,
    amount: u64,
    recipient: address,
    ctx: &mut TxContext,
) {
    assert!(&cex_op_registry.cex_op_cap[ctx.sender()] == cex_cap, ECapabilityMismatch);
    assert!((cex_cap.id.to_inner() == object::id_from_address(ctx.sender())), EInvalidOPCap);
    let is_operator = &cex_op_registry.is_cex_op[ctx.sender()];
    assert!(*is_operator, EOperatorNotAuthorized);
    assert!(!(recipient == ctx.sender()), ECannotMintToSelf);
    let totalMinted = COMMUNITY_SUPPLY + op_registry.op_minted + cex_op_registry.cex_op_minted;
    let cexOpRemaining = cex_op_registry.cex_op_total_supply - cex_op_registry.cex_op_minted;
    assert!(totalMinted < TOTAL_SUPPLY, ETotalSupplyLimitReached);
    assert!(cexOpRemaining >= amount, EInsufficientCexOpSupply);
    cex_op_registry.cex_op_minted = cex_op_registry.cex_op_minted + amount;
    event::emit(CexOpMinted {
        message: b"Cex Op Minted Successfully".to_string(),
        amount: amount,
        recipient: recipient,
        cex_operator: ctx.sender(),
    });
    let coin = coin::mint(treasury_cap, amount, ctx);
    transfer::public_transfer(coin, recipient);
}

// #### Access Control ####

public fun grant_op_role(
    _admin_cap: &AdminCapability,
    op_registry: &mut OperatorsRegistry,
    operator_address: address,
    ctx: &mut TxContext,
) {
    assert!(!op_registry.is_op.contains(operator_address), EOperatorExists);
    op_registry.is_op.add(operator_address, true);
    op_registry
        .op_cap
        .add(
            operator_address,
            OPCapability {
                id: object::new(ctx),
            },
        );
}

public fun revoke_op_role(
    _admin_cap: &AdminCapability,
    op_registry: &mut OperatorsRegistry,
    operator_address: address,
) {
    assert!(!op_registry.is_op.contains(operator_address), EOperatorExists);
    op_registry.is_op.remove(operator_address);
    if (op_registry.op_cap.contains(operator_address)) {
        let capability = op_registry.op_cap.remove(operator_address);
        let OPCapability { id } = capability;
        object::delete(id);
    }
}

public fun grant_cex_op_role(
    _admin_cap: &AdminCapability,
    cex_op_registry: &mut CEXRegistry,
    ctx: &mut TxContext,
    operator_address: address,
) {
    assert!(!cex_op_registry.is_cex_op.contains(operator_address), EOperatorExists);
    cex_op_registry.is_cex_op.add(operator_address, true);
    cex_op_registry
        .cex_op_cap
        .add(
            operator_address,
            CEXCapability {
                id: object::new(ctx),
            },
        );
}

public fun revoke_cex_op_role(
    _admin_cap: &AdminCapability,
    cex_op_registry: &mut CEXRegistry,
    operator_address: address,
) {
    assert!(!cex_op_registry.is_cex_op.contains(operator_address), EOperatorExists);
    cex_op_registry.is_cex_op.remove(operator_address);

    if (cex_op_registry.cex_op_cap.contains(operator_address)) {
        let capability = cex_op_registry.cex_op_cap.remove(operator_address);
        let CEXCapability { id } = capability;
        object::delete(id);
    }
}
