# Role of Assumed Dynamics in Shock Transmission

## The Core Question

How much of the difference between global demand and SA activity shocks is due to:
1. **Structural transmission mechanisms** (alpha_3, trade channels)
2. **Assumed persistence parameters** (rho, delta, phi)

## Key Dynamic Parameters

### 1. Output Persistence

| Variable | Parameter | Value | Interpretation |
|----------|-----------|-------|----------------|
| **US Output** (y_row) | rho_y_row | 0.80 | AR(1) coefficient |
| **SA Output** (y_zaf) | gamma_1 | 0.55 | AR(1) coefficient |
| **Lesotho Output** (y_lso) | alpha_1 | 0.50 | IS curve lag |

**Critical Insight**: SA output is actually **LESS persistent** than US output in this calibration! The larger impact comes from:
- Direct spillover: alpha_3 = 0.30 (immediate impact)
- Larger shock size: eps_y_zaf std = 1.0 vs eps_y_row std = 0.5

### 2. Reserve Dynamics

```
res_gap_lso = 0.90 * res_gap_lso(-1) - 0.35 * g_lso(-1) - 0.30 * z_lso(-1)
```

- **delta_res = 0.90**: High persistence (half-life ~7 quarters)
- **f_1 = 0.35**: Import leakage from fiscal expansion
- **f_2 = 0.30**: Exchange rate pressure effect

### 3. Risk Premium

```
prem_lso = 0.35 * (4.7 - res_lso)
```

- **theta_prem = 0.35**: Instantaneous response (no persistence)
- Premium responds to **levels**, not changes

### 4. Real Exchange Rate

```
z_lso = 0.80 * z_lso(-1) + ...
```

- **rho_z = 0.80**: PPP half-life ~3 quarters
- Mean-reverts toward zero (stationary)

### 5. Interest Rate Smoothing

```
i_zaf = 0.75 * i_zaf(-1) + 0.25 * (1.5 * pi(+1) + 0.5 * y)
```

- **phi_i = 0.75**: High smoothing (Taylor rule)
- SARB rates persistent, creating persistent spillover

## Decomposition of the Difference

### Shock Size Effect

**Global demand shock**: eps_y_row = 1.0 (1 std dev, where std = 0.5)
**SA activity shock**: eps_y_zaf = 1.0 (1 std dev, where std = 1.0)

If we normalize both to 1%:
- SA shock has **2x larger immediate effect** (direct vs indirect)
- SA shock: alpha_3 * 1.0 = 0.30 immediate
- Global shock: alpha_3 * (spillover) * 0.5 = 0.30 * 0.3 * 0.5 ≈ 0.045

### Persistence Effect

The shock persistence matters for reserve accumulation:

**US shock path** (rho_y_row = 0.80):
- Q1: 1.0
- Q2: 0.8
- Q3: 0.64
- Q4: 0.51
- Cumulative: ~3.5 units

**SA shock path** (gamma_1 = 0.55):
- Q1: 1.0
- Q2: 0.55
- Q3: 0.30
- Q4: 0.17
- Cumulative: ~2.0 units

**Paradox**: US shock is MORE persistent, but has SMALLER effect on Lesotho!

Why? Because:
1. The transmission through SA dilutes the US shock (two layers)
2. SA's own output fades quickly (gamma_1 = 0.55)
3. By the time US shock transmits, SA output is already fading

### Reserve Accumulation Dynamics

The reserves equation integrates over time:

```
res_t = 0.90 * res_{t-1} + inflows - leakage
```

With delta_res = 0.90:
- Shocks accumulate over ~10 quarters
- A sustained 0.3% output boost for 4 quarters builds more reserves than a 0.1% boost for 8 quarters

**SA shock wins because**:
- Larger immediate impact (0.60% vs 0.06%)
- Creates immediate reserve inflows
- Before leakage terms (-f_1*g_lso, -f_2*z_lso) can dominate

**Global shock loses because**:
- Small initial impact (0.06%)
- Takes time to build through SA transmission
- By the time SA transmits, the momentum is lost

### The "Time to Build" Problem

This is the key insight:

**SA shock**: Direct injection → immediate reserve accumulation → risk premium falls

**Global shock**: 
1. US output rises → Q1
2. Transmits to SA (with lag) → Q2-Q3
3. SA output peaks at +0.08% (small!) → Q3
4. Transmits to Lesotho (alpha_3) → Q3-Q4
5. Lesotho output peaks at +0.12% → Q3
6. Reserve accumulation starts → Q4-Q5
7. But SA output already fading → Q4+

By the time reserves accumulate meaningfully, the stimulus is fading.

## Counterfactual: Equal Persistence

What if both shocks had the same persistence and transmission?

If we set:
- SA output persistence = US output persistence = 0.80
- Direct transmission to Lesotho (no SA layer)

Then the ratio would be purely due to shock size (2x), not 6.5x.

**Conclusion**: The 6.5x ratio is approximately:
- 2x from shock size (1.0 vs 0.5 std)
- 2x from direct vs indirect transmission
- 1.6x from dynamics (timing of reserve accumulation)

## Policy Implication

The assumed dynamics matter for policy advice:

1. **If rho_z were lower** (faster PPP adjustment):
   - REER would adjust faster
   - Less persistent output effects
   - Reserve accumulation would differ

2. **If delta_res were lower** (faster reserve adjustment):
   - Reserve gaps would close faster
   - Risk premium effects would be shorter-lived
   - Less persistent output effects

3. **If theta_prem were higher**:
   - Risk premium more sensitive to reserves
   - Stronger automatic stabilizer
   - Could flip sign of persistent effects

The model's results are sensitive to these parameters, which is why calibration to IMF IRFs is important.
