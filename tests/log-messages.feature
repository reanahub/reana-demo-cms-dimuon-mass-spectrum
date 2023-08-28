# Tests for the expected workflow log messages

Feature: Log messages

    As a researcher,
    I want to be able to see the log messages of my workflow execution,
    So that I can verify that the workflow ran correctly.

    Scenario: The analysis steps have been correctly registered and logged
        When the workflow is finished
		Then the engine logs should contain
            """
            Publishing step:0, cmd: source /opt/cms/cmsset_default.sh && scramv1 project CMSSW CMSSW_5_3_32
            """
        And the engine logs should contain "eval `scramv1 runtime -sh`"
        And the engine logs should contain "scram b && cmsRun ./demoanalyzer_cfg.py"

    Scenario: The data analysis step has produced the expected messages
        When the workflow is finished
        Then the logs should contain
        """
        TrigReport ---------- Event  Summary ------------
        TrigReport Events total = 10000 passed = 10000 failed = 0

        TrigReport ---------- Path   Summary ------------
        TrigReport  Trig Bit#        Run     Passed     Failed      Error Name
        TrigReport     1    0      10000      10000          0          0 p

        TrigReport -------End-Path   Summary ------------
        TrigReport  Trig Bit#        Run     Passed     Failed      Error Name

        TrigReport ---------- Modules in Path: p ------------
        TrigReport  Trig Bit#    Visited     Passed     Failed      Error Name
        TrigReport     1    0      10000      10000          0          0 demo

        TrigReport ---------- Module Summary ------------
        TrigReport    Visited        Run     Passed     Failed      Error Name
        TrigReport      10000      10000      10000          0          0 demo
        TrigReport      10000      10000      10000          0          0 TriggerResults
        """
