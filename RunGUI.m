%% Run this function to run the GUI
% You can either
%   1) Open this function and press Run
%   2) Type RunGUI into the command line


%% Clear some stuff up
clear all
close all force
%% This runs the GUI
version = '8';
fprintf('Running Version %s of the GUI\n',string(version))
disp('Starting GUI')
run(['v',version,'_SARS_CoV_2_1AprSM.mlapp'])
