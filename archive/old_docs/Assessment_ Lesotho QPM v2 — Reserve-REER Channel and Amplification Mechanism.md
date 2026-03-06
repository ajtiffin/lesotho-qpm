

# Assessment: Lesotho QPM v2 — The Reserve Channel, Amplification Mechanism, and Needed Modifications

## 1. Is the Kimi Report an Accurate Outline of the Model?

**Broadly yes, with some caveats.** The report correctly identifies:

- The three-block structure (Lesotho / SA / RoW)
- The new commodity price channel (trend-gap decomposition, $\gamma_6 = 0.01$ from SARB)
- The reserve-risk premium feedback loop as the key amplifier
- The sign convention ($\hat{z}^{LSO} > 0$ = depreciation, $\hat{z}^{LSO} < 0$ = appreciation)

**However, the report's narrative about "CBL intervention" is an interpretive overlay, not what the model actually specifies.** The Dynare code contains no intervention decision rule — it simply has the reduced-form equation:

$$
\widehat{res}^{LSO}_t = \delta \, \widehat{res}^{LSO}_{t-1} - f_1 \, G^{LSO}_{t-1} - f_2 \, \hat{z}^{LSO}_{t-1} + \varepsilon^{res}_t
$$

The report *interprets* $-f_2 \hat{z}^{LSO}_{t-1}$ as "CBL buys foreign currency to prevent excessive appreciation," but the equation is really just a reduced-form relationship between the REER gap and reserves. **This distinction matters for the diagnosis below.**

---

## 2. Your Core Concern: Does Appreciation Automatically Add to Reserves? Does This Make Economic Sense?

### 2.1 What the Model Says

The key equation (Eq. 7 in the Dynare code):

$$
\widehat{res}^{LSO}_t = 0.90 \, \widehat{res}^{LSO}_{t-1} - 0.35 \, G^{LSO}_{t-1} - 0.30 \, \hat{z}^{LSO}_{t-1} + \varepsilon^{res}_t
$$

When the Rand/Loti appreciates ($\hat{z}^{LSO} < 0$), the term $-f_2 \times (\text{negative}) = \text{positive}$, so **reserves mechanically increase**.

Combined with the risk premium equation:

$$
\widehat{prem}^{LSO}_t = -\theta \, \widehat{res\_gap}^{LSO}_t + \varepsilon^{prem}_t
$$

(since $prem = \theta(res\_bar - res) = -\theta \cdot res\_gap$), higher reserves → lower premium → lower domestic interest rate → further output stimulus.

### 2.2 The Government Spending Channel: Economically Sensible ✓

The $-f_1 G^{LSO}_{t-1}$ term makes clear economic sense for Lesotho:

- Government spending in Lesotho has a high import content (much comes from SA)
- Fiscal expansion → import surge → FX outflows → reserves decline
- This is well-documented by the IMF for Lesotho's balance of payments

**This channel is the model's strongest feature** — it captures the key policy concern that fiscal profligacy drains reserves and threatens the peg.

### 2.3 The REER-Reserves Channel: **Problematic** ✗

The $-f_2 \hat{z}^{LSO}_{t-1}$ term is where your instinct is right to be concerned. The logic chain for a commodity price shock is:

1. Gold price up → SA output up (small, via $\gamma_6 = 0.01$)
2. SARB tightens slightly → Rand appreciates via UIP
3. Loti appreciates in lockstep (peg: $s^{LSO} = s^{ZAF}$)
4. $\hat{z}^{LSO} < 0$ → **reserves automatically accumulate** (via $-f_2$)
5. Higher reserves → lower risk premium → lower Lesotho interest rate
6. Easier monetary conditions → Lesotho output booms **3× more than SA**

**The fundamental problem: Steps 4-6 invert the normal economics of a currency peg for a country like Lesotho.**

### 2.4 Why This Doesn't Make Sense for Lesotho

#### Problem A: Lesotho is not an FX-intervening central bank in the usual sense

Under the Common Monetary Area (CMA), the Loti is pegged 1:1 to the Rand. The Central Bank of Lesotho (CBL) doesn't need to "intervene" in the FX market to maintain this peg against the Rand — the peg is automatic within the CMA. When the Rand appreciates against the USD, the Loti appreciates against the USD automatically, without any reserve operations.

