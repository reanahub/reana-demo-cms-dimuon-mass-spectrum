#/bin/zsh

# This script uses standalone Docker. Run it as follows:
#
# $ docker run --rm -i -t -v `pwd`:/w  docker.io/cmsopendata/cmssw_5_3_32 /w/run.sh
#
# Check results via:
#
# $ root results.root


source /opt/cms/cmsset_default.sh
scramv1 project CMSSW CMSSW_5_3_32
cd CMSSW_5_3_32/src
eval `scramv1 runtime -sh`
cd ../..
mkdir reana-demo-cms-dimuon-mass-spectrum
cd reana-demo-cms-dimuon-mass-spectrum
mkdir DimuonSpectrum2011
cd DimuonSpectrum2011
cp -a /w/* .
scram b
cmsRun ./demoanalyzer_cfg.py
cp DoubleMu.root /w/results.root
