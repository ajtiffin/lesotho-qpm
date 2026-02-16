## Where commodity prices enter the SARB QPM (WP/17/01)

Commodity prices show up in **two distinct places** in the model:

### 1) **Export commodity prices → “commodity terms of trade” → output gap (demand)**
In the **IS curve for the output gap**, the model includes the deviation of South Africa’s **real export commodity price index** from trend:
\[
\hat y_t
= a_1 E_t \hat y_{t+1} + a_2 \hat y_{t-1}
- a_3\big[a_4\,\hat{lr}_t + (1-a_4)(-\hat z_t)\big]
+ a_5 \hat y_t^\* + a_6\, d rcom_t + \varepsilon^{\hat y}_t
\]
(Equation (1) in the paper; \(a_6=0.01\))

- \(rcom_t\) is “**international commodity prices** … (deflated by foreign CPI)” (Appendix C variable list).
- \(d rcom_t\) is the **(real) export commodity price index deviation from trend** (the paper refers to this as the *commodity terms-of-trade effect*; see also the output gap decompositions where it’s labelled “Terms of trade”, Figure 17a).

So commodity prices feed into the model as an **exogenous terms-of-trade/demand driver of the output gap**.

### 2) **Global commodity prices (oil, food) → non-core CPI components directly**
Commodity prices also enter **headline inflation mechanically** through the **non-core CPI blocks**:

- **Food CPI inflation** depends on **international food prices** and the exchange rate:
  \[
  \pi^{food}_t = \dots + b_{32}(\Delta food_t + \Delta s_t) + \dots
  \]
  (Equation (13))

- **Fuel (petrol) inflation** is tied to **oil prices** and the exchange rate via the Basic Fuel Price (BFP):
  \[
  \Delta bfp_t = \Delta oil_t + \Delta s_t + \varepsilon^{\Delta bfp}
  \]
  (Equation (20)), which then feeds petrol prices and \(\pi^{petrol}_t\) (Equations (17)–(21)).

These are the model’s **direct CPI pass-through** channels for commodity prices—but they are specifically **food and oil**, not metals.

---

## How a *positive commodity price shock* (e.g., gold) would be reflected

It depends on which “commodity price” you mean in this paper’s structure:

### A) If it’s a **gold/metal price increase affecting SA’s export commodity index** (the “terms of trade” channel)
In the QPM, that shows up as a **positive shock to \(d rcom_t\)** (grouped under “Commodity” shocks in Appendix B: \( \varepsilon^{d rcom}_t\)).

**Model-implied reflection:**
1. **\(d rcom_t \uparrow\)** (export commodity prices above trend)
2. **Output gap \(\hat y_t \uparrow\)** via \(a_6 d rcom_t\) in the IS curve (Eq. 1)  
   → in Figure 17a you’d see a positive bar under **“Terms of trade”**; in Figure 17b a positive contribution under **“Commodity”**.
3. Higher \(\hat y_t\) raises **real marginal costs** in the Phillips curves (services/core goods/food), putting **upward pressure on (especially core) inflation** over time (through the output-gap term embedded in \(rmc\)).
4. The **Taylor rule** reacts to higher forecast inflation / positive output gap, so **repo \(i_t\uparrow\)** (Eq. 31).
5. Higher \(i_t\) tends to **appreciate the currency** via the UIP block (Eqs. 29–30), which then partially offsets inflation through cheaper imports, but also feeds back to demand through the exchange-rate gap term in the IS curve.

**Key point for gold specifically:** there is **no direct “gold price → CPI” equation** here; gold primarily matters insofar as it moves the **export commodity price index / terms of trade**, and then works **indirectly** through activity, inflation, and policy.

### B) If it’s a **global oil or food price shock** (the direct CPI channel)
A positive shock would appear as:
- \( \Delta oil_t \uparrow\) → **petrol inflation up quickly** (via BFP, Eqs. 20–21 → petrol, Eq. 17)
- \( \Delta food_t \uparrow\) → **food inflation up** (Eq. 13)

