///
/// this code was written by a human :)
///
module challenge::day_07;

// === Import ===

use std::string::String;

// === Structs ===

public struct Habit has copy, drop 
{
    name: String,
    completed: bool
}

public struct HabitList has drop 
{
    habits: vector<Habit>
}

// === Functions ===

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

fun empty_list(): HabitList 
{
    let empty_habitlist = HabitList 
    {
        habits: vector::empty()
    };

    return empty_habitlist 
}

fun add_habit(list: &mut HabitList, habit: Habit) 
{
    vector::push_back(&mut list.habits, habit);
}

fun complete_habit(list: &mut HabitList, index: u64) 
{
    let len = vector::length(&list.habits);

    if (index < len) 
    {
        let habit = vector::borrow_mut(&mut list.habits, index);
        habit.completed = true;
    }
    else
    {
        abort 1
    }
}

// === TESTS ===

#[test]
fun test_add_habits() 
{
    let mut list = empty_list();
    
    let habit1 = make_habit(b"Move Ogren");
    let habit2 = new_habit(b"Spor Yap".to_string());

    add_habit(&mut list, habit1);
    add_habit(&mut list, habit2);

    let len = vector::length(&list.habits);
    
    assert!(len == 2, 0); 
}

#[test]
fun test_complete_habit() 
{
    let mut list = empty_list();
    let habit = new_habit(b"Kod Yaz".to_string());
    add_habit(&mut list, habit);

    complete_habit(&mut list, 0);

    let completed_habit = vector::borrow(&list.habits, 0);
    
    assert!(completed_habit.completed == true, 1);
}