Lesotho's reserves are **not driven by FX intervention** in the way they would be for (say) the Czech National Bank or the Hong Kong Monetary Authority. Instead, they are driven primarily by:

- **SACU revenue transfers** (fiscal inflows from the Southern African Customs Union)
- **Trade balance dynamics** (imports from SA drain reserves)
- **Capital flows** (remittances, FDI)

An appreciation of the Rand/Loti against the USD does **not** create a reserve accumulation mechanism for CBL in the way the model implies.

#### Problem B: The appreciation channel runs the wrong way for Lesotho's trade

When the Loti appreciates in real terms, Lesotho's exports (mainly textiles to the US under AGOA, and diamonds) become **less competitive**. This tends to **worsen** the current account, which should **drain** reserves, not accumulate them. The model has the sign backwards for Lesotho's specific circumstances.

#### Problem C: The amplification magnitude is implausible

A 3% commodity price gap shock (tiny, temporary) produces:
- SA output: +0.03% peak
- Lesotho output: +0.097% peak — **3.2× amplification**
- Lesotho reserves: +0.19 months of imports at Q10
- Risk premium: −0.052pp

For context, Lesotho's target reserves are 4.7 months of imports. A tiny SA commodity blip generating nearly +0.2 months of reserve accumulation (≈4% of total) is unreasonable.

#### Problem D: The sign should likely be reversed or the channel removed

For Lesotho, appreciation pressure more plausibly **reduces** reserves because:
- Stronger Loti → cheaper imports → higher import demand → FX outflows
- Stronger Loti → less competitive exports → lower export revenue → FX outflows
- Stronger Loti → Lesotho workers' remittances from SA buy fewer Maloti when converted

If anything, $f_2$ should have the **opposite sign** (or the $-f_2$ should be $+f_2$), or the term should be dropped entirely.

---

## 3. Does the Model Need to Be Modified?

**Yes.** I recommend the following changes, in order of priority:

### Modification 1: Remove or Reverse the REER Term in the Reserves Equation

**Option A (Preferred — Remove):**

Replace:
```
res_gap_lso = delta_res * res_gap_lso(-1)
            - f_1 * g_lso(-1)
            - f_2 * z_lso(-1)
            + eps_res_lso;
```

With:
```
res_gap_lso = delta_res * res_gap_lso(-1)
            - f_1 * g_lso(-1)
            + eps_res_lso;
```

**Rationale:** The fiscal channel ($f_1$) is the economically important one for Lesotho. The REER channel doesn't correspond to an identifiable reserve-management mechanism under the CMA. This approach is clean and transparent.

**Option B (Alternative — link reserves to the trade balance / current account):**

If you want reserves to respond to external conditions, a better specification would link reserves to:
- Lesotho's output gap (higher domestic demand → more imports → reserve drain)
- SA's output gap directly (SA demand for Lesotho exports → reserve inflows)

For example:
```
res_gap_lso = delta_res * res_gap_lso(-1)
            - f_1 * g_lso(-1)
            - f_3 * y_lso(-1)        // demand-driven import leakage
            + f_4 * y_zaf(-1)        // SA demand for Lesotho exports
            + eps_res_lso;
```

This would give you a BOP-consistent reserve equation where:
- Lesotho booming → imports rise → reserves fall (sensible)
- SA booming → demand for Lesotho goods → reserves rise (sensible)
- Government spending → import leakage → reserves fall (already captured)

### Modification 2: Consider Adding SACU Revenue Channel (Longer Term)

Lesotho's reserves are heavily influenced by SACU customs revenue transfers, which are themselves a function of SA's economic performance (customs revenue rises when SA imports more). This could be modelled as:

$$
\widehat{res}^{LSO}_t = \delta \, \widehat{res}^{LSO}_{t-1} - f_1 G^{LSO}_{t-1} + f_5 \hat{y}^{ZAF}_{t-1} + \varepsilon^{res}_t
$$

where $f_5 \hat{y}^{ZAF}$ captures the fact that when SA economy grows, SACU revenues rise, and Lesotho receives larger transfers. This would preserve a positive spillover from SA to Lesotho reserves **through the correct channel** (fiscal transfers, not exchange rate mechanics).

