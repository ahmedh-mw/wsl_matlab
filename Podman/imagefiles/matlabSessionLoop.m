%   Copyright 2025 The MathWorks, Inc.
function matlabSessionLoop(exitSessionMarker)
    arguments
        exitSessionMarker = "exitSession";
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %               Initialization
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    disp('Starting MATLAB session initialization...')

    %------- inbound & outbound folders --------%
    if ispc
        homePath = getenv('USERPROFILE');
    else
        homePath = getenv('HOME');
    end

    loopRootPath = fullfile(homePath, ".matlab");
    inboundPath = fullfile(loopRootPath, ".inbound");
    outboundPath = fullfile(loopRootPath, ".outbound");
    archivePath = fullfile(loopRootPath, ".archive");
    for p=[inboundPath, outboundPath, archivePath]
        if ~isfolder(p)
            mkdir(p);
        end
    end
    startFilePath = fullfile(loopRootPath, "start.txt");
    writelines("MATLAB has been started...", startFilePath);

    %------- warming up toolboxes --------%
    new_system('dummy_model');
    close_system('dummy_model');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %               Waiting for commands
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    readyFilePath = fullfile(loopRootPath, "init.txt");
    writelines("MATLAB has been initialized...", readyFilePath);
    disp('Waiting for commands...')
    EOF_MARKER = "###############--EOF_EXECUTION--###############";
    while true
        entries = dir(inboundPath);
        files = entries(~[entries.isdir]); % remove directories
        if ~isempty(files)
            [~, idx] = min([files.datenum]);
            oldest_in_file = files(idx).name;
            [~, oldest_file_name, ~] = fileparts(oldest_in_file);
            oldest_out_file = [oldest_file_name '.out'];
            try
                file_content = fileread(fullfile(inboundPath, oldest_in_file));
                if strcmp(file_content, exitSessionMarker)
                    disp('...Exiting the session loop');
                    diary(fullfile(outboundPath, oldest_out_file));
                    movefile(fullfile(inboundPath, oldest_in_file), fullfile(archivePath, oldest_in_file));
                    disp(EOF_MARKER);
                    diary off;
                    break;
                end
                disp(strjoin(['Executing:', fullfile(inboundPath, oldest_in_file)]));
                diary(fullfile(outboundPath, oldest_out_file));
                movefile(fullfile(inboundPath, oldest_in_file), fullfile(archivePath, oldest_in_file));
                eval(file_content);
            catch ME
                disp(strjoin(["Error identifier:", ME.identifier]));
                disp(ME.getReport());
            end
            disp(EOF_MARKER);
            diary off;
        else
            pause(0.2);
        end
    end
end