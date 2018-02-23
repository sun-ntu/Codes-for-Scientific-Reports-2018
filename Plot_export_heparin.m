clear all;
close all;

Folder='Heparin_data\'; % heparin data folder
load ([Folder 'absorption_heparin.mat'])

freq_s=(0.0681:0.0681:0.0681*15);    % Frequency set as in the cac_heparin file.
% Due to 259 pts in time domain and a time interval of 0.0567 (ps)
freq_s=freq_s';    % 272GHz at freq_s(4), 817GHz at freq_s(12)
%% Export/plot  data in Origin
    % Obtain Origin COM Server object
    % This will connect to an existing instance of Origin, or create a new one if none exist
    originObj=actxserver('Origin.Application');

    % Make the Origin session visible
    invoke(originObj, 'Execute', 'doc -mc 1;');
       
    % Clear "dirty" flag in Origin to suppress prompt for saving current project
    % You may want to replace this with code to handling of saving current project
    invoke(originObj, 'IsModified', 'false');
%%
    % Load the custom project CreateOriginPlot.OPJ found in Samples area of Origin installation
    invoke(originObj, 'Execute', 'heparin.OPJ');
%     strPath='';
%     strPath = invoke(originObj, 'LTStr', 'syspath$');
    invoke(originObj, 'Load', strcat([pwd '\heparin.OPJ']));
    % Create some data to send over to Origin - create three vectors
    % This can be replaced with real data such as result of computation in MATLAB
    mdata = [freq_s absorption_heparin];
    % Send this data over to the Data1 worksheet
    invoke(originObj, 'PutWorksheet', 'Data1', mdata);
    % Rescale the two layers in the graph and copy graph to clipboard
    invoke(originObj, 'Execute', 'page.active = 1;');
    invoke(originObj, 'CopyPage', 'Graph1');
%% 