### Modification 3: Validate the Risk Premium Sensitivity

Even after fixing the reserves equation, check whether $\theta_{prem} = 0.35$ is reasonable. This parameter means that a 1-month deviation in reserves produces a 35bp change in the risk premium. Given Lesotho's CMA membership (which provides an implicit guarantee from SA), this may be too large.

---

## 4. Summary Table

| Feature | Report's Claim | Dynare Code | Economic Assessment |
|---------|---------------|-------------|-------------------|
| Commodity → SA IS curve | ✓ Correct | $\gamma_6 \cdot d\_rcom$ in SA IS | Sensible, from SARB |
| Trend-gap decomposition | ✓ Correct | AR(1) gap + RW trend | Sensible |
| Fiscal → reserves drain | ✓ Correct | $-f_1 \cdot G^{LSO}_{t-1}$ | **Economically sound** |
| REER appreciation → reserves up | ✓ Correctly described | $-f_2 \cdot \hat{z}^{LSO}_{t-1}$ | **Economically questionable** |
| 3× amplification | ✓ Correctly described | Via reserve-premium loop | **Artifact of problematic $f_2$ channel** |
| "CBL intervention" narrative | Interpretive overlay | No intervention rule in code | **Misleading for CMA context** |

---

## 5. Bottom Line

**Your instinct is correct.** The model's REER-reserves channel ($-f_2 \hat{z}^{LSO}$) creates an economically implausible amplification mechanism where any positive shock to South Africa "automatically" builds Lesotho's reserves and eases its financial conditions. This doesn't reflect how the CMA actually works. The government spending channel ($-f_1 G^{LSO}$) is the correctly specified and economically meaningful part of the reserves equation. The REER term should be removed or replaced with a more structurally appropriate specification (e.g., trade-balance-linked or SACU-revenue-linked).

Let me re-examine the Dynare code and the model structure carefully to give you precise guidance on calibration and the fiscal feedback question.
Now let me read the Dynare code more carefully, focusing on the exact equations and trace the full transmission:
Now let me look up some empirical data on Lesotho's economy to ground my parameter recommendations:
Now let me do some computations to derive sensible parameter values and verify the fiscal feedback mechanism under Option B:
### 1) What should \(f_3\) and \(f_4\) be in Option B?

Recall Option B was to replace the “REER → reserves” term with something closer to a reduced-form balance-of-payments logic, e.g.

\[
res\_gap^{LSO}_t
= \delta\,res\_gap^{LSO}_{t-1}
- f_1 g^{LSO}_{t-1}
- f_3 y^{LSO}_{t-1}
+ f_4 y^{ZAF}_{t-1}
+ \varepsilon^{res}_t.
\]

There is **no single “correct” calibration** for \(f_3,f_4\) without data-fitting, because your reserves equation is not derived from an accounting identity; it’s a semi-structural closure. So the right way to set them is: pick target *IRFs* (or second moments) that you think are plausible for Lesotho, and back out values.

That said, you can choose **economically disciplined starting values** using two principles:

#### Principle A: “Domestic demand pressure drains reserves”
Lesotho is extremely import-dependent (especially from SA), so when \(y_{LSO}\) is above potential, imports rise and reserves tend to fall. That means:

- \(f_3 > 0\) (because it enters as \(- f_3 y_{LSO}\)).

**A sensible starting range:**  
- \(f_3 \in [0.05, 0.20]\)

Interpretation: a 1pp positive output gap sustained for a quarter reduces the reserves gap next quarter by 0.05–0.20 “months of imports” (before persistence). Given reserves are around ~4–5 months in steady state, values above ~0.2 can make reserves unrealistically volatile unless shocks are tiny.

#### Principle B: “South African activity can improve Lesotho’s reserves, but not hugely”
SA expansions can raise Lesotho reserves through things like:
- SACU revenues (important in practice),
- some export demand,
- remittance/transfer dynamics.

So:
- \(f_4 > 0\).

But because your model’s SA output gap responses are typically small (e.g., the commodity shock gives SA peak output gap around 0.03 in the report), \(f_4\) would need to be quite large to generate big reserve moves. That’s a warning sign: you *don’t want* the reserves channel to become a new “amplifier” that recreates the same pathology as the REER term.

