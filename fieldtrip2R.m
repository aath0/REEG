
% initialize path with fieldtrip:
addpath('D:\Data\matlab\fieldtrip-20170207\')
ft_defaults

fout = 'D:\Data\R\fieldtripWrapper\Data\'; % Folder, where demo data are stored & results will be saved

%based on the dataset used in the fieldtrip tutorial, available for
%download from here:
% ftp://ftp.fieldtriptoolbox.org/pub/fieldtrip/tutorial/cluster_permutation_freq/dataFC.mat
% ftp://ftp.fieldtriptoolbox.org/pub/fieldtrip/tutorial/cluster_permutation_freq/dataFIC.mat

load([fout, 'dataFC.mat']) %load demo data
load([fout, 'dataFIC.mat']) %load demo data

%keep some exemplar channels and compute averages:
cfg = [];
cfg.channel = [dataFIC.label(1:5:end)];
avgFIC = ft_timelockanalysis(cfg, dataFIC);
avgFC = ft_timelockanalysis(cfg, dataFC);

% retrieve average ERPs:
data2plotFC = avgFC.avg; % channels x time matrix
data2plotFIC = avgFIC.avg; % channels x time matrix
time = avgFC.time; % 1 x time vector
channels = avgFC.label; % channels x 1 (cell) vector

% initialize structure:
d4R.data = [];
d4R.condition = [];
d4R.time = [];
d4R.channels = [];

% bring all data in the same format and prepare structure 
% with time-frames (compatible for all matlab versions):
time2plot = repmat(time, size(data2plotFC,1),1);
channels2plot = repmat(channels,1, size(data2plotFC,2),1);

% create data-frame compatible data:
d4R.data = [data2plotFIC(:); data2plotFC(:)];
%condition codes, 1 -> FIC / 2 -> FC
d4R.condition = [ones(length(data2plotFIC(:)),1); 2*ones(length(data2plotFC(:)),1)];
d4R.time = [time2plot(:);time2plot(:)];
d4R.channels = [channels2plot(:);channels2plot(:)];
    
save([fout, 'Data4R.mat'], 'd4R')


