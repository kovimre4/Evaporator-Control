clear

% Initialise parameters
initialise_parameters

n_rhoAs = 20;
n_Ms = 20;
n_UA2s = 20;

rhoAs = linspace(10, 40, n_rhoAs);
Ms = linspace(15, 25, n_Ms);
UA2s = linspace(5, 8, n_UA2s);

settling_times = zeros(n_rhoAs, n_Ms, n_UA2s, 3);
warning('off','all')

for i_rhoA = 1:n_rhoAs
    for i_M = 1:n_Ms
        for i_UA2 = 1:n_UA2s
            % Simulate
            in = Simulink.SimulationInput('plant_master');
            in = in.setVariable('rhoA', rhoAs(i_rhoA));
            in = in.setVariable('M', Ms(i_M));
            in = in.setVariable('UA2', UA2s(i_UA2));
            out = sim(in);

            % Extract signals
            t = out.tout;
            L2 = out.yout(:, 1);
            P2 = out.yout(:, 2);
            X2 = out.yout(:, 3);

            tol = 0.01;     % 1% within nominal value is considered settled
            st_L2 = settling_time(t, L2, 1.0, tol);
            st_P2 = settling_time(t, P2, 50.5, tol);
            st_X2 = settling_time(t, X2, 25.0, tol);
            
            settling_times(i_rhoA, i_M, i_UA2, :) = [st_L2, st_P2, st_X2];
        end
    end
end

save('settling_times.mat', 'settling_times', 'rhoAs', 'Ms', 'UA2s')