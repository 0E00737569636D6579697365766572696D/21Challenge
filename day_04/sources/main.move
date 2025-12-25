///
/// this code was written by a human :)
/// 
module challenge::day_04 
{
    use std::string::String;

    #[test_only]
    use std::string;

    public struct Habit has copy, drop 
    {
        name: String,
        completed: bool
    }

    public fun new_habit(name: String): Habit 
    {
        Habit 
        {
            name,
            completed: false
        }
    }

    public struct HabitList has drop 
    {
        habits: vector<Habit>
    }

    public fun empty_list(): HabitList 
    {
        HabitList 
        {
            habits: vector::empty()
        }
    }

    public fun add_habit(list: &mut HabitList, habit: Habit) 
    {
        vector::push_back(&mut list.habits, habit);
    }

    #[test]
    fun test_habit_flow() 
    {
        let habit_name = string::utf8(b"Kod yazmak"); 
        let habit = new_habit(habit_name);
        let mut list = empty_list();

        add_habit(&mut list, habit);
        assert!(vector::length(&list.habits) == 1, 0);
    }

    #[test]
    fun test_empty_list_starts_empty() 
    {
        let list = empty_list();
        
        assert!(vector::length(&list.habits) == 0, 1); 
    }

    #[test]
    fun test_add_multiple_habits() 
    {
        let mut list = empty_list();
        
        let h1 = new_habit(string::utf8(b"Su Ic"));
        let h2 = new_habit(string::utf8(b"Yuruyus Yap"));
        let h3 = new_habit(string::utf8(b"Kitap Oku"));

        add_habit(&mut list, h1);
        add_habit(&mut list, h2);
        add_habit(&mut list, h3);

        assert!(vector::length(&list.habits) == 3, 2);
    }

    #[test]
    fun test_verify_habit_data() 
    {
        let mut list = empty_list();
        let name_str = string::utf8(b"Kodlama Calis");
        
        let habit = new_habit(name_str);
        add_habit(&mut list, habit);

        let saved_habit = vector::borrow(&list.habits, 0);
        
        assert!(saved_habit.name == string::utf8(b"Kodlama Calis"), 3);

        assert!(saved_habit.completed == false, 4);
    }
}
