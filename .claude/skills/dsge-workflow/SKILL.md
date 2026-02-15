---
name: dsge-workflow
description: Complete workflow for building, running, and validating DSGE models in Dynare. Use when working with macroeconomic models, FPAS/QPM models, Dynare code, or comparing model results with literature. Covers reading PDFs, model specification, Dynare implementation, IRF analysis, and sensitivity testing.
disable-model-invocation: true
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
---

# DSGE Model Development Workflow

This skill guides the complete process of developing, running, and validating DSGE models in Dynare, with emphasis on FPAS/QPM (Forecasting and Policy Analysis System / Quarterly Projection Model) frameworks used by central banks.

## Workflow Overview

```
Literature Review → Model Specification → Dynare Implementation →
Testing & Validation → Literature Comparison → Sensitivity Analysis
```

## Phase 1: Literature Review and PDF Analysis

When the user provides a PDF (paper, model documentation, or country report):

### 1.1 Extract Key Information

Read the PDF and identify:

**Model Structure:**
- Country/region focus
- Model type (QPM, FPAS, DSGE, etc.)
- Key equations (IS curve, Phillips curve, policy rules)
- Calibration approach (Bayesian, MLE, moments matching)

**Key Parameters:**
| Parameter Type | What to Look For | Typical Values |
|---------------|------------------|----------------|
| Persistence | rho, gamma, delta | 0.5-0.95 |
| Elasticities | alpha, beta | 0.1-0.5 |
| Policy coefficients | phi_pi, phi_y | 1.5, 0.5 |
| Steady states | ss, bar suffix | Varies |

**Shock Specifications:**
- Standard deviations
- AR(1) coefficients
- Cross-correlations

**Validation Targets:**
- IRF shapes (hump-backed, monotonic, etc.)
- Peak responses
- Half-lives
- Variance decompositions

### 1.2 Document Findings

Create a summary document:
```markdown
## Literature Summary: [Paper Title]

### Model Structure
- [ ] Small open economy / Multi-country
- [ ] Currency regime (peg/float)
- [ ] Key frictions and features

### Key Equations
- IS curve: [equation form]
- Phillips curve: [equation form]
- Policy rule: [equation form]

### Calibration
| Parameter | Value | Source |
|-----------|-------|--------|
| [param] | [value] | [estimation/calibration] |

### Validation Targets
- [ ] IRF: [variable] peaks at [value] in [quarter]
- [ ] Shock: [type] with std = [value]
```

## Phase 2: Model Specification

### 2.1 Define Model Structure

Based on literature, specify:

**Variables:**
```matlab
// Endogenous
var y pi i r z s ...;

// Exogenous
shocks eps_y, eps_pi, eps_i, ...;

// Parameters
parameters alpha, beta, rho, ...;
```

**Equations:**
1. IS curve (aggregate demand)
2. Phillips curve (aggregate supply)
3. Policy rule (Taylor-type)
4. UIP/Exchange rate
5. Foreign block (if multi-country)
6. Shock processes

### 2.2 Calibration Strategy

**Prioritize:**
1. Micro-founded parameters (from literature)
2. Steady states (observable)
3. Estimated parameters (from similar countries)
4. Posterior modes (if available)

**Document choices:**
```matlab
// Calibrated from micro data
alpha_1 = 0.50;     // Habit persistence (literature average)

// Estimated for similar economies
alpha_3 = 0.30;     // Spillover (IMF posterior ~0.35)

// Matching steady-state targets
res_ss = 4.70;      // 4.7 months imports (IMF ARA metric)
```

## Phase 3: Dynare Implementation

### 3.1 File Structure

Create organized model files:

```
model-directory/
├── country_model.mod       # Main model file
├── parameters.mod          # Parameter definitions (optional)
├── steady_state.m          # Steady state computation (if needed)
├── analysis/
│   ├── run_irf_analysis.m  # IRF extraction
│   ├── sensitivity.m       # Parameter sensitivity
│   └── generate_charts.R   # Visualization
└── data/
    └── literature_irfs.csv # Comparison data
```

### 3.2 Model File Template

