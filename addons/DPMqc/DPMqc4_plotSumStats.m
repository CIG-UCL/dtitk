function DPMqc4_plotSumStats(mean_param_file, fsl_path, label_list, std_param_file, img_format)
% 
% DPMqc4_plotSumStats(mean_param_file, fsl_path, label_list, std_param_file, img_format)
% 
% Create an image which summrizes the stats for one parameter in a specific
% region of interest
% Use [] if you want to forgo an optional input.
% Es: DPMqc4_plotSumStats(mean_param_file, [], [], [], img_format)
% 
% Inputs:
% mean_param_file: A text file containing an array of the mean parameters
% for each label and each subject. Rows are subjects and columns are labels.
% [optional] fsl_path: specify the path to fsl directory
% [optional] label_list: file in whic are listed the indices of the labels 
%            to analyse.
% [optional] std_param_file: same as mean_param_file but with standard
%            deviations
% [optional] img_format: format of the image should be a string. Es. '-png'
%            '-pdf', '-tif'.
%
% Outputs:
% A figure summary of the statistics
% 
% Authors:
% Michele Guerreri (michele.guerreri@gmail.com)
% Christopher Parker
% Gary Hui Zhang

%% Set the stage

% check if the variables exist
if ~exist('fsl_path','var') || isempty(fsl_path)
    % Check if the freesurfer directory is set correctly
    fsl_path = getenv('FSLDIR');
    if isempty(fsl_path)
        error('FSL environment variable $FSLDIR not set properly')
    end
end
if  ~exist('label_list','var') || isempty(label_list)
    labels=[3 4 5 17 18 19 20 33 34 25 26];
    % 3 GCC Genu-of-corpus-callosum
    % 4 BCC Body-of-corpus-callosum
    % 5 SCC Splenium-of-corpus-callosum
    % 17 ALIC-R Anterior-limb-of-internal-capsule-right
    % 18 ALIC-L Anterior-limb-of-internal-capsule-left
    % 19 PLIC-R Posterior-limb-of internal capsule-right
    % 20 PLIC-L Posterior-limb-of-internal-capsule-left
    % 33 EC-R External-capsule-right
    % 34 EC-L External-capsule-left
else
    labels = dlmread(label_list);
end
if ~exist('img_format','var') || isempty(img_format)
    img_format = '-png';
end
% Read the data
data = dlmread(mean_param_file);
n_subj = size(data,1);
n_rois = size(data,2);

% Import std if needed
if exist('std_param_file','var')
    std = dlmread(std_param_file);
else
    std = zeros(n_subj, n_rois);
end

% load the xml file with JHU lables and indices
jhu_xml = fullfile(fsl_path, 'data/atlases/JHU-labels.xml');
jhu_labels = xml2struct(jhu_xml);

% Define the output name
[out_path, out_basename, ~] = fileparts(mean_param_file);
% Loop over the ROIs and create the plot
for rr = 1:n_rois
    % Open figure
    f1 = figure('Units', 'Normalized', 'Color', [1 1 1], 'Position', [0 0 .5 .5]);
    % Create tight subplot
    ts = tight_subplot(1, 2, [.1 .1], [.1 .1], [.1 .1]);
    % Add title to the figure 
    roi_name = jhu_labels.atlas.data.label{labels(rr)+1}.Text;
    add_title(f1, out_basename ,roi_name);
    % plot the violin
    plot_violin(data(:,rr), ts(1));
    % plot the bars
    plot_bars(data(:,rr), ts(2), std(:,rr));
    % export image
    roi_name_noblank = regexprep( roi_name, ' +', '_' );
    output_name = fullfile(out_path, sprintf('%s_%s', out_basename, roi_name_noblank));
    export_fig(f1, output_name, img_format, '-nocrop');
    close(f1);
end

end

function add_title(f, basename ,roi_name)
    figure(f);
    a = annotation('textbox');
    a.Position = [0 1 1 0];
    a.String = sprintf('%s mean values in the %s', basename, roi_name);
    a.FontSize = 14;
    a.HorizontalAlignment = 'center';
    a.FontWeight = 'bold';
    a.Interpreter = 'none';
end

function  plot_violin(d, ax)
    % Function to plot the vionlin and the boxplot
    axes(ax);
    violin(d, 'facecolor', [.7 .7 .7]);
    Ylim = ax.YLim;
    hold on
    boxplot(d)
    ax.YLim = Ylim;
    ax.YLabel.String = 'Mean Value';
end

function plot_bars(d, ax, std)
    % Funtion to plot bard
    axes(ax);
    b = bar(d, 'stacked', 'facecolor', [.7 .7 .7]);
    xCnt = get(b(1),'XData')';
    % Add errorbars
    hold on
    errorbar(xCnt, d, std, std, 'b', 'LineStyle','none')
    ax.XLabel.String = 'Subject index';
end