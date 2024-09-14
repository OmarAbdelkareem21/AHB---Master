library verilog;
use verilog.vl_types.all;
entity MasterAHB_tb is
    generic(
        AddresseWidth   : integer := 32;
        DataWidth       : integer := 32;
        InWidth         : integer := 32;
        ControlWidth    : integer := 16
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of AddresseWidth : constant is 1;
    attribute mti_svvh_generic_type of DataWidth : constant is 1;
    attribute mti_svvh_generic_type of InWidth : constant is 1;
    attribute mti_svvh_generic_type of ControlWidth : constant is 1;
end MasterAHB_tb;
