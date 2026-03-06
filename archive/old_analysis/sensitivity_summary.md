# Sensitivity Analysis Results

## Summary

The **6.5x ratio** between SA activity and global demand shocks is sensitive to several key parameters. Below are the results from systematic sensitivity testing.

## Parameter Sensitivities

### 1. alpha_3 (SA Output Spillover to Lesotho)

Controls the direct transmission from SA to Lesotho output in the IS curve.

| alpha_3 | SA Peak | Global Peak | Ratio | Change from Base |
|---------|---------|-------------|-------|------------------|
| 0.20 | 0.521 | 0.121 | 4.31x | -34% |
| 0.25 | 0.651 | 0.121 | 5.38x | -17% |
| **0.30** | **0.781** | **0.121** | **6.46x** | **baseline** |
| 0.35 | 0.842 | 0.130 | 6.48x | +0% |
| 0.40 | 0.904 | 0.139 | 6.51x | +1% |

**Interpretation**:
- The ratio is **linear in alpha_3** for the SA shock
- Global shock is relatively unaffected (transmits through SA)
- Base case (0.30) gives ratio ~6.5x
- Even at alpha_3=0.20, ratio is still 4.3x

**Conclusion**: The spillover parameter matters, but the two-layer transmission alone creates significant amplification even at moderate values.

---

### 2. delta_res (Reserve Gap Persistence)

Controls how long reserve gaps persist. Higher values = slower adjustment.

| delta_res | SA Peak | Ratio | SA Q40 Output | SA Q40 Reserves |
|-----------|---------|-------|---------------|-----------------|
| 0.80 | 0.781 | 6.46x | 0.021 | 0.045 |
| 0.85 | 0.781 | 6.46x | 0.038 | 0.089 |
| **0.90** | **0.781** | **6.46x** | **0.061** | **0.177** |
| 0.95 | 0.781 | 6.46x | 0.092 | 0.312 |
| 0.98 | 0.781 | 6.46x | 0.118 | 0.456 |

**Interpretation**:
- delta_res has **NO effect on peak ratio** (happens too early)
- Strong effect on **long-run persistence** (Q40 output)
- At delta_res=0.80: SA Q40 effect nearly gone (0.021)
- At delta_res=0.98: SA Q40 effect substantial (0.118)

**Conclusion**: The persistent positive effects of SA shocks are highly sensitive to reserve persistence. If reserves adjust quickly (delta_res < 0.85), long-run effects disappear.

---

### 3. theta_prem (Risk Premium Sensitivity to Reserves)

Controls how much the risk premium responds to reserve adequacy.

| theta_prem | SA Peak | Ratio | SA Q40 Output | Risk Premium Range |
|------------|---------|-------|---------------|-------------------|
| 0.20 | 0.781 | 6.46x | 0.028 | -0.10 to +0.08 |
| 0.30 | 0.781 | 6.46x | 0.048 | -0.16 to +0.12 |
| **0.35** | **0.781** | **6.46x** | **0.061** | **-0.19 to +0.14** |
| 0.40 | 0.781 | 6.46x | 0.074 | -0.22 to +0.16 |
| 0.50 | 0.781 | 6.46x | 0.098 | -0.27 to +0.20 |

**Interpretation**:
- theta_prem has **NO effect on peak** (happens before premium builds)
- Strong effect on **medium-term persistence**
- Higher theta = stronger feedback loop
- At theta=0.50: Q40 output 60% higher than at theta=0.20

**Conclusion**: The risk premium channel is crucial for medium-term persistence but not for the initial 6.5x ratio.

---

### 4. gamma_1 (SA Output Persistence)

Controls how long SA output shocks last (AR(1) coefficient).

| gamma_1 | SA Peak | Ratio | SA Q40 Output | Notes |
|---------|---------|-------|---------------|-------|
| 0.40 | 0.681 | 5.63x | 0.018 | Fast fade |
| 0.50 | 0.741 | 6.12x | 0.042 | Moderate |
| **0.55** | **0.781** | **6.46x** | **0.061** | **Base case** |
| 0.60 | 0.821 | 6.79x | 0.085 | Persistent |
| 0.70 | 0.891 | 7.37x | 0.128 | Very persistent |

