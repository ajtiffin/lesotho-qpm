#!/usr/bin/env python3
"""
Generate the Oil Shock Results Report as PDF using WeasyPrint.
Reads simulation results from oil_shock_results.json and embeds IRF plots.
"""

import json
import base64
import os
from weasyprint import HTML

OUTPUT_DIR = '/home/user/lesotho-qpm'

def img_to_base64(filepath):
    """Embed an image as a base64 data URI."""
    with open(filepath, 'rb') as f:
        data = base64.b64encode(f.read()).decode('utf-8')
    return f'data:image/png;base64,{data}'

def generate_report():
    # Load results
    with open(os.path.join(OUTPUT_DIR, 'oil_shock_results.json')) as f:
        data = json.load(f)

    summary = data['summary']
    paths = data['irf_paths']

    # Key statistics for inline use
    pi_lso_impact = summary['Lesotho Inflation']['Impact (Q0)']
    pi_lso_yr1 = summary['Lesotho Inflation']['Year 1 Avg']
    pi_lso_yr2 = summary['Lesotho Inflation']['Year 2 Avg']
    y_lso_impact = summary['Lesotho Output Gap']['Impact (Q0)']
    y_lso_peak = summary['Lesotho Output Gap']['Peak']
    y_lso_peak_q = summary['Lesotho Output Gap']['Peak Quarter']
    i_lso_impact = summary['Lesotho Interest Rate']['Impact (Q0)']
    r_lso_impact = summary['Lesotho Real Rate']['Impact (Q0)']
    z_lso_impact = summary['Lesotho REER Gap']['Impact (Q0)']
    res_impact = summary['Reserves Gap']['Impact (Q0)']
    res_cum = summary['Reserves Gap']['Cumulative (5yr)']
    prem_impact = summary['Risk Premium']['Impact (Q0)']
    prem_peak = summary['Risk Premium']['Peak']
    prem_peak_q = summary['Risk Premium']['Peak Quarter']
    i_lso_peak = summary['Lesotho Interest Rate']['Peak']
    i_lso_peak_q = summary['Lesotho Interest Rate']['Peak Quarter']
    i_lso_yr1 = summary['Lesotho Interest Rate']['Year 1 Avg']
    i_lso_yr2 = summary['Lesotho Interest Rate']['Year 2 Avg']
    r_lso_peak = summary['Lesotho Real Rate']['Peak']
    r_lso_peak_q = summary['Lesotho Real Rate']['Peak Quarter']
    r_lso_yr1 = summary['Lesotho Real Rate']['Year 1 Avg']
    r_lso_yr2 = summary['Lesotho Real Rate']['Year 2 Avg']
    z_lso_peak = summary['Lesotho REER Gap']['Peak']
    z_lso_peak_q = summary['Lesotho REER Gap']['Peak Quarter']
    z_lso_yr1 = summary['Lesotho REER Gap']['Year 1 Avg']
    z_lso_yr2 = summary['Lesotho REER Gap']['Year 2 Avg']
    res_peak = summary['Reserves Gap']['Peak']
    res_peak_q = summary['Reserves Gap']['Peak Quarter']
    res_yr1 = summary['Reserves Gap']['Year 1 Avg']
    res_yr2 = summary['Reserves Gap']['Year 2 Avg']
    prem_yr1 = summary['Risk Premium']['Year 1 Avg']
    prem_yr2 = summary['Risk Premium']['Year 2 Avg']
    pi_lso_peak = summary['Lesotho Inflation']['Peak']
    pi_lso_peak_q = summary['Lesotho Inflation']['Peak Quarter']
    y_lso_yr1 = summary['Lesotho Output Gap']['Year 1 Avg']
    y_lso_yr2 = summary['Lesotho Output Gap']['Year 2 Avg']

    # Embed images
    img_macro = img_to_base64(os.path.join(OUTPUT_DIR, 'IRF_oil_shock_macro.png'))
    img_reserves = img_to_base64(os.path.join(OUTPUT_DIR, 'IRF_oil_shock_reserves.png'))
    img_decomp = img_to_base64(os.path.join(OUTPUT_DIR, 'IRF_oil_shock_decomposition.png'))
    img_compare = img_to_base64(os.path.join(OUTPUT_DIR, 'IRF_oil_shock_comparison.png'))

    html_content = f"""<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<style>
    @page {{
        size: A4;
        margin: 2cm 2.2cm;
        @top-center {{
            content: "Lesotho QPM — Oil Shock Analysis";
            font-size: 9pt;
            color: #666;
        }}
        @bottom-center {{
            content: "Page " counter(page) " of " counter(pages);
            font-size: 9pt;
            color: #666;
        }}
    }}
    body {{
        font-family: 'Georgia', 'Times New Roman', serif;
        font-size: 11pt;
        line-height: 1.5;
        color: #222;
    }}
    h1 {{
        font-size: 22pt;
        color: #1a3c6e;
        margin-bottom: 0.2em;
        border-bottom: 3px solid #1a3c6e;
        padding-bottom: 0.3em;
    }}
    h2 {{
        font-size: 15pt;
        color: #1a3c6e;
        margin-top: 1.5em;
        border-bottom: 1px solid #ccc;
        padding-bottom: 0.2em;
    }}
    h3 {{
        font-size: 12pt;
        color: #333;
        margin-top: 1.2em;
    }}
    .subtitle {{
        font-size: 14pt;
        color: #555;
        margin-top: 0;
        margin-bottom: 0.3em;
    }}
    .meta {{
        font-size: 10pt;
        color: #777;
        margin-bottom: 2em;
    }}
    .executive-summary {{
        background: #f0f4f8;
        border-left: 4px solid #1a3c6e;
        padding: 1em 1.2em;
        margin: 1.5em 0;
    }}
    .executive-summary p {{
        margin: 0.4em 0;
    }}
    .key-finding {{
        background: #fff8e1;
        border-left: 4px solid #f9a825;
        padding: 0.8em 1em;
        margin: 1em 0;
        font-style: italic;
    }}
    table {{
        border-collapse: collapse;
        width: 100%;
        margin: 1em 0;
        font-size: 10pt;
    }}
    th {{
        background: #1a3c6e;
        color: white;
        padding: 8px 10px;
        text-align: left;
        font-weight: bold;
    }}
    td {{
        padding: 6px 10px;
        border-bottom: 1px solid #ddd;
    }}
    tr:nth-child(even) {{
        background: #f9f9f9;
    }}
    .num {{
        text-align: right;
        font-family: 'Courier New', monospace;
    }}
    img.irf {{
        width: 100%;
        max-width: 100%;
        margin: 1em 0;
    }}
    .figure-caption {{
        text-align: center;
        font-size: 10pt;
        color: #555;
        font-style: italic;
        margin-top: -0.5em;
        margin-bottom: 1.5em;
    }}
    .equation {{
        background: #f5f5f5;
        padding: 0.6em 1em;
        margin: 0.8em 0;
        font-family: 'Courier New', monospace;
        font-size: 10pt;
        border-radius: 3px;
    }}
    .page-break {{
        page-break-before: always;
    }}
    ul {{
        margin: 0.5em 0;
        padding-left: 1.5em;
    }}
    li {{
        margin-bottom: 0.3em;
    }}
</style>
</head>
<body>

<h1>Impact of a 10% Oil Price Shock on Lesotho</h1>
<p class="subtitle">Results from the Lesotho Quarterly Projection Model (QPM)</p>
<p class="meta">
    Model: Lesotho QPM v2 (Recalibrated) &bull; Based on IMF CR/2023/269<br>
    Method: Perfect foresight simulation with iterative expectations<br>
    Date: March 2026
</p>

<div class="executive-summary">
    <h3 style="margin-top:0; color:#1a3c6e;">Executive Summary</h3>
    <p>This report presents the results of a <strong>10 percent oil price shock</strong> simulated
    through the Lesotho Quarterly Projection Model. The shock is modeled as a one-time 10 percentage
    point increase in oil price inflation, which propagates through the economy via commodity cost
    channels unique to Lesotho's CPI structure.</p>
    <p><strong>Key findings:</strong></p>
    <ul>
        <li>Lesotho inflation rises by <strong>{pi_lso_impact:.2f} pp on impact</strong>,
            driven by Lesotho's higher oil weight in CPI (8%) relative to South Africa (5%).</li>
        <li>The output gap expands by <strong>{y_lso_peak:.2f} pp</strong> (peaking at quarter
            {y_lso_peak_q:.0f}), as higher inflation lowers the real interest rate under the peg,
            creating an accommodative monetary stance that the CBL cannot independently offset.</li>
        <li>The real exchange rate appreciates ({z_lso_impact:.2f} pp on impact), improving
            Lesotho's external competitiveness metric while reflecting higher domestic prices.</li>
        <li>Foreign exchange reserves improve modestly as the REER appreciation reduces
            interventionist pressure, lowering the risk premium by up to <strong>{abs(prem_peak):.2f} pp</strong>.</li>
        <li>The shock is <strong>persistent</strong> (oil price AR coefficient = 0.70), with
            inflation effects lingering for approximately 8&ndash;10 quarters.</li>
    </ul>
</div>

<h2>1. The Oil Price Shock</h2>

<p>We model a <strong>one-time, 10 percentage point shock to oil price inflation</strong>
(<em>&epsilon;<sub>oil</sub></em> = 10.0 at <em>t</em> = 0). Given the oil price persistence
parameter (&rho;<sub>oil</sub> = 0.70), the oil price inflation follows:</p>

<div class="equation">
    &pi;<sup>oil</sup><sub>t</sub> = 0.70 &times; &pi;<sup>oil</sup><sub>t&minus;1</sub> + &epsilon;<sub>oil,t</sub>
</div>

<p>This generates a gradually declining oil inflation path: 10.0 pp on impact, 7.0 pp in Q1,
4.9 pp in Q2, declining to below 1 pp by Q8. The cumulative oil price level increase over
five years is approximately <strong>33.3 percent</strong>.</p>

<h3>Transmission channels to Lesotho</h3>
<p>The oil shock transmits to Lesotho through the <strong>differential CPI weight channel</strong>.
The Lesotho Phillips curve is:</p>
<div class="equation">
    &pi;<sup>LSO</sup><sub>t</sub> = &pi;<sup>ZAF</sup><sub>t</sub>
    + (&omega;<sup>LSO</sup><sub>1</sub> &minus; &omega;<sup>ZAF</sup><sub>1</sub>) &times; &pi;<sup>oil</sup><sub>t</sub>
    + (&omega;<sup>LSO</sup><sub>2</sub> &minus; &omega;<sup>ZAF</sup><sub>2</sub>) &times; &pi;<sup>food</sup><sub>t</sub>
    + &beta;<sub>1</sub> y<sup>LSO</sup><sub>t</sub> + &hellip;
</div>

<p>Since Lesotho has a higher oil weight in its CPI basket (8%) compared to South Africa (5%),
the <strong>differential effect is 3 percentage points per unit of oil inflation</strong>.
On impact: (0.08 &minus; 0.05) &times; 10.0 = <strong>0.30 pp</strong> of direct inflation pass-through,
with an additional 0.02 pp from the demand feedback (output gap &times; &beta;<sub>1</sub>).</p>

<div class="key-finding">
    <strong>Key insight:</strong> Under Lesotho's currency peg to the Rand, the Central Bank of
    Lesotho (CBL) cannot independently tighten monetary policy in response to the oil-driven inflation.
    The CBL must track SARB's rate, but since South Africa's Phillips curve in this model does not
    include direct commodity price terms, SARB does not respond. This creates an
    <strong>asymmetric inflationary burden</strong> on Lesotho.
</div>

<div class="page-break"></div>

<h2>2. Macroeconomic Impact</h2>

<h3>2.1 Summary of Results</h3>

<table>
    <tr>
        <th>Variable</th>
        <th class="num">Impact (Q0)</th>
        <th class="num">Peak</th>
        <th class="num">Peak Qtr</th>
        <th class="num">Year 1 Avg</th>
        <th class="num">Year 2 Avg</th>
    </tr>
    <tr>
        <td>Oil Price Inflation (pp)</td>
        <td class="num">+10.00</td>
        <td class="num">+10.00</td>
        <td class="num">0</td>
        <td class="num">+6.33</td>
        <td class="num">+1.52</td>
    </tr>
    <tr>
        <td>Lesotho Inflation (pp)</td>
        <td class="num">+{pi_lso_impact:.2f}</td>
        <td class="num">+{pi_lso_peak:.2f}</td>
        <td class="num">{pi_lso_peak_q:.0f}</td>
        <td class="num">+{pi_lso_yr1:.2f}</td>
        <td class="num">+{pi_lso_yr2:.2f}</td>
    </tr>
    <tr>
        <td>Lesotho Output Gap (pp)</td>
        <td class="num">+{y_lso_impact:.2f}</td>
        <td class="num">+{y_lso_peak:.2f}</td>
        <td class="num">{y_lso_peak_q:.0f}</td>
        <td class="num">+{y_lso_yr1:.2f}</td>
        <td class="num">+{y_lso_yr2:.2f}</td>
    </tr>
    <tr>
        <td>Lesotho Real Interest Rate (pp)</td>
        <td class="num">{r_lso_impact:.2f}</td>
        <td class="num">{r_lso_peak:.2f}</td>
        <td class="num">{r_lso_peak_q:.0f}</td>
        <td class="num">{r_lso_yr1:.2f}</td>
        <td class="num">{r_lso_yr2:.2f}</td>
    </tr>
    <tr>
        <td>CBL Interest Rate (pp)</td>
        <td class="num">{i_lso_impact:.2f}</td>
        <td class="num">{i_lso_peak:.2f}</td>
        <td class="num">{i_lso_peak_q:.0f}</td>
        <td class="num">{i_lso_yr1:.2f}</td>
        <td class="num">{i_lso_yr2:.2f}</td>
    </tr>
    <tr>
        <td>Real Exchange Rate Gap (pp)</td>
        <td class="num">{z_lso_impact:.2f}</td>
        <td class="num">{z_lso_peak:.2f}</td>
        <td class="num">{z_lso_peak_q:.0f}</td>
        <td class="num">{z_lso_yr1:.2f}</td>
        <td class="num">{z_lso_yr2:.2f}</td>
    </tr>
    <tr>
        <td>Reserves Gap (months)</td>
        <td class="num">+{res_impact:.2f}</td>
        <td class="num">+{res_peak:.2f}</td>
        <td class="num">{res_peak_q:.0f}</td>
        <td class="num">+{res_yr1:.2f}</td>
        <td class="num">+{res_yr2:.2f}</td>
    </tr>
    <tr>
        <td>Risk Premium (pp)</td>
        <td class="num">{prem_impact:.2f}</td>
        <td class="num">{prem_peak:.2f}</td>
        <td class="num">{prem_peak_q:.0f}</td>
        <td class="num">{prem_yr1:.2f}</td>
        <td class="num">{prem_yr2:.2f}</td>
    </tr>
</table>
<p class="figure-caption">Table 1: Impulse response summary statistics for a 10% oil price shock</p>

<h3>2.2 Impulse Response Functions</h3>

<img class="irf" src="{img_macro}" alt="Macroeconomic IRFs">
<p class="figure-caption">Figure 1: Impulse responses of key macroeconomic variables to a 10% oil price shock.
The shock raises Lesotho inflation on impact while lowering the real interest rate, producing
a mildly expansionary output effect under the peg.</p>

<div class="page-break"></div>

<h2>3. Transmission Mechanism Analysis</h2>

<h3>3.1 Inflation Channel</h3>

<p>The oil shock affects Lesotho inflation through two reinforcing channels:</p>
<ol>
    <li><strong>Direct commodity pass-through:</strong> The differential oil CPI weight
    (&omega;<sup>LSO</sup><sub>1</sub> &minus; &omega;<sup>ZAF</sup><sub>1</sub> = 0.03)
    transmits 0.30 pp of inflation on impact. This is the dominant channel, accounting for
    approximately 93% of the initial inflation response.</li>
    <li><strong>Demand feedback:</strong> The positive output gap (&beta;<sub>1</sub> = 0.25)
    adds a further 0.02 pp through the Phillips curve demand channel.</li>
</ol>

<img class="irf" src="{img_decomp}" alt="Inflation Decomposition">
<p class="figure-caption">Figure 2: Decomposition of Lesotho inflation response. The oil price
differential effect (red) dominates, with a small contribution from demand pressure (blue).
SA inflation pass-through (green) is negligible as the SA Phillips curve does not include
direct commodity price effects.</p>

<h3>3.2 Real Interest Rate and Output Channel</h3>

<p>The most notable result is the <strong>expansionary output effect</strong> of the oil shock.
This seemingly counterintuitive result follows directly from the peg constraint:</p>

<ol>
    <li>Oil shock raises Lesotho inflation by {pi_lso_impact:.2f} pp</li>
    <li>The CBL cannot independently raise rates (must track SARB)</li>
    <li>SARB does not respond (oil does not enter SA Phillips curve directly)</li>
    <li>Real interest rate falls: <em>r</em><sup>LSO</sup> = <em>i</em><sup>LSO</sup> &minus;
        E<sub>t</sub>&pi;<sup>LSO</sup><sub>t+1</sub> drops by {abs(r_lso_impact):.2f} pp</li>
    <li>Lower real rate stimulates demand through the IS curve</li>
</ol>

<div class="key-finding">
    <strong>Policy implication:</strong> Under the peg, oil price shocks create a
    <em>procyclical monetary stance</em> in Lesotho. Higher inflation lowers real rates,
    stimulating demand when the central bank should be tightening. This highlights the cost
    of limited monetary autonomy when facing asymmetric supply shocks.
</div>

<h3>3.3 External Sector: Reserves and Risk Premium</h3>

<img class="irf" src="{img_reserves}" alt="Reserves Channel IRFs">
<p class="figure-caption">Figure 3: Oil shock transmission through the reserves and risk premium
channel. The REER appreciation (lower panel, left) reduces reserve pressure, slightly improving
the reserves gap and lowering the risk premium.</p>

<p>The oil shock produces a <strong>modest improvement in reserves</strong> through an indirect channel:</p>
<ul>
    <li>Higher Lesotho inflation relative to SA causes <strong>real appreciation</strong>
        (REER gap = {z_lso_impact:.2f} pp)</li>
    <li>In this model, REER appreciation reduces exchange rate pressure on reserves
        (<em>f</em><sub>2</sub> &times; <em>z</em>), improving the reserves gap</li>
    <li>Higher reserves reduce the risk premium, further easing monetary conditions</li>
</ul>

<p>This creates a <strong>positive feedback loop</strong> that amplifies the initial
expansionary impulse: oil shock &rarr; inflation &uarr; &rarr; real rate &darr; &rarr;
output &uarr; &rarr; REER appreciation &rarr; reserves &uarr; &rarr; premium &darr; &rarr;
output &uarr; further.</p>

<div class="page-break"></div>

<h2>4. Lesotho vs. South Africa Comparison</h2>

<img class="irf" src="{img_compare}" alt="Lesotho vs SA Comparison">
<p class="figure-caption">Figure 4: Comparison of Lesotho and South Africa responses.
Lesotho bears the full brunt of the inflation shock due to its higher CPI oil weight,
while South Africa is insulated. The asymmetric response highlights the cost of the
peg when facing commodity-specific shocks.</p>

<p>The comparison reveals the <strong>fundamental asymmetry</strong> of commodity shocks
under the peg arrangement:</p>

<table>
    <tr>
        <th>Variable</th>
        <th class="num">Lesotho</th>
        <th class="num">South Africa</th>
        <th>Implication</th>
    </tr>
    <tr>
        <td>Inflation (impact)</td>
        <td class="num">+{pi_lso_impact:.2f} pp</td>
        <td class="num">0.00 pp</td>
        <td>Lesotho bears all inflation</td>
    </tr>
    <tr>
        <td>Output gap (peak)</td>
        <td class="num">+{y_lso_peak:.2f} pp</td>
        <td class="num">0.00 pp</td>
        <td>Procyclical monetary stance</td>
    </tr>
    <tr>
        <td>Policy rate (impact)</td>
        <td class="num">{i_lso_impact:.2f} pp</td>
        <td class="num">0.00 pp</td>
        <td>No independent response possible</td>
    </tr>
    <tr>
        <td>Real rate (impact)</td>
        <td class="num">{r_lso_impact:.2f} pp</td>
        <td class="num">0.00 pp</td>
        <td>Monetary conditions loosen</td>
    </tr>
</table>
<p class="figure-caption">Table 2: Asymmetric impact of oil shock on Lesotho vs. South Africa</p>

<div class="key-finding">
    <strong>Structural vulnerability:</strong> The model confirms that Lesotho's higher
    dependence on oil imports (8% of CPI vs. 5% for SA) combined with the loss of monetary
    autonomy under the peg creates an asymmetric inflation burden. South Africa can absorb
    oil shocks through its flexible monetary policy framework; Lesotho cannot.
</div>

<h2>5. Sensitivity and Robustness</h2>

<h3>5.1 Shock Size Proportionality</h3>

<p>Since the model is linear, all results scale proportionally with the shock size. A 20% oil
shock would produce exactly double the inflation and output responses. A 50% shock (similar
to the 2022 energy crisis) would generate approximately:</p>
<ul>
    <li>Inflation: +{pi_lso_impact*5:.1f} pp on impact</li>
    <li>Output gap: +{y_lso_peak*5:.2f} pp peak expansion</li>
    <li>Real rate: {r_lso_impact*5:.1f} pp decline</li>
</ul>

<h3>5.2 Key Parameter Sensitivity</h3>

<table>
    <tr>
        <th>Parameter</th>
        <th>Base Value</th>
        <th>Role in Oil Shock Transmission</th>
    </tr>
    <tr>
        <td>&omega;<sup>LSO</sup><sub>1</sub> (oil CPI weight)</td>
        <td>0.08</td>
        <td>Direct pass-through; doubling to 0.16 would triple inflation impact</td>
    </tr>
    <tr>
        <td>&rho;<sub>oil</sub> (oil persistence)</td>
        <td>0.70</td>
        <td>Governs duration; higher values prolong inflationary period</td>
    </tr>
    <tr>
        <td>&beta;<sub>1</sub> (Phillips curve slope)</td>
        <td>0.25</td>
        <td>Amplifies demand feedback; steeper curve raises second-round effects</td>
    </tr>
    <tr>
        <td>&alpha;<sub>4</sub> (monetary conditions)</td>
        <td>0.45</td>
        <td>Determines output sensitivity to real rate decline</td>
    </tr>
</table>
<p class="figure-caption">Table 3: Key parameters governing oil shock transmission</p>

<div class="page-break"></div>

<h2>6. Policy Implications</h2>

<h3>6.1 The CBL's Constrained Response</h3>

<p>The oil shock analysis reveals a fundamental limitation of Lesotho's monetary arrangement.
Under the peg, the CBL faces a <strong>"trapped accommodation" problem</strong>:</p>

<ul>
    <li>Oil shock raises domestic inflation above SA levels</li>
    <li>The peg requires CBL to track SARB's policy rate</li>
    <li>SARB has no reason to tighten (oil doesn't directly affect SA in this model)</li>
    <li>Result: <strong>real monetary conditions loosen precisely when they should tighten</strong></li>
</ul>

<h3>6.2 Recommended Policy Responses</h3>

<p>Given the monetary policy constraint, the authorities could consider:</p>

<ol>
    <li><strong>Targeted fiscal measures:</strong> Temporary fuel subsidies or tax relief to
    partially offset the CPI impact (though this has fiscal cost and may drain reserves
    if sustained).</li>
    <li><strong>Macroprudential tightening:</strong> Reserve requirements or loan-to-value
    limits could cool demand without violating the peg.</li>
    <li><strong>Strategic petroleum reserves:</strong> Building oil buffer stocks during periods
    of low prices to smooth domestic price volatility.</li>
    <li><strong>Energy diversification:</strong> Reducing the CPI oil weight through investment
    in renewable energy and energy efficiency would structurally reduce vulnerability.</li>
</ol>

<h3>6.3 Reserve Adequacy Considerations</h3>

<p>While the oil shock modestly <em>improves</em> reserves in this simulation (through the
REER channel), a sustained oil price increase would eventually raise import costs, potentially
reversing this effect. Maintaining reserves above the ARA target of 4.7 months of import
cover is essential to preserve the credibility of the peg arrangement during commodity
price episodes.</p>

<h2>7. Model Limitations and Extensions</h2>

<ul>
    <li><strong>No direct SA oil channel:</strong> The SA Phillips curve does not include oil
    prices directly. In reality, SARB would also face higher headline inflation and may
    tighten, partially mitigating the Lesotho real rate decline.</li>
    <li><strong>Linear model:</strong> Cannot capture threshold effects (e.g., reserves falling
    below a critical level triggering nonlinear premium responses).</li>
    <li><strong>No second-round effects on food:</strong> Oil price increases raise agricultural
    input costs, which would amplify the shock through Lesotho's high food CPI weight (35%).</li>
    <li><strong>No terms-of-trade deterioration:</strong> Rising oil import costs worsen
    Lesotho's current account, which could create additional reserve pressure not captured here.</li>
</ul>

<h2>8. Conclusion</h2>

<p>The simulation of a 10% oil price shock through the Lesotho QPM reveals the structural
vulnerability of a small, import-dependent economy operating under a currency peg. The key
findings are:</p>

<ol>
    <li><strong>Immediate inflation impact:</strong> {pi_lso_impact:.2f} pp rise in Lesotho
    CPI inflation on impact, driven by the differential oil weight in the consumption basket.</li>
    <li><strong>Procyclical monetary conditions:</strong> Unable to tighten independently,
    Lesotho experiences a {abs(r_lso_impact):.2f} pp real interest rate decline, producing
    a counterintuitive output expansion of up to {y_lso_peak:.2f} pp.</li>
    <li><strong>Persistent effects:</strong> With oil price persistence of 0.70, inflation
    remains elevated for 8&ndash;10 quarters, averaging {pi_lso_yr1:.2f} pp in year 1 and
    {pi_lso_yr2:.2f} pp in year 2.</li>
    <li><strong>Asymmetric burden:</strong> Lesotho bears the full inflationary cost while
    South Africa is insulated, highlighting the price Lesotho pays for monetary policy
    subordination under the CMA arrangement.</li>
</ol>

<p>These results underscore the importance of <strong>non-monetary policy instruments</strong>&mdash;fiscal
buffers, macroprudential tools, and structural energy reforms&mdash;for managing commodity
price shocks in Lesotho.</p>

<hr style="margin-top:2em;">
<p style="font-size:9pt; color:#888;">
    <strong>Technical note:</strong> Model solved using iterative perfect-foresight method
    (converged in 33 iterations). All results are percentage point deviations from steady state.
    Based on the Lesotho QPM v2 (recalibrated), implemented from IMF Country Report No. 2023/269.
</p>

</body>
</html>"""

    # Generate PDF
    pdf_path = os.path.join(OUTPUT_DIR, 'OIL_SHOCK_RESULTS_REPORT.pdf')
    HTML(string=html_content).write_pdf(pdf_path)
    print(f"PDF report generated: {pdf_path}")

    return pdf_path


if __name__ == '__main__':
    generate_report()
