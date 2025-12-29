///
/// this code was written by a human :)
///
module challenge::day_08;
use std::string::String;

public struct Task has copy, drop
{
    title: String,
    reward: u64,
    done: bool
}

fun new_task(title: String, reward: u64): Task
{
    let created_task: Task = Task
    {
        title: title,
        reward: reward,
        done: false
    };

    return created_task
}

