---
name: shock-scenario
description: >
  Use when the user wants to run a shock scenario through the Lesotho QPM model.
  Triggers: "run a shock", "simulate a shock", "oil price shock", "fiscal shock",
  "food price shock", "what happens if oil prices rise", "global demand shock",
  "commodity shock", "SARB rate hike", or any request to analyze a macroeconomic
  shock scenario for Lesotho/South Africa.
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
---

# Lesotho QPM Shock Scenario Skill

Run any shock scenario through the Lesotho QPM Version 4, generating IRF charts and an analytical PDF report.

## Workflow

Follow these steps **in order**, confirming with the user after Step 2.

### Step 1: Parse the Shock Request

Extract from the user's description:

- **Which shock(s):** Map to exogenous variable(s) from the catalog below
- **Magnitude:** e.g., 10% oil price increase, 1pp fiscal expansion
- **Duration:** Single quarter impulse vs sustained N quarters
- **Expectation regime:** Unanticipated (default), anticipated, or compare both

If anything is ambiguous, ask the user before proceeding.

### Step 2: Present Shock Design (Get Approval)

Show the user:
1. The eps sequence for each shock (values per quarter)
2. Expected price/variable paths for the first 8 quarters
3. Which transmission channels will be active
4. The expectation regime(s) to be used

**Wait for user approval before proceeding.**

### Step 3: Write Simulation .mod File

Create `simul_<scenario_name>.mod` in the project root, based on `simul_10pct_oil_v4.mod` as template. The .mod file must include:
- All 28 endogenous variables (same var block as v4)
- All 19 exogenous shocks (same varexo block)
- All parameters with v4 calibration values
- The full v4 model block (28 equations)
- For **unanticipated**: `shocks; var <shock>; stderr <magnitude>; end;` then `stoch_simul(order=1, irf=20, nograph, noprint);`
- For **anticipated**: `initval; ... end; steady;` then deterministic `shocks; var <shock>; periods ...; values ...; end;` then `perfect_foresight_setup(periods=40); perfect_foresight_solver;`

### Step 4: Run Dynare

```bash
cd /Users/andrewtiffin/Projects/lesotho
/opt/homebrew/bin/octave --no-gui --eval "addpath('/opt/homebrew/Cellar/dynare/6.5_1/lib/dynare/matlab'); dynare simul_<name>.mod noclearall"
```

Verify: Blanchard-Kahn satisfied, steady state found, solver converged.

### Step 5: Generate IRF Charts

Write `analysis/generate_<scenario>_irfs.m` based on `analysis/generate_oil_shock_irfs.m` as template.

**For unanticipated sustained shocks:** Use superposition (see Section 4 below).

**For anticipated shocks:** Read from `oo_.endo_simul` with variable indices (see Section 6).

**Standard 5 figures:**
1. Shock paths (level + inflation for commodity shocks; level for other shocks)
2. South Africa transmission (4-panel: pi_zaf, i_zaf, y_zaf, r_zaf)
3. Lesotho key variables (4-panel: pi_lso, y_lso, z_lso, i_lso)
4. Reserves and risk premium (2-panel)
5. Lesotho inflation decomposition (stacked bar)

For **compare both** scenarios: overlay anticipated (dashed) and unanticipated (solid) on the same charts.

Run with:
```bash
cd /Users/andrewtiffin/Projects/lesotho/analysis
/opt/homebrew/bin/octave --no-gui generate_<scenario>_irfs.m
```

### Step 6: Write Analytical Report

Create `analysis/<scenario>_report.qmd` following the standard structure (see Section 7). Tailor the transmission channels section to only include channels activated by the specific shock. Use actual IRF values from the simulation in all tables and text.

### Step 7: Render PDF

```bash
cd /Users/andrewtiffin/Projects/lesotho/analysis
quarto render <scenario>_report.qmd --to typst
```

---

## Shock Catalog

### Commodity Shocks (Level-Based)

These use AR(1) on the **price level gap**. Inflation is the first difference.

