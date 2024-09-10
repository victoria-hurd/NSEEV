% AUTHORS: Sarah Leary, Victoria Hurd
% DATE CREATED: 9/10/2024
% DATE LAST MODIFIED: 9/10/2024
% PROJECT: NSEEV Project
% CLASS: Human Operation of Aerospace Vehicles

%% Housekeeping
clear;clc;close all

%% Modeling
n_fix = 10;
fix_time = makedist('Normal','mu', 0, 'sigma',0.5);
