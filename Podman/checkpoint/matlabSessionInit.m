disp('Starting MATLAB session initialization...')
new_system('a')
disp('Waiting for signal file to start shared engine...')
signalFile = '/tmp/start_signal.txt';
while ~isfile(signalFile)
    pause(0.2);
end
matlab.engine.shareEngine('matlab_shared_engine')