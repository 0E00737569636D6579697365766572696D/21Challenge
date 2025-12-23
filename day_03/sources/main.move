// YENI GUNE GECICEZ LANET OLSUN.. SONRADAN DOLDURUCAM - KENDI TARZIMDA YAZICAM..

module challenge::day_03 {
    use std::vector;

    public struct Habit has copy, drop {
        name: vector<u8>,
        completed: bool,
    }   

    public fun create_habit(name: vector<u8>): Habit {
        Habit {
            name,
            completed: false,
        }
    }
}