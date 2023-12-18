// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vblinking_led.h for the primary calling header

#include "verilated.h"

#include "Vblinking_led__Syms.h"
#include "Vblinking_led__Syms.h"
#include "Vblinking_led___024root.h"

VL_ATTR_COLD void Vblinking_led___024root___eval_initial__TOP(Vblinking_led___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vblinking_led__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vblinking_led___024root___eval_initial__TOP\n"); );
    // Init
    VlWide<4>/*127:0*/ __Vtemp_1;
    // Body
    __Vtemp_1[0U] = 0x2e766364U;
    __Vtemp_1[1U] = 0x5f6c6564U;
    __Vtemp_1[2U] = 0x6b696e67U;
    __Vtemp_1[3U] = 0x626c696eU;
    vlSymsp->_vm_contextp__->dumpfile(VL_CVT_PACK_STR_NW(4, __Vtemp_1));
    vlSymsp->_traceDumpOpen();
    vlSelf->tb__DOT__clk = 0U;
    VL_FINISH_MT("blinking_led_tb.v", 22, "");
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vblinking_led___024root___dump_triggers__stl(Vblinking_led___024root* vlSelf);
#endif  // VL_DEBUG

VL_ATTR_COLD void Vblinking_led___024root___eval_triggers__stl(Vblinking_led___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vblinking_led__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vblinking_led___024root___eval_triggers__stl\n"); );
    // Body
    vlSelf->__VstlTriggered.set(0U, (0U == vlSelf->__VstlIterCount));
    vlSelf->__VstlTriggered.set(1U, ((IData)(vlSelf->tb__DOT__clk) 
                                     != (IData)(vlSelf->__Vtrigprevexpr___TOP__tb__DOT__clk__0)));
    vlSelf->__Vtrigprevexpr___TOP__tb__DOT__clk__0 
        = vlSelf->tb__DOT__clk;
    if (VL_UNLIKELY((1U & (~ (IData)(vlSelf->__VstlDidInit))))) {
        vlSelf->__VstlDidInit = 1U;
        vlSelf->__VstlTriggered.set(1U, 1U);
    }
#ifdef VL_DEBUG
    if (VL_UNLIKELY(vlSymsp->_vm_contextp__->debug())) {
        Vblinking_led___024root___dump_triggers__stl(vlSelf);
    }
#endif
}
