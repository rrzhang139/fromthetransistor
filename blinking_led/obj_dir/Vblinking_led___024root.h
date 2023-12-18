// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vblinking_led.h for the primary calling header

#ifndef VERILATED_VBLINKING_LED___024ROOT_H_
#define VERILATED_VBLINKING_LED___024ROOT_H_  // guard

#include "verilated.h"


class Vblinking_led__Syms;

class alignas(VL_CACHE_LINE_BYTES) Vblinking_led___024root final : public VerilatedModule {
  public:

    // DESIGN SPECIFIC STATE
    CData/*0:0*/ tb__DOT__clk;
    CData/*0:0*/ tb__DOT__led;
    CData/*0:0*/ __Vtrigprevexpr___TOP__tb__DOT__clk__0;
    CData/*0:0*/ __VstlDidInit;
    CData/*0:0*/ __Vtrigprevexpr___TOP__tb__DOT__clk__1;
    CData/*0:0*/ __VactDidInit;
    CData/*0:0*/ __VactContinue;
    IData/*31:0*/ tb__DOT__uut__DOT__cnt;
    IData/*31:0*/ __Vdly__tb__DOT__uut__DOT__cnt;
    IData/*31:0*/ __VstlIterCount;
    IData/*31:0*/ __Vtrigprevexpr___TOP__tb__DOT__uut__DOT__cnt__0;
    IData/*31:0*/ __VactIterCount;
    VlTriggerVec<2> __VstlTriggered;
    VlTriggerVec<3> __VactTriggered;
    VlTriggerVec<3> __VnbaTriggered;

    // INTERNAL VARIABLES
    Vblinking_led__Syms* const vlSymsp;

    // CONSTRUCTORS
    Vblinking_led___024root(Vblinking_led__Syms* symsp, const char* v__name);
    ~Vblinking_led___024root();
    VL_UNCOPYABLE(Vblinking_led___024root);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
};


#endif  // guard
