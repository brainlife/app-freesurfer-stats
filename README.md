[![Abcdspec-compliant](https://img.shields.io/badge/ABCD_Spec-v1.1-green.svg)](https://github.com/brain-life/abcd-spec)
[![Run on Brainlife.io](https://img.shields.io/badge/Brainlife-brainlife.app.272-blue.svg)](https://doi.org/10.25663/brainlife.app.272)

# Freesurfer Statistics

<!-- brainlife-app:begin (generated from the App manifest; edit the manifest, not this block) -->

**Computes volume, cortical thickness and mean diffusion measures (DTI, optional NODDI, myelin, qMRI) in each ROI of a FreeSurfer <parcellation>+aseg volume with mri_segstats.**

Uses the chosen FreeSurfer parcellation volume (aparc, aparc.a2009s or aparc.DKTatlas +aseg) from the subject directory, resamples each measure map to it by header and summarises thickness and every measure per ROI with mri_segstats into parc_nodes.csv. Use it when the ROIs of interest are FreeSurfer's own parcellations; for a custom parcellation use the 'Parcellation (volume)' variant. Measure maps must be aligned with the FreeSurfer anatomy.

Run it on brainlife.io: [https://doi.org/10.25663/brainlife.app.554](https://doi.org/10.25663/brainlife.app.554)

| Input | Datatype | Required | Description |
|---|---|---|---|
| `freesurfer` | `neuro/freesurfer` | yes | Output directory of FreeSurfer recon-all for the subject. |
| `tensor` | `neuro/tensor` | yes | DTI (and optionally DKI) measures such as FA, MD, RD and AD. |
| `noddi` | `neuro/noddi` | no | Optional NODDI maps (NDI, ISOVF, ODI). |
| `myelin` | `neuro/myelin-map` | no | Optional myelin map. |
| `qmri` | `neuro/anat/qmri` | no | Optional quantitative MRI maps (T1, R1, M0, PD, MTV, VIP, SIR, WF). |

| Output | Datatype | Description |
|---|---|---|
| `parc-stats` | `neuro/parc-stats` | parc_nodes.csv with volume, thickness and mean measure values per ROI. |

| Parameter | Type | Default | Description |
|---|---|---|---|
| `parcellation` | enum | `aparc.a2009s` | This is the freesurfer parcellation to use to compute statistics within Options: `aparc`, `aparc.a2009s`, `aparc.DKTatlas`. |

Runtime: container `brainlife/freesurfer-stats:1.2`; 4 CPUs; 29 GB memory; 2.5 h walltime; needs `FREESURFER_LICENSE`.

Please cite:
- Avesani P, McPherson B, Hayashi S, et al. The open diffusion data derivatives, brain data upcycling via integrated publishing of derivatives and reproducible open cloud services. Sci Data 6, 69 (2019). [doi:10.1038/s41597-019-0073-y](https://doi.org/10.1038/s41597-019-0073-y)
- Dale AM, Fischl B, Sereno MI. Cortical surface-based analysis. I. Segmentation and surface reconstruction. NeuroImage 9, 179-194 (1999).

<!-- brainlife-app:end -->

This app will convert the Freesurfer stats files created during recon-all into a user-friendly, tidy format csv for downstream analyses. This app uses an open source package called 'FreesurferStats' to do the conversion for us. This app will output a parc-stats datatype containing the information for each parcel for the chosen Freesurfer parcellation.

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

You can submit this App online at [https://doi.org/10.25663/brainlife.app.272](https://doi.org/10.25663/brainlife.app.272) via the 'Execute' tab.

### Running Locally (on your machine)

1. git clone this repo

2. Inside the cloned directory, create `config.json` with something like the following content with paths to your input files.

```json
{
    "freesurfer": "/input/freesurfer/output",
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

The main output of this App is a parc-stats datatype containing a csv file containing data for each measure and parcel within the chosen Freesurfer parcellation.

#### Product.json

The secondary output of this app is `product.json`. This file allows web interfaces, DB and API calls on the results of the processing.

### Dependencies

This App only requires [singularity](https://www.sylabs.io/singularity/) to run. If you don't have singularity, you will need to install following dependencies.   

- Freesurfer: https://surfer.nmr.mgh.harvard.edu/
- FSL: https://fsl.fmrib.ox.ac.uk/fsl/fslwiki
- python3: https://www.python.org/downloads/
- pandas: https://pandas.pydata.org/
- numpy: https://numpy.org/
- matlab: https://www.mathworks.com/products/matlab.html
- vistasoft: https://github.com/vistalab/vistasoft
- jsonlab: https://github.com/fangq/jsonlab
- wma_tools: https://github.com/DanNBullock/wma_tools
- Freesurfer Stats: https://github.com/fphammerle/freesurfer-stats

#### MIT Copyright (c) 2020 brainlife.io The University of Texas at Austin and Indiana University
