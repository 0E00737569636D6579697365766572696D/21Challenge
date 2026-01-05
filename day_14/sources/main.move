///
/// this code was written by a human :)
///
module challenge::day_14;

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

// === Tests (Day 14 Challenge) ===

#[test]
fun test_create_and_add()
{
    let owner = @0xA;
    let mut board = new_board(owner);
    let task = new_task(b"Learn Move".to_string(), 100);

    assert!(vector::is_empty(&board.tasks), 0);

    add_task(&mut board, task);

    assert!(vector::length(&board.tasks) == 1, 1);
}

#[test]
fun test_completion_count()
{
    let owner = @0xB;
    let mut board = new_board(owner);
    
    let mut task1 = new_task(b"Task 1".to_string(), 50);
    let task2 = new_task(b"Task 2".to_string(), 50);

    complete_task(&mut task1);

    add_task(&mut board, task1);
    add_task(&mut board, task2);

    assert!(vector::length(&board.tasks) == 2, 0);

    let completed = completed_count(&board);
    assert!(completed == 1, 1);
}

#[test]
fun test_total_reward_calc()
{
    let owner = @0xC;
    let mut board = new_board(owner);

    add_task(&mut board, new_task(b"Small Task".to_string(), 100));
    add_task(&mut board, new_task(b"Big Task".to_string(), 200));
    add_task(&mut board, new_task(b"Bonus Task".to_string(), 50));

    let total = total_reward(&board);
    assert!(total == 350, 0);
}