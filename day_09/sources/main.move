///
/// this code was written by a human :)
///
#[allow(unused_function, dead_code)]
module challenge::day_09;

// === Import ===

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

// === Functions ===

fun new_task(title: String, reward: u64): Task
{
    let created_task: Task = Task
    {
        title: title,
        reward: reward,
        status: TaskStatus::Open
    };

    return created_task
}

/* if else yapısı yerine pattern matching */
/* Eğer task.status Open ise true döndürür değilse false return eder*/
fun is_open(task: &Task): bool 
{
    match (task.status) 
    {
        TaskStatus::Open => true, 
        TaskStatus::Completed => false
    }
}

/*fun is_open(task: &Task): bool
{
    if (task.status == TaskStatus::Open)
    {
        return true
    }
    else
    {
        return false
    }
}*/