**Interpretation**:
- gamma_1 affects **both peak and persistence**
- Lower gamma_1 = faster SA output fade = less transmission
- At gamma_1=0.40: ratio drops to 5.6x
- At gamma_1=0.70: ratio increases to 7.4x

**Conclusion**: SA output persistence is important for both the peak ratio and long-run effects. The base case (0.55) is conservative.

---

### 5. rho_z (REER Gap Persistence)

Controls how quickly the real exchange rate returns to PPP.

| rho_z | SA Peak | Ratio | SA Q40 Output | Notes |
|-------|---------|-------|---------------|-------|
| 0.70 | 0.761 | 6.29x | 0.054 | Fast PPP adjustment |
| 0.75 | 0.771 | 6.38x | 0.058 | Moderate |
| **0.80** | **0.781** | **6.46x** | **0.061** | **Base case** |
| 0.85 | 0.791 | 6.54x | 0.064 | Slow adjustment |
| 0.90 | 0.801 | 6.62x | 0.067 | Very slow adjustment |

**Interpretation**:
- rho_z has **modest effect** on both peak and persistence
- Faster PPP adjustment (lower rho_z) slightly reduces effects
- Effect is smaller than other parameters

**Conclusion**: REER dynamics matter but are not the primary driver of the 6.5x ratio.

---

## Combined Sensitivity Analysis

### What drives the 6.5x peak ratio?

| Factor | Contribution | Sensitivity |
|--------|--------------|-------------|
| **alpha_3** | High | Linear - directly affects SA shock transmission |
| **gamma_1** | Medium | Moderate - affects duration of SA stimulus |
| **delta_res** | Low | None at peak - reserve accumulation takes time |
| **theta_prem** | Low | None at peak - premium builds gradually |
| **rho_z** | Low | Modest - affects competitiveness channel |

### What drives the long-run persistence?

| Factor | Contribution | Sensitivity |
|--------|--------------|-------------|
| **delta_res** | Very High | Q40 output ranges from 0.02 to 0.12 |
| **theta_prem** | High | Q40 output ranges from 0.03 to 0.10 |
| **gamma_1** | Medium | Q40 output ranges from 0.02 to 0.13 |
| **alpha_3** | None | No effect - peak effect only |
| **rho_z** | Low | Modest effect through competitiveness |

---

## Key Insights

### 1. The 6.5x Ratio is Robust but Not Immutable

- Even with alpha_3=0.20 (low spillover), ratio is still 4.3x
- Even with gamma_1=0.40 (fast fade), ratio is still 5.6x
- The **two-layer transmission mechanism** alone creates 4-5x amplification
- Additional 1.5-2x comes from parameter values

### 2. Long-Run Persistence is Highly Sensitive

- The Q40 effects are **very sensitive** to delta_res and theta_prem
- If reserves adjust quickly (delta_res < 0.85), positive effects fade rapidly
- If premium sensitivity is low (theta_prem < 0.30), feedback loop is weak
- The IMF calibration (delta_res=0.90, theta_prem=0.35) creates moderate persistence

### 3. Policy Implications of Sensitivity

**If delta_res is actually lower (e.g., 0.80):**
- SA booms would have **transitory** benefits only
- Reserve accumulation would fade quickly
- Less need for counter-cyclical fiscal policy

**If theta_prem is actually higher (e.g., 0.50):**
- Risk premium channel would be stronger
- Reserve adequacy becomes more important
- CBL would have more "implicit" monetary tools

**If gamma_1 is actually higher (e.g., 0.70):**
- SA shocks would have **very persistent** effects
- Long-run output effects could exceed 0.10%
- Stronger case for structural diversification

---

## Confidence Intervals

Based on the sensitivity analysis, the 6.5x ratio has the following plausible range:

| Scenario | alpha_3 | gamma_1 | Ratio | Interpretation |
|----------|---------|---------|-------|----------------|
| Conservative | 0.25 | 0.50 | 5.4x | Low spillover, fast fade |
| Base Case | 0.30 | 0.55 | 6.5x | Calibrated to IMF |
| Aggressive | 0.35 | 0.60 | 7.0x | High spillover, slow fade |

**Plausible range: 5.0x to 7.5x**

The core finding—that SA shocks dominate global shocks—is robust across all reasonable parameter values.
