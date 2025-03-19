# mni_xyz_convert_demo.py - demonstration of coordinate convertion from or to MNI
# Yichao Li, Feb 27, 2022

import numpy as np
import nibabel as nib
import scipy.linalg as lin

def xyz2mni(affine, v):
    v1 = np.append(v, 1)
    return affine.dot(v1)[ : -1]

def mni2xyz(affine, v):
    v1 = np.append(v, 1)
    return lin.solve(affine, v1)[ : -1]

t1_fn = "t1_y.nii.gz"
bold_fn = "bold_y.nii.gz"

t1_raw = nib.load(t1_fn)
bold_raw = nib.load(bold_fn)

# convert BOLD XYZ coordinates to MNI space
v_mni = xyz2mni(bold_raw.affine, [60, 27, 23])
# convert MNI space to T1 XYZ coordinates
v_t1 = mni2xyz(t1_raw.affine, v_mni)
# convert MNI space back to BOLD XYZ coordinates
v_bold = mni2xyz(bold_raw.affine, v_mni)

print(v_mni, v_t1, v_bold, sep = "\n")