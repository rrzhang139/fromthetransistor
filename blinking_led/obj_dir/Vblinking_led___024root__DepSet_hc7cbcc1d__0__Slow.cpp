// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vblinking_led.h for the primary calling header

#include "verilated.h"

#include "Vblinking_led__Syms.h"
#include "Vblinking_led___024root.h"

VL_ATTR_COLD void Vblinking_led___024root___eval_static__TOP(Vblinking_led___024root* vlSelf);

VL_ATTR_COLD void Vblinking_led___024root___eval_static(Vblinking_led___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vblinking_led__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vblinking_led___024root___eval_static\n"); );
    // Body
    Vblinking_led___024root___eval_static__TOP(vlSelf);
}

VL_ATTR_COLD void Vblinking_led___024root___eval_static__TOP(Vblinking_led___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vblinking_led__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vblinking_led___024root___eval_static__TOP\n"); );
    // Body
    vlSelf->tb__DOT__clk = 0U;
    vlSelf->tb__DOT__uut__DOT__cnt = 0U;
}

VL_ATTR_COLD void Vblinking_led___024root___eval_initial__TOP(Vblinking_led___024root* vlSelf);

VL_ATTR_COLD void Vblinking_led___024root___eval_initial(Vblinking_led___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vblinking_led__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vblinking_led___024root___eval_initial\n"); );
    // Body
    Vblinking_led___024root___eval_initial__TOP(vlSelf);
    vlSelf->__Vtrigprevexpr___TOP__tb__DOT__clk__0 = 0U;
    vlSelf->__Vtrigprevexpr___TOP__tb__DOT__clk__1 = 0U;
    vlSelf->__Vtrigprevexpr___TOP__tb__DOT__uut__DOT__cnt__0 
        = vlSelf->tb__DOT__uut__DOT__cnt;
}

VL_ATTR_COLD void Vblinking_led___024root___eval_final(Vblinking_led___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vblinking_led__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vblinking_led___024root___eval_final\n"); );
}

VL_ATTR_COLD void Vblinking_led___024root___eval_triggers__stl(Vblinking_led___024root* vlSelf);
#ifdef VL_DEBUG
VL_ATTR_COLD void Vblinking_led___024root___dump_triggers__stl(Vblinking_led___024root* vlSelf);
#endif  // VL_DEBUG
VL_ATTR_COLD void Vblinking_led___024root___eval_stl(Vblinking_led___024root* vlSelf);

VL_ATTR_COLD void Vblinking_led___024root___eval_settle(Vblinking_led___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vblinking_led__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vblinking_led___024root___eval_settle\n"); );
    // Init
    CData/*0:0*/ __VstlContinue;
    // Body
    vlSelf->__VstlIterCount = 0U;
    __VstlContinue = 1U;
    while (__VstlContinue) {
        __VstlContinue = 0U;
        Vblinking_led___024root___eval_triggers__stl(vlSelf);
        if (vlSelf->__VstlTriggered.any()) {
            __VstlContinue = 1U;
            if (VL_UNLIKELY((0x64U < vlSelf->__VstlIterCount))) {
#ifdef VL_DEBUG
                Vblinking_led___024root___dump_triggers__stl(vlSelf);
#endif
                VL_FATAL_MT("blinking_led_tb.v", 1, "", "Settle region did not converge.");
            }
            vlSelf->__VstlIterCount = ((IData)(1U) 
                                       + vlSelf->__VstlIterCount);
            Vblinking_led___024root___eval_stl(vlSelf);
        }
    }
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vblinking_led___024root___dump_triggers__stl(Vblinking_led___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vblinking_led__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vblinking_led___024root___dump_triggers__stl\n"); );
    // Body
    if ((1U & (~ (IData)(vlSelf->__VstlTriggered.any())))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelf->__VstlTriggered.word(0U))) {
        VL_DBG_MSGF("         'stl' region trigger index 0 is active: Internal 'stl' trigger - first iteration\n");
    }
    if ((2ULL & vlSelf->__VstlTriggered.word(0U))) {
        VL_DBG_MSGF("         'stl' region trigger index 1 is active: @([hybrid] tb.clk)\n");
    }
}
#endif  // VL_DEBUG

void Vblinking_led___024root___act_sequent__TOP__0(Vblinking_led___024root* vlSelf);

VL_ATTR_COLD void Vblinking_led___024root___eval_stl(Vblinking_led___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vblinking_led__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vblinking_led___024root___eval_stl\n"); );
    // Body
    if ((2ULL & vlSelf->__VstlTriggered.word(0U))) {
        Vblinking_led___024root___act_sequent__TOP__0(vlSelf);
    }
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vblinking_led___024root___dump_triggers__act(Vblinking_led___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vblinking_led__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vblinking_led___024root___dump_triggers__act\n"); );
    // Body
    if ((1U & (~ (IData)(vlSelf->__VactTriggered.any())))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelf->__VactTriggered.word(0U))) {
        VL_DBG_MSGF("         'act' region trigger index 0 is active: @([hybrid] tb.clk)\n");
    }
    if ((2ULL & vlSelf->__VactTriggered.word(0U))) {
        VL_DBG_MSGF("         'act' region trigger index 1 is active: @(posedge tb.clk)\n");
    }
    if ((4ULL & vlSelf->__VactTriggered.word(0U))) {
        VL_DBG_MSGF("         'act' region trigger index 2 is active: @([changed] tb.uut.cnt)\n");
    }
}
#endif  // VL_DEBUG

#ifdef VL_DEBUG
VL_ATTR_COLD void Vblinking_led___024root___dump_triggers__nba(Vblinking_led___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vblinking_led__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vblinking_led___024root___dump_triggers__nba\n"); );
    // Body
    if ((1U & (~ (IData)(vlSelf->__VnbaTriggered.any())))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelf->__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 0 is active: @([hybrid] tb.clk)\n");
    }
    if ((2ULL & vlSelf->__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 1 is active: @(posedge tb.clk)\n");
    }
    if ((4ULL & vlSelf->__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 2 is active: @([changed] tb.uut.cnt)\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD void Vblinking_led___024root___ctor_var_reset(Vblinking_led___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vblinking_led__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vblinking_led___024root___ctor_var_reset\n"); );
    // Body
    vlSelf->tb__DOT__clk = VL_RAND_RESET_I(1);
    vlSelf->tb__DOT__led = VL_RAND_RESET_I(1);
    vlSelf->tb__DOT__uut__DOT__cnt = VL_RAND_RESET_I(32);
    vlSelf->__Vdly__tb__DOT__uut__DOT__cnt = VL_RAND_RESET_I(32);
    vlSelf->__Vtrigprevexpr___TOP__tb__DOT__clk__0 = VL_RAND_RESET_I(1);
    vlSelf->__VstlDidInit = 0;
    vlSelf->__Vtrigprevexpr___TOP__tb__DOT__clk__1 = VL_RAND_RESET_I(1);
    vlSelf->__Vtrigprevexpr___TOP__tb__DOT__uut__DOT__cnt__0 = VL_RAND_RESET_I(32);
    vlSelf->__VactDidInit = 0;
}
