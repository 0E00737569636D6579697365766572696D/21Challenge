///
/// this code was written by a human :)
///
module challenge::day_13;

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

public fun complete_task(task: &mut Task) 
{
    task.status = TaskStatus::Completed;
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


public fun total_reward(board: &TaskBoard): u64
{
    let len = vector::length(&board.tasks);
    let mut total = 0;
    let mut i = 0;

    while (i < len)
    {
        let task = vector::borrow(&board.tasks, i);
        total = total + task.reward;
        i = i + 1;
    };

    total
}

public fun completed_count(board: &TaskBoard): u64
{
    let len = vector::length(&board.tasks);
    let mut count = 0;
    let mut i = 0;

    while (i < len)
    {
        let task = vector::borrow(&board.tasks, i);
        if (task.status == TaskStatus::Completed)
        {
            count = count + 1;
        };
        i = i + 1;
    };

    count
}

// === Tests ===

#[test]
fun test_aggregations()
{
    let user = @0x1;
    let mut board = new_board(user);
    
    let mut task1 = new_task(b"Move Calis".to_string(), 100);
    let task2 = new_task(b"Spor Yap".to_string(), 200);
    let mut task3 = new_task(b"Kitap Oku".to_string(), 50);

    complete_task(&mut task1);
    complete_task(&mut task3);

    add_task(&mut board, task1);
    add_task(&mut board, task2);
    add_task(&mut board, task3);

    // Test 1: Toplam ödül (100 + 200 + 50 = 350)
    assert!(total_reward(&board) == 350, 0);

    // Test 2: Tamamlanan sayısı (task1 ve task3 = 2)
    assert!(completed_count(&board) == 2, 1);
}