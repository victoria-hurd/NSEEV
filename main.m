% AUTHORS: Sarah Leary, Victoria Hurd, Abby Rindfuss, Lena Obaid
% DATE CREATED: 9/10/2024
% DATE LAST MODIFIED: 9/12/2024
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
fix_time = random(fix_dist,n_fix,1);
% now visualizing the lognormal distribution:
figure(1)
subplot(1,2,1)
histfit(fix_time,3,'lognormal')
title('Fixation Time Lognormal Dist')

sac_time = random(sac_dist,n_fix,1);
% now visualizing the lognormal distribution:
subplot(1,2,2)
histfit(sac_time,3,'normal')
title('Saccade Time Normal Dist')
sgtitle('Distributions for 10 Random Numbers')

%% NSEEV Probability Model for Next Display: 
%Need to write a function that can take in current display and export next
%display


%% 1. Simulation of the Eye Position
% start each scan at A
% eye position as a function of time for 10 fixations
    %%% did we ask Torin about how to choose the sequence? ie random,
    %%% optimize, or we decide? For now, I'm just picking A, B, C, D

% timevec will be like [fix_time, sac_time, fix_time, sac_time ...]

%% 1. Simulation of the Eye Position
% Sequence of displays: A -> B -> C -> D
sequence = {'A', 'B', 'C', 'D'};
seq_numeric = [1, 2, 3, 4];  % Mapping A = 1, B = 2, C = 3, D = 4 for plotting along the y axis

% Initialize time vector and eye position array
time_points = zeros(2 * n_fix-1, 1);
eye_position = zeros(2 * n_fix-1, 1);

% Start at display A
current_time = 0;
current_display=1;

for i = 1:n_fix

    % Fixation on display
    %eye_position(2*i - 1) = seq_numeric(mod(i-1, length(sequence)) + 1);  % A -> B -> C -> D -> A...
    [~,current_display] = NextDisplay(current_display);
    eye_position(2*i - 1) = current_display;
    time_points(2*i - 1) = current_time;
    current_time = current_time + fix_time(i);
    
    % Saccade (if not the last fixation)
    if i < n_fix+1
        eye_position(2*i) = NaN;  % No display viewed during saccades
        time_points(2*i) = current_time;
        current_time = current_time + sac_time(i);
    end
end

%% Plot the scan pattern
figure(2)
hold on

% Plot the fixations (solid lines) using the stairs function
stairs(time_points, eye_position, 'LineWidth', 2, 'Color', 'b');

% Plot the saccades (red dashed lines)
plot([0 time_points(1)],[1 eye_position(1)],'r--', 'LineWidth', 1.5);
for i = 1:2:(2*n_fix-2)  % Iterate over every other element for 9 saccades
    % Plot the saccade as a red dashed line
    plot([time_points(i+1), time_points(i+2)], [eye_position(i), eye_position(i+2)], 'r--', 'LineWidth', 1.5);
end

% Labels and formatting
xlabel('Time (s)');
ylabel('Display (1=A, 2=B, 3=C, 4=D)');
title('Eye Position Over Time (10 Fixations)');
yticks([1 2 3 4]);
yticklabels({'A', 'B', 'C', 'D'});
ylim([1 4]);
grid on;
legend({'Fixations', 'Saccades'}, 'Location', 'best');
hold off;

%% 2. Monte Carlo Simulations
% number of simulations
n_sim = 1000;
% number of fixations (updating)
n_fix = 100;
% initializing
current_display = 1;
current_time = 0;
% count of time spent fixating on each display
time_count_fix = zeros(1,4);
time_count_sim = zeros(n_sim,4);
for j = 1:n_sim
    for i = 1:n_fix
    
        % Fixation on display
        [~,current_display] = NextDisplay(current_display);

        % fixation and saccade time
        fix_time = random(fix_dist,1,1);
        sac_time = random(sac_dist,1,1);

        current_time = current_time + sac_time + fix_time;

        time_count_fix(current_display) = time_count_fix(current_display)+fix_time;
    end

    % finding relative time on each display
    time_count_sim(j,:) = time_count_fix./current_time;
    % Note that these do not add up to 1 because we're dividing by the
    % TOTAL time (i.e., including the saccade time)

    % resetting
    time_count_fix = zeros(1,4);
    current_time = 0;

end

% plotting a histogram for each display
fig = figure(); hold on; 
subplot(2,2,1); hold on; grid minor;
histogram(time_count_sim(:,1));
title('Display A','Interpreter','latex')
set(gca,'FontSize',20);
hold off;
subplot(2,2,2); hold on; grid minor;
histogram(time_count_sim(:,2));
title('Display B','Interpreter','latex')
set(gca,'FontSize',20);
hold off;
subplot(2,2,3); hold on; grid minor;
histogram(time_count_sim(:,3));
title('Display C','Interpreter','latex')
set(gca,'FontSize',20);
hold off;
subplot(2,2,4); hold on; grid minor;
histogram(time_count_sim(:,4));
title('Display D','Interpreter','latex')
set(gca,'FontSize',20);
hold off;

han=axes(fig,'visible','off'); 
han.Title.Visible='on';
han.XLabel.Visible='on';
han.YLabel.Visible='on';
ylabel(han,'Frequency','Interpreter','latex','FontSize',25);
xlabel(han,'Relative Time','Interpreter','latex','FontSize',25)
sgtitle('Relative Time Spent on Each Display','Interpreter','latex','FontSize',25);
