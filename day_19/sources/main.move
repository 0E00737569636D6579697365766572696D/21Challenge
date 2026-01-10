///
/// this code was written by a human :)
///
module challenge::day_19;

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

// === Internal Helpers ===

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

fun plant(counters: &mut FarmCounters, plotId: u8)
{
    assert!(plotId > 0 && (plotId as u64) <= MAX_PLOTS, E_INVALID_PLOT_ID);
    assert!(vector::length(&counters.plots) < MAX_PLOTS, E_PLOT_LIMIT_EXCEEDED);
    assert!(!vector::contains(&counters.plots, &plotId), E_PLOT_ALREADY_EXISTS);

    vector::push_back(&mut counters.plots, plotId);
    counters.planted = counters.planted + 1;
}

fun harvest(counters: &mut FarmCounters, plotId: u8)
{
    let (found, index) = vector::index_of(&counters.plots, &plotId);
    assert!(found, E_PLOT_NOT_FOUND);

    vector::remove(&mut counters.plots, index);
    counters.harvested = counters.harvested + 1;
}

// === View Functions ===

fun total_planted(farm: &Farm): u64
{
    farm.counters.planted
}

fun total_harvested(farm: &Farm): u64
{
    farm.counters.harvested
}

// === Wrapper Functions ===

fun plant_on_farm(farm: &mut Farm, plotId: u8)
{
    plant(&mut farm.counters, plotId);
}

fun harvest_from_farm(farm: &mut Farm, plotId: u8)
{
    harvest(&mut farm.counters, plotId);
}

// === Entry Functions ===

entry fun create_farm(ctx: &mut TxContext)
{
    let farm = new_farm(ctx);
    transfer::share_object(farm); 
}

entry fun plant_on_farm_entry(farm: &mut Farm, plotId: u8)
{
    plant_on_farm(farm, plotId);
}

entry fun harvest_from_farm_entry(farm: &mut Farm, plotId: u8)
{
    harvest_from_farm(farm, plotId);
}

// testler

#[test_only]
use sui::test_scenario;
#[test_only]
const ADMIN: address = @0xA;
#[test_only]
const USER: address = @0xB;

#[test]
fun test_view_functions_logic()
{
    let mut scenario = test_scenario::begin(ADMIN);

    // farm olustur
    {
        let ctx = test_scenario::ctx(&mut scenario);
        create_farm(ctx);
    };

    test_scenario::next_tx(&mut scenario, USER);

    // ek
    {
        let mut farm = test_scenario::take_shared<Farm>(&scenario);
        plant_on_farm_entry(&mut farm, 1);
        plant_on_farm_entry(&mut farm, 2);
        plant_on_farm_entry(&mut farm, 3);
        assert!(total_planted(&farm) == 3, 0);
        assert!(total_harvested(&farm) == 0, 1);
        test_scenario::return_shared(farm);
    };

    test_scenario::next_tx(&mut scenario, USER);

    // hasat et
    {
        let mut farm = test_scenario::take_shared<Farm>(&scenario);
        harvest_from_farm_entry(&mut farm, 1);
        harvest_from_farm_entry(&mut farm, 2);
        assert!(total_harvested(&farm) == 2, 2);
        assert!(total_planted(&farm) == 3, 3);
        test_scenario::return_shared(farm);
    };

    test_scenario::end(scenario);
}

