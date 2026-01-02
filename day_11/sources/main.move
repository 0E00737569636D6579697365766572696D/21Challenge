///
/// this code was written by a human :)
///
module challenge::day_11;

// === Import ===

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

fun new_task(title: String, reward: u64): Task
{
    Task
    {
        title: title,
        reward: reward,
        status: TaskStatus::Open
    }
}

///
/// (en) Creates a new empty board for a specific user (address).
/// (tr) Belirli bir adres için boş bir pano oluşturur.
///
fun new_board(owner: address): TaskBoard
{
    TaskBoard
    {
        owner: owner,
        tasks: vector::empty()
    }
}

///
/// (en) Adds a task to the board. Ownership of the task is transferred to the board.
/// (tr) Panoya görev ekler. Görevin sahipliği artık panoya geçer.
///
fun add_task(board: &mut TaskBoard, task: Task)
{
    vector::push_back(&mut board.tasks, task);
}

// === Tests ===

#[test]
fun test_task_board_flow()
{
    let user_address = @0xCAFE;
    let mut board = new_board(user_address);

    assert!(board.owner == @0xCAFE, 0);

    let task = new_task(b"Move Ogren".to_string(), 100);
    add_task(&mut board, task);

    assert!(vector::length(&board.tasks) == 1, 1);
}