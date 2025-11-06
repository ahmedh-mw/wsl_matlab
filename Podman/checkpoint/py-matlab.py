import argparse
import matlab.engine
import os
import time

DEFAULT_SESSION_NAME = 'matlab_shared_engine'
TIMEOUT = 300  # seconds
INTERVAL = 0.2   # seconds between checks

def parse_arguments():
    parser = argparse.ArgumentParser(description='Send batch command to MATLAB session.', prog='py-matlab.py')
    parser.add_argument('-s', '--session', required=False, help='MATLAB engine session name')
    parser.add_argument('-b', '--batch', required=True, help='Batch command to execute in MATLAB')
    args = parser.parse_args()
    return args

if __name__ == "__main__":
    args = parse_arguments()
    if args.session:
        session_name = args.session
    else:
        session_name = DEFAULT_SESSION_NAME
    
    signal_file_path = "/tmp/start_signal.txt"
    if not os.path.exists(signal_file_path):
        with open(signal_file_path, "w") as signal_file:
            signal_file.write('start')
    
    elapsed = 0
    session_found = False
    while elapsed < TIMEOUT:
        if session_name in matlab.engine.find_matlab():
            session_found = True
            break
        time.sleep(INTERVAL)
        elapsed += INTERVAL
    
    if not session_found:
        raise RuntimeError("No MATLAB shared session found within timeout period.")
    
    eng = matlab.engine.connect_matlab(session_name)
    eng.eval(args.batch, nargout=0)