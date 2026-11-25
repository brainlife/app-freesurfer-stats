<h1 align="center">FreeSurfer and parcellation statistics</h1>

<p align="center">
  Tidy CSV tables of morphometry and diffusion measures per parcel, from FreeSurfer recon-all, a parcellation and, optionally, DTI, NODDI, myelin or quantitative MRI maps.
</p>

<p align="center">
  <a href="https://github.com/brainlife/abcd-spec"><img src="https://img.shields.io/badge/ABCD_Spec-v1.1-green.svg" alt="ABCD Spec v1.1"></a>
  <a href="https://doi.org/10.25663/brainlife.app.553"><img src="https://img.shields.io/badge/Brainlife-brainlife.app.553-blue.svg" alt="Run on brainlife.io"></a>
  <a href="https://github.com/brainlife/app-freesurfer-stats/blob/master/LICENSE"><img src="https://img.shields.io/badge/License-MIT-lightgrey.svg" alt="MIT license"></a>
</p>

> **This branch, `parc-stats-volume-diffusion-v1.0`, is the brainlife.io App Compute summary statistics of diffusion measures from Parcellation (volume)** ([doi:10.25663/brainlife.app.553](https://doi.org/10.25663/brainlife.app.553)). The other Apps in this repository are listed under **Versions on brainlife.io** below.

## At a glance

<!-- brainlife-app:begin (generated from the App manifest; edit the manifest, not this block) -->

> **Computes volume, cortical thickness and mean diffusion measures (DTI, optional NODDI, myelin, qMRI) in each ROI of a volumetric parcellation with FreeSurfer mri_segstats.**

Resamples the parcellation and each measure map to the FreeSurfer subject (header-based, nearest neighbour), projects cortical thickness into the volume and summarises every measure per parcel with mri_segstats, writing parc_nodes.csv and rois.csv. Use it to get per-region diffusion statistics for a custom volumetric parcellation. Inputs must be aligned with the FreeSurfer anatomy.

| | |
|---|---|
| **Inputs** | `neuro/parcellation/volume` · `neuro/freesurfer` · `neuro/tensor` · `neuro/noddi` (optional) · `neuro/myelin-map` (optional) · `neuro/anat/qmri` (optional) |
| **Outputs** | `neuro/parc-stats` · `raw` |
| **Container** | `brainlife/freesurfer-stats:1.2` |
| **Resources** | 4 CPUs · 29 GB memory · 2.5 h walltime |
| **Requires** | `FREESURFER_LICENSE` |
| **Run it** | [doi.org/10.25663/brainlife.app.553](https://doi.org/10.25663/brainlife.app.553) |

#### Inputs

| Input | Datatype | Required | Description |
|---|---|---|---|
| `parc` | `neuro/parcellation/volume` | yes | Volumetric parcellation with its label key. Must be aligned with the FreeSurfer subject. |
| `freesurfer` | `neuro/freesurfer` | yes | Output directory of FreeSurfer recon-all for the subject. |
| `tensor` | `neuro/tensor` | yes | DTI (and optionally DKI) measures such as FA, MD, RD and AD. |
| `noddi` | `neuro/noddi` | no | Optional NODDI maps (NDI, ISOVF, ODI). |
| `myelin` | `neuro/myelin-map` | no | Optional myelin map. |
| `qmri` | `neuro/anat/qmri` | no | Optional quantitative MRI maps (T1, R1, M0, PD, MTV, VIP, SIR, WF). |

#### Outputs

| Output | Datatype | Description |
|---|---|---|
| `parc-stats` | `neuro/parc-stats` | parc_nodes.csv and rois.csv with volume, thickness and mean measure values per parcel. |
| `raw` | `raw` |  |

<!-- brainlife-app:end -->

## Versions on brainlife.io

This repository hosts several related Apps, each built from its own branch. All output a `neuro/parc-stats` dataset.

| App | What it summarises | Branch | Run it | Status |
|---|---|---|---|---|
| Compute summary statistics of diffusion measures from Freesurfer Parcellation (volume) | volume, thickness and diffusion measures per ROI of a FreeSurfer `<parc>+aseg` | [`freesurfer-stats-diffusion-v1.0`](https://github.com/brainlife/app-freesurfer-stats/tree/freesurfer-stats-diffusion-v1.0) | [doi:10.25663/brainlife.app.554](https://doi.org/10.25663/brainlife.app.554) | current |
| **Compute summary statistics of diffusion measures from Parcellation (volume)** (this branch) | volume, thickness and diffusion measures per ROI of a custom volumetric parcellation | [`parc-stats-volume-diffusion-v1.0`](https://github.com/brainlife/app-freesurfer-stats/tree/parc-stats-volume-diffusion-v1.0) | [doi:10.25663/brainlife.app.553](https://doi.org/10.25663/brainlife.app.553) | current |
| Compute summary statistics of diffusion measures from subcortical segmentation | volume and diffusion measures per FreeSurfer `aseg` structure | [`subcort-stats-v1.0`](https://github.com/brainlife/app-freesurfer-stats/tree/subcort-stats-v1.0) | [doi:10.25663/brainlife.app.389](https://doi.org/10.25663/brainlife.app.389) | current |
| Parcellation Statistics - Surface | area, volume, thickness and curvature per parcel of a surface annotation | [`updated-parc-stats-surface-v1.0`](https://github.com/brainlife/app-freesurfer-stats/tree/updated-parc-stats-surface-v1.0) | [doi:10.25663/brainlife.app.484](https://doi.org/10.25663/brainlife.app.484) | current |
| Parcellation Statistics - Volume | volume and thickness per parcel of a volumetric parcellation | [`parc-stats-volume-v1.0`](https://github.com/brainlife/app-freesurfer-stats/tree/parc-stats-volume-v1.0) | [doi:10.25663/brainlife.app.463](https://doi.org/10.25663/brainlife.app.463) | current |
| Freesurfer Statistics | FreeSurfer recon-all stats for aparc, aparc.a2009s or aparc.DKTatlas, plus whole-brain, subcortical and nuclei volumes | [`v1.3-add-nuclei`](https://github.com/brainlife/app-freesurfer-stats/tree/v1.3-add-nuclei) | [doi:10.25663/brainlife.app.272](https://doi.org/10.25663/brainlife.app.272) | current |
| Parcellation Statistics - Surface - Deprecated Datatype | surface annotation (deprecated datatype) | [`parc-stats-surface-v1.0`](https://github.com/brainlife/app-freesurfer-stats/tree/parc-stats-surface-v1.0) | [doi:10.25663/brainlife.app.464](https://doi.org/10.25663/brainlife.app.464) | deprecated |
| Parcellation Statistics | volumetric parcellation | [`parc-stats-v1.2`](https://github.com/brainlife/app-freesurfer-stats/tree/parc-stats-v1.2) | [doi:10.25663/brainlife.app.443](https://doi.org/10.25663/brainlife.app.443) | deprecated |
| Parcellation Statistics - Deprecated | volumetric parcellation | [`parc-stats-v1.0`](https://github.com/brainlife/app-freesurfer-stats/tree/parc-stats-v1.0) | [doi:10.25663/brainlife.app.374](https://doi.org/10.25663/brainlife.app.374) | deprecated |

## Running the App

### On brainlife.io

Pick the App that matches your data from the table above, choose the inputs from your project and press **Execute**. Every App needs the FreeSurfer recon-all output of the subject; all other images must already be aligned with the FreeSurfer anatomy (alignment is header based).

- **FreeSurfer parcellation with diffusion measures** ([doi:10.25663/brainlife.app.554](https://doi.org/10.25663/brainlife.app.554)): choose a `neuro/freesurfer` dataset, a `neuro/tensor` dataset (DTI and optionally DKI measures) and, optionally, `neuro/noddi`, `neuro/myelin-map` and `neuro/anat/qmri` datasets, and set `parcellation` to `aparc`, `aparc.a2009s` (default) or `aparc.DKTatlas`. The App resamples each measure map to the `<parcellation>+aseg` volume and summarises cortical thickness and every measure per ROI with `mri_segstats` into `parc_nodes.csv`. For a custom parcellation, use the *Parcellation (volume)* variant ([doi:10.25663/brainlife.app.553](https://doi.org/10.25663/brainlife.app.553)), which also writes `rois.csv`.
- **Subcortical structures** ([doi:10.25663/brainlife.app.389](https://doi.org/10.25663/brainlife.app.389)): summarises volume and mean DTI and NODDI measures within each FreeSurfer `aseg` structure into `aseg_nodes.csv`.
- **Surface parcellation** ([doi:10.25663/brainlife.app.484](https://doi.org/10.25663/brainlife.app.484)): runs `mris_anatomical_stats` on left and right `.annot` files defined on the same FreeSurfer subject. Use it whenever a surface parcellation is available.
- **Volumetric parcellation** ([doi:10.25663/brainlife.app.463](https://doi.org/10.25663/brainlife.app.463)): intended for when a surface parcellation/annotation is not available. Volume and cortical thickness values will differ slightly from the surface computations, although within standard deviation.
- **FreeSurfer Statistics** ([doi:10.25663/brainlife.app.272](https://doi.org/10.25663/brainlife.app.272)): converts the recon-all stats files for the chosen parcellation into tidy CSVs with the open-source [freesurfer-stats](https://github.com/fphammerle/freesurfer-stats) package, with whole-brain, subcortical and, when present, nuclei volumes.

### Locally

You need [Singularity/Apptainer](https://apptainer.org/), [`jq`](https://jqlang.github.io/jq/) and a [FreeSurfer license](https://surfer.nmr.mgh.harvard.edu/registration.html). FreeSurfer, FSL, the freesurfer-stats Python environment and the compiled MATLAB code run inside containers.

1. Clone this repository and check out the branch of the App you want (for example `git checkout freesurfer-stats-diffusion-v1.0`).
2. Create `config.json` with the paths to your inputs. For the FreeSurfer-parcellation diffusion App:

   ```json
   {
       "freesurfer": "/input/freesurfer/output",
       "parcellation": "aparc.a2009s",
       "fa": "/input/tensor/fa.nii.gz",
       "md": "/input/tensor/md.nii.gz",
       "rd": "/input/tensor/rd.nii.gz",
       "ad": "/input/tensor/ad.nii.gz"
   }
   ```

   Optional measure maps use the keys `ndi`, `isovf`, `odi` (NODDI), `myelin`, and `T1`, `R1`, `M0`, `PD`, `MTV`, `VIP`, `SIR`, `WF` (qMRI). For *Freesurfer Statistics*, only `freesurfer` and `parcellation` are needed.

3. Export your license and run the App:

   ```bash
   export FREESURFER_LICENSE="$(cat ~/freesurfer/license.txt)"
   ./main
   ```

## Outputs

```text
parc-stats/
└── parc-stats/
    ├── parc_nodes.csv   volume, cortical thickness and mean measure values per ROI
    └── rois.csv         ROI statistics (Parcellation (volume) variants)
```

*Freesurfer Statistics* writes its tables (per-hemisphere and combined cortical measures, `whole_brain.csv`, subcortical volumes and `rois.csv`) to `output/parc-stats/`; the subcortical App writes `aseg_nodes.csv`; the surface App writes `cortex.csv`, `whole_brain.csv` and per-hemisphere tables.

## Troubleshooting

- **`Please set FREESURFER_LICENSE in .bashrc`**: export the contents of your FreeSurfer `license.txt` as `FREESURFER_LICENSE` before running `./main`.
- **`output missing`**: the expected CSV was not produced. Check that the FreeSurfer directory contains the `stats` and `mri` files for the chosen parcellation, or, for the surface App, that the annotation matches the subject's surfaces.
- **`stats computation failed. check derivatives and error log`**: `mri_segstats` did not produce a summary for a measure. Check that the measure maps and parcellation are valid and aligned with the FreeSurfer anatomy.

## Citing

> [!TIP]
> If you use this App in your work, please cite the App, the software it builds on and brainlife.io (below). GitHub's **Cite this repository** button gives the App citation in APA and BibTeX.

If you use these Apps, please cite FreeSurfer and brainlife.io:

- Dale AM, Fischl B, Sereno MI. Cortical surface-based analysis. I. Segmentation and surface reconstruction. *NeuroImage* 9:179–194 (1999).
- Compute summary statistics of diffusion measures from Parcellation (volume). brainlife.io App. [doi:10.25663/brainlife.app.553](https://doi.org/10.25663/brainlife.app.553)
- Avesani P, McPherson B, Hayashi S, et al. The open diffusion data derivatives, brain data upcycling via integrated publishing of derivatives and reproducible open cloud services. Sci Data 6, 69 (2019). [doi:10.1038/s41597-019-0073-y](https://doi.org/10.1038/s41597-019-0073-y)
- Dale AM, Fischl B, Sereno MI. Cortical surface-based analysis. I. Segmentation and surface reconstruction. NeuroImage 9, 179-194 (1999).
- Fischl. FreeSurfer. *NeuroImage* 62:774-781 (2012). [doi:10.1016/j.neuroimage.2012.01.021](https://doi.org/10.1016/j.neuroimage.2012.01.021)
- Jenkinson et al. FSL. *NeuroImage* 62:782-790 (2012). [doi:10.1016/j.neuroimage.2011.09.015](https://doi.org/10.1016/j.neuroimage.2011.09.015)
- Zhang et al. NODDI: Practical in vivo neurite orientation dispersion and density imaging of the human brain. *NeuroImage* 61:1000-1016 (2012). [doi:10.1016/j.neuroimage.2012.03.072](https://doi.org/10.1016/j.neuroimage.2012.03.072)
- Bullock et al. Associative white matter connecting the dorsal and ventral posterior human cortex. *Brain Structure and Function* 224:2631-2660 (2019). [doi:10.1007/s00429-019-01907-8](https://doi.org/10.1007/s00429-019-01907-8)
- Hayashi S, Caron BA, Heinsfeld AS, et al. brainlife.io: a decentralized and open-source cloud platform to support neuroscience research. *Nature Methods* 21:809–813 (2024). [doi:10.1038/s41592-024-02237-2](https://doi.org/10.1038/s41592-024-02237-2)

## Authors

- Brad Caron

**Contributors:** Soichi Hayashi, Anibal Sólon

The Apps use [vistasoft](https://github.com/vistalab/vistasoft), [jsonlab](https://github.com/fangq/jsonlab), [wma_tools](https://github.com/DanNBullock/wma_tools) and [freesurfer-stats](https://github.com/fphammerle/freesurfer-stats).

## Funding

[![Wellcome-226486/Z/22/Z](https://img.shields.io/badge/Wellcome-226486%2FZ%2F22%2FZ-purple.svg)](https://wellcome.org/)
[![NIH-NINDS-U24NS140384](https://img.shields.io/badge/NIH_NINDS-U24NS140384-green.svg)](https://reporter.nih.gov/project-details/11261037)
[![NIH-NINDS-UM1NS132207](https://img.shields.io/badge/NIH_NINDS-UM1NS132207-green.svg)](https://reporter.nih.gov/project-details/11411328)
[![NIH-NIBIB-R01EB029272](https://img.shields.io/badge/NIH_NIBIB-R01EB029272-green.svg)](https://reporter.nih.gov/project-details/10262925)
[![NIH-NIBIB-R01EB030896](https://img.shields.io/badge/NIH_NIBIB-R01EB030896-green.svg)](https://reporter.nih.gov/project-details/10428625)
[![NIH-NIMH-R01MH126699](https://img.shields.io/badge/NIH_NIMH-R01MH126699-green.svg)](https://reporter.nih.gov/project-details/10460628)
[![NIH-NIDCD-R01DC020088](https://img.shields.io/badge/NIH_NIDCD-R01DC020088-green.svg)](https://reporter.nih.gov/project-details/11140284)
[![NSF-BCS-1734853](https://img.shields.io/badge/NSF_BCS-1734853-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1734853)
[![NSF-BCS-2203524](https://img.shields.io/badge/NSF_BCS-2203524-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2203524)
[![NSF-IIS-1636893](https://img.shields.io/badge/NSF_IIS-1636893-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1636893)
[![NSF-OAC-2148729](https://img.shields.io/badge/NSF_OAC-2148729-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2148729)
[![NSF-IIS-1912270](https://img.shields.io/badge/NSF_IIS-1912270-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1912270)
[![NSF-IIS-2148700](https://img.shields.io/badge/NSF_IIS-2148700-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2148700)
[![NSF-OAC-1916518](https://img.shields.io/badge/NSF_OAC-1916518-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1916518)

<sub>brainlife.io is publicly funded, and acknowledging that support helps keep it running. This App was developed with support from Wellcome, the U.S. National Institutes of Health (including the BRAIN Initiative BRAIN CONNECTS program: The Axonal Projectome EXchange, U24NS140384, and the Center for Mesoscale Connectomics, UM1NS132207) and the U.S. National Science Foundation.</sub>

## License

[MIT](https://github.com/brainlife/app-freesurfer-stats/blob/master/LICENSE). FreeSurfer itself is distributed under its own [license](https://surfer.nmr.mgh.harvard.edu/fswiki/FreeSurferSoftwareLicense).