| Shock | Variable | Typical Size | AR(1) rho | Key Channels |
|-------|----------|:---:|:---:|------|
| Oil price | `eps_oil` | 0.10 (10%) | 0.80 | Oil→SA inflation ($\lambda_4$), oil→food ($\kappa$), CPI differentials |
| Food price | `eps_food` | 0.10 (10%) | 0.60 | Food→SA inflation ($\lambda_5$), food CPI differential |
| Combined oil+food | `eps_oil` + `eps_food` | varies | 0.70/0.60 | All commodity channels |

### Rate/Gap Shocks (Already Stationary)

These are AR(1) on the rate or gap directly. No level/inflation decomposition needed.

| Shock | Variable | Typical Size | AR(1) rho | Key Channels |
|-------|----------|:---:|:---:|------|
| Lesotho fiscal | `eps_g_lso` | 0.01 (1% GDP) | 0.70 | IS curve ($\alpha_6$), reserves ($f_1$), inflation ($\beta_1$) |
| Lesotho demand | `eps_y_lso` | 0.01 (1pp) | — | Direct output, inflation, reserves |
| Lesotho cost-push | `eps_pi_lso` | 0.01 (1pp) | — | Direct inflation, real rate |
| Lesotho persistent supply | `eps_u_lso` | 0.01 | 0.50 | Persistent inflation (2-period MA) |
| Risk premium | `eps_prem_lso` | 0.01 (1pp) | — | Interest rate, reserves feedback |
| SA demand | `eps_y_zaf` | 0.01 (1pp) | — | Trade spillover ($\alpha_3$), SACU |
| SA cost-push | `eps_pi_zaf` | 0.01 (1pp) | — | SA inflation→LSO, SARB response |
| SA monetary policy | `eps_i_zaf` | 0.0025 (25bp) | — | Peg ($i^{LSO}=i^{ZAF}+prem$), real rate |
| SA exchange rate | `eps_s_zaf` | 0.01 | — | REER, UIP |
| Global demand | `eps_y_row` | 0.01 (1pp) | 0.80 | ROW→SA ($\gamma_5$)→LSO ($\alpha_3$) chain |
| Global inflation | `eps_pi_row` | 0.01 (1pp) | 0.50 | ROW inflation→SA REER, commodity prices |
| Global monetary | `eps_i_row` | 0.0025 (25bp) | 0.75 | UIP→Rand, SA monetary conditions |
| Commodity price gap | `eps_com` | 0.01 | 0.70 | Terms of trade→SA IS ($\gamma_6$) |
| Commodity trend | `eps_rcom_trend` | 0.01 | RW | Permanent terms of trade shift |

---

## Sustained Shock Math

To hold a **level-based** variable (oil, food) at a target for N quarters with AR(1) persistence $\rho$:

```
eps_1 = target
eps_t = target * (1 - rho)   for t = 2, ..., N
eps_t = 0                     for t > N  (natural decay)
```

**Examples:**
- Oil at +10% for 4Q, rho=0.80: eps = {0.10, 0.02, 0.02, 0.02}
- Food at +5% for 2Q, rho=0.60: eps = {0.05, 0.02}
- Oil at +10% for 1Q only: eps = {0.10}

For **rate/gap shocks** (fiscal, demand, etc.) with AR(1) persistence rho:
```
eps_1 = target
eps_t = target * (1 - rho)   for t = 2, ..., N
```

**Example:** Fiscal expansion of 1% GDP for 4Q, rho_g=0.70: eps_g = {0.01, 0.003, 0.003, 0.003}

---

## Superposition for Unanticipated Shocks

In a linear model, the response to a sequence of unanticipated shocks is the **sum of shifted individual IRFs**.

The base IRF from `stoch_simul` is the response to `eps = stderr` (one standard deviation). For a shock sequence with different magnitudes, scale accordingly.

**Octave code template:**

```matlab
% Load base IRFs
load('../simul_<name>/Output/simul_<name>_results.mat');
base_irf = @(varname) oo_.irfs.([varname '_<shock_name>']);

% Define shock sequence relative to base IRF magnitude
% Example: oil sustained 4Q with stderr=0.10
% eps = {0.10, 0.02, 0.02, 0.02} → weights = {1.0, 0.2, 0.2, 0.2}
shock_weights = [1.0, 0.3, 0.3, 0.3];
shock_periods = [1, 2, 3, 4];

% Superimpose shifted IRFs
function result = superimpose(base, weights, periods, T)
    result = zeros(1, T);
    for k = 1:length(weights)
        shift = periods(k) - 1;
        for t = 1:T
            src = t - shift;
            if src >= 1 && src <= length(base)
                result(t) = result(t) + weights(k) * base(src);
            end
        end
    end
end

% Apply to each variable
T = 20;
pi_lso = superimpose(base_irf('pi_lso'), shock_weights, shock_periods, T) * 100;
% ... repeat for all variables
```

