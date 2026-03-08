// 10% Oil Price Shock Simulation - V4 (enriched oil/food transmission)
// Unanticipated one-time 10% oil price LEVEL shock, decays via AR(1) on level
// V4 changes: lambda_4, lambda_5 in SA Phillips curve; kappa_oil_food in food eq
var
    y_lso pi_lso i_lso r_lso z_lso s_lso res_gap_lso res_lso res_bar_lso prem_lso g_lso
    y_zaf pi_zaf i_zaf r_zaf z_zaf s_zaf
    y_row pi_row i_row
    pi_oil pi_food poil_gap pfood_gap rcom rcom_bar d_rcom pi_com;

varexo
    eps_y_lso eps_pi_lso eps_i_lso eps_s_lso eps_res_lso eps_prem_lso eps_g_lso eps_u_lso
    eps_y_zaf eps_pi_zaf eps_i_zaf eps_s_zaf
    eps_y_row eps_pi_row eps_i_row
    eps_oil eps_food eps_com eps_rcom_trend;

parameters
    alpha_1 alpha_2 alpha_3 alpha_4 alpha_5 alpha_6
    beta_1 omega_1_lso omega_1_zaf omega_2_lso omega_2_zaf rho_u
    delta_res f_1 f_3 f_4 rho_res_bar res_ss
    theta_prem
    gamma_1 gamma_2 gamma_3 gamma_4 gamma_5 gamma_6
    lambda_1 lambda_2 lambda_3 lambda_4 lambda_5
    phi_i phi_pi phi_y pi_target_zaf
    sigma_s
    rho_y_row rho_pi_row rho_i_row
    rho_oil rho_food rho_com rho_d_rcom kappa_oil_food
    rho_g rho_z;

// Calibration (V4 - enriched oil/food transmission)
alpha_1=0.50; alpha_2=0.10; alpha_3=0.30; alpha_4=0.20; alpha_5=0.50; alpha_6=0.30;
beta_1=0.25; omega_1_lso=0.08; omega_1_zaf=0.05; omega_2_lso=0.35; omega_2_zaf=0.20; rho_u=0.50;
delta_res=0.90; f_1=0.35; f_3=0.10; f_4=0.02; rho_res_bar=0.90; res_ss=4.70;
theta_prem=0.35;
gamma_1=0.55; gamma_2=0.10; gamma_3=0.25; gamma_4=0.08; gamma_5=0.10; gamma_6=0.01;
lambda_1=0.50; lambda_2=0.30; lambda_3=0.15; lambda_4=0.08; lambda_5=0.10;
phi_i=0.75; phi_pi=1.50; phi_y=0.50; pi_target_zaf=4.50;
sigma_s=0.50;
rho_y_row=0.80; rho_pi_row=0.50; rho_i_row=0.75;
rho_oil=0.80; rho_food=0.60; rho_com=0.70; rho_d_rcom=0.70; kappa_oil_food=0.05;
rho_g=0.70; rho_z=0.80;

model(linear);
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
    y_zaf = gamma_1*y_zaf(-1) + gamma_2*y_zaf(+1) - gamma_3*r_zaf + gamma_4*z_zaf + gamma_5*y_row + gamma_6*d_rcom + eps_y_zaf;
    // V4: SA Phillips curve with oil and food price terms
    pi_zaf = lambda_1*pi_zaf(-1) + (1-lambda_1)*pi_zaf(+1) + lambda_2*y_zaf + lambda_3*(z_zaf-z_zaf(-1)) + lambda_4*pi_oil + lambda_5*pi_food + eps_pi_zaf;
    i_zaf = phi_i*i_zaf(-1) + (1-phi_i)*(phi_pi*pi_zaf(+1) + phi_y*y_zaf) + eps_i_zaf;
    r_zaf = i_zaf - pi_zaf(+1);
    s_zaf = sigma_s*s_zaf(-1) + (1-sigma_s)*s_zaf(+1) - (i_zaf-i_row)/4 + eps_s_zaf;
    z_zaf = rho_z*z_zaf(-1) + (s_zaf-s_zaf(-1)) - (pi_zaf-pi_row)/4;
    y_row = rho_y_row*y_row(-1) + eps_y_row;
    pi_row = rho_pi_row*pi_row(-1) + eps_pi_row;
    i_row = rho_i_row*i_row(-1) + (1-rho_i_row)*(1.5*pi_row+0.5*y_row) + eps_i_row;
    rcom = rcom_bar + d_rcom;
    rcom_bar = rcom_bar(-1) + eps_rcom_trend;
    d_rcom = rho_d_rcom*d_rcom(-1) + eps_com;
    pi_com = pi_row + (rcom-rcom(-1));
    // Oil price LEVEL gap (AR(1) on level, not inflation)
    poil_gap = rho_oil*poil_gap(-1) + eps_oil;
    pi_oil = poil_gap - poil_gap(-1);
    // V4: Food price LEVEL gap with oil-to-food linkage
    pfood_gap = rho_food*pfood_gap(-1) + kappa_oil_food*poil_gap + eps_food;
    pi_food = pfood_gap - pfood_gap(-1);
end;

steady;
check;

// Unanticipated 10% oil price LEVEL shock (one-time surprise)
// poil_gap jumps 0.10, then decays at rho_oil=0.80
// pi_oil spikes in Q1 then turns negative as level reverts
shocks;
    var eps_oil; stderr 0.10;
end;

stoch_simul(order=1, irf=20, nograph, noprint);
