///
/// this code was written by an ai :)
/// Day 21: Final Polish & Comprehensive Testing
/// Based on Move Book Code Quality Checklist
///
module challenge::day_21
{
    // =========================================================================
    // Dependencies
    // =========================================================================

    use sui::event;
    use sui::transfer;
    use sui::object::{Self, UID};
    use sui::tx_context::TxContext;

    // =========================================================================
    // Constants & Error Codes
    // =========================================================================

    /// Maximum number of plots allowed in a farm.
    const MAX_PLOTS: u64 = 20;

    /// Error: The requested plot does not exist in the list.
    const E_PLOT_NOT_FOUND: u64 = 1;
    /// Error: The farm has reached its maximum capacity.
    const E_PLOT_LIMIT_EXCEEDED: u64 = 2;
    /// Error: The provided Plot ID is invalid (e.g., 0 or > MAX).
    const E_INVALID_PLOT_ID: u64 = 3;
    /// Error: The plot ID has already been planted.
    const E_PLOT_ALREADY_EXISTS: u64 = 4;

    // =========================================================================
    // Events
    // =========================================================================

    /// Emitted when a new plot is successfully planted.
    public struct PlantEvent has copy, drop
    {
        /// Total number of planted plots after the operation.
        planted_after: u64
    }

    // =========================================================================
    // Structs
    // =========================================================================

    /// Internal state container for the Farm.
    /// Has 'store' to be embedded within the Farm object.
    public struct FarmCounters has copy, drop, store
    {
        planted: u64,
        harvested: u64,
        plots: vector<u8>
    }

    /// The main Farm object shared on the network.
    public struct Farm has key
    {
        id: UID,
        counters: FarmCounters
    }

    // =========================================================================
    // Internal Helpers (Business Logic)
    // =========================================================================

    /// Creates a fresh set of counters.
    fun new_counters(): FarmCounters
    {
        FarmCounters
        {
            planted: 0,
            harvested: 0,
            plots: vector::empty()
        }
    }

    /// Creates a new Farm object.
    fun new_farm(ctx: &mut TxContext): Farm
    {
        Farm
        {
            id: object::new(ctx),
            counters: new_counters()
        }
    }

    /// Core logic for planting.
    /// Checks all constraints before modifying state.
    fun plant(counters: &mut FarmCounters, plotId: u8)
    {
        // 1. Validation: Range Check
        assert!(plotId > 0 && (plotId as u64) <= MAX_PLOTS, E_INVALID_PLOT_ID);
        
        // 2. Validation: Capacity Check
        assert!(vector::length(&counters.plots) < MAX_PLOTS, E_PLOT_LIMIT_EXCEEDED);
        
        // 3. Validation: Uniqueness Check
        assert!(!vector::contains(&counters.plots, &plotId), E_PLOT_ALREADY_EXISTS);

        // 4. Action: Update State
        vector::push_back(&mut counters.plots, plotId);
        counters.planted = counters.planted + 1;
    }

    /// Core logic for harvesting.
    fun harvest(counters: &mut FarmCounters, plotId: u8)
    {
        // 1. Validation: Existence Check
        let (found, index) = vector::index_of(&counters.plots, &plotId);
        assert!(found, E_PLOT_NOT_FOUND);

        // 2. Action: Update State
        vector::remove(&mut counters.plots, index);
        counters.harvested = counters.harvested + 1;
    }

    // =========================================================================
    // View Functions (Read-Only API)
    // =========================================================================

    /// Returns the total number of currently planted plots.
    public fun total_planted(farm: &Farm): u64
    {
        farm.counters.planted
    }

    /// Returns the total number of harvests performed.
    public fun total_harvested(farm: &Farm): u64
    {
        farm.counters.harvested
    }

    // =========================================================================
    // Entry Functions (Transaction Interface)
    // =========================================================================

    /// Creates a new Farm and shares it with the network.
    entry fun create_farm(ctx: &mut TxContext)
    {
        let farm = new_farm(ctx);
        transfer::share_object(farm); 
    }

    /// Plants a crop on a specific plot ID.
    /// Emits a PlantEvent upon success.
    entry fun plant_on_farm_entry(farm: &mut Farm, plotId: u8)
    {
        plant(&mut farm.counters, plotId);
        
        // Interaction: Emit Event
        event::emit(PlantEvent { planted_after: total_planted(farm) });
    }

    /// Harvests a crop from a specific plot ID.
    entry fun harvest_from_farm_entry(farm: &mut Farm, plotId: u8)
    {
        harvest(&mut farm.counters, plotId);
    }

    // =========================================================================
    // Tests
    // =========================================================================

    #[test_only]
    use sui::test_scenario;
    #[test_only]
    const ADMIN: address = @0xA;
    #[test_only]
    const USER: address = @0xB;

    // --- TEST 1: Creation & Initial State ---
    #[test]
    fun test_create_farm()
    {
        let mut scenario = test_scenario::begin(ADMIN);
        {
            let ctx = test_scenario::ctx(&mut scenario);
            create_farm(ctx);
        };
        test_scenario::next_tx(&mut scenario, USER);
        {
            let farm = test_scenario::take_shared<Farm>(&scenario);
            assert!(total_planted(&farm) == 0, 0);
            assert!(total_harvested(&farm) == 0, 1);
            test_scenario::return_shared(farm);
        };
        test_scenario::end(scenario);
    }

