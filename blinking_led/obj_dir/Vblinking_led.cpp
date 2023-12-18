// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Model implementation (design independent parts)

#include "Vblinking_led.h"
#include "Vblinking_led__Syms.h"
#include "verilated_vcd_c.h"

//============================================================
// Constructors

Vblinking_led::Vblinking_led(VerilatedContext* _vcontextp__, const char* _vcname__)
    : VerilatedModel{*_vcontextp__}
    , vlSymsp{new Vblinking_led__Syms(contextp(), _vcname__, this)}
    , rootp{&(vlSymsp->TOP)}
{
    // Register model with the context
    contextp()->addModel(this);
}

Vblinking_led::Vblinking_led(const char* _vcname__)
    : Vblinking_led(Verilated::threadContextp(), _vcname__)
{
}

//============================================================
// Destructor

Vblinking_led::~Vblinking_led() {
    delete vlSymsp;
}

//============================================================
// Evaluation function

#ifdef VL_DEBUG
void Vblinking_led___024root___eval_debug_assertions(Vblinking_led___024root* vlSelf);
#endif  // VL_DEBUG
void Vblinking_led___024root___eval_static(Vblinking_led___024root* vlSelf);
void Vblinking_led___024root___eval_initial(Vblinking_led___024root* vlSelf);
void Vblinking_led___024root___eval_settle(Vblinking_led___024root* vlSelf);
void Vblinking_led___024root___eval(Vblinking_led___024root* vlSelf);

void Vblinking_led::eval_step() {
    VL_DEBUG_IF(VL_DBG_MSGF("+++++TOP Evaluate Vblinking_led::eval_step\n"); );
#ifdef VL_DEBUG
    // Debug assertions
    Vblinking_led___024root___eval_debug_assertions(&(vlSymsp->TOP));
#endif  // VL_DEBUG
    vlSymsp->__Vm_activity = true;
    vlSymsp->__Vm_deleter.deleteAll();
    if (VL_UNLIKELY(!vlSymsp->__Vm_didInit)) {
        vlSymsp->__Vm_didInit = true;
        VL_DEBUG_IF(VL_DBG_MSGF("+ Initial\n"););
        Vblinking_led___024root___eval_static(&(vlSymsp->TOP));
        Vblinking_led___024root___eval_initial(&(vlSymsp->TOP));
        Vblinking_led___024root___eval_settle(&(vlSymsp->TOP));
    }
    // MTask 0 start
    VL_DEBUG_IF(VL_DBG_MSGF("MTask0 starting\n"););
    Verilated::mtaskId(0);
    VL_DEBUG_IF(VL_DBG_MSGF("+ Eval\n"););
    Vblinking_led___024root___eval(&(vlSymsp->TOP));
    // Evaluate cleanup
    Verilated::endOfThreadMTask(vlSymsp->__Vm_evalMsgQp);
    Verilated::endOfEval(vlSymsp->__Vm_evalMsgQp);
}

void Vblinking_led::eval_end_step() {
    VL_DEBUG_IF(VL_DBG_MSGF("+eval_end_step Vblinking_led::eval_end_step\n"); );
#ifdef VM_TRACE
    // Tracing
    if (VL_UNLIKELY(vlSymsp->__Vm_dumping)) vlSymsp->_traceDump();
#endif  // VM_TRACE
}

//============================================================
// Events and timing
bool Vblinking_led::eventsPending() { return false; }

uint64_t Vblinking_led::nextTimeSlot() {
    VL_FATAL_MT(__FILE__, __LINE__, "", "%Error: No delays in the design");
    return 0;
}

//============================================================
// Utilities

const char* Vblinking_led::name() const {
    return vlSymsp->name();
}

//============================================================
// Invoke final blocks

void Vblinking_led___024root___eval_final(Vblinking_led___024root* vlSelf);

VL_ATTR_COLD void Vblinking_led::final() {
    Vblinking_led___024root___eval_final(&(vlSymsp->TOP));
}

//============================================================
// Implementations of abstract methods from VerilatedModel

const char* Vblinking_led::hierName() const { return vlSymsp->name(); }
const char* Vblinking_led::modelName() const { return "Vblinking_led"; }
unsigned Vblinking_led::threads() const { return 1; }
void Vblinking_led::prepareClone() const { contextp()->prepareClone(); }
void Vblinking_led::atClone() const {
    contextp()->threadPoolpOnClone();
}
std::unique_ptr<VerilatedTraceConfig> Vblinking_led::traceConfig() const {
    return std::unique_ptr<VerilatedTraceConfig>{new VerilatedTraceConfig{false, false, false}};
};

//============================================================
// Trace configuration

void Vblinking_led___024root__trace_init_top(Vblinking_led___024root* vlSelf, VerilatedVcd* tracep);

VL_ATTR_COLD static void trace_init(void* voidSelf, VerilatedVcd* tracep, uint32_t code) {
    // Callback from tracep->open()
    Vblinking_led___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vblinking_led___024root*>(voidSelf);
    Vblinking_led__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    if (!vlSymsp->_vm_contextp__->calcUnusedSigs()) {
        VL_FATAL_MT(__FILE__, __LINE__, __FILE__,
            "Turning on wave traces requires Verilated::traceEverOn(true) call before time 0.");
    }
    vlSymsp->__Vm_baseCode = code;
    tracep->scopeEscape(' ');
    tracep->pushNamePrefix(std::string{vlSymsp->name()} + ' ');
    Vblinking_led___024root__trace_init_top(vlSelf, tracep);
    tracep->popNamePrefix();
    tracep->scopeEscape('.');
}

VL_ATTR_COLD void Vblinking_led___024root__trace_register(Vblinking_led___024root* vlSelf, VerilatedVcd* tracep);

VL_ATTR_COLD void Vblinking_led::trace(VerilatedVcdC* tfp, int levels, int options) {
    if (tfp->isOpen()) {
        vl_fatal(__FILE__, __LINE__, __FILE__,"'Vblinking_led::trace()' shall not be called after 'VerilatedVcdC::open()'.");
    }
    if (false && levels && options) {}  // Prevent unused
    tfp->spTrace()->addModel(this);
    tfp->spTrace()->addInitCb(&trace_init, &(vlSymsp->TOP));
    Vblinking_led___024root__trace_register(&(vlSymsp->TOP), tfp->spTrace());
}
