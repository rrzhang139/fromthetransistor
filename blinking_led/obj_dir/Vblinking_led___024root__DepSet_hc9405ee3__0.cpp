// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vblinking_led.h for the primary calling header

#include "verilated.h"

#include "Vblinking_led__Syms.h"
#include "Vblinking_led__Syms.h"
#include "Vblinking_led___024root.h"

#ifdef VL_DEBUG
VL_ATTR_COLD void Vblinking_led___024root___dump_triggers__act(Vblinking_led___024root* vlSelf);
#endif  // VL_DEBUG

void Vblinking_led___024root___eval_triggers__act(Vblinking_led___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vblinking_led__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vblinking_led___024root___eval_triggers__act\n"); );
    // Body
    vlSelf->__VactTriggered.set(0U, ((IData)(vlSelf->tb__DOT__clk) 
                                     != (IData)(vlSelf->__Vtrigprevexpr___TOP__tb__DOT__clk__1)));
    vlSelf->__VactTriggered.set(1U, ((IData)(vlSelf->tb__DOT__clk) 
                                     & (~ (IData)(vlSelf->__Vtrigprevexpr___TOP__tb__DOT__clk__1))));
    vlSelf->__VactTriggered.set(2U, (vlSelf->tb__DOT__uut__DOT__cnt 
                                     != vlSelf->__Vtrigprevexpr___TOP__tb__DOT__uut__DOT__cnt__0));
    vlSelf->__Vtrigprevexpr___TOP__tb__DOT__clk__1 
        = vlSelf->tb__DOT__clk;
    vlSelf->__Vtrigprevexpr___TOP__tb__DOT__uut__DOT__cnt__0 
        = vlSelf->tb__DOT__uut__DOT__cnt;
    if (VL_UNLIKELY((1U & (~ (IData)(vlSelf->__VactDidInit))))) {
        vlSelf->__VactDidInit = 1U;
        vlSelf->__VactTriggered.set(0U, 1U);
        vlSelf->__VactTriggered.set(2U, 1U);
    }
#ifdef VL_DEBUG
    if (VL_UNLIKELY(vlSymsp->_vm_contextp__->debug())) {
        Vblinking_led___024root___dump_triggers__act(vlSelf);
    }
#endif
}