**For combined shocks** (e.g., oil + food simultaneously): since the model is linear, run `stoch_simul` once with both shocks specified, or sum the individual IRFs.

---

## Transmission Channel Descriptions

Use these as building blocks for the report's Transmission Channels section. Include only those relevant to the specific shock.

### Oil → SA Inflation (Direct)
Oil price inflation enters the SA hybrid Phillips curve via $\lambda_4 = 0.03$. With $\lambda_1 = 0.50$ backward-looking weight, the hybrid Phillips curve amplifies and smooths the direct impulse. Calibration: fuel CPI weight 4.58% x BFP pass-through ~0.45 + indirect.

### Oil → Food Prices
The food price level responds to the oil price level via $\kappa_{oil \to food} = 0.05$: $p^{food}_t = 0.60 \cdot p^{food}_{t-1} + 0.05 \cdot p^{oil}_t + \varepsilon^{food}_t$. Calibration: SARB WP1701 b_36=0.033, scaled for cumulative reduced-form effect.

### Food → SA Inflation
Food inflation enters the SA Phillips curve via $\lambda_5 = 0.05$. Food CPI weight in SA is 17.24%.

### SA Inflation → Lesotho
SA inflation transmits one-for-one to Lesotho: $\pi^{LSO} = \pi^{ZAF} + (\omega^{LSO}_1 - \omega^{ZAF}_1)\pi^{oil} + (\omega^{LSO}_2 - \omega^{ZAF}_2)\pi^{food} + \beta_1 \hat{y}^{LSO}$. The CPI weight differentials are: oil 0.03 (8% vs 5%), food 0.15 (35% vs 20%).

### SARB Monetary Policy Spillover
The SARB Taylor rule: $i^{ZAF} = 0.75 \cdot i^{ZAF}_{-1} + 0.25 \cdot (1.50 \cdot E[\pi^{ZAF}_{+1}] + 0.50 \cdot \hat{y}^{ZAF})$. Under the peg, $i^{LSO} = i^{ZAF} + prem$. The real rate is $r^{LSO} = i^{LSO} - E[\pi^{LSO}_{+1}]$. Key insight: if Lesotho inflation exceeds SA inflation (due to CPI weight differentials), the Lesotho real rate falls even as the nominal rate rises, producing expansionary output effects. Under unanticipated shocks with level-based oil prices, the inflation spike is transient, so the real rate may instead rise.

### Fiscal → Reserves → Risk Premium
Government spending enters the IS curve ($\alpha_6 = 0.30$) and drains reserves via import leakage ($f_1 = 0.35$). Reserve depletion raises the risk premium ($\theta_{prem} = 0.35$), which feeds back to interest rates and output.

### Global Demand → SA → Lesotho
US output gap enters SA IS curve ($\gamma_5 = 0.10$). SA output gap enters Lesotho IS curve ($\alpha_3 = 0.30$). The chain multiplier is modest (~0.03) but persistent due to AR(1) dynamics.

### Terms of Trade → SA IS Curve
The commodity price gap enters the SA IS curve ($\gamma_6 = 0.01$). Small direct effect but combined with exchange rate effects via UIP.

---

## Technical Reference

### Paths
- Dynare MATLAB path: `/opt/homebrew/Cellar/dynare/6.5_1/lib/dynare/matlab`
- Octave binary: `/opt/homebrew/bin/octave`
- Project root: `/Users/andrewtiffin/Projects/lesotho`
- Analysis dir: `/Users/andrewtiffin/Projects/lesotho/analysis`
- Figures dir: `/Users/andrewtiffin/Projects/lesotho/analysis/figures`

