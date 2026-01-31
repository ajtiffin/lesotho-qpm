# Claude Session Context - Lesotho QPM Model

**Last Updated:** 2026-01-31
**To Resume:** Open this file and say "continue from where we left off" or ask about any aspect of the project.

---

## Project Summary

Built a **semi-structural New Keynesian Quarterly Projection Model (QPM)** for Lesotho based on IMF Country Report No. 2023/269 by Zviad Zedginidze.

### Key Model Features
- Two-country structure: Lesotho + South Africa (gateway to ROW)
- Currency peg: Loti pegged to South African Rand at 1:1
- Foreign exchange reserves dynamics with fiscal leakage
- Endogenous risk premium linked to reserves gap
- 23 endogenous variables, 17 shocks
- Blanchard-Kahn conditions satisfied (5 jump variables)

---

## File Inventory

| File | Description | Status |
|------|-------------|--------|
| `lesotho_model.mod` | Dynare model specification (v2 recalibrated) | ✓ Complete |
| `LESOTHO_SESSION_LOG.md` | Conversation log of development process | ✓ Complete |
| `LESOTHO_RESEARCH_REPORT.qmd` | Quarto research report | ✓ Complete |
| `LESOTHO_RESEARCH_REPORT.pdf` | Rendered PDF report | ✓ Complete |
| `LESOTHO_RESEARCH_REPORT.md` | Markdown version (older) | ✓ Complete |
| `IRF_fiscal_shock.pdf` | Custom IRF plot for fiscal shock | ✓ Complete |
| `002-article-A002-en.pdf` | Source IMF paper | Reference |
| `+lesotho_model/` | Generated Dynare MATLAB/Octave code | ✓ Generated |
| `lesotho_model/` | Dynare output (results, IRF graphs, bytecode) | ✓ Generated |

---

## GitHub Repository

**URL:** https://github.com/ajtiffin/lesotho-qpm

All files and subfolders have been pushed. Repository is public.

---

## How to Run the Model

```bash
cd ~/nk_dsge/lesotho

# Run with Octave (installed via Homebrew)
octave --no-gui --eval "
addpath('/opt/homebrew/Cellar/dynare/6.5_1/lib/dynare/matlab');
dynare lesotho_model.mod;
"
```

---

## Key Parameter Values (Recalibrated v2)

| Parameter | Value | Description |
|-----------|-------|-------------|
| α₃ | 0.40 | South Africa output spillover |
| α₄ | 0.45 | Monetary conditions effect |
| α₆ | 0.30 | Fiscal multiplier |
| β₁ | 0.25 | Phillips curve slope |
| δ | 0.95 | Reserves persistence |
| θ | 0.50 | Premium sensitivity to reserves |
| f₁ | 0.50 | Fiscal leakage to imports |

---

## IRF Results (Fiscal Shock +1pp GDP)

| Variable | Impact | Peak | Long-run |
|----------|--------|------|----------|
| Output gap | +0.30pp | +0.31pp | −0.32pp |
| Reserves gap | 0 | −1.19 mo. | ~0 |
| Risk premium | 0 | +0.60pp | ~0 |

The negative long-run output effect demonstrates crowding out via the fiscal-reserves-premium feedback loop.

---

## Development History

1. **Initial build:** Created model from IMF paper equations
2. **Error 1:** 24 equations, 23 variables → removed redundant reserves identity
3. **Error 2:** BK violation (6 unstable, 5 jump) → added REER mean-reversion (ρ_z = 0.80)
4. **Documentation:** Created session log and Quarto research report
5. **Validation:** Compared IRFs with IMF paper Figures 4 and 6
6. **Recalibration:** Strengthened transmission parameters to match IMF results
7. **GitHub:** Pushed to https://github.com/ajtiffin/lesotho-qpm

---

## Potential Next Steps

- [ ] Add SACU revenue volatility module
- [ ] Implement nonlinear reserves threshold effects
- [ ] Add climate/agricultural shock module
- [ ] Bayesian estimation with actual Lesotho data
- [ ] Compare with other CMA countries (Eswatini, Namibia)
- [ ] Build forecasting scenarios

---

## Quick Commands

```bash
# Re-render research report
quarto render LESOTHO_RESEARCH_REPORT.qmd --to typst

# Generate new IRF plots
octave --no-gui --eval "addpath('/opt/homebrew/Cellar/dynare/6.5_1/lib/dynare/matlab'); dynare lesotho_model.mod;"

# Push changes to GitHub
git add -A && git commit -m "Update" && git push
```

---

*This context file enables session continuity with Claude.*