```matlab
// =====================================================================
// [Country] [Model Type] Model
// Based on: [Literature reference]
// Date: [Date]
// =====================================================================

var
    // Domestic variables
    y pi i r z s
    // Foreign variables
    y_f pi_f i_f
    // Shocks
    eps_y eps_pi eps_i
    ;

varexo
    eps_y_shock eps_pi_shock eps_i_shock
    ;

parameters
    // Domestic
    alpha_1 alpha_2 alpha_3 alpha_4
    beta_1 beta_2
    // Policy
    phi_i phi_pi phi_y
    // Foreign
    rho_y rho_pi rho_i
    ;

// -------------------------------------------------------------------------
// PARAMETER VALUES
// -------------------------------------------------------------------------

alpha_1 = 0.50;     // Output persistence
alpha_3 = 0.30;     // Spillover coefficient
// ... etc

// -------------------------------------------------------------------------
// MODEL EQUATIONS
// -------------------------------------------------------------------------

model(linear);
    // IS curve
    y = alpha_1*y(-1) + alpha_2*y(+1) + alpha_3*y_f - alpha_4*r + eps_y;

    // Phillips curve
    pi = beta_1*pi(+1) + beta_2*y + eps_pi;

    // Taylor rule
    i = phi_i*i(-1) + (1-phi_i)*(phi_pi*pi(+1) + phi_y*y) + eps_i;

    // Real rate definition
    r = i - pi(+1);

    // Foreign block (AR processes)
    y_f = rho_y*y_f(-1) + eps_y_shock;
    pi_f = rho_pi*pi_f(-1) + eps_pi_shock;
    i_f = rho_i*i_f(-1) + eps_i_shock;

end;

// -------------------------------------------------------------------------
// STEADY STATE
// -------------------------------------------------------------------------

steady_state_model;
    y = 0;
    pi = 0;
    i = 0;
    r = 0;
    // ... etc
end;

// -------------------------------------------------------------------------
// SHOCKS
// -------------------------------------------------------------------------

shocks;
    var eps_y_shock = 0.01^2;
    var eps_pi_shock = 0.005^2;
    var eps_i_shock = 0.002^2;
end;

// -------------------------------------------------------------------------
// OPTIONS & SIMULATION
// -------------------------------------------------------------------------

stoch_simul(order=1,
           irf=40,
           periods=0,
           noprint,
           nograph)
           y pi i r z s;
```

### 3.3 Common Pitfalls

**Check for:**
- [ ] Blanchard-Kahn conditions (eigenvalues)
- [ ] Stationarity of all processes
- [ ] Correct shock variances (not just stderr values)
- [ ] Proper timing (end of period vs beginning)
- [ ] Units (percent vs levels)

## Phase 4: Running and Testing

### 4.1 Initial Run

```bash
dynare country_model.mod
```

**Verify:**
1. No preprocessor errors
2. Blanchard-Kahn condition satisfied
3. Steady state computed
4. IRFs generated

### 4.2 Diagnostic Checks

**Eigenvalue check:**
```
Looking for eigenvalues > 1...
# should equal number of forward-looking variables
```

**Steady state verification:**
- All variables at expected values?
- No NaN or Inf?

**IRF sanity check:**
- Do IRFs return to steady state?
- Are magnitudes reasonable?
- Do signs make economic sense?

### 4.3 Common Errors and Fixes

| Error | Cause | Fix |
|-------|-------|-----|
| BK condition fail | Wrong timing or eigenvalues | Check forward-looking variables |
| Singularity | Redundant equation | Check equation count |
| Steady state fail | Wrong calibration | Check parameter values |
| NaN in IRFs | Division by zero | Add small epsilon |

## Phase 5: Literature Comparison

### 5.1 Extract Model IRFs

Use Octave/MATLAB:
```matlab
% Load results
load('model/Output/model_results.mat', 'oo_');

% Extract specific IRF
irf_y_shock = oo_.irfs.y_eps_y;
irf_pi_shock = oo_.irfs.pi_eps_y;

% Peak values
peak_y = max(irf_y_shock);
peak_q = find(irf_y_shock == peak_y, 1);
```

### 5.2 Create Comparison Table

| Variable | Your Model | Literature | Difference | Assessment |
|----------|------------|------------|------------|------------|
| y (peak) | 0.78% | 0.75% | +4% | ✅ Match |
| pi (Q4) | 0.29% | 0.35% | -17% | ⚠️ Check |
| i (peak) | 0.31% | 0.28% | +11% | ✅ Match |

### 5.3 Calibration Adjustment

If differences are significant (>20%):

1. **Identify source**: Which equation drives the difference?
2. **Adjust parameters**: Within reasonable bounds
3. **Re-run**: Test sensitivity
4. **Document**: Explain calibration choices

**Priority order for adjustment:**
1. Spillover coefficients (alpha_3)
2. Persistence parameters (rho, gamma)
3. Policy rule coefficients (phi_pi, phi_y)
4. Shock variances

## Phase 6: Sensitivity Analysis

### 6.1 Key Parameters to Test

