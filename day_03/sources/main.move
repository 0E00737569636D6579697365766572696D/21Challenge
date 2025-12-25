///
/// this code was written by a human :)
/// 
module challenge::day_03
{
    public struct Habit has copy, drop
    {
        name: vector<u8>,
        completed: bool
    }   

    public fun new_habit(name: vector<u8>): Habit 
    {
        Habit 
        {
            name: name,
            completed: false
        }
    }
}