function [rel_probability,next_display] = NextDisplay(seq_numeric)
%% Purpose: This function takes in the numeric equivalent of display name,
% calculates the absolute probability of transitioning from that display to
% all other displays, and normalizes it to a relative probability, and
% determines the next display the operator will fixate on.
% Inputs: A number representing the current display 'seq_numeric'
% Outputs: Vector of RELATIVE probabilities 'rel_probability' in the form 
% [p(A) p(B) p(C) p(D)]./sum([p(A) p(B) p(C) p(D)]) and a number
% representing the next display 'next_display'

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

% Combining into vectors
S_vec = [S_A S_B S_C S_D];
Ex_vec = [Ex_A Ex_B Ex_C Ex_D];
V_vec = [V_A V_B V_C V_D];
Ef_A = [0 Ef_AB Ef_AC Ef_AD]; % effort to transition to A from B, C, and D
Ef_B = [Ef_AB 0 Ef_BC Ef_BD]; % effort to transition to B from A, C, and D
Ef_C = [Ef_AC Ef_BC 0 Ef_CD]; % effort to transition to C from A, B, and D
Ef_D = [Ef_AD Ef_BD Ef_CD 0]; % effort to transition to D from A, B, and C

% Combining into a matrix
Ef_mat = [Ef_A; Ef_B; Ef_C; Ef_D];

%% Calculating absolute probabilities

% pre-allocating
abs_probability = zeros(1,4);

% Looping over each display
for i = 1:4
    if i == seq_numeric
        abs_probability(i) = 0;
    else
        abs_probability(i) = S_vec(i) - Ef_mat(seq_numeric,i) ...
            + Ex_vec(i) + V_vec(i);
    end
end

%% Calculating relative probabilities
rel_probability = abs_probability./sum(abs_probability);

%% Next display
% Cumulative probability
cuml_probability = zeros(1,length(rel_probability)+1);
for j=1:length(rel_probability)
       cuml_probability(j+1) = sum(rel_probability(1:j));
end

% fitting a uniform distribution
next_fix = unifrnd(0,cuml_probability(end));

% check in which interval of the cuml_probability is this element 
for j=1:length(rel_probability)
   if next_fix >= cuml_probability(j) && next_fix < cuml_probability(j+1)
       break
   end
end

% determine next display
next_display = j;

end