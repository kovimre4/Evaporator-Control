clear

y_final = [1.0 50.5 25.0];

% Initialise parameters
initialise_parameters

% Simulate
in = Simulink.SimulationInput('plant_master');
in = in.setVariable('rhoA', 20);
out = sim(in);

% Evaluate signals
t = out.tout;
y = out.yout;

error = y-y_final;
treshold = 0.00001 * y_final;

within_treshold = error <= treshold;

% Search for when the signal stays within the treshold
settled = cumprod(within_treshold, 1, 'reverse');

t = [0 0 0
     t t t];
within_treshold = [[false false false]
                   within_treshold];

ts = t(~within_treshold)
ts = ts(end, :)
               
 
