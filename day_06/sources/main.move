///
/// this code was written by a human
/// 
module challenge::day_06;

// === Import ===

use std::string::String;

#[test_only]
use std::debug;

// === Structs ===

public struct Habit has copy, drop 
{
    name: String, 
    completed: bool
}

// === Private Functions ===

fun new_habit(name: String): Habit 
{
    let my_habit = Habit
    {
        name: name,
        completed: false
    };
    
    return my_habit
}

fun make_habit(name_bytes: vector<u8>): Habit
{
    let name = name_bytes.to_string();
    let habit = new_habit(name);

    return habit
}

// === Test Functions ===

#[test]
fun make_habit_working()
{
    let name: vector<u8> = vector[105, 108, 107, 101, 114];
    let habit: Habit = make_habit(name);

    debug::print(&habit.name);
    assert!(&habit.name == "ilker", 0);
}