That lifts **headline CPI** (via the CPI aggregation, Eq. 3), and monetary policy responds through the Taylor rule.

---

If you tell me whether you mean (i) **gold as an export-price/terms-of-trade shock** or (ii) **gold as a proxy for global risk/financial conditions**, I can map it to the exact shock you’d use in this QPM (in this paper, gold most naturally fits (i) via \(d rcom_t\), not via CPI).

### In this paper, “gold as an export price shock” maps to the **export commodity price index gap** \(d rcom_t\)

The model brings commodity prices in mainly through the **IS (output gap) equation** as a *commodity terms-of-trade effect*:

- The output gap \(\hat y_t\) depends on (among other things) the deviation of South Africa’s **real export commodity price index** from trend, \(d rcom_t\) (their words: “deviation of South Africa’s export commodity price index (real) from its trend value”):
\[
\hat y_t
= a_1 E_t \hat y_{t+1} + a_2 \hat y_{t-1}
- a_3\big[a_4 \hat{lr}_t + (1-a_4)(-\hat z_t)\big]
+ a_5 \hat y_t^\*
+ a_6\, d rcom_t
+ \varepsilon^{\hat y}_t,
\]
with \(a_6=0.01\). (Eq. (1))

- “Real” commodity prices are defined as **international commodity prices deflated by foreign CPI** (\(rcom\); Appendix C), and the **commodity price index** is a *weighted export commodities* index (Appendix A). The shock decomposition groups include a specific **commodity shock** \(\varepsilon^{d rcom}_t\) (Table A2).

So: a gold export price shock is represented in this framework as a **positive shock to \(d rcom_t\)** (i.e., export commodity prices above their trend, in real terms).

---

## What a **positive gold/export price shock** looks like in the QPM dynamics

Interpreting “gold up” as \(d rcom_t \uparrow\) (or \(\varepsilon^{d rcom}_t>0\)):

1. **Direct impact (demand channel):**  
   \(d rcom_t \uparrow \Rightarrow \hat y_t \uparrow\) through \(a_6 d rcom_t\) in the IS curve (Eq. 1).  
   In the paper’s historical output-gap decomposition, this shows up under **“Terms of trade”** in the *equation decomposition* (Figure 17a) and under **“Commodity”** in the *shock decomposition* (Figure 17b).

2. **Inflation pressures (indirect, via activity and marginal costs):**  
   A higher \(\hat y_t\) raises real marginal costs in the Phillips-curve blocks (services/core goods/food marginal cost terms depend on \(\hat y_t\); e.g., Eqs. (8), (12), (14)), putting **upward pressure on core inflation** over time.

3. **Policy response:**  
   Higher forecast inflation and a more positive output gap lead the **Taylor rule** to raise the policy rate \(i_t\) (Eq. (31)).

4. **Exchange-rate feedback (endogenous):**  
   Higher domestic rates (relative to foreign, risk-adjusted) tend to **appreciate the currency** through the modified UIP block (Eqs. (29)–(30)), which then:
   - dampens inflation via import-price inflation and exchange-rate terms in price equations, and
   - affects demand through the exchange-rate term in the IS curve.

### Important nuance for gold specifically
The paper does **not** have a “gold price \(\rightarrow\) CPI” mechanical pass-through equation (those direct commodity-to-CPI blocks are for **oil/petrol** and **food**). For gold-as-export-price, the effect is primarily the **terms-of-trade/demand** channel via \(d rcom_t\), with inflation and the exchange rate responding **indirectly** through the model’s general equilibrium links.

If you want, I can translate this into a one-line "shock implementation": set \(\varepsilon^{d rcom}_t\) to a positive impulse (size you choose), and read the resulting IRFs of \(\hat y_t\), \(\pi^{cpi}_t\), \(i_t\), and \(\hat z_t\).

---

## Implementation in Lesotho Model v2: Consistency with SARB Framework

### Key Correction Made