### Variable Indices (for `oo_.endo_simul` in perfect foresight)
```
1:y_lso  2:pi_lso  3:i_lso  4:r_lso  5:z_lso  6:s_lso  7:res_gap_lso
8:res_lso  9:res_bar_lso  10:prem_lso  11:g_lso
12:y_zaf  13:pi_zaf  14:i_zaf  15:r_zaf  16:z_zaf  17:s_zaf
18:y_row  19:pi_row  20:i_row
21:pi_oil  22:pi_food  23:poil_gap  24:pfood_gap
25:rcom  26:rcom_bar  27:d_rcom  28:pi_com
```

Steady state is period 1. Simulation periods start at index `ss+1` where `ss=1`.

### IRF Field Names (for `oo_.irfs` from stoch_simul)
Format: `oo_.irfs.<endogenous_var>_<exogenous_shock>`
Example: `oo_.irfs.pi_lso_eps_oil`, `oo_.irfs.y_zaf_eps_g_lso`

### V4 Parameter Values
```
% Lesotho IS
alpha_1=0.50; alpha_2=0.10; alpha_3=0.30; alpha_4=0.20; alpha_5=0.50; alpha_6=0.30;

% Lesotho Phillips
beta_1=0.25; omega_1_lso=0.08; omega_1_zaf=0.05; omega_2_lso=0.35; omega_2_zaf=0.20; rho_u=0.50;

% Lesotho Reserves
delta_res=0.90; f_1=0.35; f_3=0.10; f_4=0.02; rho_res_bar=0.90; res_ss=4.70;
theta_prem=0.35;

% SA IS
gamma_1=0.55; gamma_2=0.10; gamma_3=0.25; gamma_4=0.08; gamma_5=0.10; gamma_6=0.01;

% SA Phillips
lambda_1=0.50; lambda_2=0.30; lambda_3=0.15; lambda_4=0.03; lambda_5=0.05;

% SA Taylor
phi_i=0.75; phi_pi=1.50; phi_y=0.50; pi_target_zaf=4.50;

% SA UIP
sigma_s=0.50;

% ROW
rho_y_row=0.80; rho_pi_row=0.50; rho_i_row=0.75;

% Commodities
rho_oil=0.80; rho_food=0.60; rho_com=0.70; rho_d_rcom=0.70; kappa_oil_food=0.05;

% Other
rho_g=0.70; rho_z=0.80;
```

### V4 Model Equations (28 total)
```
% Lesotho block (11 equations)
y_lso = alpha_1*y_lso(-1) + alpha_2*y_lso(+1) + alpha_3*y_zaf - alpha_4*(alpha_5*r_lso + (1-alpha_5)*z_lso) + alpha_6*g_lso + eps_y_lso;
pi_lso = pi_zaf + (omega_1_lso-omega_1_zaf)*pi_oil + (omega_2_lso-omega_2_zaf)*pi_food + beta_1*y_lso + eps_u_lso + rho_u*eps_u_lso(-1) + eps_pi_lso;
s_lso = s_zaf + eps_s_lso;
i_lso = i_zaf + prem_lso + eps_i_lso;
r_lso = i_lso - pi_lso(+1);
z_lso = rho_z*z_lso(-1) + (s_lso-s_lso(-1)) - (pi_lso-pi_zaf)/4;
res_gap_lso = delta_res*res_gap_lso(-1) - f_1*g_lso(-1) - f_3*y_lso(-1) + f_4*y_zaf(-1) + eps_res_lso;
res_bar_lso = (1-rho_res_bar)*res_ss + rho_res_bar*res_bar_lso(-1);
res_lso = res_gap_lso + res_bar_lso;
prem_lso = theta_prem*(res_bar_lso - res_lso) + eps_prem_lso;
g_lso = rho_g*g_lso(-1) + eps_g_lso;

% SA block (6 equations)
y_zaf = gamma_1*y_zaf(-1) + gamma_2*y_zaf(+1) - gamma_3*r_zaf + gamma_4*z_zaf + gamma_5*y_row + gamma_6*d_rcom + eps_y_zaf;
pi_zaf = lambda_1*pi_zaf(-1) + (1-lambda_1)*pi_zaf(+1) + lambda_2*y_zaf + lambda_3*(z_zaf-z_zaf(-1)) + lambda_4*pi_oil + lambda_5*pi_food + eps_pi_zaf;
i_zaf = phi_i*i_zaf(-1) + (1-phi_i)*(phi_pi*pi_zaf(+1) + phi_y*y_zaf) + eps_i_zaf;
r_zaf = i_zaf - pi_zaf(+1);
s_zaf = sigma_s*s_zaf(-1) + (1-sigma_s)*s_zaf(+1) - (i_zaf-i_row)/4 + eps_s_zaf;
z_zaf = rho_z*z_zaf(-1) + (s_zaf-s_zaf(-1)) - (pi_zaf-pi_row)/4;

% ROW block (3 equations)
y_row = rho_y_row*y_row(-1) + eps_y_row;
pi_row = rho_pi_row*pi_row(-1) + eps_pi_row;
i_row = rho_i_row*i_row(-1) + (1-rho_i_row)*(1.5*pi_row+0.5*y_row) + eps_i_row;

% Commodity block (8 equations)
rcom = rcom_bar + d_rcom;
rcom_bar = rcom_bar(-1) + eps_rcom_trend;
d_rcom = rho_d_rcom*d_rcom(-1) + eps_com;
pi_com = pi_row + (rcom-rcom(-1));
poil_gap = rho_oil*poil_gap(-1) + eps_oil;
pi_oil = poil_gap - poil_gap(-1);
pfood_gap = rho_food*pfood_gap(-1) + kappa_oil_food*poil_gap + eps_food;
pi_food = pfood_gap - pfood_gap(-1);
```