| Parameter | Test Range | Impact |
|-----------|------------|--------|
| alpha_3 | ±30% | Peak response |
| rho/persistence | ±20% | Persistence |
| phi_pi | 1.0-2.0 | Policy effectiveness |
| delta_res | 0.80-0.98 | Long-run effects |
| theta_prem | 0.20-0.50 | Feedback strength |

### 6.2 Automated Sensitivity Script

```matlab
% Sensitivity analysis
base_value = 0.30;
test_values = [0.20, 0.25, 0.30, 0.35, 0.40];

for i = 1:length(test_values)
    % Update parameter
    set_param_value('alpha_3', test_values(i));

    % Re-run
    stoch_simul(...);

    % Store results
    results(i).value = test_values(i);
    results(i).peak_y = max(oo_.irfs.y_eps_y);
end
```

### 6.3 Sensitivity Report

Document:
- Parameter ranges tested
- Impact on key variables
- Robustness of conclusions
- Confidence intervals

## Phase 7: Documentation and Reporting

### 7.1 Model Documentation

Create comprehensive documentation:

```markdown
# [Country] QPM Model Documentation

## Overview
- Model type: [QPM/FPAS/DSGE]
- Base: [Literature reference]
- Extensions: [Any modifications]

## Structure
[Block diagram of model]

## Equations
[Full equation listing]

## Calibration
[Parameter table with sources]

## Validation
[Comparison with literature]

## Usage
[How to run and interpret]
```

### 7.2 Create Charts and Figures

Generate publication-quality figures:
- IRF plots (multiple shocks)
- Comparison with literature
- Sensitivity analysis
- Variance decomposition

### 7.3 Report Generation

Use Quarto for automated reports:
```yaml
format:
  pdf:
    toc: true
    number-sections: true
```

## Best Practices

### Version Control
- Commit .mod files
- Track parameter changes
- Document calibration iterations

### Testing
- Run after each parameter change
- Compare IRFs visually
- Check economic intuition

### Collaboration
- Clear variable naming
- Commented equations
- Separate country-specific vs generic code

### Reproducibility
- Document Dynare version
- Save random seeds
- Archive results

## Quick Reference

### Dynare Commands
```bash
dynare model.mod                    # Run model
dynare model.mod noclearall        # Keep workspace
dynare model.mod nograph           # No graphs
dynare model.mod nostrict          # Relax warnings
```

### Key Diagnostics
```matlab
% Check eigenvalues
check;

% Steady state
steady;

% IRFs
stoch_simul(irf=40);

% Variance decomposition
stoch_simul(order=1, periods=100000);
```

### Common Parameter Values

| Type | Parameter | Typical Range |
|------|-----------|---------------|
| Habit | alpha_1 | 0.3-0.7 |
| Forward-looking | alpha_2 | 0.1-0.3 |
| Spillover | alpha_3 | 0.1-0.5 |
| Phillips curve | beta_1 | 0.1-0.3 |
| Taylor inflation | phi_pi | 1.2-2.0 |
| Taylor output | phi_y | 0.0-0.8 |
| Interest smoothing | phi_i | 0.5-0.9 |

## Troubleshooting Guide

### Model won't run
1. Check equation count matches variable count
2. Verify all variables declared
3. Check for syntax errors

### BK condition fails
1. Count forward-looking variables
2. Check eigenvalue output
3. Adjust timing if needed

### IRFs look wrong
1. Check shock signs
2. Verify parameter signs
3. Check steady state

### Comparison fails
1. Check shock sizes
2. Verify units (percent vs level)
3. Check timing conventions

## Supporting Files

This skill includes additional resources:

### Templates
- **[templates/model_template.mod](templates/model_template.mod)**: Complete Dynare model template with all standard sections. Copy and customize for new models.

### Scripts
- **[scripts/analyze_irfs.m](scripts/analyze_irfs.m)**: Octave/MATLAB script to extract IRF peaks, variance decompositions, and export to CSV. Run after Dynare execution.

## Example Usage

```bash
# 1. Start with template
cp ~/.claude/skills/dsge-workflow/templates/model_template.mod my_model.mod

# 2. Edit and customize parameters and equations

# 3. Run model
dynare my_model.mod

# 4. Analyze results in Octave
analyze_irfs.m
```

## Resources

### Dynare Documentation
- Manual: dynare.org/manual
- Forum: dynare.org/forum

### Literature Sources
- IMF Working Papers
- Central Bank Working Papers
- Academic journals (JME, AEJ:Macro)

### Model Repositories
- IMF GPM
- FRB/US
- ECB EAGLE

---

**Usage:** Invoke this skill with `/dsge-workflow` when starting a new model project or when you need guidance on any phase of DSGE model development.