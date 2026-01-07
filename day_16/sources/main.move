///
/// this code was written by a human :)
///
module challenge::day_16;

// === Constants ===

const MAX_PLOTS: u64 = 20;
const E_PLOT_NOT_FOUND: u64 = 1;
const E_PLOT_LIMIT_EXCEEDED: u64 = 2;
const E_INVALID_PLOT_ID: u64 = 3;
const E_PLOT_ALREADY_EXISTS: u64 = 4;

// === Structs ===

public struct FarmCounters has copy, drop, store
{
    planted: u64,
    harvested: u64,
    plots: vector<u8>
}

public struct Farm has key
{
    id: UID,
    counters: FarmCounters
}

// === Functions ===

fun new_counters(): FarmCounters
{
    FarmCounters
    {
        planted: 0,
        harvested: 0,
        plots: vector::empty()
    }
}

fun new_farm(ctx: &mut TxContext): Farm
{
    Farm
    {
        id: object::new(ctx),
        counters: new_counters()
    }
}

public fun plant(counters: &mut FarmCounters, plotId: u8)
{
    assert!(plotId > 0 && (plotId as u64) <= MAX_PLOTS, E_INVALID_PLOT_ID);
    assert!(vector::length(&counters.plots) < MAX_PLOTS, E_PLOT_LIMIT_EXCEEDED);
    assert!(!vector::contains(&counters.plots, &plotId), E_PLOT_ALREADY_EXISTS);

    vector::push_back(&mut counters.plots, plotId);
    counters.planted = counters.planted + 1;
}

public fun harvest(counters: &mut FarmCounters, plotId: u8)
{
    let (found, index) = vector::index_of(&counters.plots, &plotId);
    assert!(found, E_PLOT_NOT_FOUND);

    vector::remove(&mut counters.plots, index);
    counters.harvested = counters.harvested + 1;
}