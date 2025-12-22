///
/// this code was written by a human :)
/// 
module challenge::day_02 
{
    #[test_only]
    use std::unit_test::assert_eq;

    #[test_only]
    const EZeroSum: u64 = 0;


    fun sum(a: u64, b:u64): u64 // private is good
    {
        let total = a + b;
        return total
    }


    #[test]
    fun test_sum()
    {
        let total;

        total = sum(21,21);
        assert_eq!(total, 42);
    }

    #[test, expected_failure(abort_code = EZeroSum)]
    fun test_sum_zero()
    {
        let total;

        total = sum(0,0);

        if (total == 0)
            abort EZeroSum
    }

}
