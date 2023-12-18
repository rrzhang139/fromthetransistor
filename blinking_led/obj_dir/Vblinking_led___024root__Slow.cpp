// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vblinking_led.h for the primary calling header

#include "verilated.h"

#include "Vblinking_led__Syms.h"
#include "Vblinking_led__Syms.h"
#include "Vblinking_led___024root.h"

void Vblinking_led___024root___ctor_var_reset(Vblinking_led___024root* vlSelf);

Vblinking_led___024root::Vblinking_led___024root(Vblinking_led__Syms* symsp, const char* v__name)
    : VerilatedModule{v__name}
    , vlSymsp{symsp}
 {
    // Reset structure values
    Vblinking_led___024root___ctor_var_reset(this);
}

void Vblinking_led___024root::__Vconfigure(bool first) {
    if (false && first) {}  // Prevent unused
}

Vblinking_led___024root::~Vblinking_led___024root() {
}
