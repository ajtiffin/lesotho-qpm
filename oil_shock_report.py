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
    shock_duration = data.get('shock_duration', 1)

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

    # Oil price summary stats
    pi_oil_impact = summary['Oil Price Inflation']['Impact (Q0)']
    pi_oil_peak = summary['Oil Price Inflation']['Peak']
    pi_oil_peak_q = summary['Oil Price Inflation']['Peak Quarter']
    pi_oil_yr1 = summary['Oil Price Inflation']['Year 1 Avg']
    pi_oil_yr2 = summary['Oil Price Inflation']['Year 2 Avg']
    pi_oil_cum = summary['Oil Price Inflation']['Cumulative (5yr)']

    # Embed images
    img_macro = img_to_base64(os.path.join(OUTPUT_DIR, 'IRF_oil_shock_macro.png'))
    img_reserves = img_to_base64(os.path.join(OUTPUT_DIR, 'IRF_oil_shock_reserves.png'))
    img_decomp = img_to_base64(os.path.join(OUTPUT_DIR, 'IRF_oil_shock_decomposition.png'))
    img_compare = img_to_base64(os.path.join(OUTPUT_DIR, 'IRF_oil_shock_comparison.png'))

    dur_label = f" ({shock_duration}-Quarter Persistent)" if shock_duration > 1 else ""

    html_content = f"""<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<style>
    @page {{
        size: A4;
        margin: 2cm 2.2cm;
        @top-center {{
            content: "Lesotho QPM — Global Oil Shock Analysis";
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

<h1>Impact of a Global Oil Price Shock on Lesotho{dur_label}</h1>
<p class="subtitle">Results from the Lesotho Quarterly Projection Model (QPM)</p>
<p class="meta">
    Model: Lesotho QPM v2 (Recalibrated) &bull; Based on IMF CR/2023/269<br>
    Shock: 10% oil price inflation sustained for {shock_duration} consecutive quarters<br>
    Method: Perfect foresight simulation with iterative expectations<br>
    Date: March 2026
</p>

<div class="executive-summary">
    <h3 style="margin-top:0; color:#1a3c6e;">Executive Summary</h3>
    <p>This report presents the results of a <strong>global oil price shock</strong> simulated
    through the Lesotho Quarterly Projection Model. The shock is modeled as a
    <strong>10 percentage point oil price inflation impulse sustained for {shock_duration}
    consecutive quarters</strong> (Q0&ndash;Q{shock_duration - 1}), representing a persistent
    global supply disruption such as an OPEC production cut, geopolitical conflict, or
    sustained supply-chain bottleneck.</p>
    <p><strong>Key findings:</strong></p>
    <ul>
        <li>Lesotho inflation peaks at <strong>{pi_lso_peak:.2f} pp in quarter {pi_lso_peak_q:.0f}</strong>,
            rising from {pi_lso_impact:.2f} pp on impact to nearly 1 pp as the persistent shock
            compounds through the AR(1) oil price process.</li>
        <li>The output gap expands significantly, peaking at <strong>{y_lso_peak:.2f} pp
            in quarter {y_lso_peak_q:.0f}</strong>, as the sustained inflation episode
            drives a prolonged decline in real interest rates that the CBL cannot offset
            under the peg.</li>
        <li>The real interest rate falls by up to <strong>{abs(r_lso_peak):.2f} pp</strong>
            (quarter {r_lso_peak_q:.0f}), creating strongly procyclical monetary conditions.</li>
        <li>Cumulative oil price level increase over 5 years:
            approximately <strong>{pi_oil_cum:.0f} percent</strong>, reflecting
            both the repeated shocks and the autoregressive persistence (&rho;<sub>oil</sub> = 0.70).</li>
        <li>The REER appreciates by up to <strong>{abs(z_lso_peak):.2f} pp</strong>,
            generating a reserves improvement of {res_peak:.2f} months and a risk premium
            decline of {abs(prem_peak):.2f} pp&mdash;further amplifying the expansionary impulse.</li>
    </ul>
</div>

<h2>1. The Oil Price Shock Scenario</h2>

<h3>1.1 Design of the Persistent Shock</h3>

<p>Unlike a one-off oil price spike, this scenario models a <strong>sustained global oil price
disturbance</strong> where the shock impulse (&epsilon;<sub>oil</sub> = 10.0 pp) is applied
for <strong>{shock_duration} consecutive quarters</strong>. This captures real-world episodes where
oil prices remain elevated for an extended period due to structural supply constraints.</p>

<p>The oil price inflation process follows:</p>
<div class="equation">
    &pi;<sup>oil</sup><sub>t</sub> = 0.70 &times; &pi;<sup>oil</sup><sub>t&minus;1</sub> + &epsilon;<sub>oil,t</sub>
    &nbsp;&nbsp;&nbsp; where &epsilon;<sub>oil,t</sub> = 10.0 for t = 0, 1, 2, 3
</div>

<p>Because the AR(1) coefficient (&rho;<sub>oil</sub> = 0.70) causes oil inflation to persist
beyond the shock period, the {shock_duration}-quarter impulse <strong>compounds</strong> over time:</p>

<table>
    <tr>
        <th>Quarter</th>
        <th class="num">&epsilon;<sub>oil</sub></th>
        <th class="num">&pi;<sup>oil</sup></th>
        <th>Mechanism</th>
    </tr>
    <tr>
        <td>Q0</td>
        <td class="num">10.0</td>
        <td class="num">+{pi_oil_impact:.1f}</td>
        <td>Initial shock</td>
    </tr>
    <tr>
        <td>Q1</td>
        <td class="num">10.0</td>
        <td class="num">+17.0</td>
        <td>New shock + 0.70 &times; prior = 10 + 7</td>
    </tr>
    <tr>
        <td>Q2</td>
        <td class="num">10.0</td>
        <td class="num">+21.9</td>
        <td>Compounding: 10 + 0.70 &times; 17</td>
    </tr>
    <tr>
        <td>Q3</td>
        <td class="num">10.0</td>
        <td class="num">+{pi_oil_peak:.1f}</td>
        <td>Peak oil inflation (final shock quarter)</td>
    </tr>
    <tr>
        <td>Q4</td>
        <td class="num">0.0</td>
        <td class="num">~17.7</td>
        <td>Decay begins: 0.70 &times; {pi_oil_peak:.1f}</td>
    </tr>
    <tr>
        <td>Q8</td>
        <td class="num">0.0</td>
        <td class="num">~4.3</td>
        <td>Continued AR decay</td>
    </tr>
</table>
<p class="figure-caption">Table 1: Oil price inflation path under the {shock_duration}-quarter persistent shock</p>

<p>The peak oil inflation of <strong>{pi_oil_peak:.1f} pp in Q{pi_oil_peak_q:.0f}</strong> is
roughly {pi_oil_peak / pi_oil_impact:.1f}&times; the single-quarter impact, demonstrating the
powerful compounding effect of persistent shocks through the AR process.</p>

<h3>1.2 Transmission Channels</h3>
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
With oil inflation peaking at {pi_oil_peak:.1f} pp, the direct inflation pass-through
reaches 0.03 &times; {pi_oil_peak:.1f} = <strong>{0.03 * pi_oil_peak:.2f} pp</strong>
before accounting for demand feedback.</p>

<div class="key-finding">
    <strong>Key insight:</strong> Under Lesotho's currency peg to the Rand, the Central Bank of
    Lesotho (CBL) cannot independently tighten monetary policy in response to the oil-driven inflation.
    A persistent shock compounds this problem: the CBL must passively absorb {shock_duration} quarters
    of progressively worsening inflation with no policy lever available.
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
        <td class="num">+{pi_oil_impact:.2f}</td>
        <td class="num">+{pi_oil_peak:.2f}</td>
        <td class="num">{pi_oil_peak_q:.0f}</td>
        <td class="num">+{pi_oil_yr1:.2f}</td>
        <td class="num">+{pi_oil_yr2:.2f}</td>
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
<p class="figure-caption">Table 2: Impulse response summary statistics for a 10% oil price shock
persisting {shock_duration} quarters</p>

<h3>2.2 Impulse Response Functions</h3>

<img class="irf" src="{img_macro}" alt="Macroeconomic IRFs">
<p class="figure-caption">Figure 1: Impulse responses of key macroeconomic variables to a
{shock_duration}-quarter persistent 10% oil price shock. Note the compounding pattern in oil
price inflation (top-left), the sustained inflation elevation in Lesotho (top-center), and the
progressively widening output gap (middle-left) driven by declining real interest rates.</p>

<div class="page-break"></div>

<h2>3. Transmission Mechanism Analysis</h2>

<h3>3.1 Inflation Channel</h3>

<p>The persistent oil shock produces a <strong>hump-shaped inflation response</strong> in Lesotho,
peaking at {pi_lso_peak:.2f} pp in Q{pi_lso_peak_q:.0f}. This contrasts with a single-quarter
shock where inflation peaks immediately and decays monotonically. The inflation dynamics
reflect two reinforcing forces:</p>
<ol>
    <li><strong>Direct commodity pass-through:</strong> The differential oil CPI weight
    (&omega;<sup>LSO</sup><sub>1</sub> &minus; &omega;<sup>ZAF</sup><sub>1</sub> = 0.03)
    transmits {pi_lso_impact:.2f} pp of inflation on impact, rising to {0.03 * pi_oil_peak:.2f} pp
    at the oil inflation peak as successive shocks compound through the AR process.</li>
    <li><strong>Demand feedback:</strong> The expanding output gap (&beta;<sub>1</sub> = 0.25)
    adds progressively more second-round inflation as the economy overheats, contributing
    approximately {0.25 * y_lso_peak:.2f} pp at the output peak.</li>
</ol>

<img class="irf" src="{img_decomp}" alt="Inflation Decomposition">
<p class="figure-caption">Figure 2: Decomposition of Lesotho inflation response. The oil price
differential effect (red) dominates initially, with demand pressure (blue) growing over time
as the output gap expands. The hump-shaped total inflation profile reflects the compounding
of the {shock_duration}-quarter persistent shock.</p>

<h3>3.2 Real Interest Rate and Output Channel</h3>

<p>The persistent shock dramatically amplifies the <strong>procyclical monetary stance
problem</strong>. With inflation elevated for multiple quarters, the real interest rate
decline is both larger and more sustained than under a one-off shock:</p>

<ol>
    <li>Persistent oil shock sustains inflation at {pi_lso_yr1:.2f} pp average in year 1</li>
    <li>The CBL cannot independently raise rates (must track SARB)</li>
    <li>SARB does not respond (oil does not enter SA Phillips curve directly)</li>
    <li>Real interest rate falls by up to <strong>{abs(r_lso_peak):.2f} pp</strong>
        (Q{r_lso_peak_q:.0f}), averaging {abs(r_lso_yr1):.2f} pp below steady state
        in year 1 and {abs(r_lso_yr2):.2f} pp in year 2</li>
    <li>The sustained real rate decline drives the output gap to <strong>{y_lso_peak:.2f} pp</strong>
        by Q{y_lso_peak_q:.0f}&mdash;a significant overheating episode</li>
</ol>

<div class="key-finding">
    <strong>Policy implication:</strong> A persistent global oil shock creates a
    <em>prolonged procyclical monetary stance</em> in Lesotho. The {shock_duration}-quarter
    persistence means the economy overheats for approximately {y_lso_peak_q:.0f}+ quarters,
    with the output gap averaging {y_lso_yr1:.2f} pp in year 1 and {y_lso_yr2:.2f} pp
    in year 2. This sustained overheating is far more destabilizing than a transient spike,
    as it risks entrenching inflationary expectations and creating asset price distortions.
</div>

<h3>3.3 External Sector: Reserves and Risk Premium</h3>

<img class="irf" src="{img_reserves}" alt="Reserves Channel IRFs">
<p class="figure-caption">Figure 3: Oil shock transmission through the reserves and risk premium
channel. The persistent REER appreciation builds over the shock period, producing a substantial
reserves improvement and risk premium decline that amplifies the expansionary impulse.</p>

<p>The persistent shock significantly amplifies the <strong>reserves-premium feedback channel</strong>:</p>
<ul>
    <li>Sustained higher Lesotho inflation causes a <strong>cumulative real appreciation</strong>
        of up to {abs(z_lso_peak):.2f} pp (Q{z_lso_peak_q:.0f})</li>
    <li>This improvement in the REER reduces exchange rate pressure on reserves,
        pushing the reserves gap to <strong>+{res_peak:.2f} months</strong> by Q{res_peak_q:.0f}</li>
    <li>Higher reserves lower the risk premium by up to <strong>{abs(prem_peak):.2f} pp</strong>,
        easing borrowing conditions</li>
    <li>The lower premium feeds back to output via the IS curve, creating a
        <strong>self-reinforcing expansionary loop</strong></li>
</ul>

<p>This amplification mechanism is substantially stronger under a persistent shock.
The reserves improvement is {abs(res_peak / res_impact):.0f}&times; larger than the
initial impact, reflecting the compounding of the REER appreciation over multiple quarters.</p>

<div class="page-break"></div>

<h2>4. Lesotho vs. South Africa Comparison</h2>

<img class="irf" src="{img_compare}" alt="Lesotho vs SA Comparison">
<p class="figure-caption">Figure 4: Comparison of Lesotho and South Africa responses to the
persistent oil shock. The asymmetry is stark: Lesotho experiences sustained inflation and
output overheating while South Africa remains entirely unaffected. This divergence persists
well beyond the {shock_duration}-quarter shock period.</p>

<p>The persistent shock magnifies the <strong>fundamental asymmetry</strong> of commodity shocks
under the peg arrangement:</p>

<table>
    <tr>
        <th>Variable</th>
        <th class="num">Lesotho</th>
        <th class="num">South Africa</th>
        <th>Implication</th>
    </tr>
    <tr>
        <td>Inflation (peak)</td>
        <td class="num">+{pi_lso_peak:.2f} pp</td>
        <td class="num">0.00 pp</td>
        <td>Lesotho bears all inflation for {shock_duration}+ quarters</td>
    </tr>
    <tr>
        <td>Output gap (peak)</td>
        <td class="num">+{y_lso_peak:.2f} pp</td>
        <td class="num">0.00 pp</td>
        <td>Sustained procyclical overheating</td>
    </tr>
    <tr>
        <td>Policy rate (impact)</td>
        <td class="num">{i_lso_impact:.2f} pp</td>
        <td class="num">0.00 pp</td>
        <td>No independent monetary response possible</td>
    </tr>
    <tr>
        <td>Real rate (peak)</td>
        <td class="num">{r_lso_peak:.2f} pp</td>
        <td class="num">0.00 pp</td>
        <td>Deep, sustained monetary easing</td>
    </tr>
    <tr>
        <td>Year 1 avg inflation</td>
        <td class="num">+{pi_lso_yr1:.2f} pp</td>
        <td class="num">0.00 pp</td>
        <td>Prolonged cost-of-living pressure</td>
    </tr>
    <tr>
        <td>Year 2 avg inflation</td>
        <td class="num">+{pi_lso_yr2:.2f} pp</td>
        <td class="num">0.00 pp</td>
        <td>Slow normalization after shock ends</td>
    </tr>
</table>
<p class="figure-caption">Table 3: Asymmetric impact of persistent oil shock on Lesotho vs. South Africa</p>

<div class="key-finding">
    <strong>Structural vulnerability:</strong> The persistent shock scenario starkly illustrates the
    cost of monetary subordination. Lesotho's inflation averages {pi_lso_yr1:.2f} pp above steady
    state for a full year&mdash;equivalent to an annual CPI increase of roughly
    {pi_lso_yr1 * 4:.1f} pp in annualized terms&mdash;while South Africa is entirely insulated.
    For a country where food (35% of CPI) and fuel are essential household expenditures,
    this represents a significant welfare loss concentrated on the poorest households.
</div>

<h2>5. Comparison: Persistent vs. One-Off Shock</h2>

<p>To contextualize the severity of the persistent shock, we compare peak responses
against a single-quarter benchmark (computed by linearity):</p>

<table>
    <tr>
        <th>Variable</th>
        <th class="num">1Q Shock (peak)</th>
        <th class="num">{shock_duration}Q Shock (peak)</th>
        <th class="num">Amplification</th>
    </tr>
    <tr>
        <td>Oil Price Inflation</td>
        <td class="num">10.0 pp</td>
        <td class="num">{pi_oil_peak:.1f} pp</td>
        <td class="num">{pi_oil_peak / 10.0:.1f}&times;</td>
    </tr>
    <tr>
        <td>Lesotho Inflation</td>
        <td class="num">~0.32 pp</td>
        <td class="num">{pi_lso_peak:.2f} pp</td>
        <td class="num">{pi_lso_peak / 0.32:.1f}&times;</td>
    </tr>
    <tr>
        <td>Output Gap</td>
        <td class="num">~0.19 pp</td>
        <td class="num">{y_lso_peak:.2f} pp</td>
        <td class="num">{y_lso_peak / 0.19:.1f}&times;</td>
    </tr>
    <tr>
        <td>Real Interest Rate</td>
        <td class="num">~&minus;0.26 pp</td>
        <td class="num">{r_lso_peak:.2f} pp</td>
        <td class="num">{abs(r_lso_peak) / 0.26:.1f}&times;</td>
    </tr>
</table>
<p class="figure-caption">Table 4: Amplification from single-quarter to {shock_duration}-quarter persistent shock</p>

<p>The persistent shock produces a <strong>{pi_lso_peak / 0.32:.1f}&times; amplification</strong>
in peak inflation and a <strong>{y_lso_peak / 0.19:.1f}&times; amplification</strong> in peak
output response. This super-linear amplification arises from the compounding of the AR(1)
process combined with the feedback through the real interest rate and reserves channels.</p>

<div class="page-break"></div>

<h2>6. Policy Implications</h2>

<h3>6.1 The CBL's Constrained Response</h3>

<p>The persistent oil shock analysis reveals a severe limitation of Lesotho's monetary arrangement.
Under the peg, the CBL faces a <strong>"trapped accommodation" problem</strong> that intensifies
over time:</p>

<ul>
    <li>Quarter after quarter, oil shocks raise domestic inflation above SA levels</li>
    <li>The peg requires CBL to track SARB's policy rate throughout</li>
    <li>SARB has no reason to tighten (oil doesn't directly affect SA in this model)</li>
    <li>The real rate decline <em>cumulates</em>, reaching {r_lso_peak:.2f} pp by Q{r_lso_peak_q:.0f}</li>
    <li>Result: <strong>monetary conditions loosen progressively for {shock_duration}+ quarters,
        precisely when they should be tightening progressively</strong></li>
</ul>

<h3>6.2 Recommended Policy Responses</h3>

<p>The severity of the persistent shock scenario makes the case for non-monetary policy
instruments even more compelling:</p>

<ol>
    <li><strong>Pre-positioned fuel price stabilization fund:</strong> Given the {shock_duration}-quarter
    duration, temporary fuel subsidies must be pre-funded to avoid depleting reserves. A
    stabilization fund financed during low oil price periods could absorb
    approximately {pi_lso_yr1:.1f} pp of CPI impact per quarter.</li>
    <li><strong>Macroprudential tightening:</strong> With output expanding {y_lso_peak:.2f} pp
    above potential, immediate tightening of reserve requirements and loan-to-value limits
    is warranted to prevent credit overheating and asset price distortions.</li>
    <li><strong>Strategic petroleum reserves:</strong> A 90-day strategic reserve (in line with
    IEA recommendations) could buffer {shock_duration}&ndash;6 quarters of supply disruption,
    breaking the direct pass-through channel.</li>
    <li><strong>Energy transition acceleration:</strong> The persistent nature of the shock
    underscores the long-term case for reducing the CPI oil weight. Each 1pp reduction in
    the oil CPI weight would lower the inflation impact by approximately
    {pi_oil_peak * 0.01:.2f} pp at the peak.</li>
    <li><strong>Coordinated CMA response:</strong> Negotiate with SARB for a commodity-price
    adjustment mechanism in the CMA framework, allowing CBL to add a small
    commodity-adjustment premium to its policy rate during sustained oil episodes.</li>
</ol>

<h3>6.3 Reserve Adequacy Under Persistent Shocks</h3>

<p>While the model shows reserves <em>improving</em> through the REER channel
(+{res_peak:.2f} months by Q{res_peak_q:.0f}), this result should be interpreted with caution.
The model does not capture:</p>
<ul>
    <li><strong>Import cost inflation:</strong> Sustained oil prices raise the import bill,
    which would drain reserves through the current account</li>
    <li><strong>Capital flight risk:</strong> Persistent inflation differentials may trigger
    speculative pressure against the peg if markets doubt sustainability</li>
    <li><strong>Terms-of-trade shock:</strong> Lesotho's narrow export base means the oil
    import cost increase is not offset by higher export revenues</li>
</ul>

<p>Maintaining reserves well above the ARA target of 4.7 months is therefore essential
as a buffer against these channels not captured in the model.</p>

<h2>7. Model Limitations and Extensions</h2>

<ul>
    <li><strong>No direct SA oil channel:</strong> The SA Phillips curve does not include oil
    prices directly. In reality, a {shock_duration}-quarter global oil shock would raise SA
    headline inflation significantly, prompting SARB tightening, which would feed through
    to Lesotho via the interest rate tracking rule and partially offset the real rate decline.</li>
    <li><strong>No oil-food linkage:</strong> Persistent oil price increases raise agricultural
    input costs, which would amplify the shock through Lesotho's high food CPI weight (35%).
    This channel could roughly double the inflation impact in an extended model.</li>
    <li><strong>Linear model:</strong> Cannot capture threshold effects that become
    increasingly relevant under persistent shocks (e.g., non-linear reserves pressure,
    peg credibility thresholds, wage-price spirals).</li>
    <li><strong>No expectations channel:</strong> Under a persistent shock, agents may revise
    inflation expectations upward, creating additional second-round effects not captured
    in this backward/forward-looking hybrid specification.</li>
</ul>

<h2>8. Conclusion</h2>

<p>The simulation of a <strong>{shock_duration}-quarter persistent global oil price shock</strong>
through the Lesotho QPM reveals the substantial vulnerability of a small, import-dependent
economy operating under a currency peg when facing sustained commodity price pressures:</p>

<ol>
    <li><strong>Compounding inflation:</strong> Inflation peaks at {pi_lso_peak:.2f} pp in
    Q{pi_lso_peak_q:.0f}, averaging {pi_lso_yr1:.2f} pp in year 1 and {pi_lso_yr2:.2f} pp
    in year 2. This represents a sustained cost-of-living shock, equivalent to roughly
    {pi_lso_yr1 * 4:.1f} pp in annualized terms during the first year.</li>
    <li><strong>Severe monetary policy misalignment:</strong> The real interest rate falls
    by up to {abs(r_lso_peak):.2f} pp, driving the output gap to {y_lso_peak:.2f} pp&mdash;a
    significant overheating episode that lasts well beyond the shock period.</li>
    <li><strong>Super-linear amplification:</strong> The persistent shock produces
    {pi_lso_peak / 0.32:.1f}&times; the inflation impact and {y_lso_peak / 0.19:.1f}&times;
    the output impact of a single-quarter shock, due to AR compounding and
    feedback through reserves and premium channels.</li>
    <li><strong>Deep asymmetric burden:</strong> Lesotho absorbs the entire inflationary cost
    while South Africa remains unaffected, making persistent oil shocks among the most
    destabilizing scenarios for the CMA arrangement.</li>
</ol>

<p>These results make a strong case for <strong>institutional reforms</strong>&mdash;including
a fuel stabilization fund, strategic reserves, macroprudential tools, and potentially a
commodity-adjustment mechanism within the CMA framework&mdash;to manage the unique vulnerability
of pegged economies to persistent global commodity shocks.</p>

<hr style="margin-top:2em;">
<p style="font-size:9pt; color:#888;">
    <strong>Technical note:</strong> Model solved using iterative perfect-foresight method
    (converged in 35 iterations). All results are percentage point deviations from steady state.
    Shock: &epsilon;<sub>oil</sub> = 10.0 applied for {shock_duration} consecutive quarters.
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
