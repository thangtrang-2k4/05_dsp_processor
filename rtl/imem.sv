module imem #(
    parameter int    DEPTH_WORDS = 1024
)(
             input  logic rst_n,
             input  logic [31:0] addr,
             output logic [31:0] inst
);
  // Dung lượng: 1024 word (4KB)
  logic [7:0] inst_mem [0:DEPTH_WORDS-1];

  // ==== đọc instruction ====
  always_comb begin
    if (!rst_n)
      inst = 32'd0;
    else if (addr[31:2] < DEPTH_WORDS)
      inst = {inst_mem[addr], inst_mem[addr+1], inst_mem[addr+2], inst_mem[addr+3]};
    else
      inst = 32'h00000013;
  end
  // ==== nạp nội dung chương trình ====
initial begin
    string path;
    int file;

    file = $fopen("../rtl/imem_path.txt", "r");

    if (!file) begin
        $display("ERROR: Cannot open imem_path.txt");
        $finish;
    end

    void'($fgets(path, file));
    $fclose(file);

    // remove '\n'
    if (path.len() > 0 && path[path.len()-1] == 8'h0A)
        path = path.substr(0, path.len()-2);

    // remove '\r'
    if (path.len() > 0 && path[path.len()-1] == 8'h0D)
        path = path.substr(0, path.len()-2);

    $display("Loading instruction memory from: '%s'", path);

    $readmemh(path, inst_mem);

    $display("Instruction memory loaded.");
end
//  initial begin
//    $readmemh("/home/trangthang/Workspace/02_Project/01_GitHub/05_rv32i_P_extension/sw/hazards_test/hazards_program_all.mem", inst_mem);
//  end

endmodule
