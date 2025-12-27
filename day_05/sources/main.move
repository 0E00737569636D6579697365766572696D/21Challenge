///
/// this code was written by a human :)
/// 
module challenge::day_05; // (en) :D    (tr) yeni öğrendim xd dosyada tek 1 modül olacaksa böyle kullanılmasına izin veriliyormuş

// === Import ===

use std::string::String;

// === Error Constants ===

const EInvalidNumber: u64 = 1; 

// === Structs ===

public struct Habit has copy, drop 
{
    name: String, // (en) i ll use string.. NOT vector<u8>  (tr) abi niye vector<u8> kullanayım burada daha demin day 04 de stringe geçmiştik..
    completed: bool
}

public struct HabitList has drop 
{
    habits: vector<Habit>
}

// === Private Functions ===

/// 
/// (en) It creates a habit with the data in the parameter it receives and returns it. 
/// (tr) aldığı parametredeki veriyle bir habit oluşturur ve geri döndürür. 
/// 
fun new_habit(name: String): Habit 
{
    let my_habit = Habit
    {
        name: name,
        completed: false
    }; // (en) i dont like this language errors.. (tr) sıçam böyle syntaxe
    
    return my_habit // (en) Learning syntax.. (tr) bir şey döndürdüğünü belli etmek bence önemli 
}

///
/// (en) Creates and returns an empty habit list.
/// (tr) Boş bir habitlist oluşturur ve geri döndürür.
/// 
fun empty_list(): HabitList 
{
    let empty_habitlist = HabitList 
    {
        habits: vector::empty()
    };

    return empty_habitlist 
}

///
/// (en) add a habit on the habitlist
/// (tr) listeye habiti arkadan ittirir xd
/// 
fun add_habit(list: &mut HabitList, habit: Habit) 
{
    vector::push_back(&mut list.habits, habit);
}

///
/// (en) Sets the `completed` field to true for the habit at `index`.
/// Aborts with `EInvalidNumber` if the index is invalid.
/// (tr) gönderilen listedeki habitin completed alanını true yapmak ister. 
/// Yapamazsa kızar :)
/// 
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
        abort EInvalidNumber
    }
}

// === Test Functions ===

///
/// (en) It adds a habit, marks it as done, and checks if it is really done.
/// (tr) Kodu doğru yazmışmıyım onu test etmeye çalışıyo da daha bizi tanımıyo :D
///
#[test]
fun test_complete_habit() 
{
    let mut list = empty_list();
    let name = b"Kodlama Calis".to_string(); // (en) I learned that I can do it using to_string. (tr) c# bunu beğendi xd

    add_habit(&mut list, new_habit(name)); 

    complete_habit(&mut list, 0);

    let habit_updated = vector::borrow(&list.habits, 0);
    assert!(habit_updated.completed == true, 0);
}

///
/// (en) Tries to complete a habit that doesn't exist. It MUST fail (abort).
/// (tr) Boş bir liste ile birlikte Test adında bir habit oluşturduktan sonra listeye Test habitini ekleriz
///      ve Test habitimiz listemizin 0. indexinde yer alır ancak biz complete_habit fonksiyonuna 99. indexi
///      göndererek 99. indexi true yapmasını isteriz. bu durumda yazdığımız else kısmının çalışması ve abort 1 
///      yapması gerekir. 
///      özet olarak: Sıkıntı yoksa sıkıntı vardır xd 
///
#[test, expected_failure(abort_code = EInvalidNumber)] // (en) i like it  (tr) böyle de yazılabiliyormuş beğendim
fun test_invalid_index_should_fail() 
{
    let mut list = empty_list();
    add_habit(&mut list, new_habit(b"Test".to_string()));

    complete_habit(&mut list, 99); // (en) It should normally throw an error, but I added expected_failure xd (tr) düşme ahmedim düşme
}

/*
Running Move unit tests
[ PASS    ] challenge::day_05::test_complete_habit
[ PASS    ] challenge::day_05::test_invalid_index_should_fail
Test result: OK. Total tests: 2; passed: 2; failed: 0
*/