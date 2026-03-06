#!/usr/bin/env python3
"""
Sensitivity analysis for Lesotho QPM model
Tests how persistence parameters affect the 6.5x ratio
"""

import subprocess
import re
import json

def run_dynare():
    """Run dynare and extract key results"""
    cmd = """
    addpath('/opt/homebrew/Cellar/dynare/6.5_1/lib/dynare/matlab');
    cd('/Users/andrewtiffin/Projects/lesotho');
    dynare lesotho_model.mod noclearall;
    load('lesotho_model/Output/lesotho_model_results.mat', 'oo_');
    sa_peak = max(oo_.irfs.y_lso_eps_y_zaf);
    glob_peak = max(oo_.irfs.y_lso_eps_y_row);
    ratio = sa_peak / glob_peak;
    sa_q40 = oo_.irfs.y_lso_eps_y_zaf(40);
    glob_q40 = oo_.irfs.y_lso_eps_y_row(40);
    printf('RESULTS:%.4f,%.4f,%.2f,%.4f,%.4f\\n', sa_peak, glob_peak, ratio, sa_q40, glob_q40);
    """

    result = subprocess.run(
        ['octave', '--eval', cmd],
        capture_output=True,
        text=True,
        timeout=120
    )

    # Extract results from output
    for line in result.stdout.split('\n'):
        if line.startswith('RESULTS:'):
            parts = line.replace('RESULTS:', '').split(',')
            return {
                'sa_peak': float(parts[0]),
                'global_peak': float(parts[1]),
                'ratio': float(parts[2]),
                'sa_q40': float(parts[3]),
                'global_q40': float(parts[4])
            }
    return None

def update_param(param_name, value):
    """Update parameter in mod file"""
    with open('/Users/andrewtiffin/Projects/lesotho/lesotho_model.mod', 'r') as f:
        content = f.read()

    # Replace parameter value
    pattern = rf'{param_name}\s*=\s*[\d.]+'
    replacement = f'{param_name}     = {value:.2f}'
    content = re.sub(pattern, replacement, content)

    with open('/Users/andrewtiffin/Projects/lesotho/lesotho_model.mod', 'w') as f:
        f.write(content)

def restore_backup():
    """Restore original mod file"""
    subprocess.run(['cp', '/Users/andrewtiffin/Projects/lesotho/lesotho_model.mod.backup',
                    '/Users/andrewtiffin/Projects/lesotho/lesotho_model.mod'])

def main():
    # Parameter ranges to test
    sensitivity_tests = {
        'alpha_3': [0.20, 0.25, 0.30, 0.35, 0.40],
        'delta_res': [0.80, 0.85, 0.90, 0.95, 0.98],
        'theta_prem': [0.20, 0.30, 0.35, 0.40, 0.50],
        'rho_z': [0.70, 0.75, 0.80, 0.85, 0.90],
        'gamma_1': [0.40, 0.50, 0.55, 0.60, 0.70]
    }

    results = {}

    print("=" * 80)
    print("SENSITIVITY ANALYSIS: Lesotho QPM Model")
    print("=" * 80)

    # Run base case
    print("\nRunning BASE CASE...")
    restore_backup()
    base_results = run_dynare()
    if base_results:
        print(f"  SA peak: {base_results['sa_peak']:.3f}")
        print(f"  Global peak: {base_results['global_peak']:.3f}")
        print(f"  Ratio: {base_results['ratio']:.2f}x")
        print(f"  SA Q40: {base_results['sa_q40']:.3f}")
        print(f"  Global Q40: {base_results['global_q40']:.3f}")
        results['base'] = base_results

    # Run sensitivity for each parameter
    for param, values in sensitivity_tests.items():
        print(f"\n{'='*80}")
        print(f"SENSITIVITY: {param}")
        print(f"{'='*80}")
        print(f"{'Value':<10} {'SA Peak':<10} {'Global':<10} {'Ratio':<10} {'SA Q40':<10} {'Global Q40':<10}")
        print("-" * 80)

        param_results = []
        for value in values:
            restore_backup()
            update_param(param, value)
            result = run_dynare()
            if result:
                param_results.append({'value': value, **result})
                print(f"{value:<10.2f} {result['sa_peak']:<10.3f} {result['global_peak']:<10.3f} "
                      f"{result['ratio']:<10.2f} {result['sa_q40']:<10.3f} {result['global_q40']:<10.3f}")

        results[param] = param_results

    # Restore original
    restore_backup()

    # Save results
    with open('/Users/andrewtiffin/Projects/lesotho/analysis/sensitivity_results.json', 'w') as f:
        json.dump(results, f, indent=2)

    print("\n" + "=" * 80)
    print("Analysis complete!")
    print("Results saved to: sensitivity_results.json")
    print("=" * 80)

if __name__ == '__main__':
    main()
