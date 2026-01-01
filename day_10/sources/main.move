///
/// this code was written by a human :)
///
module challenge::day_10;

use std::string::String;

// === Enum ===

public enum TaskStatus has copy, drop
{
    Open,
    Completed
}

// === Struct ===

public struct Task has copy, drop
{
    title: String,
    reward: u64,
    status: TaskStatus
}

// === Public Functions ===

///
/// (en) Creates a new task. Public because everyone should be able to create a task.
/// (tr) Yeni görev oluşturur. Public yaptık çünkü dışarıdan görev oluşturulabilmeli.
///
public fun new_task(title: String, reward: u64): Task
{
    Task
    {
        title: title,
        reward: reward,
        status: TaskStatus::Open
    }
}

///
/// (en) Marks the task as completed.
/// (tr) Görevi tamamlandı olarak işaretler.
///      Yapması gerektiği işi private fonksiyona yaptırtır.
///      Bu sayede bonusu yapmış oldum :)
///
public fun complete_task(task: &mut Task)
{
    internal_set_status(task, TaskStatus::Completed);
}

// === Private Function ===

///
/// (en) Internal function to change status. Private! Outside world cannot access this directly.
/// (tr) Statüyü değiştiren asıl fonksiyon bu. Ama private.
///      Yani başka modüller kafasına göre "update_status" diyip durumu değiştiremez.
///      Sadece bizim izin verdiğimiz "complete_task" fonksiyonu sayesinde yapılabilir.
///
fun internal_set_status(task: &mut Task, new_status: TaskStatus)
{
    task.status = new_status;
}

// === Tests ===

#[test]
fun test_complete_task_flow()
{
    let mut task = new_task(b"Gorevi bitir".to_string(), 500);
 
    match (task.status)
    {
        TaskStatus::Open => {},
        _ => abort 0
    };
    complete_task(&mut task);

    match (task.status)
    {
        TaskStatus::Completed => {},
        _ => abort 1 // Tamamlanmamış.
    };
}