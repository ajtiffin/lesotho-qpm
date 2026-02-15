#!/bin/bash

# Sensitivity analysis script
# Tests each parameter at different values

cd /Users/andrewtiffin/Projects/lesotho

echo "=== SENSITIVITY ANALYSIS ==="
echo ""

# Create backup
cp lesotho_model.mod lesotho_model.mod.backup

# Function to run model and extract results
run_model() {
    param=$1
    value=$2
    echo "Testing $param = $value"

    # Update parameter in mod file
    sed -i '' "s/$param *= *[0-9.]+/$param = $value/" lesotho_model.mod

    # Run dynare
    octave --eval "addpath('/opt/homebrew/Cellar/dynare/6.5_1/lib/dynare/matlab'); cd('/Users/andrewtiffin/Projects/lesotho'); dynare lesotho_model.mod noclearall;" 2> /dev/null

    # Extract results
    octave --eval "
        cd('/Users/andrewtiffin/Projects/lesotho');
        load('lesotho_model/Output/lesotho_model_results.mat', 'oo_');
        sa_peak = max(oo_.irfs.y_lso_eps_y_zaf);
        glob_peak = max(oo_.irfs.y_lso_eps_y_row);
        ratio = sa_peak / glob_peak;
        sa_q40 = oo_.irfs.y_lso_eps_y_zaf(40);
        glob_q40 = oo_.irfs.y_lso_eps_y_row(40);
        printf('%.3f,%.3f,%.2f,%.3f,%.3f\n', sa_peak, glob_peak, ratio, sa_q40, glob_q40);
    " 2> /dev/null | tail -1
}

# Base case
echo "Running BASE CASE (alpha_3=0.30, delta_res=0.90, theta_prem=0.35, rho_z=0.80, gamma_1=0.55)"
echo "SA_peak,Global_peak,Ratio,SA_Q40,Global_Q40"
run_model "alpha_3" "0.30"

echo ""
echo "=== ALPHA_3 (SA Spillover) Sensitivity ==="
echo "SA_peak,Global_peak,Ratio,SA_Q40,Global_Q40"
for val in 0.20 0.25 0.30 0.35 0.40; do
    result=$(run_model "alpha_3" "$val")
    echo "$val: $result"
done

# Restore base
cp lesotho_model.mod.backup lesotho_model.mod

echo ""
echo "=== DELTA_RES (Reserve Persistence) Sensitivity ==="
echo "SA_peak,Global_peak,Ratio,SA_Q40,Global_Q40"
for val in 0.80 0.85 0.90 0.95 0.98; do
    result=$(run_model "delta_res" "$val")
    echo "$val: $result"
done

# Restore base
cp lesotho_model.mod.backup lesotho_model.mod

echo ""
echo "=== THETA_PREM (Premium Sensitivity) Sensitivity ==="
echo "SA_peak,Global_peak,Ratio,SA_Q40,Global_Q40"
for val in 0.20 0.30 0.35 0.40 0.50; do
    result=$(run_model "theta_prem" "$val")
    echo "$val: $result"
done

# Restore base
cp lesotho_model.mod.backup lesotho_model.mod

echo ""
echo "=== RHO_Z (REER Persistence) Sensitivity ==="
echo "SA_peak,Global_peak,Ratio,SA_Q40,Global_Q40"
for val in 0.70 0.75 0.80 0.85 0.90; do
    result=$(run_model "rho_z" "$val")
    echo "$val: $result"
done

# Restore base
cp lesotho_model.mod.backup lesotho_model.mod

echo ""
echo "=== GAMMA_1 (SA Output Persistence) Sensitivity ==="
echo "SA_peak,Global_peak,Ratio,SA_Q40,Global_Q40"
for val in 0.40 0.50 0.55 0.60 0.70; do
    result=$(run_model "gamma_1" "$val")
    echo "$val: $result"
done

# Restore original
cp lesotho_model.mod.backup lesotho_model.mod
rm lesotho_model.mod.backup

echo ""
echo "=== Analysis Complete ==="
