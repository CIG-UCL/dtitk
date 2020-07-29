function run_cmd(cmd, log_file_id)
% 
% function run_cmd(cmd, log_file)
% 
% Simple function to run bash commands from matlab.
% If the input is only the command run_cmd displays it on command window.
% Otherwise it displays it onto the file specifide by log_file_id
% 
%
% cmd: string with bash command
% log_file_id: id of a log file
%
% Example run_cmd('ls')

if nargin == 1
    fprintf('%s\n', cmd);
elseif nargin == 2
    fprintf(log_file_id,'%s\n', cmd);
end
system(cmd);