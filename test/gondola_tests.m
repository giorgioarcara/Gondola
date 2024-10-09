%% Import test libraries
import matlab.unittest.TestRunner;
import matlab.unittest.TestSuite;
import matlab.unittest.plugins.TestReportPlugin;

%% Add path
test_folder = fileparts(mfilename('fullpath'));
addpath(test_folder);

%% Define test suites (i.e. which test to run)
suite_GT_funcs = TestSuite.fromFolder(fullfile(test_folder,"GT_funcs"),"IncludingSubfolders",true);

allSuites = [suite_GT_funcs];

%% Define test plugin
test_results_folder = 'test_results';
nowstr = string(datetime("now", "Format", "yyyyMMdd_HHmmss"));
pdfFile = sprintf('GondolaTestReport_%s.pdf',nowstr);
plugin = TestReportPlugin.producingPDF(fullfile(test_results_folder,pdfFile));

%% Define test runner
runner = TestRunner.withTextOutput;
runner.addPlugin(plugin)

%% Run test

result = runner.run(allSuites);

%% Remove path
rmpath(test_folder);