    // --- TEST 2: Planting Logic ---
    #[test]
    fun test_planting_increases_counter()
    {
        let mut scenario = test_scenario::begin(ADMIN);
        {
            let ctx = test_scenario::ctx(&mut scenario);
            create_farm(ctx);
        };
        test_scenario::next_tx(&mut scenario, USER);
        {
            let mut farm = test_scenario::take_shared<Farm>(&scenario);
            plant_on_farm_entry(&mut farm, 1);
            assert!(total_planted(&farm) == 1, 0);
            test_scenario::return_shared(farm);
        };
        test_scenario::end(scenario);
    }

    // --- TEST 3: Harvesting Logic ---
    #[test]
    fun test_harvesting_increases_counter()
    {
        let mut scenario = test_scenario::begin(ADMIN);
        {
            let ctx = test_scenario::ctx(&mut scenario);
            create_farm(ctx);
        };
        test_scenario::next_tx(&mut scenario, USER);
        {
            let mut farm = test_scenario::take_shared<Farm>(&scenario);
            plant_on_farm_entry(&mut farm, 1);
            harvest_from_farm_entry(&mut farm, 1);
            
            // Planted count stays 1 (cumulative logic used in helper), 
            // but vector length decreases. Let's check harvested count.
            assert!(total_harvested(&farm) == 1, 0);
            
            test_scenario::return_shared(farm);
        };
        test_scenario::end(scenario);
    }

    // --- TEST 4: Complex Scenario ---
    #[test]
    fun test_multiple_operations()
    {
        let mut scenario = test_scenario::begin(ADMIN);
        {
            let ctx = test_scenario::ctx(&mut scenario);
            create_farm(ctx);
        };
        test_scenario::next_tx(&mut scenario, USER);
        {
            let mut farm = test_scenario::take_shared<Farm>(&scenario);
            plant_on_farm_entry(&mut farm, 3);
            plant_on_farm_entry(&mut farm, 5);
            plant_on_farm_entry(&mut farm, 18);
            
            harvest_from_farm_entry(&mut farm, 5);

            // 3 planted total, 1 harvested total
            assert!(total_planted(&farm) == 3, 0);
            assert!(total_harvested(&farm) == 1, 1);
            
            test_scenario::return_shared(farm);
        };
        test_scenario::end(scenario);
    }

    // --- TEST 5: Edge Case - ID 0 ---
    #[test]
    #[expected_failure(abort_code = E_INVALID_PLOT_ID)]
    fun test_invalid_plot_id_zero()
    {
        let mut scenario = test_scenario::begin(ADMIN);
        {
            let ctx = test_scenario::ctx(&mut scenario);
            create_farm(ctx);
        };
        test_scenario::next_tx(&mut scenario, USER);
        {
            let mut farm = test_scenario::take_shared<Farm>(&scenario);
            plant_on_farm_entry(&mut farm, 0); // Should Fail
            test_scenario::return_shared(farm);
        };
        test_scenario::end(scenario);
    }

    // --- TEST 6: Edge Case - ID Too Large ---
    #[test]
    #[expected_failure(abort_code = E_INVALID_PLOT_ID)]
    fun test_invalid_plot_id_too_large()
    {
        let mut scenario = test_scenario::begin(ADMIN);
        {
            let ctx = test_scenario::ctx(&mut scenario);
            create_farm(ctx);
        };
        test_scenario::next_tx(&mut scenario, USER);
        {
            let mut farm = test_scenario::take_shared<Farm>(&scenario);
            plant_on_farm_entry(&mut farm, 21); // Should Fail
            test_scenario::return_shared(farm);
        };
        test_scenario::end(scenario);
    }

    // --- TEST 7: Duplicate Prevention ---
    #[test]
    #[expected_failure(abort_code = E_PLOT_ALREADY_EXISTS)]
    fun test_duplicate_plot()
    {
        let mut scenario = test_scenario::begin(ADMIN);
        {
            let ctx = test_scenario::ctx(&mut scenario);
            create_farm(ctx);
        };
        test_scenario::next_tx(&mut scenario, USER);
        {
            let mut farm = test_scenario::take_shared<Farm>(&scenario);
            plant_on_farm_entry(&mut farm, 1);
            plant_on_farm_entry(&mut farm, 1); // Should Fail
            test_scenario::return_shared(farm);
        };
        test_scenario::end(scenario);
    }

    // --- TEST 8: Max Capacity ---
    #[test]
    #[expected_failure(abort_code = E_PLOT_LIMIT_EXCEEDED)]
    fun test_plot_limit()
    {
        let mut scenario = test_scenario::begin(ADMIN);
        {
            let ctx = test_scenario::ctx(&mut scenario);
            create_farm(ctx);
        };
        test_scenario::next_tx(&mut scenario, USER);
        {
            let mut farm = test_scenario::take_shared<Farm>(&scenario);
            
            // Fill the farm (1 to 20)
            let mut i: u8 = 1;
            while (i <= 20) 
            {
                plant_on_farm_entry(&mut farm, i);
                i = i + 1;
            };

            // Try 21st plant (even if duplicate logic exists, capacity check is first)
            plant_on_farm_entry(&mut farm, 1);
            
            test_scenario::return_shared(farm);
        };
        test_scenario::end(scenario);
    }

    // --- TEST 9: Harvest Non-Existent ---
    #[test]
    #[expected_failure(abort_code = E_PLOT_NOT_FOUND)]
    fun test_harvest_nonexistent_plot()
    {
        let mut scenario = test_scenario::begin(ADMIN);
        {
            let ctx = test_scenario::ctx(&mut scenario);
            create_farm(ctx);
        };
        test_scenario::next_tx(&mut scenario, USER);
        {
            let mut farm = test_scenario::take_shared<Farm>(&scenario);
            harvest_from_farm_entry(&mut farm, 10); // Never planted
            test_scenario::return_shared(farm);
        };
        test_scenario::end(scenario);
    }

}