#include "Vblinking_led.h"
#include "verilated.h"
#include "verilated_vcd_c.h"

int main(int argc, char **argv, char **env) {
    Verilated::commandArgs(argc, argv);
    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;

    Vblinking_led *top = new Vblinking_led;
    top->trace(tfp, 99);
    tfp->open("blinking_led.vcd");

    vluint64_t main_time = 0;

    while (!Verilated::gotFinish()) {
        top->eval();
        tfp->dump(main_time);
        main_time++;
    }

    tfp->close();
    delete top;
    exit(0);
}
