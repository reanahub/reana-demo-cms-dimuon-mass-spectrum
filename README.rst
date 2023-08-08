==========================================
 REANA example - CMS dimuon mass spectrum
==========================================

.. image:: https://www.reana.io/static/img/badges/launch-on-reana-at-cern.svg
   :target: https://reana.cern.ch/launch?url=https%3A%2F%2Fgithub.com%2Freanahub%2Freana-demo-cms-dimuon-mass-spectrum&name=reana-demo-cms-dimuon-mass-spectrum

About
======

This REANA reproducible analysis example demonstrates the computation of the
invariant mass spectrum of two muon final states with CMS Open Data.
It is based on the `original code <http://opendata.cern.ch/record/5001>`_ from
the `CERN Open Data portal <http://opendata.cern.ch/>`_.

Analysis structure
===================

Making a research data analysis reproducible basically means to provide
"runnable recipes" addressing (1) where is the input data, (2) what software was
used to analyse the data, (3) which computing environments were used to run the
software and (4) which computational workflow steps were taken to run the
analysis. This will permit to instantiate the analysis on the computational
cloud and run the analysis to obtain (5) output results.

1. Input data
-------------

The ``datasets`` directory contains files with the information about locations
of the collision datasets and the list of validated runs that will be used in
the analysis.

2. Analysis code
----------------

The analysis code is located in the in ``src`` directory and in
``demoanalyzer_cfg.py`` file.

3. Compute environment
----------------------

In order to be able to rerun the analysis even several years in the future, we
need to "encapsulate the current compute environment", for example to freeze the
software package versions our analysis is using. We shall achieve this by
preparing a `Docker <https://www.docker.com>`_ container image for our analysis
steps.

This example runs within the `CMSSW <http://cms-sw.github.io>`_ analysis
framework that was packaged for Docker in `clelange/cmssw
<https://hub.docker.com/r/clelange/cmssw/>`_.

4. Analysis workflow
--------------------

The computational workflow is essentially sequential in nature. We can use the
REANA serial workflow engine and represent the analysis workflow as follows:

.. code-block:: console

                    START
                      |
                      |
                      V
   +-----------------------------------------+
   | (1) scram b                             |
   |                                         |
   +-----------------------------------------+
                      |
                      |
                      V
   +-----------------------------------------+
   | (2) demoanalyzer_cfg.py                 | <-- datasets
   |                                         |
   +-----------------------------------------+
                      |
                      | DoubleMu.root
                      |
                      V
                     STOP

5. Output results
-----------------

The  run will create DoubleMu.root output file in the `ROOT
<https://root.cern.ch/>`_ format that contains output histograms, for example:

.. figure:: https://github.com/reanahub/reana-demo-cms-dimuon-mass-spectrum/blob/master/docs/plot_GMmass.png?raw=true
   :alt: plot_GMmass.png
   :align: center

Running the example on REANA cloud
==================================

There are two ways to execute this analysis example on REANA.

If you would like to simply launch this analysis example on the REANA instance
at CERN and inspect its results using the web interface, please click on
the following badge:

.. image:: https://www.reana.io/static/img/badges/launch-on-reana-at-cern.svg
   :target: https://reana.cern.ch/launch?url=https%3A%2F%2Fgithub.com%2Freanahub%2Freana-demo-cms-dimuon-mass-spectrum&name=reana-demo-cms-dimuon-mass-spectrum

|

If you would like a step-by-step guide on how to use the REANA command-line
client to launch this analysis example, please read on.

We start by creating a `reana.yaml <reana.yaml>`_ file describing the above
analysis structure with its inputs, code, runtime environment, computational
workflow steps and expected outputs:

.. code-block:: yaml
    version: 0.6.0
      inputs:
        files:
           - BuildFile.xml
           - demoanalyzer_cfg.py
        directories:
           - datasets
           - python
           - src
      workflow:
        type: serial
        specification:
          steps:
            - name: demoanalyzer
              environment: 'docker.io/cmsopendata/cmssw_5_3_32'
              commands:
                - >
                  source /opt/cms/cmsset_default.sh
                  && scramv1 project CMSSW CMSSW_5_3_32
                  && cd CMSSW_5_3_32/src
                  && eval `scramv1 runtime -sh`
                  && mkdir reana-demo-cms-dimuon-mass-spectrum
                  && cd reana-demo-cms-dimuon-mass-spectrum
                  && mkdir DimuonSpectrum2011
                  && cd DimuonSpectrum2011
                  && cp -r ../../../../datasets ../../../../python ../../../../src ../../../../BuildFile.xml ../../../../demoanalyzer_cfg.py .
                  && scram b
                  && cmsRun ./demoanalyzer_cfg.py
      outputs:
        files:
          - CMSSW_5_3_32/src/reana-demo-cms-dimuon-mass-spectrum/DimuonSpectrum2011/DoubleMu.root

We can now install the REANA command-line client, run the analysis and download
the resulting ROOT file containing plots:

.. code-block:: console

    $ # create new virtual environment
    $ virtualenv ~/.virtualenvs/myreana
    $ source ~/.virtualenvs/myreana/bin/activate
    $ # install REANA client
    $ pip install reana-client
    $ # connect to some REANA cloud instance
    $ export REANA_SERVER_URL=https://reana.cern.ch/
    $ export REANA_ACCESS_TOKEN=XXXXXXX
    $ # create new workflow
    $ reana-client create -n my-analysis
    $ export REANA_WORKON=my-analysis
    $ # upload input code and data to the workspace
    $ reana-client upload
    $ # start computational workflow
    $ reana-client start
    $ # ... should be finished in about 1 minute
    $ reana-client status
    $ # download output root file with generated plots
    $ reana-client download

Please see the `REANA-Client <https://reana-client.readthedocs.io/>`_
documentation for more detailed explanation of typical ``reana-client`` usage
scenarios.

Contributors
============

The list of contributors in alphabetical order:

- `Radovan Lascsak <https://orcid.org/0000-0002-8412-5702>`_
- `Ronald Dobos  <https://orcid.org/0000-0003-2914-000X>`_
- `Tibor Simko <https://orcid.org/0000-0001-7202-5803>`_
