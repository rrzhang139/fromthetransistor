// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vblinking_led.h for the primary calling header

#include "verilated.h"

#include "Vblinking_led__Syms.h"
#include "Vblinking_led___024root.h"

VL_INLINE_OPT void Vblinking_led___024root___act_sequent__TOP__0(Vblinking_led___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vblinking_led__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vblinking_led___024root___act_sequent__TOP__0\n"); );
    // Body
    vlSelf->tb__DOT__clk = (1U & (~ (IData)(vlSelf->tb__DOT__clk)));
}

void Vblinking_led___024root___eval_act(Vblinking_led___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vblinking_led__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vblinking_led___024root___eval_act\n"); );
    // Body
    if ((1ULL & vlSelf->__VactTriggered.word(0U))) {
        Vblinking_led___024root___act_sequent__TOP__0(vlSelf);
    }
}

VL_INLINE_OPT void Vblinking_led___024root___nba_sequent__TOP__0(Vblinking_led___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vblinking_led__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vblinking_led___024root___nba_sequent__TOP__0\n"); );
    // Body
    vlSelf->__Vdly__tb__DOT__uut__DOT__cnt = vlSelf->tb__DOT__uut__DOT__cnt;
    vlSelf->__Vdly__tb__DOT__uut__DOT__cnt = ((IData)(1U) 
                                              + vlSelf->tb__DOT__uut__DOT__cnt);
}

VL_INLINE_OPT void Vblinking_led___024root___nba_sequent__TOP__1(Vblinking_led___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vblinking_led__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vblinking_led___024root___nba_sequent__TOP__1\n"); );
    // Body
    vlSelf->tb__DOT__led = (0xc350U <= vlSelf->tb__DOT__uut__DOT__cnt);
}

VL_INLINE_OPT void Vblinking_led___024root___nba_sequent__TOP__2(Vblinking_led___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vblinking_led__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vblinking_led___024root___nba_sequent__TOP__2\n"); );
    // Body
    vlSelf->tb__DOT__uut__DOT__cnt = vlSelf->__Vdly__tb__DOT__uut__DOT__cnt;
}

void Vblinking_led___024root___eval_nba(Vblinking_led___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vblinking_led__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vblinking_led___024root___eval_nba\n"); );
    // Body
    if ((2ULL & vlSelf->__VnbaTriggered.word(0U))) {
        Vblinking_led___024root___nba_sequent__TOP__0(vlSelf);
    }
    if ((4ULL & vlSelf->__VnbaTriggered.word(0U))) {
        Vblinking_led___024root___nba_sequent__TOP__1(vlSelf);
    }
    if ((2ULL & vlSelf->__VnbaTriggered.word(0U))) {
        Vblinking_led___024root___nba_sequent__TOP__2(vlSelf);
    }
}

void Vblinking_led___024root___eval_triggers__act(Vblinking_led___024root* vlSelf);
#ifdef VL_DEBUG
VL_ATTR_COLD void Vblinking_led___024root___dump_triggers__act(Vblinking_led___024root* vlSelf);
#endif  // VL_DEBUG
#ifdef VL_DEBUG
VL_ATTR_COLD void Vblinking_led___024root___dump_triggers__nba(Vblinking_led___024root* vlSelf);
#endif  // VL_DEBUG

void Vblinking_led___024root___eval(Vblinking_led___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vblinking_led__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vblinking_led___024root___eval\n"); );
    // Init
    VlTriggerVec<3> __VpreTriggered;
    IData/*31:0*/ __VnbaIterCount;
    CData/*0:0*/ __VnbaContinue;
    // Body
    __VnbaIterCount = 0U;
    __VnbaContinue = 1U;
    while (__VnbaContinue) {
        __VnbaContinue = 0U;
        vlSelf->__VnbaTriggered.clear();
        vlSelf->__VactIterCount = 0U;
        vlSelf->__VactContinue = 1U;
        while (vlSelf->__VactContinue) {
            vlSelf->__VactContinue = 0U;
            Vblinking_led___024root___eval_triggers__act(vlSelf);
            if (vlSelf->__VactTriggered.any()) {
                vlSelf->__VactContinue = 1U;
                if (VL_UNLIKELY((0x64U < vlSelf->__VactIterCount))) {
#ifdef VL_DEBUG
                    Vblinking_led___024root___dump_triggers__act(vlSelf);
#endif
                    VL_FATAL_MT("blinking_led_tb.v", 1, "", "Active region did not converge.");
                }
                vlSelf->__VactIterCount = ((IData)(1U) 
                                           + vlSelf->__VactIterCount);
                __VpreTriggered.andNot(vlSelf->__VactTriggered, vlSelf->__VnbaTriggered);
                vlSelf->__VnbaTriggered.thisOr(vlSelf->__VactTriggered);
                Vblinking_led___024root___eval_act(vlSelf);
            }
        }
        if (vlSelf->__VnbaTriggered.any()) {
            __VnbaContinue = 1U;
            if (VL_UNLIKELY((0x64U < __VnbaIterCount))) {
#ifdef VL_DEBUG
                Vblinking_led___024root___dump_triggers__nba(vlSelf);
#endif
                VL_FATAL_MT("blinking_led_tb.v", 1, "", "NBA region did not converge.");
            }
            __VnbaIterCount = ((IData)(1U) + __VnbaIterCount);
            Vblinking_led___024root___eval_nba(vlSelf);
        }
    }
}

#ifdef VL_DEBUG
void Vblinking_led___024root___eval_debug_assertions(Vblinking_led___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vblinking_led__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vblinking_led___024root___eval_debug_assertions\n"); );
}
#endif  // VL_DEBUG
