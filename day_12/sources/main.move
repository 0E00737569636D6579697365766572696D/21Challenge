///
/// this code was written by a human :)
///
module challenge::day_12;

use std::string::String;

// === Enums ===

public enum TaskStatus has copy, drop
{
    Open,
    Completed
}

// === Structs ===

public struct Task has copy, drop
{
    title: String,
    reward: u64,
    status: TaskStatus
}

public struct TaskBoard has drop
{
    owner: address,
    tasks: vector<Task>
}

// === Functions ===

public fun new_task(title: String, reward: u64): Task
{
    Task
    {
        title: title,
        reward: reward,
        status: TaskStatus::Open
    }
}

public fun new_board(owner: address): TaskBoard
{
    TaskBoard
    {
        owner: owner,
        tasks: vector::empty()
    }
}

public fun add_task(board: &mut TaskBoard, task: Task)
{
    vector::push_back(&mut board.tasks, task);
}

public fun find_task_by_title(board: &TaskBoard, title: String): Option<u64>
{
    let len = vector::length(&board.tasks);
    let mut i = 0;

    while (i < len)
    {
        let task = vector::borrow(&board.tasks, i);

        if (task.title == title)
        {
            return option::some(i)
        };

        i = i + 1;
    };

    option::none()
}

// === Tests ===

#[test]
fun test_find_task()
{
    let user = @0x1;
    let mut board = new_board(user);
    
    add_task(&mut board, new_task(b"Move Calis".to_string(), 100)); // index 0
    add_task(&mut board, new_task(b"Spor Yap".to_string(), 200));   // index 1

    let result_some = find_task_by_title(&board, b"Spor Yap".to_string());
    
    assert!(option::is_some(&result_some), 0); // Dolu mu?
    assert!(option::borrow(&result_some) == 1, 1); // İçindeki 1 mi?

    let result_none = find_task_by_title(&board, b"Uyu".to_string());

    assert!(option::is_none(&result_none), 2); // Boş mu?
}