### Octave Caveats
- `yline()` is not available in Octave. Use `plot([1 T], [0 0], 'k-', 'linewidth', 0.5)` instead.
- Use `figure('visible', 'off', ...)` for headless chart generation.
- Save with `print(fig, [figdir 'filename.png'], '-dpng', '-r200')`.

### Chart Color Palette
```matlab
c1 = [0.20 0.40 0.70];  % blue
c2 = [0.80 0.35 0.20];  % rust
c3 = [0.30 0.65 0.30];  % green
c4 = [0.55 0.35 0.65];  % purple
c_grey = [0.45 0.45 0.45];
```

---

## Report Template Structure

Use `analysis/oil_shock_report.qmd` as the template. Standard YAML header:

```yaml
---
title: "<Shock Type> Analysis"
subtitle: "Lesotho QPM Version 4 — <Shock Description>"
date: "<Current Month Year>"
author: "Research Team"
format:
  typst:
    toc: true
    toc-depth: 3
    number-sections: true
    columns: 1
    margin:
      x: 2.5cm
      y: 2.5cm
    mainfont: "New Computer Modern"
    fontsize: 11pt
---
```

### Standard Sections

1. **Executive Summary** (unnumbered) — Model/simulation metadata line, then 5-6 bullet point key findings with specific numbers
2. **Shock Design** — Rationale (why this shock matters for Lesotho), specification (equations, eps sequence), price/variable path table, shock path figure
3. **Transmission Channels** — Only those activated by this shock. Use subsections for each channel. Include the relevant equation and parameter values. For anticipated vs unanticipated comparisons, highlight where expectations matter.
4. **Simulation Results: South Africa** — Table at quarters {1,2,3,4,5,6,8,12,16}, SA 4-panel chart, narrative on inflation, SARB response, output
5. **Simulation Results: Lesotho** — Same table format, Lesotho 4-panel chart, subsections for: Inflation dynamics (with decomposition chart), Output gap, REER, Reserves (with reserves chart)
6. **Policy Implications** — 4-5 numbered points, tailored to the specific shock
7. **Technical Notes** — Parameter table, solution method, limitations

For **compare both** reports: add comparison columns in tables and discuss the role of expectations explicitly.

---

## Template Files

Reference these existing files when building new scenarios:

| Purpose | File Path |
|---------|-----------|
| Simulation (unanticipated) | `simul_10pct_oil_v4.mod` |
| Simulation (anticipated) | `simul_10pct_oil_v4_anticipated.mod` |
| Chart generation | `analysis/generate_oil_shock_irfs.m` |
| Report | `analysis/oil_shock_report.qmd` |
| Full model (read-only reference) | `lesotho_model_v4.mod` |
