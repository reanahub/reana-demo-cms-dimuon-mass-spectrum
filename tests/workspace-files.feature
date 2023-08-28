# Tests for the presence of files in the workspace

Feature: Workspace files

    As a researcher,
    I want to make sure that my Snakemake workflow produces expected files,
    and that the files fetched from the remote locations are not corrupted,
    so that I can be sure that the workflow outputs are correct.

    Scenario: The workspace contains all the relevant input files
        When the workflow execution completes
        Then the workspace should include "BuildFile.xml"
        And the workspace should include "datasets/CMS_Run2011A_DoubleMu_AOD_12Oct2013-v1_10000_file_index.txt"
        And the workspace should include "datasets/CMS_Run2011A_DoubleMu_AOD_12Oct2013-v1_10001_file_index.txt"
        And the workspace should include "datasets/CMS_Run2011A_DoubleMu_AOD_12Oct2013-v1_20000_file_index.txt"
        And the workspace should include "datasets/CMS_Run2011A_SingleMu_AOD_12Oct2013-v1_10000_file_index.txt"
        And the workspace should include "datasets/CMS_Run2011A_SingleMu_AOD_12Oct2013-v1_10001_file_index.txt"
        And the workspace should include "datasets/CMS_Run2011A_SingleMu_AOD_12Oct2013-v1_20000_file_index.txt"
        And the workspace should include "datasets/CMS_Run2011A_SingleMu_AOD_12Oct2013-v1_20001_file_index.txt"
        And the workspace should include "src/DimuonSpectrum2011.cc"
        And the workspace should include "python/demoanalyzer_cfi.py"
        And the workspace should include "demoanalyzer_cfg.py"

    Scenario: The SCRAM build system produces the expected file
	When the workflow is finished
	Then the workspace should include "CMSSW_5_3_32/.SCRAM/slc6_amd64_gcc472/timestamps/boost_system"

    Scenario: The analysis produces the expected output file
        When the workflow is finished
        Then the workspace should include
            """
            CMSSW_5_3_32/src/reana-demo-cms-dimuon-mass-spectrum/DimuonSpectrum2011/DoubleMu.root
            """
