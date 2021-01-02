
ni = readFileNifti('/biac2/wandell2/data/anatomy/dougherty/t1.nii.gz');
voxDim = [.9 .9 .9];
anat = mrAnatResliceSpm(double(ni.data), ni.qto_ijk, [], [.9 .9 .9]);
anat(anat<0) = 0;
anat(anat>32765) = 32765;
anat = int16(round(anat));
brainMask = mrAnatExtractBrain(anat,voxDim);

wmThreshold = 24500;

brain = double(anat);
brain(~brainMask) = 0;

whiteMatter = brain > wmThreshold;
% Clean up the segmentation with some image processing
whiteMatter = smooth3(double(whiteMatter))>0.5;

[faces, vertices] = isosurface(whiteMatter, 0);

% To compute the vertext normals and curvature, we use some of the NYU
% tools:
unix('svn checkout https://cbi.nyu.edu/svn/mrTools/trunk mrTools');
addpath(genpath('mrTools'));
innerSurf.Nvtcs = size(vertices,1);
innerSurf.vtcs = vertices;
innerSurf.tris = faces;
innerSurf.Ntris = length(faces);
% We need the normals, so let's calculate them too.
innerSurf.normals = calcSurfaceNormals(innerSurf);
curvature = calcCurvature(innerSurf, []);
curvature(isnan(curvature)) = 0;
curvature(curvature>.5) = .5;
curvature(curvature<-.5) = -.5;
curvature = curvature+.5;

mesh.vertices = vertices;
mesh.faces = faces;
mesh.vertexNormals = innerSurf.normals;
mesh.curvature = curvature;
save mrTutVisualizationData.mat anat voxDim brainMask mesh