**Initial (incorrect) implementation:**
```matlab
// Commodity prices (NEW in v2)
rcom            // Real commodity price index (terms of trade)

// SA IS Curve
y_zaf = ... + gamma_6 * rcom + eps_y_zaf;  // WRONG: uses level

// Commodity equation
rcom = rcom(-1) + pi_com - pi_row;  // Unit root process
```

**Problem:** Using `rcom` (level) in the IS curve creates **non-stationarity**. Since `rcom` follows a random walk, a commodity price shock would permanently shift the SA output gap, and IRFs would never return to steady state.

---

### Correct Implementation (Trend-Deviation Decomposition)

**New variables:**
```matlab
rcom            // Real commodity price level (trend + deviation)
rcom_bar        // Trend component (non-stationary, random walk)
d_rcom          // Deviation from trend (stationary, AR(1)) - enters IS curve
```

**Equations:**
```matlab
// 1. Real commodity price decomposition
rcom = rcom_bar + d_rcom;

// 2. Trend component (random walk - captures super-cycles)
rcom_bar = rcom_bar(-1) + eps_rcom_trend;

// 3. Deviation/Gap component (AR(1) - stationary cycles)
d_rcom = rho_d_rcom * d_rcom(-1) + eps_com;

// 4. SA IS Curve - uses d_rcom (gap), NOT rcom (level)
y_zaf = gamma_1*y_zaf(-1) + gamma_2*y_zaf(+1)
      - gamma_3*r_zaf + gamma_4*z_zaf + gamma_5*y_row
      + gamma_6*d_rcom          // CORRECT: deviation from trend
      + eps_y_zaf;
```

**Shocks:**
- `eps_com`: Cyclical commodity price shock (e.g., gold boom) → affects `d_rcom` → enters IS curve
- `eps_rcom_trend`: Trend commodity price shock (e.g., long-term structural shift) → affects `rcom_bar` → does NOT directly affect output gap

---

### Consistency with SARB WP1701

| Aspect | SARB Model | Lesotho v2 Implementation | Status |
|--------|------------|---------------------------|--------|
| **Variable entering IS curve** | \(d\,rcom_t\) (deviation from trend) | `d_rcom` | ✅ Consistent |
| **Coefficient** | \(a_6 = 0.01\) | `gamma_6 = 0.01` | ✅ Consistent |
| **Definition of rcom** | International commodity prices deflated by foreign CPI | `rcom = rcom_bar + d_rcom` | ✅ Consistent |
| **Trend treatment** | Implicit trend extracted | Explicit `rcom_bar` random walk | ✅ Equivalent |
| **Stationarity** | Gap is stationary | `d_rcom` is AR(1), stationary | ✅ Consistent |
| **CPI pass-through** | Oil → fuel prices; Food → food CPI | `pi_oil`, `pi_food` in Phillips curve | ✅ Consistent |

---

### Economic Interpretation

**What the model captures:**
1. **Cyclical gold booms** (`eps_com` shock to `d_rcom`):
   - Short-term increase in SA export commodity prices above trend
   - Boosts SA output gap via IS curve (with coefficient 0.01)
   - IRFs return to steady state as `d_rcom` mean-reverts

2. **Long-term commodity super-cycles** (`eps_rcom_trend` shock to `rcom_bar`):
   - Permanent shift in commodity price level
   - Does NOT directly affect SA output gap (only deviation does)
   - Affects Lesotho through other channels (if any)

3. **No direct gold → CPI link**: Gold price changes work through the **demand channel** (boosting SA output), which then affects inflation indirectly via Phillips curve dynamics.

---

### Key Insight

The critical distinction is between:
- **Level** (`rcom`): Non-stationary, includes trends, should NOT enter stationary IS curve
- **Gap/Deviation** (`d_rcom`): Stationary, mean-reverting, enters IS curve

This decomposition is essential for proper QPM modeling where:
- Output gaps are stationary (mean-zero) by definition
- IRFs return to steady state
- Trend and cyclical components can be analyzed separately