**A sensible starting range:**
- \(f_4 \in [0.02, 0.10]\)

#### A concrete “baseline calibration” to start simulations
If you want one specific proposal to implement and test first:

- **\(f_3 = 0.10\)**
- **\(f_4 = 0.05\)**

Why this pair?
- It makes domestic overheating a meaningful reserve drain (which is consistent with the fiscal/import-leakage narrative you already trust).
- It allows SA conditions to matter, but keeps it secondary unless SA shocks are large.

#### Quick diagnostic you should run after choosing \(f_3,f_4\)
Simulate two scenarios and check signs/magnitudes:

1) **Pure Lesotho demand shock** (\(\varepsilon^{y,LSO}\)):  
You should see \(y_{LSO}\uparrow \Rightarrow res\_gap\downarrow \Rightarrow prem\uparrow \Rightarrow i_{LSO}\uparrow\) (tightening via risk premium).

2) **Pure SA demand shock** (\(\varepsilon^{y,ZAF}\)):  
You should see \(y_{ZAF}\uparrow\) spill into \(y_{LSO}\uparrow\) (via \(\alpha_3\)), which tends to drain reserves via \(-f_3 y_{LSO}\), but partly offset by \(+f_4 y_{ZAF}\). Net sign depends on calibration—this is where you encode your view of whether SA booms are “good for reserves” (via SACU) or “bad for reserves” (via import surge dominating).

If you believe SACU dominates, you want the net effect closer to positive; if imports dominate, net negative.

---

### 2) Do we get the **same fiscal → risk premium feedback** in Option B?

**Yes**, as long as you keep the same risk premium equation and keep \(g_{LSO}\) in the reserves equation.

In the current model:

- Reserves gap:
\[
res\_gap_t
= \delta res\_gap_{t-1} - f_1 g_{t-1} \; (\text{minus other stuff}) + \varepsilon^{res}_t
\]

- Actual reserves:
\[
res_t = res\_gap_t + res\_bar_t
\]

- Premium:
\[
prem_t = \theta\,(res\_bar_t - res_t) + \varepsilon^{prem}_t
\]

So if \(g_{LSO}\uparrow\), then \(res\_gap\downarrow\Rightarrow res\downarrow\Rightarrow (res\_bar-res)\uparrow\Rightarrow prem\uparrow\). That channel remains intact.

**In Option B**, the reserves equation still contains the term \(-f_1 g_{t-1}\). Therefore fiscal policy still drains reserves and raises the premium. So the *qualitative* fiscal → premium mechanism is unchanged.

The only difference is: Option B adds **extra ways** fiscal can affect reserves indirectly:
- \(g\uparrow \Rightarrow y_{LSO}\uparrow\) via the IS curve (since you have \(+\alpha_6 g_t\)),
- then \(y_{LSO}\uparrow \Rightarrow res\_gap\downarrow\) via \(-f_3 y_{LSO}\).

So under Option B, fiscal expansion can tighten the risk premium through **two** routes:
1) the direct leakage term \(-f_1 g\) (the one you already like), and
2) an endogenous import-demand leakage term via \(-f_3 y_{LSO}\).

That is economically reasonable for Lesotho, provided \(f_3\) isn’t too large.

---

### 3) One important caution about timing (lags)
Your current reserves equation uses **lagged** drivers: \(g(-1)\), \(z(-1)\). If you add \(y_{LSO}(-1)\) and \(y_{ZAF}(-1)\), you preserve that timing convention. But be aware:

- fiscal shock hits \(g_t\) today,
- output responds today,
- reserves respond next quarter (because of the lag).

That’s fine; just make sure it matches the story you want.

---

### 4) Suggested next step (so you don’t “guess” \(f_3,f_4\))
If you tell me which empirical behavior you want to match, I can give you tighter numbers. For example:

- “A 1pp fiscal expansion for 1 quarter should lower reserves by ~0.1 months of imports at peak.”
- “A 1pp SA output gap shock should raise Lesotho reserves by ~0.05 months at peak (via SACU).”

Give me 1–2 such targets and I’ll back out a consistent \(f_3,f_4\) (and tell you whether you must also adjust \(\theta_{prem}\) to avoid excessive amplification).