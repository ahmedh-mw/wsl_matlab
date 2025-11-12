import argparse
import os
import time
import shutil

INTERVAL = 0.2   # seconds between checks
EOF_MARKER = "###############--EOF_EXECUTION--###############"

def parse_arguments():
    parser = argparse.ArgumentParser(description='Send batch command to MATLAB session.', prog='py-matlab.py')
    parser.add_argument('-batch', required=True, help='Batch command to execute in MATLAB')
    args = parser.parse_args()
    return args

if __name__ == "__main__":
    args = parse_arguments()
    home_path = os.path.expanduser("~")
    loopRootPath = os.path.join(home_path, ".matlab")
    inbound_path = os.path.join(loopRootPath, ".inbound")
    outbound_path = os.path.join(loopRootPath, ".outbound")
    archive_path = os.path.join(loopRootPath, ".archive")
    process_id = str(os.getpid())
    inbound_file_path = os.path.join(inbound_path, f"{process_id}.in")
    outbound_file_path = os.path.join(outbound_path, f"{process_id}.out")
    archive_file_path = os.path.join(archive_path, f"{process_id}.out")

    # Ensure directories exist
    for path in [inbound_path, outbound_path, archive_path]:
        os.makedirs(path, exist_ok=True)

    # Write batch command to inbound file (no extra newline)
    with open(inbound_file_path, "w") as inbound_file:
        inbound_file.write(args.batch)

    # Wait for outbound file to appear
    while not os.path.exists(outbound_file_path):
        time.sleep(INTERVAL)

    # Read outbound file line by line, stopping at EOF marker
    with open(outbound_file_path, 'r') as outbound_file:
        while True:
            line = outbound_file.readline()
            if line:
                if line.rstrip() == EOF_MARKER:
                    break
                print(line, end='')
            else:
                time.sleep(INTERVAL)

    # Move outbound file to archive
    if os.path.exists(archive_file_path):
        os.remove(archive_file_path)
    shutil.move(outbound_file_path, archive_file_path)