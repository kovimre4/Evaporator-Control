clear
% Initialise parameters
initialise_parameters

% Percentage tolerance for considering signal as settled
tol = 0.01;

% Load model
model = 'plant_master';
load_system(model);

% 2) Set up the sweep parameters
n_rhoAs = 20;
n_Ms = 20;
n_UA2s = 20;

rhoAs = linspace(10, 40, n_rhoAs);
Ms = linspace(15, 25, n_Ms);
UA2s = linspace(5, 8, n_UA2s);

[RHOAS, MS, UA2S] = meshgrid(rhoAs, Ms, UA2s);

RHOAS = reshape(RHOAS, 1, []);
MS = reshape(MS, 1, []);
UA2S = reshape(UA2S, 1, []);

n_sims = n_rhoAs*n_Ms*n_UA2s;

% Create an array of SimulationInput objects and specify the sweep values for each simulation
simIn(1:n_sims) = Simulink.SimulationInput(model);
for i = 1:n_sims
    simIn(i) = simIn(i).setVariable('rhoA', RHOAS(i));
    simIn(i) = simIn(i).setVariable('M', MS(i));
    simIn(i) = simIn(i).setVariable('UA2', UA2S(i));
end

% Simulate the model 
simOut = parsim(simIn, 'UseFastRestart', 'on');

% Process results (sts = settling times)
sts_L2 = ones(size(simOut));
sts_P2 = ones(size(simOut));
sts_X2 = ones(size(simOut));

for i= 1:n_sims
    % Extract signals    
    t = simOut(i).tout;
    L2 = simOut(i).yout(:, 1);
    P2 = simOut(i).yout(:, 2);
    X2 = simOut(i).yout(:, 3);
    
    sts_L2(i) = settling_time(t, L2, 1.0, tol);
    sts_P2(i) = settling_time(t, P2, 50.5, tol);
    sts_X2(i) = settling_time(t, X2, 25.0, tol);
end

sts_L2 = reshape(sts_L2, n_rhoAs, n_Ms, n_UA2s);
sts_P2 = reshape(sts_P2, n_rhoAs, n_Ms, n_UA2s);
sts_X2 = reshape(sts_X2, n_rhoAs, n_Ms, n_UA2s);
simOut = reshape(simOut, n_rhoAs, n_Ms, n_UA2s);

settling_times(:,:,:,1) = sts_L2;
settling_times(:,:,:,2) = sts_P2;
settling_times(:,:,:,3) = sts_X2;

save('settling_times_parallel.mat', 'settling_times', 'simOut', 'rhoAs', 'Ms', 'UA2s')