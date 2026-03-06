# Model Comparison: My Results vs IMF Paper (CR/2023/269)

## Figure 6: Government Spending Shock

### IMF Paper Results (visual estimation from Figure 6)
| Variable | Q1 | Q2 | Q4 | Q8 | Q12 |
|----------|-----|-----|-----|-----|-----|
| **Output Gap** | +0.35% | +0.32% | +0.15% | -0.10% | -0.15% |
| **Inflation** | +0.10% | +0.10% | +0.05% | -0.02% | -0.05% |
| **Reserves** | 0.00 | -0.30 | -0.60 | -0.70 | -0.60 |
| **Risk Premium** | +0.15% | +0.30% | +0.35% | +0.35% | +0.30% |

### My Model Results (1 std dev shock, std=1.0)
| Variable | Q1 | Q2 | Q4 | Q8 | Q12 |
|----------|-----|-----|-----|-----|-----|
| **Output Gap** | +0.37% | +0.39% | +0.15% | -0.15% | -0.26% |
| **Inflation** | +0.09% | +0.10% | +0.04% | -0.04% | -0.07% |
| **Reserves** | 0.00 | -0.49 | -1.00 | -1.13 | -1.13 |
| **Risk Premium** | +0.00% | +0.25% | +0.50% | +0.57% | +0.57% |

### Assessment: FISCAL SHOCK
**Similarities:**
- Output peaks early (Q1-Q2) then turns negative
- Inflation follows output with similar magnitude
- Reserves drain significantly
- Risk premium rises as reserves fall

**Differences:**
- My reserves drain is **stronger** (-1.13 vs -0.70 at Q8)
- My output decline is more persistent
- My risk premium peaks higher (+0.57% vs +0.35%)

**Possible explanations:**
1. My import leakage parameter (f_1 = 0.50) may be too high
2. My reserve persistence (delta_res = 0.95) creates stronger persistence
3. The IMF may use a different shock size or calibration

---

## Figure 4: SA Interest Rate Shock (100bp increase)

### IMF Paper Results (visual estimation)
| Variable | Q1 | Q2 | Q4 | Q8 |
|----------|-----|-----|-----|-----|
| **Output Gap** | -0.15% | -0.20% | -0.15% | -0.08% |
| **Inflation** | -0.15% | -0.20% | -0.15% | -0.05% |
| **Interest Rate** | +1.00% | +0.80% | +0.40% | +0.20% |

### My Model Results (1 std dev shock, std=0.25)
**Note:** My shock is 0.25 std dev. To compare with 100bp, I need to scale by 4x:

| Variable | Q1 | Q2 | Q4 | Q8 |
|----------|-----|-----|-----|-----|
| **Output Gap** | -0.52% | -0.73% | -0.67% | -0.28% |
| **Inflation** | -0.57% | -0.78% | -0.62% | -0.07% |
| **Interest Rate** | +0.72% | +0.24% | -0.14% | +0.24% |

### Assessment: MONETARY SHOCK
**Similarities:**
- Output and inflation decline following rate increase
- Interest rate tracks SA with slight lag

**Differences:**
- My output response is **3-4x larger** than IMF
- My inflation response is **3-4x larger** than IMF
- The IMF shows smoother interest rate persistence

**Possible explanations:**
1. My SA spillover parameter (alpha_3 = 0.40) may be too high
2. My real interest rate effect (alpha_4 = 0.45) may be too strong
3. The IMF model may have different Taylor rule coefficients

---

## Figure 7: Composite Shock (Weaker Demand + Higher US Fed Funds)

### IMF Paper Results (visual estimation)
This is a **negative** demand shock:
| Variable | Q1 | Q2 | Q4 | Q8 | Q12 |
|----------|-----|-----|-----|-----|-----|
| **Output Gap** | -0.30% | -0.50% | -0.40% | -0.20% | -0.10% |
| **Reserves** | +0.20 | +0.10 | -0.10 | -0.15 | -0.10 |
| **Risk Premium** | -0.10% | +0.05% | +0.10% | +0.08% | +0.05% |

### My Model: Global Demand Shock (POSITIVE 1% shock)
**Note:** My shock is positive, so signs are opposite:
| Variable | Q1 | Q2 | Q4 | Q8 | Q12 |
|----------|-----|-----|-----|-----|-----|
| **Output Gap** | +0.07% | +0.12% | +0.14% | +0.04% | -0.01% |
| **Reserves** | 0.00 | +0.01 | +0.08 | +0.19 | +0.18 |
| **Risk Premium** | -0.00% | -0.01% | -0.04% | -0.09% | -0.09% |

### My Model: SA Activity Shock (POSITIVE 1% shock)
| Variable | Q1 | Q2 | Q4 | Q8 | Q12 |
|----------|-----|-----|-----|-----|-----|
| **Output Gap** | +0.73% | +0.92% | +0.78% | +0.58% | +0.59% |
| **Reserves** | 0.00 | +0.19 | +0.82% | +1.51% | +1.52% |
| **Risk Premium** | -0.00% | -0.10% | -0.41% | -0.76% | -0.76% |

### Assessment: DEMAND SHOCKS
**Key Finding:** The IMF's "composite shock" combines multiple shocks. Neither of my single shocks matches it perfectly:

1. **My Global Shock**: Too small (0.14% peak vs 0.50% in IMF)
   - The IMF composite likely includes stronger SA output effects
   - My transmission through SA is too weak

2. **My SA Shock**: Too large and persistent (0.92% peak)
   - More persistent than IMF (0.59% at Q12 vs -0.10%)
   - Reserve accumulation much stronger (1.52 vs -0.10)

**Critical Observation:** The IMF composite shock shows reserves eventually turning **negative** (-0.15 at Q8), while my positive SA shock shows reserves staying strongly **positive**. This suggests:
- The IMF shock includes offsetting elements
- My SA shock parameter (alpha_3 = 0.40) may be too high
- My reserve accumulation dynamics may be too strong

---

## Summary of Discrepancies

| Aspect | My Model | IMF Paper | Assessment |
|--------|----------|-----------|------------|
| **Fiscal offset** | Reserves -1.13 at Q12 | Reserves -0.70 at Q8 | My leakage too strong |
| **Monetary transmission** | Output -0.73% at Q2 | Output -0.20% at Q2 | My spillover too strong |
| **SA output spillover** | 0.92% peak | Not directly shown | May be too high |
| **Reserve dynamics** | High persistence | Faster mean-reversion | delta_res = 0.95 too high? |
| **Risk premium** | -0.76% to +0.57% | -0.10% to +0.35% | My theta_prem = 0.50 too high? |

---

## Recommended Parameter Adjustments

Based on this comparison, consider:

1. **Reduce f_1 (fiscal leakage)**: From 0.50 to 0.35
2. **Reduce alpha_3 (SA spillover)**: From 0.40 to 0.30
3. **Reduce delta_res (reserve persistence)**: From 0.95 to 0.90
4. **Reduce theta_prem (premium sensitivity)**: From 0.50 to 0.35

These adjustments would bring the model closer to IMF results while maintaining economic logic.
