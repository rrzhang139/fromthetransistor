// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "Vblinking_led__Syms.h"


VL_ATTR_COLD void Vblinking_led___024root__trace_init_sub__TOP__0(Vblinking_led___024root* vlSelf, VerilatedVcd* tracep) {
    if (false && vlSelf) {}  // Prevent unused
    Vblinking_led__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vblinking_led___024root__trace_init_sub__TOP__0\n"); );
    // Init
    const int c = vlSymsp->__Vm_baseCode;
    // Body
    tracep->pushNamePrefix("tb ");
    tracep->declBit(c+1,"clk", false,-1);
    tracep->declBit(c+2,"led", false,-1);
    tracep->pushNamePrefix("uut ");
    tracep->declBit(c+1,"clk", false,-1);
    tracep->declBit(c+2,"led", false,-1);
    tracep->declBus(c+3,"cnt", false,-1, 31,0);
    tracep->popNamePrefix(2);
}

VL_ATTR_COLD void Vblinking_led___024root__trace_init_top(Vblinking_led___024root* vlSelf, VerilatedVcd* tracep) {
    if (false && vlSelf) {}  // Prevent unused
    Vblinking_led__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vblinking_led___024root__trace_init_top\n"); );
    // Body
    Vblinking_led___024root__trace_init_sub__TOP__0(vlSelf, tracep);
}

VL_ATTR_COLD void Vblinking_led___024root__trace_full_top_0(void* voidSelf, VerilatedVcd::Buffer* bufp);
void Vblinking_led___024root__trace_chg_top_0(void* voidSelf, VerilatedVcd::Buffer* bufp);
void Vblinking_led___024root__trace_cleanup(void* voidSelf, VerilatedVcd* /*unused*/);

VL_ATTR_COLD void Vblinking_led___024root__trace_register(Vblinking_led___024root* vlSelf, VerilatedVcd* tracep) {
    if (false && vlSelf) {}  // Prevent unused
    Vblinking_led__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vblinking_led___024root__trace_register\n"); );
    // Body
    tracep->addFullCb(&Vblinking_led___024root__trace_full_top_0, vlSelf);
    tracep->addChgCb(&Vblinking_led___024root__trace_chg_top_0, vlSelf);
    tracep->addCleanupCb(&Vblinking_led___024root__trace_cleanup, vlSelf);
}

VL_ATTR_COLD void Vblinking_led___024root__trace_full_sub_0(Vblinking_led___024root* vlSelf, VerilatedVcd::Buffer* bufp);

VL_ATTR_COLD void Vblinking_led___024root__trace_full_top_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vblinking_led___024root__trace_full_top_0\n"); );
    // Init
    Vblinking_led___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vblinking_led___024root*>(voidSelf);
    Vblinking_led__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    // Body
    Vblinking_led___024root__trace_full_sub_0((&vlSymsp->TOP), bufp);
}

VL_ATTR_COLD void Vblinking_led___024root__trace_full_sub_0(Vblinking_led___024root* vlSelf, VerilatedVcd::Buffer* bufp) {
    if (false && vlSelf) {}  // Prevent unused
    Vblinking_led__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vblinking_led___024root__trace_full_sub_0\n"); );
    // Init
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode);
    // Body
    bufp->fullBit(oldp+1,(vlSelf->tb__DOT__clk));
    bufp->fullBit(oldp+2,(vlSelf->tb__DOT__led));
    bufp->fullIData(oldp+3,(vlSelf->tb__DOT__uut__DOT__cnt),32);
}
