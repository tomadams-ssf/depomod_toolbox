%% What?

% This describes how to create a new project from a template and run the
% model using the graphical user interface.


%% Define name and location

% This is a reasonable default location, but it can be anywhere.
rootDir = 'C:\newdepomod_projects\';
% name of the project, will become the root directory name and prefix of
% all filenames
projectName = 'bay_of_fish';

if ~exist(rootDir, 'dir')
    mkdir(rootDir);
end

%% initialize project

% create from template with desired location and name
project = NewDepomod.Project.createFromTemplate(rootDir, projectName, 'force',1)
 
% project = 
%   Project with properties:
% 
%        version: 2
%       location: [1x1 NewDepomod.PropertiesFile]
%     bathymetry: [1x1 NewDepomod.BathymetryFile]
%      flowmetry: [1x1 NewDepomod.FlowmetryFile]
%           name: 'bay_of_fish'
%           path: 'C:\newdepomod_projects\bay_of_fish'
%     solidsRuns: [1 Depomod.Run.Collection]
%       EmBZRuns: [1 Depomod.Run.Collection]
%       TFBZRuns: [1 Depomod.Run.Collection]

% Notice there includes 1 solids run and 1 EmBZ run as well as objects
% describing the bathymetry and flow data
     
%% View the bathymetry

% plot the raw cell-by-cell bathymetry
figure;
project.bathymetry.plot

% or pass in the 'contour' option to make a tider plot
project.bathymetry.plot('contour',1)

%% View the flow (requires rcm_toolbox MATLAB library)

flowProfile = project.flowmetry.toRCMProfile

flowProfile.Bins{1}.scatterPlot % bed
flowProfile.Bins{3}.scatterPlot % surface

%% Inspect solids run

% Select the first solids run
solidsRun = project.solidsRuns.item(1)

% solidsRun = 
%   Solids with properties:
% 
%              defaultPlotLevels: [4 192 1553 10000]
%                    defaultUnit: 'g m^{-2} y^{-1}'
%                      modelFile: [1x1 NewDepomod.PropertiesFile]
%         physicalPropertiesFile: [1x1 NewDepomod.PropertiesFile]
%              configurationFile: [1x1 NewDepomod.PropertiesFile]
%                    runtimeFile: [1x1 NewDepomod.PropertiesFile]
%                     inputsFile: [1x1 NewDepomod.InputsPropertiesFile]
%            iterationInputsFile: []
%         exportedTimeSeriesFile: []
%     consolidatedTimeSeriesFile: []
%                      solidsSur: []
%                      carbonSur: []
%             iterationRunNumber: '1'
%                  modelFileName: 'bay_of_fish-1-NONE.depomodmodelproperties'
%                        project: [1x1 NewDepomod.Project]
%                    cfgFileName: []
%                      runNumber: '1'
%                          cages: [2 Depomod.Layout.Site]

% Notice this references all of the input (e.g. cages, inputs, physical)
% files and all of the output files (sur(face), time series) which will be
% written when the model is executed. So this object can be used to
% navigate all of the information related to a particular run.

% Check out the biomass
solidsRun.inputsFile.FeedInputs.biomass
solidsRun.inputsFile.FeedInputs.stockingDensity

% ans =
% 1000
% ans =
% 13.0826

% And some of the physical properties
solidsRun.physicalPropertiesFile.Transports.bottomRoughnessLength.smooth
solidsRun.physicalPropertiesFile.Transports.resuspension.walker.dispersionCoefficientX

% ans =
% 0.00003
% ans =
% 0.1

% And some of the cage properties
solidsRun.cages.consolidatedCages.size       % count
solidsRun.cages.consolidatedCages.cageArea   % m2
solidsRun.cages.consolidatedCages.cageVolume % m3

% ans =
%      8
% ans =
%           6369.80278655024
% ans =
%           76437.6334386029
          
%% Execute model run

% 1 - Open up user interface
% 2 - Open up bay_of_fish project
% 3 - Navigate to models
% 4 - Right-click on the solids (NONE) run #1
% 5 - Select single run

%% Read results files

% Once model run has completed...

% Check run ITI score (ITI contour around 80% particles)
solidsRun.log.Eqs.benthic.iti
% Check DZR impact area (equivalent to 4g m-2 y-1)
solidsRun.log.Eqs.BenthicImpactedAreaEQS.area

% Check mass released...
solidsRun.log.Masses.solids.released.run
% ...and compare with mass remaining in domain - the difference is "exported"
solidsRun.log.Masses.solids.balance.run

% Masure the predicted area of a specific impact level
solidsRun.solidsSur.area(4) % 4 g m-2

% Get the predicted value at a specific location
solidsRun.solidsSur.valueAt(351000,1068800) % easting, northing

% plot impact
solidsRun.plot

%%
