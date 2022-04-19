[![Abcdspec-compliant](https://img.shields.io/badge/ABCD_Spec-v1.1-green.svg)](https://github.com/brain-life/abcd-spec)
[![Run on Brainlife.io](https://img.shields.io/badge/Brainlife-brainlife.app.389-blue.svg)](https://doi.org/10.25663/brainlife.app.389)

# Compute summary statistics of diffusion measures from subcortical segmentation

This app will compute statistics from diffusion measures inside a subcortical segmentation generated from Freesurfer. Will return volume, thickness, and mean diffusion measures for each ROI in a parcellation. Can also take in myelin-map and qmri datatypes as inputs. Uses Freesurfer to compute the statistics.

### Authors

- Brad Caron (bacaron@utexas.edu)

### Contributors

- Soichi Hayashi (shayashi@iu.edu)

### Funding Acknowledgement

brainlife.io is publicly funded and for the sustainability of the project it is helpful to Acknowledge the use of the platform. We kindly ask that you acknowledge the funding below in your publications and code reusing this code.

[![NSF-BCS-1734853](https://img.shields.io/badge/NSF_BCS-1734853-blue.svg)](https://nsf.gov/awardsearch/showAward?AWD_ID=1734853)
[![NSF-BCS-1636893](https://img.shields.io/badge/NSF_BCS-1636893-blue.svg)](https://nsf.gov/awardsearch/showAward?AWD_ID=1636893)
[![NSF-ACI-1916518](https://img.shields.io/badge/NSF_ACI-1916518-blue.svg)](https://nsf.gov/awardsearch/showAward?AWD_ID=1916518)
[![NSF-IIS-1912270](https://img.shields.io/badge/NSF_IIS-1912270-blue.svg)](https://nsf.gov/awardsearch/showAward?AWD_ID=1912270)
[![NIH-NIBIB-R01EB029272](https://img.shields.io/badge/NIH_NIBIB-R01EB029272-green.svg)](https://grantome.com/grant/NIH/R01-EB029272-01)

### Citations

We kindly ask that you cite the following articles when publishing papers and code using this code.

1. Avesani, P., McPherson, B., Hayashi, S. et al. The open diffusion data derivatives, brain data upcycling via integrated publishing of derivatives and reproducible open cloud services. Sci Data 6, 69 (2019). https://doi.org/10.1038/s41597-019-0073-y

2. Dale, A.M., Fischl, B., Sereno, M.I., 1999. Cortical surface-based analysis. I. Segmentation and surface reconstruction. Neuroimage 9, 179-194.

#### MIT Copyright (c) 2020 brainlife.io The University of Texas at Austin and Indiana University

## Running the App

### On Brainlife.io

You can submit this App online at [https://doi.org/10.25663/brainlife.app.389](https://doi.org/10.25663/brainlife.app.389) via the 'Execute' tab.

### Running Locally (on your machine)

1. git clone this repo

2. Inside the cloned directory, create `config.json` with something like the following content with paths to your input files.

```json
{
    "freesurfer": "/input/freesurfer/output",
    "fa": "/input/tensor/fa.nii.gz",
    "md": "/input/tensor/md.nii.gz",
    "rd": "/input/tensor/rd.nii.gz",
    "ad": "/input/tensor/ad.nii.gz",
    "cl": "/input/tensor/cl.nii.gz",
    "cp": "/input/tensor/cp.nii.gz",
    "cs": "/input/tensor/cs.nii.gz",
    "tensors": "/input/tensor/tensors.nii.gz",
    "kurtosis": "/input/tensor/kurtosis.nii.gz",
    "dir": "/input/noddi/dir.nii.gz",
    "ndi": "/input/noddi/ndi.nii.gz",
    "isovf": "/input/noddi/isovf.nii.gz",
    "odi": "/input/noddi/odi.nii.gz",
    "myelin": "/input/myelin/map.nii.gz",
    "T1": "/input/qmri/T1map.nii.gz",
    "T1_json": "/input/qmri/T1map_json.nii.gz",
    "R1": "/input/qmri/R1map.nii.gz",
    "R1_json": "/input/qmri/R1map_json.nii.gz",
    "M0": "/input/qmri/M0map.nii.gz",
    "M0_json": "/input/qmri/M0map_json.nii.gz",
    "PD": "/input/qmri/PD.nii.gz",
    "MTV": "/input/qmri/MTV.nii.gz",
    "VIP": "/input/qmri/VIP.nii.gz",
    "SIR": "/input/qmri/SIR.nii.gz",
    "WF": "/input/qmri/WF.nii.gz",
    "parcellation": "aparc"
}
```

### Sample Datasets

You can download sample datasets from Brainlife using [Brainlife CLI](https://github.com/brain-life/cli).

```
npm install -g brainlife
bl login
mkdir input
bl dataset download
```

3. Launch the App by executing 'main'

```bash
./main
```

## Output

The main output of this App is a parc-stats datatype containing a csv file containing data for each measure and parcel within the volumated input parcellation.

#### Product.json

The secondary output of this app is `product.json`. This file allows web interfaces, DB and API calls on the results of the processing.

### Dependencies

This App only requires [singularity](https://www.sylabs.io/singularity/) to run. If you don't have singularity, you will need to install following dependencies.   

- Freesurfer: https://surfer.nmr.mgh.harvard.edu/
- FSL: https://fsl.fmrib.ox.ac.uk/fsl/fslwiki
- python3: https://www.python.org/downloads/
- pandas: https://pandas.pydata.org/
- numpy: https://numpy.org/

#### MIT Copyright (c) 2020 brainlife.io The University of Texas at Austin and Indiana University
