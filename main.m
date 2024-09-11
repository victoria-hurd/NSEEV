% AUTHORS: Sarah Leary, Victoria Hurd
% DATE CREATED: 9/10/2024
% DATE LAST MODIFIED: 9/10/2024
% PROJECT: NSEEV Project
% CLASS: Human Operation of Aerospace Vehicles

%% Housekeeping
clear;clc;close all


%% Fixed Values

% 4 AOIs
% Each AOI has a salience, expectancy, and value
    % A (primary display)
    S_A = 2;
    Ex_A = 4;
    V_A = 2;
    
    % B (monitor for water levels)
    S_B = 3;
    Ex_B = 2;
    V_B = 1;

    % C (communications display)
    S_C = 1;
    Ex_C = 3;
    V_C = 1;

    % D (emergency notification)
    S_D = 2;
    Ex_D = 1;
    V_D = 5;

% All the combinations of transition effort:
Ef_AB = 1;
Ef_AC = 1;
Ef_AD = 5;
Ef_BC = 3;
Ef_BD = 6;
Ef_CD = 4.5;
% Also, we are assuming that effort to transition is symmetric
% meaning Ef_AB = Ef_BA, etc


%% Modeling
n_fix = 10;
fix_time = makedist('Normal','mu', 0, 'sigma',0.5);