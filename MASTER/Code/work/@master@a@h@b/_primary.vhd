library verilog;
use verilog.vl_types.all;
entity MasterAHB is
    generic(
        AddresseWidth   : integer := 32;
        DataWidth       : integer := 32;
        InWidth         : integer := 32;
        ControlWidth    : integer := 16
    );
    port(
        HREADY          : in     vl_logic;
        HRESP           : in     vl_logic;
        InAddresse      : in     vl_logic_vector;
        InWData         : in     vl_logic_vector;
        InCotrol        : in     vl_logic_vector;
        OutRData        : out    vl_logic_vector;
        HRESETn         : in     vl_logic;
        HCLK            : in     vl_logic;
        HRDATA          : in     vl_logic_vector;
        HADDR           : out    vl_logic_vector;
        HWRITE          : out    vl_logic;
        HSIZE           : out    vl_logic_vector(2 downto 0);
        HBURST          : out    vl_logic_vector(2 downto 0);
        HTRANS          : out    vl_logic_vector(1 downto 0);
        HWDATA          : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of AddresseWidth : constant is 1;
    attribute mti_svvh_generic_type of DataWidth : constant is 1;
    attribute mti_svvh_generic_type of InWidth : constant is 1;
    attribute mti_svvh_generic_type of ControlWidth : constant is 1;
end MasterAHB;
