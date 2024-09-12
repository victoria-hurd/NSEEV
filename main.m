% AUTHORS: Sarah Leary, Victoria Hurd, Abby Rindfuss
% DATE CREATED: 9/10/2024
% DATE LAST MODIFIED: 9/11/2024
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


%% Distributions
    % fixation --> saccadic eye movement --> fixation --> and so on

n_fix = 10; % number of fixations

% Each fixation time modeled as a random variable with lognormal
% distribution 
fix_dist = makedist('Lognormal','mu', 0, 'sigma',0.5);

% The duration of each saccadic eye movement can be assumed to be normally
% distributed
sac_dist = makedist('Normal','mu',0.03,'sigma',0.003);

% rng('default') % uncomment this if we want these values to never change
fix_time = random(fix_dist,10,1);
% now visualizing the lognormal distribution:
figure(1)
subplot(1,2,1)
histfit(fix_time,3,'lognormal')
title('Fixation Time Lognormal Dist')

sac_time = random(sac_dist,10,1);
% now visualizing the lognormal distribution:
subplot(1,2,2)
histfit(sac_time,3,'normal')
title('Saccade Time Normal Dist')
sgtitle('Distributions for 10 Random Numbers')

%% 1. Simulation of the Eye Position
% start each scan at A
% eye position as a function of time for 10 fixations
    %%% did we ask Torin about how to choose the sequence? ie random,
    %%% optimize, or we decide? For now, I'm just picking A, B, C, D

% timevec will be like [fix_time, sac_time, fix_time, sac_time ...]


